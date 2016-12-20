
#property  indicator_chart_window
#property  indicator_buffers 1
#property  indicator_color1  Silver

extern int Seek_Period = 15;
double PT_Buffer[],Signal[1];

int init()
{
  IndicatorBuffers(2);
  SetIndexStyle(0,DRAW_SECTION, STYLE_SOLID, 3);
  SetIndexBuffer(0, PT_Buffer);
  SetIndexDrawBegin(0,Seek_Period*3);
  SetIndexBuffer(1,Signal);
  Print("Seek_Period:",Seek_Period);
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
    PT_Buffer[i] = iMA(NULL, 0, P_Point/5, 0, MODE_SMA, PRICE_CLOSE, i);
  }

  if(OrderSelect(OrdersTotal()-1,SELECT_BY_POS))
   if(OrderType()==OP_BUY&&PT_Buffer[0]-Close[0]>=40*Point) {Signal[0]=3.0;return(0);} //close buy
   else if(OrderType()==OP_SELL&&Close[0]-PT_Buffer[0]>=40*Point){Signal[0]=2.0;return(0);} //close sell

  int j=1,CNT=0,CNT_Down=0,CNT_Up=0,Back_Bars=3;
  if(Close[0]-PT_Buffer[0]>=28*Point) //buy
  {
    while(j<Back_Bars)
    { 
      if(High[j]-Low[j]<=22*Point) {j++;Back_Bars++;}
      if((High[j]+Low[j])/2<PT_Buffer[j]) break;
      j++;
    }
    while(CNT<=Seek_Period)
    { 
      if((High[j]+Low[j])/2<PT_Buffer[j]) CNT_Up++;
      j++;CNT++; 
    }
    if(CNT-CNT_Up<=0) Signal[0]=0.0;
  }  
  else if(PT_Buffer[0]-Close[0]>=28*Point) //sell
  {
    while(j<Back_Bars)
    { 
      if(High[j+1]-Low[j+1]<=22*Point) {j++;Back_Bars++;}
      if((High[j]+Low[j])/2>PT_Buffer[j]) break;
      j++;
    }
    while(CNT<=Seek_Period-1)
    { 
      if((High[j]+Low[j])/2>PT_Buffer[j]) CNT_Down++;
      j++;CNT++;
    }
    if(CNT-CNT_Down<=0) Signal[0]=1.0;
  }
  return(0);
}

//�޳�������ƣ