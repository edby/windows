//+------------------------------------------------------------------+
//|                                                      EA_Test.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

  int 
      Bars_Sleep
  ,   Pips_Slip
  ,   Pips_Digits
  ,   SL_Point = 15
  ,   TP_Point = 0
  ;
  double 
      Pips_SL
  ;
  int init()
  {
    Bars_Sleep = Period()*60;
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
         (OrderCloseTime()-OrderOpenTime())/Bars_Sleep <= 10  
      &&  OrderProfit()                                <  0     
      && (TimeCurrent()-OrderCloseTime())/Bars_Sleep   <= 2
         )
           return(0);

    Move_Stop_Loss();
    
    int Signal =  iCustom(NULL,0,"Test_Ind",16,10.5,3,1,0);
    if( Signal == -1 ) return(0);
    if( OrdersTotal() == 0 )
    {
      if( Signal == 0 ) 
      {
        iWait();
        OrderSend(Symbol(),OP_BUY,1,Ask,3*Pips_Slip,Ask-SL_Point*Pips_SL,TP_Point,0,0,0,0);
      }
      else if(Signal==1)
      {  
        iWait();
        OrderSend(Symbol(),OP_SELL,1,Bid,3*Pips_Slip,Bid+SL_Point*Pips_SL,TP_Point,0,0,0,0);
      }
    }
    else if( OrderSelect(OrdersTotal()-1,SELECT_BY_POS) )
    {
      if( OrderType() == OP_BUY && Signal == 1 ) 
        {
          if( OrderClose(OrderTicket(),1,Bid,3*Pips_Slip,0) )  
            OrderSend(Symbol(),OP_SELL,1,Bid,3*Pips_Slip,Bid+SL_Point*Pips_SL,TP_Point,0,0,0,0);
        }
      else if( OrderType() == OP_SELL && Signal == 0 ) 
        {
          if( OrderClose(OrderTicket(),1,Ask,3*Pips_Slip,0) )  
            OrderSend(Symbol(),OP_BUY,1,Ask,3*Pips_Slip,Ask-SL_Point*Pips_SL,TP_Point,0,0,0,0);
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
        int Profit_Point = NormalizeDouble( MathAbs( Close[0] - OrderOpenPrice() )/Pips_SL,0 )
        ,   Move_Stop    = 30; 

        if( Profit_Point > 50 ) Move_Stop = 15;
        if( MathAbs( Close[0] - OrderStopLoss() ) > Move_Stop*Pips_SL )
        {
          if( OrderType() == OP_BUY ) 
          {
            iWait();
            OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]-Move_Stop*Pips_SL,0,0,0);
          }
          else if( OrderType() == OP_SELL ) 
          {
            iWait();
            OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]+Move_Stop*Pips_SL,0,0,0);
          }
        }
      }
    return;
  }

  void iWait()
  {
    if( IsTradeContextBusy() || !IsTradeAllowed() )
    Sleep(110);
    RefreshRates();
    return;
  }

//指标值和K线值得差。