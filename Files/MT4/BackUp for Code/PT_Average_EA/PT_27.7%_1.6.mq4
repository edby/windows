//+------------------------------------------------------------------+  
//|                                                                  |  
//|              Modify int start()                                  |  
//|                                                                  | 
//+------------------------------------------------------------------+  
#include <stdlib.mqh>
  extern int 
      Magic_Number_N  = 1
  ,   Magic_Number_A  = 0
//  ,   x             = 2
//  ,   y             = 30
  ,   Magic_Number_R  = -1
  ,   SL              = 25
  ,   SL_Fast         = 20
  ,   SL_Max          = 40
  ,   MS_Big          = 30
  ,   MS_Small        = 15
  ,   Points_Win_Fast = 40
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
      Lots            = 0.2
  ,   Range_Ratio_Ind = 9
  ,   Slip            = 3
  ,   Move_Ratio      = 0.24
  ;

  int 
      Bar_Seconds
  ,   Pips_Slip
  ,   Pips_Digits
  ,   Bars_Shift_1
  ,   TP              = 0
  ,   CNT             = 1
  ;
  double 
      Pips_SL
  ;
  int init()
  {
    Comment(
      "Lots: ",              Lots
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
    int i,j;
    // Get Sign for trading from Indicator by iCustom()
    int Signal =  iCustom(NULL,0,"PT_Ind",Seek_Period_Ind,Bar_Ignore_Ind,Min_Points_Ind,Max_Points_Ind,Range_Ratio_Ind,1,0);
         
    // if Signal wants to close current order within 2 bars from the time when this order was opened, set Signal as 0;
    if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS))
      if( OrderMagicNumber() == Magic_Number_R && 
          OrderProfit()      <  0.0 &&
         (TimeCurrent() - OrderOpenTime())/Bar_Seconds < 5 &&
           ( (OrderType() == OP_BUY && Signal == -1) || 
             (OrderType() == OP_SELL && Signal == 1)
           )
        )Signal = 0;
        
    // ignore the reverse signal within 2 seek_Period from when the profit order was closed.
    if(Signal!=0 && OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY))
      if(OrderProfit()>300 && 
         iBarShift(NULL,0,OrderOpenTime())-iBarShift(NULL,0,OrderCloseTime())>50 &&
         iBarShift(NULL,0,OrderCloseTime())<50 &&
         ( (OrderType()==OP_BUY  && Signal ==-1)||
           (OrderType()==OP_SELL && Signal == 1)
         )
        ) Signal =0;
        
    // open reverse order once an order was closed within half of period on stop loss line
    int Magic_Number = Magic_Number_N;
    if( OrderSelect(OrdersTotal()-1,SELECT_BY_POS) )
    {
      if( (TimeCurrent()-OrderOpenTime())/Bar_Seconds   <  MathFloor(Seek_Period_Ind/2) && 
          MathAbs((OrderClosePrice()-OrderOpenPrice())) > Pips_SL*10  &&
          OrderMagicNumber() == Magic_Number_N && 
          OrderProfit()                                 < 0
        )
        { 
          if( OrderType() == OP_BUY && Close[0] < Low[iLowest(NULL,0,MODE_LOW,3, iBarShift(Symbol(),0,OrderOpenTime()) )]-2*Pips_SL)  
            { Signal = -1; Magic_Number = Magic_Number_R; }
          else if(OrderType() ==OP_SELL && Close[0] > High[iHighest(NULL,0,MODE_HIGH,3,iBarShift(Symbol(),0,OrderOpenTime()) )]+2*Pips_SL) 
            { Signal = 1;  Magic_Number = Magic_Number_R; }
        }
    }
  
