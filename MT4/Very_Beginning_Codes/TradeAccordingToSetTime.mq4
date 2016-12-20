//+------------------------------------------------------------------+
//|                                      TradeAccordingToSetTime.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#property show_inputs
#include <WinUser32.mqh>
//--- input parameters
extern int open_time=0; // time of opening orders
extern int lots=0; // lots of new orders
extern int trade_sign=0; //mark "buy" or "sell" of new orders
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
bool time_is_first=true, trade_is_first=true;
datetime time_begin;
int init()
  {
//assign "time_begin" it value at this EA's first initializing
if(time_is_first==true)  {time_begin=TimeCurrent();time_is_first=false;}
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
//warning if time of opening is not set at the beginning.
   if (open_time==0||lots==0)
   int note=MessageBox("Please set opening time and lots at first!","Alert Message",MB_YESNO|MB_ICONEXCLAMATION);
   if (note==IDOK) 
   return (0);
   
//send orders(one order--buy/sell immediately and the other--buy/sell according to price ) when the time set is exhausted.
  if((TimeCurrent()-time_begin)/60>=open_time)
  while(trade_is_first)
  {
  
  if(trade_sign==0) 
 {OrderSend(Symbol(),OP_BUY,lots,Ask,3,0,0,0,0,0,0); OrderSend(Symbol(),OP_BUYLIMIT,lots,Bid+100*Point,3,0,0,0,0,0,0);}
  else
 {OrderSend(Symbol(),OP_SELL,lots,Bid,3,0,0,0,0,0,0);OrderSend(Symbol(),OP_SELLLIMIT,lots,OrderClosePrice()-100*Point,3,0,0,0,0,0,0);}
  if(OrdersTotal()!=0) trade_is_first=false;
  }
  
  Print("open_time: ", open_time,"  lots: ",lots,"  trade_sign: ",trade_sign);
  
   return(0);
  }
  
//+------------------------------------------------------------------+