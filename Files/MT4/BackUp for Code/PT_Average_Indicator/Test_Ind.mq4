//+------------------------------------------------------------------+
//|                                                                  |
//|           It is Ok for UDSJPY on M15 Chart                       |
//|                                                                  |
//+------------------------------------------------------------------+

#property  indicator_chart_window
#property  indicator_buffers 2
#property  indicator_color1  Silver
#property  indicator_color2  Red

extern int Seek_Period = 15, Time_Frame=15;
double PT_Buffer[],PT_Buffer_1[],Signal[1];
bool x=false;

int init()
{ 
  IndicatorBuffers(3);
  SetIndexStyle(0,DRAW_SECTION, STYLE_SOLID, 2);
  SetIndexBuffer(0, PT_Buffer);
  SetIndexDrawBegin(0,Seek_Period*3);
  SetIndexBuffer(2,Signal);
  SetIndexBuffer(1,PT_Buffer_1);
  SetIndexStyle(1,DRAW_SECTION, STYLE_SOLID, 2);
  SetIndexDrawBegin(1,Seek_Period*4);
  Print("Seek_Period and Time_Frame: ",Seek_Period," , ",Time_Frame);
  return(0);
}

int start()
{
  Signal[0]=-1.0;
  int counted_bars=IndicatorCounted();
  if(counted_bars==0) int Limit=Bars-counted_bars-1;
  else Limit=Bars-counted_bars;
  for(int i = Limit; i >= 0; i--)
  {
    int P_Point=(High[iHighest(NULL, 0, MODE_HIGH, Seek_Period, i)]-Low[iLowest(NULL, 0, MODE_HIGH, Seek_Period, i)])/Point;
    PT_Buffer[i] = iMA(NULL, 0, P_Point/Time_Frame, 0, MODE_SMA, (PRICE_HIGH+PRICE_LOW+PRICE_OPEN+PRICE_CLOSE)/4, i);
    int P_Point_1=(High[iHighest(NULL, 0, MODE_HIGH, 12*Seek_Period, i)]-Low[iLowest(NULL, 0, MODE_HIGH, 12*Seek_Period, i)])/Point;
    PT_Buffer_1[i] = iMA(NULL, 0, P_Point_1/Time_Frame, 0, MODE_SMA, (PRICE_HIGH+PRICE_LOW+PRICE_OPEN+PRICE_CLOSE)/4, i);
  }

 if(Close[0]-PT_Buffer[0]>=45*Point&&Low[iLowest(NULL,0,MODE_LOW,5,0)]>PT_Buffer[0]-50*Point) //buy
 { 
   int CNT=1;bool Check=false; //CNT's value has been changed to 0 from 1;
   while(CNT<3)
   {
     if(Low[CNT]<PT_Buffer[CNT]+5*Point) Check=true; ////////////////////////////////45 has been changed from 5 points.
     if(Check==true&&Low[CNT]>PT_Buffer[CNT]) break;
     CNT++;
   }
   if(Check==true&&Uniformity(CNT)==1) { Signal[0]=0.0; return(0);} // ||Uni==0&&iLowest(NULL,0,MODE_LOW,Seek_Period*6,0)<=2*Seek_Period
 }
  if(PT_Buffer[0]-Close[0]>=45*Point&&High[iHighest(NULL,0,MODE_HIGH,5,0)]<PT_Buffer[0]+50*Point)//sell
 { 
   CNT=1;Check=false; //CNT's value has been changed to 0 from 1;
   while(CNT<3)
   {
     if(High[CNT]>PT_Buffer[CNT]-5*Point) Check=true; ////////////////////////////////45 has been changed from 5 points.
     if(Check==true&&High[CNT]<PT_Buffer[CNT]) break;
     CNT++;
   }
   if(Check==true&&Uniformity(CNT)==0) { Signal[0]=1.0; return(0);} //||Uni==1&&iHighest(NULL,0,MODE_HIGH,Seek_Period*6,0)<=2*Seek_Period
 }
   
  return(0);
}


int Uniformity(int Bars_Shift) //check the uniformity of "Seek_Period" bars from the bar--Bars_Shift.
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

// neglect the situation of only two or three reverse bars 
// catch break out from small swings.