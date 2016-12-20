//+------------------------------------------------------------------+

//|                                                         BIAS.mq4 |

//|                       Copyright ?2005, MetaQuotes Software Corp. |

//|                                        http://www.metaquotes.net |

//+------------------------------------------------------------------+

#property copyright "Copyright ?2005, MetaQuotes Software Corp."

#property link      "http://www.metaquotes.net"



#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Silver

extern int       MAPeriod=9;
double BiasBuffer[];

int init()
  {
   IndicatorBuffers(1);
   SetIndexBuffer(0, BiasBuffer);
   SetIndexStyle(0,DRAW_LINE);
   return(0);
   }

int deinit()
  {
  return(0);
  }


int start()
  {
   int    counted_bars=IndicatorCounted();
   if(Bars<=MAPeriod) return(0);

   int i=Bars-MAPeriod-1;
   if(counted_bars>=MAPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
     double x=iMA(NULL,0,MAPeriod,0,MODE_SMA,PRICE_CLOSE,i);
     BiasBuffer[i]=(Close[i]-x)/Close[i];
     i--;
     }
   return(0);
  }

