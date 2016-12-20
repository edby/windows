//+------------------------------------------------------------------+
//|                                             MoveStopLossLine.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#property show_inputs
#include <WinUser32.mqh>

extern int trailing_stop=0;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//Warning if trailing stop level is never set;
if(trailing_stop==0)
{ MessageBox("Please set value for 'trailing_stop'! ","Warning!", MB_OK|MB_ICONWARNING); Sleep(3000);return(0);}

for(int i=OrdersTotal()-1;i>=0;i--)
{
 if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
 { 
   if(OrderType()==OP_BUY&&(Bid-OrderStopLoss())>trailing_stop*Point)
    { iWait(); OrderModify(OrderTicket(),OrderOpenPrice(),Bid-trailing_stop*Point,0,0,0);}
   else if ((OrderType()==OP_SELL&&(OrderStopLoss()-Ask)>trailing_stop*Point)||(OrderType()==OP_SELL&&OrderStopLoss()==0))
    { iWait(); OrderModify(OrderTicket(),OrderOpenPrice(),Ask+trailing_stop*Point,0,0,0);}   
 }
 
}
   
//----
   return(0);
  }
  
void iWait()
{
 if(IsTradeContextBusy()||!IsTradeAllowed()) 
 Sleep(110);
 
 RefreshRates();
 return(0);
}
//+------------------------------------------------------------------+