#property copyright "Copyright ?2007, okwh."
#property link "http://blog.sina.com.cn/FXTrade"

//#property indicator_chart_window
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
#property indicator_color2 Aqua
#property indicator_color3 CornflowerBlue
#property indicator_color4 Gold
#property indicator_color5 SkyBlue
//---- input parameters
extern int  Tbars = 1000; //只记录最近1000点
//---- buffers
double ExtMapBuffer1[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function        tick                 |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
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

   double nows=0;
int num=0,i=0;

int start()

{
  int Ncounted_bars = Bars-IndicatorCounted();
  if (Ncounted_bars == Bars) //首次，复制close数据 并且有时多数据变化，MT仅调用指标一次
  {  
   num = Ncounted_bars;
   for (int i=num;i>0;i--)  
     ExtMapBuffer1[i]= Close[i-1]; //以队列方式记录ticks 价格
   return(0);
  }
  nows = MarketInfo(Symbol(),MODE_BID);//MarketInfo(Symbol(),MODE_ASK);//+MarketInfo(Symbol(),MODE_BID))/2.0;
  SetLevelValue(0, nows) ;
  if (Ncounted_bars>1) //有时多数据变化，MT仅调用指标一次,需填充空白 由于MT的数据更新方式
   {
    for ( i=Ncounted_bars;i>0;i--)  
     ExtMapBuffer1[i-1]= ExtMapBuffer1[i]; //以队列方式记录ticks 价格
   }
  if (num>0) 
   {
     if (nows == ExtMapBuffer1[0]) return (0);//只记录有变化的数据
      if (num>Tbars)num = Tbars;
      for ( i=num;i>0;i--)  
      {
        ExtMapBuffer1[i]= ExtMapBuffer1[i-1]; //以队列方式记录ticks 价格
     }
   }
   ExtMapBuffer1[0] =   nows;
   num++;
   WindowRedraw( ) ;
return(0);

}