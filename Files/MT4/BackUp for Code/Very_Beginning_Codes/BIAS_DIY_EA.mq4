//+------------------------------------------------------------------+
//|                                                         Test.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
extern int stop_loss=60;
datetime order_open_time;
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
  double y0,y1,y2,y3;
  int Trade_Sign=iCustom(NULL,0,"BIAS_DIY",5,10,2,4); 
  if(Trade_Sign==0) return(0);
  
  if(OrdersTotal()==0)
    {
     if(Trade_Sign==1) 
        {iWait();if(OrderSend(Symbol(),OP_BUY,1,Ask,3,Ask-stop_loss*Point,0,0,0,0,0)==-1) Print("First_Order_Send has some error:",GetLastError());}
     else 
        {iWait();if(OrderSend(Symbol(),OP_SELL,1,Bid,3,Bid+stop_loss*Point,0,0,0,0,0)==-1) Print("Second_Order_Send has some error:",GetLastError());}
    }
  else 
    {
     OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
     order_open_time=OrderOpenTime();
    if((TimeCurrent()-order_open_time)/60>=30)
    {
     if(Trade_Sign==1) 
      {
        iWait();
        OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
        if(OrderType()==OP_SELL)
        {
        int order_close_sign=OrderClose(OrderTicket(),1,Ask,3,0);
       if(order_close_sign==1)
          if(OrderSend(Symbol(),OP_BUY,1,Ask,3,Ask-stop_loss*Point,0,0,0,0,0)==-1) Print("Third_Order_Send has some error:",GetLastError());
          else ;
       else Print("First_Order_Close has some error:",GetLastError());
        }
       }
      else
       {
        iWait();
        OrderSelect(0,SELECT_BY_POS,MODE_TRADES);
        if(OrderType()==OP_BUY)
        {
         order_close_sign=OrderClose(OrderTicket(),1,Bid,3,0);
      if(order_close_sign==1)
          if(OrderSend(Symbol(),OP_SELL,1,Bid,3,Bid+stop_loss*Point,0,0,0,0,0)==-1) Print("Third_Order_Send has some error:",GetLastError());
          else ;
      else Print("Second_Order_Close has some error:",GetLastError());
        }
       }
      }
    }
  
  return(0);
  }
  
  
void iWait()
{
 if(IsTradeContextBusy()||!IsTradeAllowed())
 Sleep(110);
 RefreshRates();
 return(0);
}