//+------------------------------------------------------------------+
//|                                               displayPostion.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007okw,China."

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int SignalBS =0;
datetime startTime=NULL, endTime = NULL;
color    SignalPriceBUY = Red;//Yellow;
color    SignalPriceSELL = Lime;//Cyan;
double startPrice, endprice;
int start()
  {
 int    orders=HistoryTotal(); Print("Ord=",orders);
 int i;
 for(i=orders-1;i>=0;i--)
 { 
    if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)  
    {
      if (OrderType( )==OP_BUY) 
        {
         SignalBS =1;      
         startTime= OrderOpenTime();endTime = OrderCloseTime ();
         startPrice= OrderOpenPrice(); endprice = OrderClosePrice ();
          SetBS();
        }
        else if (OrderType( )==OP_SELL) 
        {
          SignalBS =-1;     
          startTime= OrderOpenTime();endTime = OrderCloseTime ();
          startPrice= OrderOpenPrice(); endprice = OrderClosePrice ();
          SetBS();
       }
    }
 }  
//----
   return(0);
  }
//+------------------------------------------------------------------+


void SetBS()
{
if (SignalBS == 1)
   {
   ObjectDelete("BUY SIGNAL: " + TimeToStr(startTime));
   ObjectDelete("BUY : " + TimeToStr(endTime));
   ObjectDelete("BUY Close: " + TimeToStr(endTime));
   ObjectCreate("BUY SIGNAL: " + TimeToStr(startTime),OBJ_ARROW,0,startTime,startPrice);
   ObjectSet("BUY SIGNAL: " + TimeToStr(startTime),OBJPROP_ARROWCODE,5);
   ObjectSet("BUY SIGNAL: " + TimeToStr(startTime),OBJPROP_COLOR,SignalPriceBUY);
   ObjectCreate("BUY : " + TimeToStr(endTime),OBJ_TREND,0,startTime,startPrice,endTime,endprice);
   ObjectSet("BUY : " + TimeToStr(endTime),OBJPROP_COLOR,SignalPriceBUY);
   ObjectSet("BUY : " + TimeToStr(endTime),OBJPROP_RAY,false);
   ObjectSet("BUY : " + TimeToStr(endTime),OBJPROP_STYLE,STYLE_DOT);
   ObjectCreate("BUY Close: " + TimeToStr(endTime),OBJ_ARROW,0,endTime,endprice);
   ObjectSet("BUY Close: " + TimeToStr(endTime),OBJPROP_ARROWCODE,5);
   ObjectSet("BUY Close: " + TimeToStr(endTime),OBJPROP_COLOR,Tan);
   }
if (SignalBS == -1)
   {
   ObjectDelete("SELL SIGNAL: " + TimeToStr(startTime));
   ObjectDelete("SELL : " + TimeToStr(endTime));
   ObjectDelete("SELL Close: " + TimeToStr(endTime));   ObjectCreate("SELL SIGNAL: " + TimeToStr(startTime),OBJ_ARROW,0,startTime,startPrice);
   ObjectSet("SELL SIGNAL: " + TimeToStr(startTime),OBJPROP_ARROWCODE,5);
   ObjectSet("SELL SIGNAL: " + TimeToStr(startTime),OBJPROP_COLOR,SignalPriceSELL);
   ObjectCreate("SELL : " + TimeToStr(endTime),OBJ_TREND,0,startTime,startPrice,endTime,endprice);
   ObjectSet("SELL : " + TimeToStr(endTime),OBJPROP_COLOR,SignalPriceSELL);
   ObjectSet("SELL : " + TimeToStr(endTime),OBJPROP_RAY,false);
   ObjectSet("SELL : " + TimeToStr(endTime),OBJPROP_STYLE,STYLE_DOT);
   ObjectCreate("SELL Close: " + TimeToStr(endTime),OBJ_ARROW,0,endTime,endprice);
   ObjectSet("SELL Close: " + TimeToStr(endTime),OBJPROP_ARROWCODE,5);
   ObjectSet("SELL Close: " + TimeToStr(endTime),OBJPROP_COLOR,Green);
   }
}

