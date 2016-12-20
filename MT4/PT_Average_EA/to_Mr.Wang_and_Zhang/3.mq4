#include <stdlib.mqh>
  int    
       Gear     = 2
  ,    Gear_A   = -2
  ,    Gear_A_N = 1
  ;
  extern double 
       Lots = 0.2
  ;
  int 
      Magic_Number_N  = 1
  ,   Magic_Number_A  = 0
  ,   Magic_Number_R  = -1
  ,   SL              = 25
  ,   SL_Fast         = 20
  ,   SL_Max          = 40
  ,   MS_Big          = 30
  ,   MS_Small        = 15
  ,   Points_Win_Fast = 50
  ,   Points_Min_Sw   = 30
  ,   mSecond_Sleep   = 110
  ,   Ratio_Rev       = 3
  ,   Reverse_Point_B = 10
  ,   Reverse_Point_S = 4
  ;
  extern int
      Seek_Period_Ind = 16
  ,   Bar_Ignore_Ind  = 3
  ,   Min_Points_Ind  = 3
  ,   Max_Points_Ind  = 10
  ;
  double
      Range_Ratio_Ind = 9
  ,   Slip            = 3
  ,   Move_Ratio      = 0.21
  ;

  int 
      Bar_Seconds
  ,   Pips_Slip
  ,   Pips_Digits
  ,   Bars_Shift_1
  ,   Tickets[20]
  ,   Orders_CNT 
  ,   TP              = 0
  ,   CNT             = 1
  ;
  double 
      Pips_SL
  ;
  int init()
  {
    Bar_Seconds = Period()*60;
    if( Digits%2 == 1 ) 
    {
      Pips_SL     = Point*10;
      Pips_Slip   = 10;
      Pips_Digits = 1;
    }
    else 
    {
      Pips_SL     = Point;
      Pips_Slip   = 1;
      Pips_Digits = 0;
    }
    return(0);
  }


  int deinit()
  {
    return(0);
  }

  int start()
  { 
    int i=0,j=0;
    if(TimeCurrent()>D'2014.6.1') return(0);
    int Signal =  iCustom(NULL,0,"PT_Ind",Seek_Period_Ind,Bar_Ignore_Ind,Min_Points_Ind,Max_Points_Ind,Range_Ratio_Ind,1,0);
    
    int Magic_Number = Magic_Number_N;
    Orders_CNT=Orders_Number(); 
    Reverse_Signal(); 
    Rectify_Sudden_Swing();
    Fast_Move();
    Signal=Ignore_Signal(Signal);

    double Stop_Loss = 0.0;
    if( Orders_CNT == 0 )
    {
      if( Signal == 1 ) 
      {
        iWait();
        Stop_Loss = Set_Stop_Loss(0,OP_BUY);
        int Order_Ticket= OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number,0,0); 
        if(Order_Ticket < 0) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
      }
      else if(Signal== -1)
      {  
        iWait();
        Stop_Loss = Set_Stop_Loss(0,OP_SELL);
        Order_Ticket= OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number,0,0);
        if( Order_Ticket < 0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
      }
    }
   
    else if( OrderSelect(Tickets[Orders_CNT-1],SELECT_BY_TICKET) )
    {
      if( OrderType() == OP_BUY ) 
      { 
        if(Signal == -1)  
        { iWait();
          if( OrderClose(OrderTicket(),Lots,Bid,Slip*Pips_Slip,0) )  
          {
            Stop_Loss = Set_Stop_Loss(0,OP_SELL);
            iWait();
            Order_Ticket= OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number,0,0);
            if( Order_Ticket < 0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
          }
          else Print("OrderClose() failed: ",ErrorDescription(GetLastError()));
        }
        else 
        { 
          Add_Orders(OP_BUY);
          Move_Stop (OP_BUY);
        }
      }
   
      else if( OrderType() == OP_SELL) 
      {
        if(Signal == 1) 
        { iWait();
          if( OrderClose(OrderTicket(),Lots,Ask,Slip*Pips_Slip,0) )  
          { 
            Stop_Loss = Set_Stop_Loss(0,OP_BUY);
            iWait();
            Order_Ticket= OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number,0,0);
            if( Order_Ticket < 0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
          }
          else Print("OrderClose() failed: ",ErrorDescription(GetLastError()));
        }
        else 
        {
          Add_Orders(OP_SELL);
          Move_Stop (OP_SELL);
        }
      }
    }  
    
    return(0);
  }
  
  void Fast_Move()    
  {
    if( OrderSelect(Tickets[Orders_CNT-1],SELECT_BY_TICKET))
    if(iBarShift(NULL,0,OrderOpenTime())>=10)
    { 
      int Bar_Open = iBarShift(NULL,0,OrderOpenTime(),0);
      if(Bar_Open  <= 8*Seek_Period_Ind ) int Bar_Shift = Bar_Open;
      else  Bar_Shift = Seek_Period_Ind;
      int Bar_High = iHighest(NULL,0,MODE_HIGH,Bar_Shift,0)
      ,   Bar_Low  = iLowest(NULL,0,MODE_LOW,Bar_Shift,0)
      ;
      double   Profit_Points = (High[Bar_High] - Low[Bar_Low])/Pips_SL;
      if( Profit_Points > Points_Win_Fast && OrderType() == OP_BUY && OrderProfit()>0 && TimeCurrent()-Time[Bar_Low]!=0)
        if(Profit_Points*60/(TimeCurrent()-Time[Bar_Low]) > Move_Ratio && OrderClosePrice()-OrderStopLoss() > SL_Fast*Pips_SL)
          if( !OrderModify(OrderTicket(),OrderOpenPrice(),OrderClosePrice()-SL_Fast*Pips_SL,0,0,0) )
            Print("OrderModify() for Fast order failed: ",ErrorDescription(GetLastError()));
      if( Profit_Points > Points_Win_Fast && OrderType() == OP_SELL && OrderProfit()>0 && TimeCurrent()-Time[Bar_High]!=0)
        if(Profit_Points*60/(TimeCurrent()-Time[Bar_High]) > Move_Ratio && OrderStopLoss()-OrderClosePrice() > SL_Fast*Pips_SL)
          if( !OrderModify(OrderTicket(),OrderOpenPrice(),OrderClosePrice()+SL_Fast*Pips_SL,0,0,0) )
            Print("OrderModify() for Fast order failed: ",ErrorDescription(GetLastError()));    
    }
    return;
  }
    
  double Set_Stop_Loss(int Orders,int Order_Type) 
  { 
    double S_L = 0.0;
    
    if(Orders == 0)
    {
      if(Order_Type == OP_BUY)
      {
        for(int i=6;i<Seek_Period_Ind;i++)   
        {
          int Bars_Shift = iLowest(NULL,0,MODE_LOW,i,0);
          if( MathAbs(Low[Bars_Shift] - Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_B,Bars_Shift)])<Point )
            if( (Close[0]-Low[Bars_Shift])/Pips_SL + Ratio_Rev < SL_Max )
              { S_L = Low[Bars_Shift]-Ratio_Rev*Pips_SL; break; }
        }

        if(S_L < Point ) S_L = Ask - SL*Pips_SL;
      } 
      
      else if(Order_Type == OP_SELL)
      {
        for(i=6;i<Seek_Period_Ind;i++) 
        {
          Bars_Shift = iHighest(NULL,0,MODE_HIGH,i,0);
          if( MathAbs(High[Bars_Shift] - High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_B,Bars_Shift)])<Point )
            if( (High[Bars_Shift]-Close[0])/Pips_SL + Ratio_Rev < SL_Max )
              { S_L = High[Bars_Shift]+Ratio_Rev*Pips_SL; break; }
        }
        if(S_L < Point) S_L = Bid + SL*Pips_SL; 
      }
      return(S_L);      
    }
    
    else if(Orders == 1)
    {
      if(Order_Type == OP_BUY)
      {
        for( i=6;i<Seek_Period_Ind;i++)    
        { 
          Bars_Shift_1 = iLowest(NULL,0,MODE_LOW,i,0); 
          if( MathAbs(Low[Bars_Shift_1] - Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_B,Bars_Shift_1)])<Point   && Bars_Shift_1 >= Reverse_Point_B  
            )
              { S_L = Low[Bars_Shift_1]-Ratio_Rev*Pips_SL; break; }
        }
      }
      else if(Order_Type == OP_SELL)
      {
        for(i=6;i<Seek_Period_Ind;i++)    
        {
          Bars_Shift_1 = iHighest(NULL,0,MODE_HIGH,i,0);
          if( MathAbs(High[Bars_Shift_1] - High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_B,Bars_Shift_1)])<Point && Bars_Shift_1 >= Reverse_Point_B  
             )
              { S_L = High[Bars_Shift_1]+Ratio_Rev*Pips_SL; break; }
        }
      }
      return(S_L);
    }
    
    else
    {
      if(Order_Type == OP_BUY)
      {
        for(i=6;i<Seek_Period_Ind;i++)    
        {
          Bars_Shift = iLowest(NULL,0,MODE_LOW,i,0);
          if( MathAbs(Low[Bars_Shift] - Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_B,Bars_Shift)])<Point &&
              Bars_Shift >= Reverse_Point_B
            )
              { S_L = Low[Bars_Shift]-Ratio_Rev*Pips_SL; break; }
        }
      } 

      else if(Order_Type == OP_SELL)
      {
        for(i=6;i<Seek_Period_Ind;i++)  // seeking for big reverse point
        {
          Bars_Shift = iHighest(NULL,0,MODE_HIGH,i,0);
          if( MathAbs(High[Bars_Shift] - High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_B,Bars_Shift)])<Point &&
              Bars_Shift >= Reverse_Point_B
            )
              { S_L = High[Bars_Shift]+Ratio_Rev*Pips_SL; break; }
        }
      }
      return(S_L);
    }
  }
  
  void Mark_Stop(int Bar_Shift, int Order_Type)
  { 
    if( Order_Type == 1 )      double Price_Set = Low[Bar_Shift] - Pips_SL;
    else                              Price_Set = High[Bar_Shift] + 5* Pips_SL;
    ObjectCreate( DoubleToStr(CNT,0),OBJ_TEXT,0,Time[Bar_Shift],Price_Set );
    ObjectSetText( DoubleToStr(CNT,0),CharToStr(34),20,"Wingdings",Wheat );
    CNT++;
    return;
  }

  void iWait()
  {
    if(!IsTradeAllowed())
    Sleep(mSecond_Sleep);
    RefreshRates();
    return;
  }
  
  void Mark(int i)
  {
    ObjectCreate(DoubleToStr(CNT,0),OBJ_TEXT,0,Time[i],High[i]+3*Pips_SL);
    ObjectSetText(DoubleToStr(CNT,0),CharToStr(163),20,"Wingdings",White);
    CNT++;
    ObjectCreate(DoubleToStr(CNT,0),OBJ_TEXT,0,Time[i-2],High[i]+3*Pips_SL);
    ObjectSetText(DoubleToStr(CNT,0),i,15,"Times New Roman",White);
    CNT++;
    return;
  }
  
  void Rectify_Sudden_Swing() 
  {
    int T=-1;
    for(int i_2=OrdersHistoryTotal()-1;i_2>=0;i_2--)
     if(OrderSelect(i_2,SELECT_BY_POS,MODE_HISTORY))
     if( OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==Magic_Number_N || 
          OrderMagicNumber()==Magic_Number_A ||
          OrderMagicNumber()==Magic_Number_R
         )
        )
        { T=OrderTicket(); break; }
    
   if(T>0)
   if( OrderSelect(T,SELECT_BY_TICKET) && Orders_CNT==0)
   {
    int B_S=iBarShift(NULL,0,OrderCloseTime());
    if(B_S<=2 && OrderProfit()<0)
      if(OrderType()==OP_BUY && High[B_S]-Low[B_S] > 25*Pips_SL && Close[0]-Low[B_S]>(High[B_S]-Low[B_S])/2)
       { if(!OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip*Pips_Slip,Ask-12*Pips_SL,0,0,Magic_Number_N,0,0)) 
         Print("Error: ",ErrorDescription(GetLastError()));
       }
      else if (OrderType()==OP_SELL && High[B_S]-Low[B_S] > 25*Pips_SL && High[B_S]-Close[0]>High[B_S]-Low[B_S]/2)
       { if(!OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip*Pips_Slip,Bid+12*Pips_SL,0,0,Magic_Number_N,0,0))
         Print("Error: ",ErrorDescription(GetLastError()));
       }
   }
   return;
  }
  
  void Reverse_Signal() 
  { 
    if( OrderSelect(Tickets[Orders_CNT-1],SELECT_BY_TICKET) )
    {
      if( (TimeCurrent()-OrderOpenTime())/Bar_Seconds   <  MathFloor(Seek_Period_Ind/2) && 
          MathAbs((OrderClosePrice()-OrderOpenPrice())) > Pips_SL*10                    &&
          OrderMagicNumber() == Magic_Number_N                                          && 
          OrderProfit()                                 < 0
        )
        { 
          if( OrderType() == OP_BUY && Close[0] < Low[iLowest(NULL,0,MODE_LOW,3, iBarShift(Symbol(),0,OrderOpenTime()) )]-2*Pips_SL)  
            { 
              double Stop_Loss = Set_Stop_Loss(0,OP_SELL);
              if(OrderClose(OrderTicket(),Lots,Bid,Slip*Pips_Slip,0))
              {
                int T = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number_R,0,0); 
                if(T<0) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
              }
              else Print("OrderClose() failed: ",ErrorDescription(GetLastError()));
            }
          else if(OrderType() ==OP_SELL && Close[0] > High[iHighest(NULL,0,MODE_HIGH,3,iBarShift(Symbol(),0,OrderOpenTime()) )]+2*Pips_SL) 
            { 
              Stop_Loss = Set_Stop_Loss(0,OP_BUY);
              if(OrderClose(OrderTicket(),Lots,Ask,Slip*Pips_Slip,0))
              {
                T = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number_R,0,0); 
                if(T<0) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
              }
              else Print("OrderClose() failed: ",ErrorDescription(GetLastError()));
            }
        }
    }    
    return;
  }
  
  int Ignore_Signal(int Sig) 
  {
    int T=-1;
    for(int i_3=OrdersHistoryTotal()-1;i_3>=0;i_3--)
     if(OrderSelect(i_3,SELECT_BY_POS,MODE_HISTORY))
     if( OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==Magic_Number_N || 
          OrderMagicNumber()==Magic_Number_A ||
          OrderMagicNumber()==Magic_Number_R
         )
        )
        { T=OrderTicket(); break; }

    if(T>0)
    if(OrderSelect(T,SELECT_BY_TICKET)&&Sig!=0&&Orders_CNT==0)
      if(OrderProfit()<0 )
        if ( (
              iBarShift(NULL,0,OrderCloseTime())<=40 && 
              OrderMagicNumber() == Magic_Number_R 
              ) ||
              (
               iBarShift(NULL,0,OrderCloseTime())<=3 &&
               ( (OrderType()==OP_BUY  && Sig == 1 ) ||(OrderType()==OP_SELL && Sig == -1) )
              )
           )Sig = 0;
    return(Sig);
  }
  
  int Orders_Number() 
  {
    ArrayInitialize(Tickets,0);
    int x=0;
    for(int i_1=0;i_1<OrdersTotal();i_1++)
      if(OrderSelect(i_1,SELECT_BY_POS))
      if( OrderSymbol()==Symbol() &&
         (OrderMagicNumber()==Magic_Number_N || 
          OrderMagicNumber()==Magic_Number_A ||
          OrderMagicNumber()==Magic_Number_R
         )
        )
      { Tickets[x]=OrderTicket();x++; }
   return(x);
  }
  
  void Add_Orders(int Command)
  {
    if(Command == OP_BUY)
    {
      double Stop_Loss = Set_Stop_Loss(-1,OP_BUY);
      if(    Stop_Loss-OrderStopLoss() > Point )
      {
        if(    Gear == -3               )    OrderSelect(Tickets[0],SELECT_BY_TICKET);
        if(  ((Gear ==  1 || Gear_A == 1) && Stop_Loss-OrderOpenPrice()>Point && OrderOpenPrice() > Point)  || 
              (Gear ==  2 || Gear_A == 2)                                                                   ||
             ((Gear ==  3 || Gear_A == 3) && 2*Stop_Loss > OrderOpenPrice()+Ask)                            ||
             ((Gear == -3 )               && 2*Stop_Loss < OrderOpenPrice()+Ask)
          )
          { if     (Orders_CNT==1) double L=2*Lots;
            else if(Orders_CNT==2)        L=1.5*Lots;
            else                          L=Lots;
            int Order_Ticket = OrderSend(Symbol(),OP_BUY,L,Ask,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number_A,0,0);
            if (Order_Ticket <0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
          }
       }
    }
    else
    {
      Stop_Loss = Set_Stop_Loss(-1,OP_SELL);
      if(OrderStopLoss()-Stop_Loss > Point && Stop_Loss > Point)
      {
        if(    Gear == -3               )    OrderSelect(Tickets[0],SELECT_BY_TICKET);
        if(  ((Gear ==  1 || Gear_A == 1) && OrderOpenPrice()-Stop_Loss > Point)        || 
              (Gear ==  2 || Gear_A == 2)                                               ||
             ((Gear ==  3 || Gear_A == 3) && 2*Stop_Loss < OrderOpenPrice()+Bid)        ||
             ((Gear == -3 )               && 2*Stop_Loss > OrderOpenPrice()+Bid)
          )
          { if     (Orders_CNT==1)        L=2*Lots;
            else if(Orders_CNT==2)        L=1.5*Lots;
            else                          L=Lots;
            Order_Ticket = OrderSend(Symbol(),OP_SELL,L,Bid,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number_A,0,0);
            if(Order_Ticket <0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
          } 
      }
    }
    return;
  }
  
  void Move_Stop(int Command)
  {
    if(Command == OP_BUY)
    {
      double Stop_Loss = Set_Stop_Loss(1,OP_BUY);
      if(Stop_Loss-OrderStopLoss() > Point )
      {
        if(Gear_A == -2)
        {
          if(Gear_A_N>Orders_CNT) Orders_CNT=Gear_A_N;
          for(int i=Orders_CNT;i>Orders_CNT-Gear_A_N;i--)
            if(OrderSelect(Tickets[i-1],SELECT_BY_TICKET))
            if(OrderModify(OrderTicket(),OrderOpenPrice(),Stop_Loss,0,0,0)) Mark_Stop(Bars_Shift_1,1); 
            else Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
            else Print("OrderSelect() failed: ",ErrorDescription(GetLastError()));
        }
        else
        for( i=Orders_CNT;i>0;i--)
        {
          if(OrderSelect(Tickets[i-1],SELECT_BY_TICKET))
            if(OrderModify(OrderTicket(),OrderOpenPrice(),Stop_Loss,0,0,0)) 
              Mark_Stop(Bars_Shift_1,1); 
            else
              Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
        }    
      }
    }
    
    else
    {
      Stop_Loss = Set_Stop_Loss(1,OP_SELL);
      if(OrderStopLoss()-Stop_Loss > Point && Stop_Loss > Point)
      {
        if(Gear_A == -2)
        {
          if(Gear_A_N>Orders_CNT) Orders_CNT=Gear_A_N;
          for(i=Orders_CNT;i>Orders_CNT-Gear_A_N;i--)
            if(OrderSelect(Tickets[i-1],SELECT_BY_TICKET))
            if(OrderModify(OrderTicket(),OrderOpenPrice(),Stop_Loss,0,0,0))  Mark_Stop(Bars_Shift_1,-1); 
            else Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
            else Print("OrderSelect() failed: ",ErrorDescription(GetLastError()));
        }
        else
        for( i=Orders_CNT;i>0;i--)
        { 
          if(OrderSelect(Tickets[i-1],SELECT_BY_TICKET))
            if(OrderModify(OrderTicket(),OrderOpenPrice(),Stop_Loss,0,0,0)) 
              Mark_Stop(Bars_Shift_1,-1); 
            else
              Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
        }
      }
    }
  }