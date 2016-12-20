//+------------------------------------------------------------------+
//|                                                           HisInSep.mq4 |
//|                       Copyright ?2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2007, okwh"    //Draw HISTOGRAM char in subwindow 在副窗口画直方图的方法
#property link      "http://www.mql4.com/cn/users/DxdCn"

#property indicator_separate_window
#property indicator_buffers 2
/*#property indicator_color1 Red
#property indicator_color2 SpringGreen
#property indicator_color3 Red
#property indicator_color4 SpringGreen
*/
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];

extern color  BK_color= White;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

   SetIndexStyle(0,DRAW_HISTOGRAM,0, 1, Black);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM,0, 1, BK_color);
   SetIndexBuffer(1,ExtMapBuffer2);
//----
   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
for (int i=Bars-counted_bars+1;i>=0;i--)
  {
      ExtMapBuffer1[i]=High[i];
    ExtMapBuffer2[i]=Low[i];
  }

//----
   return(0);
  }
//+------------------------------------------------------------------+

