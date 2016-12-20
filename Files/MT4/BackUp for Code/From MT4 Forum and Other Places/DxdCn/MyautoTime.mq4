//+------------------------------------------------------------------+
//|                                                  MATimeAuto.mq4 |
//|                                        Copyright ?2007 , Dxdcn. |
//|                                 http://blog.sina.com.cn/FXTrade |
//+------------------------------------------------------------------+
#property  copyright "Copyright 2007 , Dxd, China."
#property  link      "http://blog.sina.com.cn/FXTrade ,  http://www.mql4.com/users/DxdCn"
#property  link      "http://www.waihui.com/bbs/profile.php?action=show&uid=5273"
//---- indicator settings
#property  indicator_chart_window
//#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  Silver
#property  indicator_color2  Red
#property  indicator_color3  Lime
#property  indicator_width1  2
//---- indicator parameters
extern int SlowEMA = 24;
extern int SlowEMA1 = 408;
//---- indicator buffers
double DxdnBuffer[];
double DxdcnSlowBuffer[];
double DxdcnFastBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0, DRAW_LINE); // DRAW_HISTOGRAM);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(0, DxdnBuffer);
   SetIndexBuffer(1, DxdcnSlowBuffer);
   SetIndexStyle(2, DRAW_ARROW, STYLE_SOLID, 4);
   SetIndexDrawBegin(1, SlowEMA1);
   SetIndexBuffer(2, DxdcnFastBuffer);
   
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int start()
  {
   SetIndexStyle(2, DRAW_ARROW, STYLE_SOLID, 4); 
   int limit;
   limit = Bars - 50;
   int SlowEMAA = SlowEMA;
   int SlowEMAB = SlowEMA1;
   double opD, opD1;
   //---- macd counted in the 1-st buffer
   double hhh, lll;
   for(int i = limit; i >= 0; i--)
     {
       //寻找某范围内高低的差值点数
       SlowEMAA = (High[iHighest(NULL, 0, MODE_HIGH, SlowEMA, i)] - 
                   Low[iLowest(NULL, 0, MODE_HIGH, SlowEMA, i)]) / Point;
       SlowEMAB = (High[iHighest(NULL, 0, MODE_HIGH, SlowEMA1, i)] - 
                   Low[iLowest(NULL, 0, MODE_HIGH, SlowEMA1, i)]) / Point;
       //用此点数做MA
       DxdnBuffer[i] = iMA(NULL, 0, SlowEMAA, 0, MODE_SMA, PRICE_CLOSE, i);
       DxdcnSlowBuffer[i] = iMA(NULL, 0, SlowEMAB, 0, MODE_SMA, PRICE_CLOSE, i);
     }
   //判断交叉
   for(i = limit; i >= 0; i--)
     {
       if(((DxdnBuffer[i] - DxdcnSlowBuffer[i]) > 0) && 
          ((DxdnBuffer[i+2] - DxdcnSlowBuffer[i+2]) < 0) && 
          ((DxdnBuffer[i] - DxdnBuffer[i+2]) > 0))
           DxdcnFastBuffer[i]=DxdnBuffer[i];
       if(((DxdnBuffer[i] - DxdcnSlowBuffer[i]) < 0) && 
          ((DxdnBuffer[i+2] - DxdcnSlowBuffer[i+2]) > 0) && 
          ((DxdnBuffer[i] - DxdnBuffer[i+2]) < 0))
           DxdcnFastBuffer[i] = DxdnBuffer[i];
     }
  }
//+------------------------------------------------------------------+