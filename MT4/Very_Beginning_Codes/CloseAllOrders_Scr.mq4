//+------------------------------------------------------------------+
//|                                                 �ر����ж���.mq4 |
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
    {Print("ѡ�񶩵�ʧ�ܣ�",GetLastError());continue;}
    if(0==OrderType()||1==OrderType())
       if(OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),1000));
       else Print("ƽ��ʧ�ܣ�",GetLastError());   
    else
      if(OrderDelete(OrderTicket()));  
      else Print("ɾ������ʧ��",GetLastError());
   }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+