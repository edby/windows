
#property copyright "Copyright ?2007, okwh."
#property link "http://blog.sina.com.cn/FXTrade"
//#property  indicator_separate_window
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Tan//Red
#property indicator_color2 Tan
#property indicator_color3 Red
#property indicator_color4 Red
#property indicator_color5 DarkSlateGray//SkyBlue//Red
#property indicator_color6 DarkSlateGray//SkyBlue
#property indicator_color7 DarkSlateGray//DarkOliveGreen//Red
#property indicator_color8 DarkSlateGray//DarkOliveGreen//Tan//SkyBlue
//---- input parameters
extern int       rsiP = 34;//23;
extern int       EMAp = 7;//55;3 5 7 9 13
extern int       up = 70;//9;
extern int       dn = 30;//9;
extern int       nup = 60;//9;
extern int       ndn = 40;//9;
extern int       rsiC = 5;//9;3  7 13 19
double ratio = 0.0005;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
SetLevelValue(0,0.0);


   IndicatorBuffers(8);
   SetIndexStyle(0,DRAW_HISTOGRAM,2, 1);
   SetIndexBuffer(0,ExtMapBuffer1);
  // SetIndexStyle(1,DRAW_HISTOGRAM,2, 1);
  // SetIndexBuffer(1,ExtMapBuffer3);
   SetIndexStyle(2,DRAW_HISTOGRAM,2, 1);
  // SetIndexStyle(3,DRAW_HISTOGRAM,2, 1);
   SetIndexBuffer(2,ExtMapBuffer2);
  // SetIndexBuffer(3,ExtMapBuffer4);
    SetIndexStyle(4,DRAW_LINE);
    SetIndexStyle(5,DRAW_LINE);
    SetIndexStyle(6,DRAW_LINE);
    SetIndexStyle(7,DRAW_LINE);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexBuffer(5,ExtMapBuffer6);
   SetIndexBuffer(6,ExtMapBuffer7);
   SetIndexBuffer(7,ExtMapBuffer8);
   ratio = 0.0004;
   if (Period()==PERIOD_M5) ratio = 0.0002;
   if (Period()==PERIOD_M1) ratio = 0.0001;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int  j,  counted_bars=IndicatorCounted();
//----A := N -( N * ( X - Y ) / 100 ),
double rsi =0,ma;
for (int i= Bars-counted_bars-1;i>=0;i--)
{
   rsi = iRSI(NULL,0,rsiP,PRICE_CLOSE,i)/rsiC;
   for (j=1; j<rsiC; j++)
    rsi += iRSI(NULL,0,rsiP,PRICE_CLOSE,i+j)/rsiC;

/*ExtMapBuffer1[i]= Close[i]*(1-(rsi-up)*ratio);
ExtMapBuffer3[i]= Close[i]*(1-(rsi-nup)*ratio);
ExtMapBuffer2[i]= Close[i]*(1-(rsi-dn)*ratio);
ExtMapBuffer4[i]= Close[i]*(1-(rsi-ndn)*ratio);
*/
ma = iMA(NULL,0,EMAp,0,MODE_SMMA,PRICE_CLOSE,i);
ExtMapBuffer1[i]= ma*(1-(rsi-up)*ratio);
ExtMapBuffer3[i]= ma*(1-(rsi-nup)*ratio);
ExtMapBuffer2[i]= ma*(1-(rsi-dn)*ratio);
ExtMapBuffer4[i]= ma*(1-(rsi-ndn)*ratio);

ExtMapBuffer5[i]=ExtMapBuffer1[i];
ExtMapBuffer6[i]=ExtMapBuffer2[i];
ExtMapBuffer7[i]=ExtMapBuffer3[i];
ExtMapBuffer8[i]=ExtMapBuffer4[i];
}
   
//----
   return(0);
  }
//+------------------------------------------------------------------+