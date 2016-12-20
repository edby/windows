//+------------------------------------------------------------------+
//|                                                                  |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

int Stop_Loss=50;

int init()
{
  return(0);
}


int deinit()
{
  
  return(0);
}

int start()
{
  int Signal=iCustom(NULL,0,"Test_Ind",15,1,0);
  if(Signal==0) {double Price_0=Ask;double Stop_Loss_0=Ask-Stop_Loss*Point;}
  else if(Signal==1) {Price_0=Bid;Stop_Loss_0=Bid+Stop_Loss*Point;}
  else if(Signal==2) {OrderSelect(OrdersTotal()-1,SELECT_BY_POS);OrderClose(OrderTicket(),1,Ask,3);return(0);}
  else if(Signal==3) {OrderSelect(OrdersTotal()-1,SELECT_BY_POS);OrderClose(OrderTicket(),1,Bid,3);return(0);}
  else return(0);
  
  if(OrdersTotal()==0){iWait();OrderSend(Symbol(),Signal,1,Price_0,3,Stop_Loss_0,0,0,0,0,0);}
  if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS))
  {
    if(OrderType()==OP_BUY&&Signal==1) {double Price_1=Bid;double Stop_Loss_1=Bid+Stop_Loss*Point;}
    else if(OrderType()==OP_SELL&&Signal==0) {Price_1=Ask;Stop_Loss_1=Ask-Stop_Loss*Point;}
    else return(0);
    if(OrderClose(OrderTicket(),1,Price_1,3,0)) OrderSend(Symbol(),Signal,1,Price_1,3,Stop_Loss_1,0,0,0,0,0);
  }
//  Move_Stop_Loss();
  return(0);
}


void Move_Stop_Loss()             // Stop loss line will go when absolute value of (difference of current price and stop loss price)is  
{                                 // bigger than small stop level, and when order profit is more than 20 points, the stop level should 
  if(OrdersTotal()==0) return;    // be changed to big stop level from small small stop level.
  for(int i=OrdersTotal();i>0;i--)
  {
    if(OrderSelect(i-1,SELECT_BY_POS))
    {
      int Profit_Point=NormalizeDouble(MathAbs(Close[0]-OrderOpenPrice())/Point,0); 
      int Move_Stop=80;
      if(Profit_Point>0&&Profit_Point<=500) Move_Stop=300;
      if(Profit_Point>800)Move_Stop=50;
      if(MathAbs(Close[0]-OrderStopLoss())>Move_Stop*Point)
      if(OrderType()==OP_BUY) {iWait();OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]-Move_Stop*Point,0,0,0);}
      else if(OrderType()==OP_SELL) {iWait();OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]+Move_Stop*Point,0,0,0);}
    } 
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


