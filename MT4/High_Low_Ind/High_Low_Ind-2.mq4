//+------------------------------------------------------------------+
//|         Modification because of iHighest()                       |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Yellow
#property indicator_color2 Red

extern int Seek_Period=15,Mini_Swing=6,Trade_Range=9; //Mini_Swing_Left and Mini_Swing_Right;
double High_Point[],Low_Point[],Point_Adapted,Call[2];// Call[0] trade signal 1:buy,-1:sell; Call[1] refered point shift bars;
datetime High_Last_Time,Low_Last_Time;               

int init()
{
   IndicatorBuffers(3);
   SetIndexBuffer(0,High_Point);
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexEmptyValue(0,0.0);
   SetIndexBuffer(1,Low_Point);
   SetIndexStyle(1,DRAW_SECTION);
   SetIndexEmptyValue(1,0.0);
   SetIndexBuffer(2,Call);
   IndicatorShortName("High_Low ("+Seek_Period+","+Mini_Swing+","+Trade_Range+")");
   
   if(Digits==3||Digits==5) Point_Adapted=Point/0.1;
   else Point_Adapted=Point;
   
   return(0);
}

int deinit()
{
   return(0);
}

int start()
{  
   if(Bars<=Seek_Period) return(0);
   int Counted_Bars=IndicatorCounted();
   if(Counted_Bars==0) Counted_Bars++;
   int Limit=Bars-Counted_Bars;
   Call[0]=0.0;
   for(int i=Limit;i>=0;i--)
   {
     int P_CNT=Seek_Period,Show_Con=0;
     while(P_CNT>=6)
     {
       int x=iHighest(NULL,0,MODE_HIGH,P_CNT,i); if(x-i<5) break;
       double High_Refer_0=High[iHighest(NULL,0,MODE_HIGH,10,x-5)],Low_Refer_0=Low[iLowest(NULL,0,MODE_LOW,x-i,i)],
       H_Current_0=High[iHighest(NULL,0,MODE_HIGH,3,i)];
       if(High_Refer_0==High[x]&&High_Refer_0-Low_Refer_0>=Mini_Swing*Point_Adapted) //peak confirm
       {
         if(High_Last_Time!=Time[x]&&Show_Con==0){High_Point[x]=High_Refer_0;High_Last_Time=Time[x];Show_Con=1;}
         if(i==0&&Low[0]!=Low_Refer_0&&H_Current_0!=High[0]&&
         H_Current_0>=High_Refer_0-Trade_Range*Point_Adapted/2&&H_Current_0<=High_Refer_0+Trade_Range*Point_Adapted //touch trading ranges
            &&Close[0]<Low[1]   //triger trading
           ){Call[0]=-1;break;}
       }
       P_CNT--;        
     }
     
     P_CNT=Seek_Period;
     Show_Con=0;
     while(P_CNT>=6)
     {
       int y=iLowest(NULL,0,MODE_LOW,P_CNT,i); if(y-i<5) break;
       double Low_Refer_1=Low[iLowest(NULL,0,MODE_LOW,10,y-5)],High_Refer_1=High[iHighest(NULL,0,MODE_HIGH,y-i,i)],
       L_Current_1=Low[iLowest(NULL,0,MODE_LOW,3,i)];
       if(Low_Refer_1==Low[y]&&High_Refer_1-Low_Refer_1>=Mini_Swing*Point_Adapted) //lawn confirm
       {
         if(Low_Last_Time!=Time[y]&&Show_Con==0){Low_Point[y]=Low_Refer_1;Low_Last_Time=Time[y];Show_Con=1;}
         if(i==0&&High[0]!=High_Refer_1&&L_Current_1!=Low[0]&&
         L_Current_1<=Low_Refer_1+Trade_Range*Point_Adapted/2&&L_Current_1>=Low_Refer_1-Trade_Range*Point_Adapted  //touch trading ranges
            &&Close[0]>High[1]    //triger trading
           ){Call[0]=1;break;}
       }
       P_CNT--;    
     }
   
   if(Call[0]==-1) Call[1]=x;
   else if(Call[0]==1) Call[1]=y;
   }

   return(0);
}

