//+------------------------------------------------------------------+
//|                                                      EA_Test.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#include <stdlib.mqh>
  
  extern int 
      Magic_Number     = 100
  ,   SL_Point         = 16
  ,   MS_Big           = 30
  ,   MS_Small         = 15
  ,   Point_Win        = 50
  ,   mSecond_Sleep    = 110
  ,   Bars_Run         = 10
  ,   Bars_Sleep_End   = 2
  ,   Bars_Sleep_Start = 14
  ,   Seek_Period_Ind  = 16
  ,   Bar_Ignore_Ind   = 3
  ;
  extern double
      Range_Ratio_Ind  = 10.5
  ,   Delta_Ratio_Ind  = 3
  ;
  int 
      Bar_Second
  ,   Pips_Slip
  ,   Pips_Digits
  ,   TP_Point = 0
  ;
  double 
      Pips_SL
  ,   Slip     = 0.5
  ;
  
  int init()
  {
    Bar_Second = Period()*60;
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
    if ( OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY) )
    {
      if (
         (OrderCloseTime()-OrderOpenTime())/Bar_Second <= Bars_Run  
   //   &&  OrderProfit()                              <  0     
      && (TimeCurrent()-OrderCloseTime())/Bar_Second   <= Bars_Sleep_End
         )
           return(0);
     }
     else Print("OrderSelect() failed: ",ErrorDescription(GetLastError()));

    Move_Stop_Loss();
    
    int Signal =  iCustom(NULL,0,"Test_Ind",Seek_Period_Ind,Bar_Ignore_Ind,Range_Ratio_Ind,Delta_Ratio_Ind,1,0);
    if( Signal == 0 ) return(0);
    if( OrdersTotal() == 0 )
    {
      if( Signal == 1 ) 
      {
        iWait();
        int Order_Ticket= OrderSend(Symbol(),OP_BUY,1,Ask,Slip*Pips_Slip,Ask-SL_Point*Pips_SL,TP_Point,0,Magic_Number,0,0); 
        if(Order_Ticket < 0) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
      }
      else if(Signal==-1)
      {  
        iWait();
        Order_Ticket= OrderSend(Symbol(),OP_SELL,1,Bid,Slip*Pips_Slip,Bid+SL_Point*Pips_SL,TP_Point,0,Magic_Number,0,0);
        if( Order_Ticket < 0 ) if(Order_Ticket < 0) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
      }
    }
    else if( OrderSelect(OrdersTotal()-1,SELECT_BY_POS) )
    {
      if( OrderType() == OP_BUY && Signal == -1 ) 
        { iWait();
          if( OrderClose(OrderTicket(),1,Bid,Slip*Pips_Slip,0) )  
          {
            Order_Ticket= OrderSend(Symbol(),OP_SELL,1,Bid,Slip*Pips_Slip,Bid+SL_Point*Pips_SL,TP_Point,0,Magic_Number,0,0);
            if( Order_Ticket < 0 ) if(Order_Ticket < 0) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
          }
          else Print("OrderClose() failed: ",ErrorDescription(GetLastError()));
        }
      else if( OrderType() == OP_SELL && Signal == 1 ) 
        { iWait();
          if( OrderClose(OrderTicket(),1,Ask,Slip*Pips_Slip,0) )  
          {
            Order_Ticket=OrderSend(Symbol(),OP_BUY,1,Ask,Slip*Pips_Slip,Ask-SL_Point*Pips_SL,TP_Point,0,Magic_Number,0,0);
            if( Order_Ticket < 0 ) if(Order_Ticket < 0) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
          }
          else Print("OrderClose() failed: ",ErrorDescription(GetLastError()));
        }
     }
    return(0);
  }

  void Move_Stop_Loss()             // Stop loss line will go when absolute value of current price minus stop loss price is  
  {                                 // bigger than big stop level, and when order profit grows big, the stop level should 
    int OT =  OrdersTotal();        // be changed to small stop level from the big one.                     
    if( OT == 0 ) return;
      if(OrderSelect(OT-1,SELECT_BY_POS))
      { 
        if((TimeCurrent()-OrderOpenTime())/Bar_Second<=Bars_Sleep_Start) return(0);
        int Profit_Point = NormalizeDouble( MathAbs( OrderClosePrice() - OrderOpenPrice() )/Pips_SL,0 )
        ,   Move_Stop    = MS_Big; 

        if( Profit_Point > Point_Win ) Move_Stop = MS_Small;
        if( OrderType() == OP_BUY && Bid-OrderStopLoss() > Move_Stop*Pips_SL )
        {
          iWait();
          if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Move_Stop*Pips_SL,0,0,0))
            Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
        }
        else if( OrderType() == OP_SELL && OrderStopLoss()-Ask > Move_Stop*Pips_SL )
        {
          iWait();
          if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Move_Stop*Pips_SL,0,0,0))
            Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
        }
      }
    return;
  }

  void iWait()
  {
    if(!IsTradeAllowed())
    Sleep(mSecond_Sleep);
    RefreshRates();
    return;
  }

//指标值和K线值得差。




