//+------------------------------------------------------------------------------------------------------------------+  
//| 1. Gear=2, Gear_A=-2,Gear_A_N=1,Lots=0.2,Move_Ratio=0.21; Net Profit:2.3 Max Drawdown:26.7% Profit Factor:1.72   |  
//| 2. Gear=-3,Gear_A=-3,           Lots=0.2,Move_Ratio=0.21; Net Profit:1.2 Max Drawdown:5.6%  Profit Factor:1.58   |
//| 2. Gear=-3,Gear_A=0,            Lots=0.2,Move_Ratio=0.21; Net Profit:1.1 Max Drawdown:8.4%  Profit Factor:1.49   |
//| 3. Gear=-3,Gear_A=-2,Gear_A_N=2,Lots=0.2,Move_Ratio=0.21; Net Profit:1.2 Max Drawdown:7.0%  Profit Factor:1.56   |
//| 4. Gear=-3,Gear_A=-2,Gear_A_N=1,Lots=0.2,Move_Ratio=0.21; Net Profit:1.3 Max Drawdown:7.75% Profit Factor:1.55   | 
//| 5. Gear=-3,Gear_A=0,            Lots=0.2,Move_Ratio=0.43; Net Profit:1.3 Max Drawdown:8.8%  Profit Factor:1.58   | 
//+------------------------------------------------------------------------------------------------------------------+  
#include <stdlib.mqh>
  extern int    
       Gear     = -3
  ,    Gear_A   = 0
  ,    Gear_A_N = 2
  ;
  extern double 
       Lots = 0.2
  ;
  extern int 
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
  ,   Seek_Period_Ind = 16
  ,   Bar_Ignore_Ind  = 3
  ,   Min_Points_Ind  = 3
  ,   Max_Points_Ind  = 10
  ;
  extern double
      Range_Ratio_Ind = 9
  ,   Slip            = 3
  ,   Move_Ratio      = 0.21   //0.21;0.24;0.43  these three values are better according to both risk and profit.
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
    Comment(
      "Gear: ",              Gear
  ,   "\nLots: ",            Lots
  ,   "\nSL: ",              SL
  ,   "\nMS_Big: ",          MS_Big
  ,   "\nMS_Small: ",        MS_Small
  ,   "\nPoints_Win_Fast: ", Points_Win_Fast
  ,   "\nmSecond_Sleep: ",   mSecond_Sleep
  ,   "\nSeek_Period_Ind: ", Seek_Period_Ind
  ,   "\nBar_Ignore_Ind: ",  Bar_Ignore_Ind
  ,   "\nMin_Points_Ind: ",  Min_Points_Ind
  ,   "\nMax_Points_Ind: ",  Max_Points_Ind
  ,   "\nRange_Ratio_Ind:",  Range_Ratio_Ind
  ,   "\nSlip: ",            Slip
 );
    
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
    // Get Sign for trading from Indicator by iCustom()
    int Signal =  iCustom(NULL,0,"Test_Ind",Seek_Period_Ind,Bar_Ignore_Ind,Min_Points_Ind,Max_Points_Ind,Range_Ratio_Ind,1,0);
    
    int Magic_Number = Magic_Number_N;
    Orders_CNT=Orders_Number(); 
    Reverse_Signal(); 
    Rectify_Sudden_Swing();
    Fast_Move();
    Signal=Ignore_Signal(Signal);

    // Real Procedure 
    double Stop_Loss = 0.0;
    // if get a trading signal and OrdersTotal() returns 0, Open order(the stop loss should be assigned by Set_Stop_Loss(),or default)
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
   
    // if get a trading signal and an order has existed, stop loss should be changed when a new value assigned by Set_Stop_Loss(),and send reverse order after close current order when a reserse signal occurs.
    else if( OrderSelect(Tickets[Orders_CNT-1],SELECT_BY_TICKET) )
    {
      if( OrderType() == OP_BUY ) 
      { 
        if(Signal == -1) // Close the current order and send reverse order 
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
        else  // Reset Stop Loss Line
        { 
          Add_Orders(OP_BUY);
          Move_Stop (OP_BUY);
        }
      }
   
      else if( OrderType() == OP_SELL) 
      {
        if(Signal == 1) // Close the current order and send reverse order 
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
        else  // Reset Stop Loss Line
        {
          Add_Orders(OP_SELL);
          Move_Stop (OP_SELL);
        }
      }
    }  
    
    return(0);
  }
  
  void Fast_Move() // if the order in a fast moving, it will never reduce profit more than "SL_Fast" Pips.    
  { //for(int i=Orders_CNT-1;i>=0;i--)    
    if( OrderSelect(Tickets[Orders_CNT-1],SELECT_BY_TICKET) )
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
    
  double Set_Stop_Loss(int Orders,int Order_Type)    // return the stop loss value
  { 
    double S_L = 0.0;
    
    // set stop loss line for opening order, if can't get, the stop loss line will be order close price plus SL*Pips_SL
    if(Orders == 0)
    {
      if(Order_Type == OP_BUY)
      {
        for(int i=6;i<Seek_Period_Ind;i++)  // seeking for big reverse point      
        {
          int Bars_Shift = iLowest(NULL,0,MODE_LOW,i,0);
          if( MathAbs(Low[Bars_Shift] - Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_B,Bars_Shift)])<Point )
            if( (Close[0]-Low[Bars_Shift])/Pips_SL + Ratio_Rev < SL_Max )
              { S_L = Low[Bars_Shift]-Ratio_Rev*Pips_SL; break; }
        }
        
        if(S_L < Point )
        for( i=3;i<Seek_Period_Ind;i++)    // seeking for small reverse point
        {
          Bars_Shift = iLowest(NULL,0,MODE_LOW,i,0);
          if( MathAbs(Low[Bars_Shift] - Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_S,Bars_Shift)])<Point )
            if( (Close[0]-Low[Bars_Shift])/Pips_SL + Ratio_Rev < SL_Max )
              { S_L = Low[Bars_Shift]-Ratio_Rev*Pips_SL; break; }
        } 
        if(S_L < Point ) S_L = Ask - SL*Pips_SL;
      } 
      
      else if(Order_Type == OP_SELL)
      {
        for(i=6;i<Seek_Period_Ind;i++)  // seeking for big reverse point      
        {
          Bars_Shift = iHighest(NULL,0,MODE_HIGH,i,0);
          if( MathAbs(High[Bars_Shift] - High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_B,Bars_Shift)])<Point )
            if( (High[Bars_Shift]-Close[0])/Pips_SL + Ratio_Rev < SL_Max )
              { S_L = High[Bars_Shift]+Ratio_Rev*Pips_SL; break; }
        }
        if(S_L < Point )
        for( i=3;i<Seek_Period_Ind;i++)    // seeking for small reverse point
        {
          Bars_Shift = iHighest(NULL,0,MODE_HIGH,i,0);
          if( MathAbs(High[Bars_Shift] - High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_S,Bars_Shift)])<Point )
            if( (High[Bars_Shift]-Close[0])/Pips_SL + Ratio_Rev < SL_Max )
              { S_L = High[Bars_Shift]+Ratio_Rev*Pips_SL; break; }
        } 
        if(S_L < Point) S_L = Bid + SL*Pips_SL; 
      }
      return(S_L);      
    }
    
    // set stop loss line for an existing order, if can't get, stop loss line is 0.0;
    else if(Orders == 1)
    {
      if(Order_Type == OP_BUY)
      {
        for( i=6;i<Seek_Period_Ind;i++)  // seeking for big reverse point      
        { 
          Bars_Shift_1 = iLowest(NULL,0,MODE_LOW,i,0); 
          if( MathAbs(Low[Bars_Shift_1] - Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_B,Bars_Shift_1)])<Point   && Bars_Shift_1 >= Reverse_Point_B  
           // &&  High[iHighest(NULL,0,MODE_HIGH,Bars_Shift_1,0)] - Low[Bars_Shift_1] > Points_Min_Sw*Pips_SL 
            )
              { S_L = Low[Bars_Shift_1]-Ratio_Rev*Pips_SL; break; }
        }
      }
      else if(Order_Type == OP_SELL)
      {
        for(i=6;i<Seek_Period_Ind;i++)  // seeking for big reverse point      
        {
          Bars_Shift_1 = iHighest(NULL,0,MODE_HIGH,i,0);
          if( MathAbs(High[Bars_Shift_1] - High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_B,Bars_Shift_1)])<Point && Bars_Shift_1 >= Reverse_Point_B  
            // && High[Bars_Shift_1] - Low[iLowest(NULL,0,MODE_LOW,Bars_Shift_1,0)] > Points_Min_Sw*Pips_SL
             )
              { S_L = High[Bars_Shift_1]+Ratio_Rev*Pips_SL; break; }
        }
      }
      return(S_L);
    }
    
    // set stop loss line for an adding order.
    else
    {
      if(Order_Type == OP_BUY)
      {
        for(i=6;i<Seek_Period_Ind;i++)  // seeking for big reverse point      
        {
          Bars_Shift = iLowest(NULL,0,MODE_LOW,i,0);
          if( MathAbs(Low[Bars_Shift] - Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_B,Bars_Shift)])<Point &&
              Bars_Shift >= Reverse_Point_B
            )
              { S_L = Low[Bars_Shift]-Ratio_Rev*Pips_SL; break; }
        }
