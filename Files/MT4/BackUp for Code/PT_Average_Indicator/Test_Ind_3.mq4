//+------------------------------------------------------------------+
//|                                                     Test_Ind.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

#property  indicator_chart_window
#property  indicator_buffers 1
#property  indicator_color1  Red

  extern int    
       Seek_Period = 15
  ,    Bar_Ign     = 3
  ,    Min_Points  = 3
  ,    Max_Points  = 10
  ;
  extern double 
       Range_Ratio = 10.5
  ;
  double        
      Pips_SL
  ,   PT_Buffer[]
  ,   Signal[1]
  ; 

  int init()
  { 
    Print("Seek_Period, Bar_Ign, Min_Points, Max_Points, Range_Ratio : ",Seek_Period,",",Bar_Ign,",",Min_Points,",",Max_Points,",",Range_Ratio);
    IndicatorBuffers      (2);
    SetIndexBuffer        (0, PT_Buffer);
    SetIndexStyle         (0,DRAW_SECTION, STYLE_SOLID, 2);
    SetIndexDrawBegin     (0,Seek_Period*3);
    SetIndexBuffer        (1,Signal);
    
    if( Digits%2 == 1 )   Pips_SL = Point*10;
    else                  Pips_SL = Point;
    
    return(0);
  }

  int start()
  {
    int counted_bars = IndicatorCounted();
    if( counted_bars < 0 ) return(0);
    else  int  Limit = Bars-counted_bars-1;
    
    if(Limit > 1000) Limit = 1000;
    for(int i=Limit; i>=0; i--)
    {
      int P_Point  = (High[iHighest(NULL, 0, MODE_HIGH, Seek_Period, i)] - Low[iLowest(NULL, 0, MODE_LOW, Seek_Period, i)])/Pips_SL;
      PT_Buffer[i] = iMA(NULL, 0, Range_Ratio*P_Point/Period(), 0, MODE_SMA,PRICE_WEIGHTED, i);
    }

   Signal[0]  = 0.0 ;
   if(   Close[0]-PT_Buffer[0] >= Min_Points*Pips_SL 
      && Low[0] > Low[iLowest(NULL,0,MODE_LOW,Seek_Period,0)] + 2*Pips_SL
      && Close[0]-PT_Buffer[0] <= Max_Points*Pips_SL
     )    //buy  
   { 
     int  CNT   =  1;
     bool Check =  false ; 
     int B_L=iLowest(NULL,0,MODE_LOW,Bar_Ign,0);////////////////////////////////////////////////////////////////////
     while( CNT <= Bar_Ign )
     {
       if( Low[CNT] < PT_Buffer[CNT]+Pips_SL/2 ) Check=true; 
       if( Check==true && Low[CNT]>PT_Buffer[CNT] ) break; 
       CNT++;
     }
     if( Check==true && Uniformity(CNT)==1 && PT_Buffer[B_L]-Low[B_L]<15*Pips_SL) Signal[0]=1.0; 
     return(0);
   }

    if(  PT_Buffer[0]-Close[0] >= Min_Points*Pips_SL 
      && High[0]<High[iHighest(NULL,0,MODE_HIGH,Seek_Period,0)] - 2*Pips_SL
      && PT_Buffer[0]-Close[0] <= Max_Points*Pips_SL
      ) //sell 
   { 
     CNT   = 1;
     Check = false;
     int B_H=iHighest(NULL,0,MODE_HIGH,Bar_Ign,0);///////////////////////////////////////////////////////
     while( CNT <= Bar_Ign )
     {
       if( High[CNT] > PT_Buffer[CNT]-Pips_SL/2 ) Check=true; 
       if( Check==true && High[CNT]<PT_Buffer[CNT] ) break; 
       CNT++;
     }
     if( Check==true && Uniformity(CNT)==-1 && High[B_H]-PT_Buffer[B_H] < 15*Pips_SL) Signal[0]=-1.0; 
   }
/*   
   if(Signal[0]!=0.0)
   { 
     if(Signal[0]==1.0)
     {
       for(i=0;i<2*Seek_Period;i++)
         if( High[i]-PT_Buffer[i] > 40*Pips_SL )
           {Signal[0]=0.0;break;}
      }
      else 
      {
        for(i=0;i<2*Seek_Period;i++)
          if( PT_Buffer[i]-Low[i] > 40*Pips_SL )
            {Signal[0]=0.0;break; }
      }
    }
*/
   
/*  
   if(Signal[0] != 0.0)
   {
     double B_M = PT_Buffer[Seek_Period];
     int Up_1=0,Up_2=0,Down_1=0,Down_2=0;
     
     for(int j=0;j<Seek_Period-1;j++)
     {
       if(PT_Buffer[j]>B_M) Up_1++;
       else                 Down_1++;
     }
     for(j=2*Seek_Period;j>Seek_Period+1;j--)
     {
       if(PT_Buffer[j]>B_M) Up_2++;
       else                 Down_2++;
     }
     
     if( (Up_1>=Seek_Period-3 && Down_2>=Seek_Period-3) ||
         (Down_1>=Seek_Period-3 && Up_2>=Seek_Period-3)
       );
     else Signal[0] = 0;
     
   }
*/  
    return(0);
  }

  int Uniformity(int Bars_Shift) 
  {
    int CNT      = 0
    ,   CNT_Up   = 0
    ,   CNT_Down = 0
    ;
    while( CNT < Seek_Period )
    {
      if( (High[CNT+Bars_Shift]+Low[CNT+Bars_Shift])/2 > PT_Buffer[CNT+Bars_Shift] ) CNT_Up++;
      if( (High[CNT+Bars_Shift]+Low[CNT+Bars_Shift])/2 < PT_Buffer[CNT+Bars_Shift] ) CNT_Down++;
      CNT++;
    }
    if     ( CNT-CNT_Up   <= 0 ) return (1);
    else if( CNT-CNT_Down <= 0 ) return (-1);
    else                         return (0);
  }

