//+------------------------------------------------------------------+
//|                                                     Test_Ind.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property  indicator_chart_window
#property  indicator_buffers 1
#property  indicator_color1  Red

extern int Seek_Period = 15;
int Time_Frame;
double Pips_SL, PT_Buffer[],Signal[1]; 

int init()
{ 
  IndicatorBuffers(2);
  SetIndexStyle(0,DRAW_SECTION, STYLE_SOLID, 2);
  SetIndexBuffer(0, PT_Buffer);
  SetIndexDrawBegin(0,Seek_Period*3);
  SetIndexBuffer(1,Signal);
  Time_Frame=(Time[1]-Time[2])/60;
  if(Digits%2==1) Pips_SL=Point*10;
  else Pips_SL=Point;
  return(0);
}

int start()
{
  Signal[0]=-1.0;
  int counted_bars=IndicatorCounted();
  if(counted_bars==0) int Limit=Bars-counted_bars-1;
  else Limit=Bars-counted_bars;
  for(int i=Limit; i>=0; i--)
  {
    int P_Point=(High[iHighest(NULL, 0, MODE_HIGH, Seek_Period, i)]-Low[iLowest(NULL, 0, MODE_LOW, Seek_Period, i)])/Pips_SL;
    PT_Buffer[i] = iMA(NULL, 0, 10.5*P_Point/Time_Frame, 0, MODE_SMA,PRICE_WEIGHTED, i);
  }

 if(Close[0]-PT_Buffer[0]>=3*Pips_SL) //buy  
 { 
   int CNT=1;bool Check=false; 
   while(CNT<=3)
   {
     if(Low[CNT]<PT_Buffer[CNT]+0.5*Pips_SL) Check=true; 
     if(Check==true&&Low[CNT]>PT_Buffer[CNT]) break; 
     CNT++;
   }
   if((Check==true)&&Uniformity(CNT)==1) Signal[0]=0.0; 
   return(0);
 }
  if(PT_Buffer[0]-Close[0]>=3*Pips_SL)//sell 
 { 
   CNT=1;Check=false;
   while(CNT<=3)
   {
     if(High[CNT]>PT_Buffer[CNT]-0.5*Pips_SL) Check=true; 
     if(Check==true&&High[CNT]<PT_Buffer[CNT]) break; 
     CNT++;
   }
   if((Check==true)&&Uniformity(CNT)==0) Signal[0]=1.0; 
 }
   
  return(0);
}

int Uniformity(int Bars_Shift) 
{
  int CNT=0,CNT_Up=0,CNT_Down=0;
  while(CNT<Seek_Period)
  {
    if((High[CNT+Bars_Shift]+Low[CNT+Bars_Shift])/2<PT_Buffer[CNT+Bars_Shift]) CNT_Up++;
    if((High[CNT+Bars_Shift]+Low[CNT+Bars_Shift])/2>PT_Buffer[CNT+Bars_Shift]) CNT_Down++;
    CNT++;
  }
  if(CNT-CNT_Up<=0) return(0);
  else if(CNT-CNT_Down<=0) return(1);
  else return(-1);
}