/*        
        if(S_L < Point )
        for( i=3;i<Seek_Period_Ind;i++)    // seeking for small reverse point
        {
          Bars_Shift = iLowest(NULL,0,MODE_LOW,i,0);
          if( Low[Bars_Shift] == Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_S,Bars_Shift)] )
            if( (Close[0]-Low[Bars_Shift])/Pips_SL + Ratio_Rev < SL_Max )
              { S_L = Low[Bars_Shift]-Ratio_Rev*Pips_SL; break; }
        } */
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
/*
        if(S_L < Point )
        for( i=3;i<Seek_Period_Ind;i++)    // seeking for small reverse point
        {
          Bars_Shift = iHighest(NULL,0,MODE_HIGH,i,0);
          if( High[Bars_Shift] == High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_S,Bars_Shift)] )
            if( (High[Bars_Shift]-Close[0])/Pips_SL + Ratio_Rev < SL_Max )
              { S_L = High[Bars_Shift]+Ratio_Rev*Pips_SL; break; }
        } */
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
  
  void Mark()
  {
    ObjectCreate(DoubleToStr(CNT,0),OBJ_TEXT,0,Time[0],Low[0]);
    ObjectSetText(DoubleToStr(CNT,0),CharToStr(166),20,"Wingdings",White);
    CNT++;
    return;
  }
  
  void Rectify_Sudden_Swing() // if an order was closed by a strong reverse bar and recover very soon, then open the same order again
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
  
  void Reverse_Signal() // open reverse order once an order was closed within half of period on stop loss line
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
  
  int Ignore_Signal(int Sig)  // ignore the continuous same signal within very few time
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
  
  int Orders_Number()  //Put selected orders' tickets into array.
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