/*  
    else if( OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY) )
    { 
     // if(OrderMagicNumber()!=1&&OrderProfit()<0&&iBarShift(NULL,0,OrderCloseTime())<=3) return;
      if( OrderProfit()<0 && iBarShift(NULL,0,OrderOpenTime()) < MathFloor(Seek_Period_Ind/2) && OrdersTotal() == 0 && OrderMagicNumber() == 1)
        {

        if(OrderType()==OP_BUY) Signal = -1;
        else                    Signal = 1;
        Magic_Number = Magic_Number_R;
     
        if(OrderType() == OP_BUY) OrderSend(Symbol(),OP_SELL,Lots,Bid,3*Pips_Slip,Bid+x_1*Pips_SL,0,0,3,0,0);
        if(OrderType() == OP_SELL) OrderSend(Symbol(),OP_BUY,Lots,Ask,3*Pips_Slip,Ask-x_1*Pips_SL,0,0,3,0,0);
        Mark();
        }
    }
*/

/*        
       // Open reverse order when reverse move occur within half of Seek Period
       if(Magic_Number == Magic_Number_N && OrderMagicNumber() == Magic_Number_N)
       { 
         int Bar_Past = (TimeCurrent()-OrderOpenTime())/Bar_Seconds
         ,   Bar_Open = iBarShift(NULL,0,OrderOpenTime())
         ;
         if( OrderType() == OP_BUY &&
             Bar_Past < Seek_Period_Ind/2 && 
             Bar_Past >=3 && 
             High[iHighest(NULL,0,MODE_HIGH,Bar_Open,0)] < High[Bar_Open]+2*Pips_SL &&
             (High[Bar_Open]-Close[0])/Pips_SL > 7
           ) { Signal = -1; Magic_Number = Magic_Number_R; Mark();}
           Print("First");
         if( OrderType() == OP_SELL &&
             Bar_Past < Seek_Period_Ind/2 && 
             Bar_Past >=3 && 
             Low[iLowest(NULL,0,MODE_LOW,Bar_Open,0)] > Low[Bar_Open]-2*Pips_SL &&
             (Close[0]-Low[Bar_Open])/Pips_SL > 7
           ) { Signal = 1; Magic_Number = Magic_Number_R; Mark();}
       }
 */       
       // Close order when the center of prices'gravity on the reverse side of the open price with in one seek period
       
    Rectify_Sudden_Swing();
//    Move_Stop_Loss() ;
    Fast_Move();

    // ignore the continuous same signal within very few time
    if(OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY)&&Signal!=0&&OrdersTotal()==0)
      if(OrderProfit()<0 )
        if ( (
              iBarShift(NULL,0,OrderCloseTime())<=40 && 
              OrderMagicNumber() == Magic_Number_R 
              ) ||
              (
               iBarShift(NULL,0,OrderCloseTime())<=3 &&
               ( (OrderType()==OP_BUY  && Signal == 1 ) ||(OrderType()==OP_SELL && Signal == -1) )
              )
           ) Signal = 0;

