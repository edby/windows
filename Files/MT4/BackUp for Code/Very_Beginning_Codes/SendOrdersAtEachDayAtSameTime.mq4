//+------------------------------------------------------------------+
//|                                SendOrdersAtEachDayAtSameTime.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

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
if((TimeCurrent()-D'18:00')%(24*60*60)==0)
   {
   Print("Order has been sent!");
   OrderSend(Symbol(),OP_BUYSTOP,1,Bid+100*Point,3,Bid-200*Point,Bid+800*Point,0,0,0,0);
   OrderSend(Symbol(),OP_SELLSTOP,1,Ask-100*Point,3,Ask+200*Point,Ask-800*Point,0,0,0,0);
   }
   return(0);
  }
//+------------------------------------------------------------------+