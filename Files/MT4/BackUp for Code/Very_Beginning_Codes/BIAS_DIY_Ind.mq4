#property copyright "Copyright ?2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 Red

double First_Buffer[],Second_Buffer[],VS_Buffer[5];
extern int  First_Period=5,Second_Period=10;
double Last_Bars=0;

int init()
  {
   IndicatorShortName("BIAS");
   IndicatorBuffers(3);
   SetIndexBuffer(0, First_Buffer);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexLabel(0,"BIAS_First");
   SetIndexDrawBegin(0,First_Period);
   SetIndexBuffer(1,Second_Buffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexLabel(1,"BIAS_Second");
   SetIndexDrawBegin(1,Second_Period);
   SetIndexBuffer(2,VS_Buffer);
      
   Last_Bars=Bars;
 
   return(0);
   }

int deinit()
  {
   return(0);
  }

int start()
  {
   int    counted_bars=IndicatorCounted();
   if(Bars<=Second_Period) return(0);

/* 
   if(counted_bars<1)
   {
    for(int i=1;i<=First_Period;i++) 
     First_Buffer[Bars-i]=0.0;
    for(i=1;i<=Second_Period;i++)
     Second_Buffer[Bars-i]=0.0;
   }
*/
 
   if(counted_bars>=First_Period) int i=Bars-counted_bars-1;
   else  i=Bars-First_Period-1;
   VS_Buffer[1]=(Close[1]-iMA(NULL,0,First_Period,0,MODE_SMA,PRICE_CLOSE,1))/Close[1];
   VS_Buffer[3]=(Close[1]-iMA(NULL,0,Second_Period,0,MODE_SMA,PRICE_CLOSE,1))/Close[1];
   
 if(counted_bars==0)
  while(i>=0)
  {
   double x=iMA(NULL,0,First_Period,0,MODE_SMA,PRICE_CLOSE,i);
   double y=iMA(NULL,0,Second_Period,0,MODE_SMA,PRICE_CLOSE,i);
     First_Buffer[i]=(Close[i]-x)*800/Close[i];
     VS_Buffer[1]=VS_Buffer[0]; 
     VS_Buffer[0]=First_Buffer[i];
     Second_Buffer[i]=(Close[i]-y)*800/Close[i];
     VS_Buffer[3]=VS_Buffer[2];
     VS_Buffer[2]=Second_Buffer[i];
     i--;
  }
else
   while(i>=0)
  {
   x=iMA(NULL,0,First_Period,0,MODE_SMA,PRICE_CLOSE,i);
   y=iMA(NULL,0,Second_Period,0,MODE_SMA,PRICE_CLOSE,i);

   if(Last_Bars==Bars) 
    {
     VS_Buffer[0]=(Close[i]-x)*800/Close[i];
     VS_Buffer[2]=(Close[i]-y)*800/Close[i];
    }
   else 
    {   
     Last_Bars=Bars;
     First_Buffer[i]=(Close[i]-x)*800/Close[i];
     VS_Buffer[1]=VS_Buffer[0]; 
     VS_Buffer[0]=First_Buffer[i];
     Second_Buffer[i]=(Close[i]-y)*800/Close[i];
     VS_Buffer[3]=VS_Buffer[2];
     VS_Buffer[2]=Second_Buffer[i];
    }
    
    VS_Buffer[4]=0.0;
    if(VS_Buffer[1]<=VS_Buffer[3]&&VS_Buffer[0]>VS_Buffer[2]) VS_Buffer[4]=-1.0;
    if(VS_Buffer[1]>=VS_Buffer[3]&&VS_Buffer[0]<VS_Buffer[2])  VS_Buffer[4]=1.0; 
    
    i--;
  }

   return(0);
  }