/*           
    // if have a good profits from last arrays orders, open reverse order
    if( OrdersTotal()==0 && OrderSelect(0,SELECT_BY_POS,MODE_HISTORY))
    {
      double SL_H = OrderStopLoss();
      int j=1;
      for( int i=1;i<4;i++)
        if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
          if( OrderStopLoss() == SL_H)
            j++;
      if(j == 4) 
    }
*/         
           
           
           
    
    // Real Procedure 
    double Stop_Loss = 0.0;
    // if get a trading signal and OrdersTotal() returns 0, Open order(the stop loss should be assigned by Set_Stop_Loss(),or default)
    if( OrdersTotal() == 0 )
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
    else if( OrderSelect(OrdersTotal()-1,SELECT_BY_POS) )
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
        else if( (TimeCurrent()-OrderOpenTime())/Bar_Seconds > Seek_Period_Ind ) // Reset Stop Loss Line
        { 
          Stop_Loss = Set_Stop_Loss(1,OP_BUY);
          if( Stop_Loss > OrderStopLoss())
          {
            Order_Ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number_A,0,0);
            if(Order_Ticket <0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
            
            if(OrderModify(OrderTicket(),OrderOpenPrice(),Stop_Loss,0,0,0)) Mark_Stop(Bars_Shift_1,1); 
            else Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
          }
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
        else if( (TimeCurrent()-OrderOpenTime())/Bar_Seconds > Seek_Period_Ind ) // Reset Stop Loss Line
        { 
          Stop_Loss = Set_Stop_Loss(1,OP_SELL);
          if( Stop_Loss < OrderStopLoss() && Stop_Loss > 0.0)
          {
            Order_Ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number_A,0,0);
            if(Order_Ticket <0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
            
            if(OrderModify(OrderTicket(),OrderOpenPrice(),Stop_Loss,0,0,0))  Mark_Stop(Bars_Shift_1,-1); 
            else Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
          }
        }
      }
    }  
    
    return(0);
  }
  
  void Fast_Move() // if the order in a fast moving, it will never reduce profit more than "SL_Fast" Pips.    
  {        
    if( OrderSelect(OrdersTotal()-1,SELECT_BY_POS) )
    if(iBarShift(NULL,0,OrderOpenTime())>=10)
    { 
      int Bar_Open = iBarShift(NULL,0,OrderOpenTime(),0);
      if(Bar_Open  <= 8*Seek_Period_Ind ) int Bar_Shift = Bar_Open;
      else  Bar_Shift = Seek_Period_Ind;
      int Bar_High = iHighest(NULL,0,MODE_HIGH,Bar_Shift,0)
      ,   Bar_Low  = iLowest(NULL,0,MODE_LOW,Bar_Shift,0)
      ;
      double   Profit_Points = (High[Bar_High] - Low[Bar_Low])/Pips_SL;
      if( Profit_Points > 50.0 && OrderType() == OP_BUY && OrderProfit()>0 && TimeCurrent()-Time[Bar_Low]!=0)
        if(Profit_Points*60/(TimeCurrent()-Time[Bar_Low]) > Move_Ratio && OrderClosePrice()-OrderStopLoss() > SL_Fast*Pips_SL)
          if( !OrderModify(OrderTicket(),OrderOpenPrice(),OrderClosePrice()-SL_Fast*Pips_SL,0,0,0) )
            Print("OrderModify() for Fast order failed: ",ErrorDescription(GetLastError()));
      if( Profit_Points > 50.0 && OrderType() == OP_SELL && OrderProfit()>0 && TimeCurrent()-Time[Bar_High]!=0)
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
        for(int i=Seek_Period_Ind;i>0;i--)  // seeking for big reverse point      
        {
          int Bars_Shift = iLowest(NULL,0,MODE_LOW,i,0);
          if(Low[Bars_Shift] == Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_B,Bars_Shift)] )
            if( (Close[0]-Low[Bars_Shift])/Pips_SL + Ratio_Rev < SL_Max )
              { S_L = Low[Bars_Shift]-Ratio_Rev*Pips_SL; break; }
        }
        
        if(S_L == 0.0)
        for( i=3;i<Seek_Period_Ind;i++)    // seeking for small reverse point
        {
          Bars_Shift = iLowest(NULL,0,MODE_LOW,i,0);
          if( Low[Bars_Shift] == Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_S,Bars_Shift)] )
            if( (Close[0]-Low[Bars_Shift])/Pips_SL < SL_Max/2 )
              { S_L = Low[Bars_Shift]-Ratio_Rev*Pips_SL; break; }
        } 
        
        if(S_L == 0.0) S_L = Ask - SL*Pips_SL;
      } 
      
      else if(Order_Type == OP_SELL)
      {
        for(i=Seek_Period_Ind;i>0;i--)  // seeking for big reverse point      
        {
          Bars_Shift = iHighest(NULL,0,MODE_HIGH,i,0);
          if(High[Bars_Shift] == High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_B,Bars_Shift)] )
            if( (High[Bars_Shift]-Close[0])/Pips_SL + Ratio_Rev < SL_Max )
              { S_L = High[Bars_Shift]+Ratio_Rev*Pips_SL; break; }
        }
        if(S_L == 0.0)
        for( i=3;i<Seek_Period_Ind;i++)    // seeking for small reverse point
        {
          Bars_Shift = iHighest(NULL,0,MODE_HIGH,i,0);
          if( High[Bars_Shift] == High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_S,Bars_Shift)] )
            if( (High[Bars_Shift]-Close[0])/Pips_SL < SL_Max/2 )
              { S_L = High[Bars_Shift]+Ratio_Rev*Pips_SL; break; }
        } 
        
        if(S_L == 0.0) S_L = Bid + SL*Pips_SL; 
      }
      return(S_L);      
    }
    
    // set stop loss line for an existing order, if can't get, stop loss line is 0.0;
    if(Orders == 1)
    {
      if(Order_Type == OP_BUY)
      {
        for( i=Seek_Period_Ind;i>0;i--)  // seeking for big reverse point      
        { 
          Bars_Shift_1 = iLowest(NULL,0,MODE_LOW,i,0);
          if( Low[Bars_Shift_1] == Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_B,Bars_Shift_1)] && 
              Bars_Shift_1 >= Reverse_Point_B   //  ||High[iHighest(NULL,0,MODE_HIGH,Bars_Shift_1,0)] - Low[Bars_Shift_1] > Points_Min_Sw*Pips_SL 
            )
              { S_L = Low[Bars_Shift_1]-Ratio_Rev*Pips_SL; break; }
        }
      }
      else if(Order_Type == OP_SELL)
      {
        for(i=Seek_Period_Ind;i>0;i--)  // seeking for big reverse point      
        {
          Bars_Shift_1 = iHighest(NULL,0,MODE_HIGH,i,0);
          if( High[Bars_Shift_1] == High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_B,Bars_Shift_1)] && 
              Bars_Shift_1 >= Reverse_Point_B // || High[Bars_Shift_1] - Low[iLowest(NULL,0,MODE_LOW,Bars_Shift_1,0)] > Points_Min_Sw*Pips_SL
             )
              { S_L = High[Bars_Shift_1]+Ratio_Rev*Pips_SL; break; }
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
  
  void Mark()
  {
    ObjectCreate(DoubleToStr(CNT,0),OBJ_TEXT,0,Time[0],Low[0]);
    ObjectSetText(DoubleToStr(CNT,0),CharToStr(166),20,"Wingdings",White);
    CNT++;
    return;
  }
  
  void Rectify_Sudden_Swing() // if an order was closed by a strong reverse bar and recover very soon, then open the same order again
  {
    if( OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY) && OrdersTotal()==0)
   {
    int B_S=iBarShift(NULL,0,OrderCloseTime());
    if(B_S<=2 && OrderProfit()<0)
      if(OrderType()==OP_BUY && High[B_S]-Low[B_S] > 25*Pips_SL && Close[0]-Low[B_S]>(High[B_S]-Low[B_S])/2)
       { if(!OrderSend(Symbol(),OP_BUY,Lots,Ask,3*Pips_Slip,Ask-12*Pips_SL,0,0,Magic_Number_N,0,0)) 
         Print("Error: ",ErrorDescription(GetLastError()));
       }
      else if (OrderType()==OP_SELL && High[B_S]-Low[B_S] > 25*Pips_SL && High[B_S]-Close[0]>High[B_S]-Low[B_S]/2)
       { if(!OrderSend(Symbol(),OP_SELL,Lots,Bid,3*Pips_Slip,Bid+12*Pips_SL,0,0,Magic_Number_N,0,0))
         Print("Error: ",ErrorDescription(GetLastError()));
       }
   }
   return;
  }
  
/*
void Move_Stop_Loss()             
  {                                
    int OT =  OrdersTotal();                   
    if( OT == 0 ) return;
      if(OrderSelect(OT-1,SELECT_BY_POS))
      { 
        int B_S = iBarShift(NULL,0,OrderOpenTime());
        if(B_S >= x) return(0);
        int Move_Stop    = y; 

        if( OrderType() == OP_BUY && Bid-OrderStopLoss() > Move_Stop*Pips_SL && High[iHighest(NULL,0,MODE_HIGH,B_S,0)]-OrderOpenPrice() >30*Pips_SL )
        {
          if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Move_Stop*Pips_SL,0,0,0))
            Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
        }
        else if( OrderType() == OP_SELL && OrderStopLoss()-Ask > Move_Stop*Pips_SL &&  OrderOpenPrice()-Low[iLowest(NULL,0,MODE_LOW,B_S,0)] >30*Pips_SL)
        {
          if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Move_Stop*Pips_SL,0,0,0))
            Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
        }
      }
    return;
  }
*/