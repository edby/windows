//+------------------------------------------------------------------+
//|                 backup for trade according to time and price.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#include <WinUser32.mqh>
#property show_inputs
//--- input parameters
extern int       open_time,close_time,sign,Lots;
extern double    buy_price_set;
extern double    sell_price_set;
// extern datetime  time_current;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
bool isFirst = true;
datetime  time_current;
int init(){
   if(isFirst) 
   { isFirst = false; 
    time_current=TimeCurrent();
    }
     
   // Do every time initialization
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
  Print("time_passed(Minutes) is:",(TimeCurrent()-time_current)/60);
// Alert for trading
if(open_time==0&&close_time==0&&Lots==0)
int note=MessageBox("Please set parameters","alert_message",MB_YESNO|MB_ICONQUESTION);
if (note==IDYES) return(0);

//send order aftet open_time;
   if(TimeCurrent()-time_current>=open_time*60&&OrdersTotal()==0&&TimeCurrent()-time_current<=18)
      if(sign*(Close[0]-buy_price_set)>0) OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-7*Point,0,0,0,0,Red);
      else if(sign*(sell_price_set-Close[0])>0) OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+7*Point,0,0,0,0,Red);
   
// close order after close_tiime;
   int orders_total=OrdersTotal();
   while(orders_total)
   {
   if(OrderSelect(orders_total-1,SELECT_BY_POS)&&TimeCurrent()-time_current>=close_time*60)
   {
    if(OrderType()==0)  OrderClose(OrderTicket(),OrderLots(),Bid,3,White);
     else               OrderClose(OrderTicket(),OrderLots(),Ask,3,White);
     Print("OrderSend() has been executed!");
   }
   orders_total--;
   }
   }