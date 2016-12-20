//+------------------------------------------------------------------+
//|                                                                  |
//|            Profit is positive for two years                      | //通过zigzag确认删除一些点
//|                                                                  |
//+------------------------------------------------------------------+

int Bars_Sleep;
int init()
{
  Bars_Sleep=Time[1]-Time[2];
  return(0);
}


int deinit()
{
  
  return(0);
}

int start()
{
  if(OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY))
  if((OrderCloseTime()-OrderOpenTime())/Bars_Sleep<=10&&OrderProfit()<0&&(TimeCurrent()-OrderCloseTime())/Bars_Sleep<=2)
  return(0);
  Move_Stop_Loss();
  int Signal=iCustom(NULL,0,"Test_Ind",16,Bars_Sleep/60,2,0);
  if(Signal==-1) return(0);
  
  if(OrdersTotal()==0)
  { 
    if(Signal==0){iWait();OrderSend(Symbol(),Signal,1,Ask,3,Ask-150*Point,0,0,0,0,0);}
    else if(Signal==1){iWait();OrderSend(Symbol(),Signal,1,Bid,3,Bid+150*Point,0,0,0,0,0);}
  }
  else if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS))
  {
    if(OrderType()==OP_BUY&&Signal==1) 
      if(OrderClose(OrderTicket(),1,Bid,3,0)) OrderSend(Symbol(),Signal,1,Bid,3,Bid+150*Point,0,0,0,0,0);
    else if(OrderType()==OP_SELL&&Signal==0) 
      if(OrderClose(OrderTicket(),1,Ask,3,0)) OrderSend(Symbol(),Signal,1,Ask,3,Ask-150*Point,0,0,0,0,0);
  }
  return(0);
}

void Move_Stop_Loss()             // Stop loss line will go when absolute value of (difference of current price and stop loss price)is  
{                                 // bigger than small stop level, and when order profit is more than 20 points, the stop level should 
  int OT=OrdersTotal();           // be changed to big stop level from small small stop level.                     
  if(OT==0) return;
    if(OrderSelect(OT-1,SELECT_BY_POS))
    {
      int Profit_Point=NormalizeDouble(MathAbs(Close[0]-OrderOpenPrice())/Point,0); 
      int Move_Stop=300; //if(Profit_Point>0&&Profit_Point<=500) 
      if(Profit_Point>500) Move_Stop=150;
      if(MathAbs(Close[0]-OrderStopLoss())>Move_Stop*Point)
      if(OrderType()==OP_BUY) {iWait();OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]-Move_Stop*Point,0,0,0);}
      else if(OrderType()==OP_SELL) {iWait();OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]+Move_Stop*Point,0,0,0);}
    }
  return;
}

void iWait()
{
  if(IsTradeContextBusy()||!IsTradeAllowed())
  Sleep(110);
  RefreshRates();
  return;
}


