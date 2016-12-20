//+------------------------------------------------------------------+  #1 opened when orderstotal()==0;
//|                                                                  |  #2 opened by move_Stop_Loss() when #1 loss within one period bars
//|              Modify int start()                                  |  #3 opened directly when fiting the condition which should open order
//|                                                                  |     which vs #2
//+------------------------------------------------------------------+  This situation will open 3 orders within very a few bars(even 1 bar).
#include <stdlib.mqh>
  extern int 
      Magic_Number    = 1
  ,   Magic_Number_R  = -1
  ,   Bars_Run        = 10
  ,   Bars_Sleep      = 2
  ,   Lots            = 1
  ,   SL_Point        = 20
  ,   MS_Big          = 30
  ,   MS_Small        = 15
  ,   Point_Win       = 50
  ,   Point_Win_F     = 40
  ,   mSecond_Sleep   = 110
  ,   Bars_Sleep_M    = 15
  ,   Seek_Period_Ind = 16
  ,   Bar_Ignore_Ind  = 3
  ,   Min_Points_Ind  = 3
  ,   Max_Points_Ind  = 10
  ;
  extern double
      Stop_Loss
  ,   Range_Ratio_Ind  = 9
  ,   Slip             = 3
  ;

  int 
      Bar_Seconds
  ,   Pips_Slip
  ,   Pips_Digits
  ,   TP_Point = 0
  ;
  double 
      Pips_SL
  ;
  int init()
  {
    Comment(
      "Lots: ",              Lots
  ,   "\nSL_Point: ",        SL_Point
  ,   "\nMS_Big: ",          MS_Big
  ,   "\nMS_Small: ",        MS_Small
  ,   "\nPoint_Win: ",       Point_Win
  ,   "\nPoint_Win_F: ",     Point_Win_F
  ,   "\nmSecond_Sleep: ",   mSecond_Sleep
  ,   "\nBars_Sleep_M: ",    Bars_Sleep_M
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
    if ( OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY) )
      if (
         (OrderCloseTime()-OrderOpenTime())/Bar_Seconds <= Bars_Run  
//    &&  OrderProfit()                                 <  0
      && (TimeCurrent()-OrderCloseTime())/Bar_Seconds   <= Bars_Sleep
         )
      return(0);
    
 
    Move_Stop_Loss();
    
    int Signal =  iCustom(NULL,0,"Test_Ind",Seek_Period_Ind,Bar_Ignore_Ind,Min_Points_Ind,Max_Points_Ind,Range_Ratio_Ind,1,0);
    if( Signal == 0 ) return(0);
 if( OrdersTotal() == 0 )
    {
      if( Signal == 1 ) 
      {
        iWait();
        int Order_Ticket= OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip*Pips_Slip,Ask-SL_Point*Pips_SL,TP_Point,0,Magic_Number,0,0); 
        if(Order_Ticket < 0) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
      }
      else if(Signal== -1)
      {  
        iWait();
        Order_Ticket= OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip*Pips_Slip,Bid+SL_Point*Pips_SL,TP_Point,0,Magic_Number,0,0);
        if( Order_Ticket < 0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
      }
    }
    else if( OrderSelect(OrdersTotal()-1,SELECT_BY_POS) )
    {
      if( OrderType() == OP_BUY && Signal == -1 ) 
        { iWait();
          if( OrderClose(OrderTicket(),Lots,Bid,Slip*Pips_Slip,0) )  
          {
            Order_Ticket= OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip*Pips_Slip,Bid+SL_Point*Pips_SL,TP_Point,0,Magic_Number,0,0);
            if( Order_Ticket < 0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
          }
          else Print("OrderClose() failed: ",ErrorDescription(GetLastError()));
        }
      else if( OrderType() == OP_SELL && Signal == 1 ) 
        { iWait();
          if( OrderClose(OrderTicket(),Lots,Ask,Slip*Pips_Slip,0) )  
          {
            Order_Ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip*Pips_Slip,Ask-SL_Point*Pips_SL,TP_Point,0,Magic_Number,0,0);
            if( Order_Ticket < 0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
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
        int Bar_Shift = iBarShift(NULL,0,OrderOpenTime(),true);
        if(Bar_Shift < 0) Print("iBarshift() failed: ", ErrorDescription(GetLastError()));
        else if(Bar_Shift < Seek_Period_Ind)
        {  
          bool OS = false;
          if(OrderType() == OP_BUY && Close[0] < Low[Bar_Shift]-Pips_SL)
          {
            if(OrderMagicNumber() == 1) OS = true;
            if(!OrderClose(OrderTicket(),Lots,OrderClosePrice(),Slip*Pips_Slip))
              Print("OrderClose() in Move_Stop_Loss() failed: ", ErrorDescription(GetLastError()));
            else if( OS )
              if(OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip*Pips_Slip,Bid+SL_Point*Pips_SL,TP_Point,0,Magic_Number_R,0,0) < 0)
                Print("OrderSend() in Move_Stop_Loss() failed: ", ErrorDescription(GetLastError()));              
          } 

          if(OrderType() == OP_SELL && Close[0] > High[Bar_Shift]+Pips_SL)
          {
            if(OrderMagicNumber() == 1) OS = true;
            if(!OrderClose(OrderTicket(),Lots,OrderClosePrice(),Slip*Pips_Slip))
              Print("OrderClose() in Move_Stop_Loss() failed: ", ErrorDescription(GetLastError()));
            else if( OS )
              if(OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip*Pips_Slip,Ask-SL_Point*Pips_SL,TP_Point,0,Magic_Number_R,0,0) < 0)
                Print("OrderSend() in Move_Stop_Loss() failed: ", ErrorDescription(GetLastError()));              
          } 
        }
      }
     
        if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS))
        {
          int Profit_Points = NormalizeDouble( MathAbs( OrderClosePrice() - OrderOpenPrice() )/Pips_SL,0 )
          ,   Move_Stop    = MS_Big; 
          if( Profit_Points > Point_Win ) Move_Stop = MS_Small;
          
          if((TimeCurrent()-OrderOpenTime())/Bar_Seconds < Bars_Sleep_M ) 
          {
             if(Profit_Points < Point_Win_F) return;
             else Move_Stop = MS_Small;
          }
          
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
  
//  触发点应该是缓坡向上或者向下的不能转折。

