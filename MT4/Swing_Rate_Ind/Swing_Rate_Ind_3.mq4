//+------------------------------------------------------------------+
//|                                                                  |
//|           Computing no more than Bars_Ind bars                       |
//|                                                                  |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property  indicator_buffers 1
#property  indicator_color1  Red

  extern int    
       Seek_Period = 15
  ,    Bars_Ind    = 1000
  ;
  extern double 
       Range_Ratio = 9
  ;
  double        
      Pips_SL
  ,   PT_Buffer[]
  ,   H_Line = 100
  ; 

  int init()
  {     
    Print("Seek_Periods:, Bar_Ign, Range_Ratio, Delta_Ratio: ",Seek_Period,",",Range_Ratio); //" and ", Seek_Period_2,
    IndicatorShortName("Swing_Rate(Seek_Period_1("+Seek_Period+") and Range_Ratio("+Range_Ratio+"))");
    IndicatorBuffers      (1);
    SetIndexBuffer        (0, PT_Buffer);
    SetIndexStyle         (0,DRAW_SECTION, STYLE_SOLID, 2);
    SetIndexDrawBegin     (0,Seek_Period*3);
    SetIndexLabel         (0,"Swing_Ratio 1");
    
    if( Digits%2 == 1 )   Pips_SL = Point*10;
    else                  Pips_SL = Point;
   
    return(0);
  }
  
  int deinit()
  {
    ObjectsDeleteAll();
    return(0);
  }

  int start()
  {    
    if(IndicatorCounted()==0)
    { 
    ObjectCreate ("UpLine",OBJ_HLINE,1,0,H_Line);
    ObjectSet    ("UpLine",OBJPROP_STYLE,STYLE_SOLID);
    ObjectSet    ("UpLine",OBJPROP_COLOR,Red);
    ObjectSet    ("UpLine",OBJPROP_WIDTH,1);
    ObjectCreate ("DownLine",OBJ_HLINE,1,0,-H_Line);
    ObjectSet    ("DownLine",OBJPROP_STYLE,STYLE_SOLID);
    ObjectSet    ("DownLine",OBJPROP_COLOR,Red);
    ObjectSet    ("DownLine",OBJPROP_WIDTH,1);
    }

    Draw_Line(Seek_Period,PT_Buffer);
    return(0) ;
  }

  void Draw_Line(int Bars_Seek,double &Array[])
  {
    int counted_bars = IndicatorCounted();
    if( counted_bars < 0 ) return(0);
    else  int  Limit = Bars-counted_bars-1;
    if(Limit > Bars_Ind) Limit = Bars_Ind;
    for(int i=Limit; i>=0; i--)
    {
      int P_Point  = (High[iHighest(NULL, 0, MODE_HIGH, Bars_Seek, i)] - Low[iLowest(NULL, 0, MODE_LOW, Bars_Seek, i)])/Pips_SL ;
      Array[i] = (Close[i]-iMA(NULL, 0, Range_Ratio*P_Point/Period(), 0, MODE_SMA,PRICE_WEIGHTED, i))/Pips_SL;
    }
  }

