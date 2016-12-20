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
extern int  Tbars = 1000; //ֻ��¼���1000��
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
  if (Ncounted_bars == Bars) //�״Σ�����close���� ������ʱ�����ݱ仯��MT������ָ��һ��
  {  
   num = Ncounted_bars;
   for (int i=num;i>0;i--)  
     ExtMapBuffer1[i]= Close[i-1]; //�Զ��з�ʽ��¼ticks �۸�
   return(0);
  }
  nows = MarketInfo(Symbol(),MODE_BID);//MarketInfo(Symbol(),MODE_ASK);//+MarketInfo(Symbol(),MODE_BID))/2.0;
  SetLevelValue(0, nows) ;
  if (Ncounted_bars>1) //��ʱ�����ݱ仯��MT������ָ��һ��,�����հ� ����MT�����ݸ��·�ʽ
   {
    for ( i=Ncounted_bars;i>0;i--)  
     ExtMapBuffer1[i-1]= ExtMapBuffer1[i]; //�Զ��з�ʽ��¼ticks �۸�
   }
  if (num>0) 
   {
     if (nows == ExtMapBuffer1[0]) return (0);//ֻ��¼�б仯������
      if (num>Tbars)num = Tbars;
      for ( i=num;i>0;i--)  
      {
        ExtMapBuffer1[i]= ExtMapBuffer1[i-1]; //�Զ��з�ʽ��¼ticks �۸�
     }
   }
   ExtMapBuffer1[0] =   nows;
   num++;
   WindowRedraw( ) ;
return(0);

}