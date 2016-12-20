//+------------------------------------------------------------------+
//|                                                 关闭所有订单.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   while(OrdersTotal())
   {
   int total=OrdersTotal();
   for(int i=total-1;i>=0;i--)
   {
    if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) 
    {Print("选择订单失败，",GetLastError());continue;}
    if(0==OrderType()||1==OrderType())
       if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),1000));
       else Print("平单失败，",GetLastError());   
    else
      if(OrderDelete(OrderTicket()));  
      else Print("删除订单失败",GetLastError());
   }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+