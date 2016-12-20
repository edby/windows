//+------------------------------------------------------------------+
//|                                                                  |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+


#property indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  Red
#property  indicator_color2  Yellow

  extern int    
       Seek_Period_1 = 15
  ,    Seek_Period_2 = 30
  ;
  extern double 
       Range_Ratio = 9
  ;
  double        
      Pips_SL
  ,   PT_Buffer_1[]
  ,   PT_Buffer_2[]
  ,   H_Line = 100
  ; 

  int init()
  { 
    Print("Seek_Periods:, Bar_Ign, Range_Ratio, Delta_Ratio: ",Seek_Period_1," and ", Seek_Period_2,",",Range_Ratio);
    IndicatorBuffers      (2);
    SetIndexBuffer        (0, PT_Buffer_1);
    SetIndexStyle         (0,DRAW_SECTION, STYLE_SOLID, 2);
    SetIndexDrawBegin     (0,Seek_Period_1*3);
    SetIndexBuffer        (1, PT_Buffer_2);
    SetIndexStyle         (1, DRAW_SECTION, STYLE_SOLID,2);
    SetIndexDrawBegin     (1, Seek_Period_2*3);
    
    if( Digits%2 == 1 )   Pips_SL = Point*10;
    else                  Pips_SL = Point;
    
    ObjectCreate ("UpLine",OBJ_HLINE,1,0,H_Line);
    ObjectSet    ("UpLine",OBJPROP_STYLE,STYLE_SOLID);
    ObjectSet    ("UpLine",OBJPROP_COLOR,Red);
    ObjectSet    ("UpLine",OBJPROP_WIDTH,1);
    ObjectCreate ("DownLine",OBJ_HLINE,1,0,-H_Line);
    ObjectSet    ("DownLine",OBJPROP_STYLE,STYLE_SOLID);
    ObjectSet    ("DownLine",OBJPROP_COLOR,Red);
    ObjectSet    ("DownLine",OBJPROP_WIDTH,1);
    ObjectCreate ("ZeroLine",OBJ_HLINE,1,0,0.0);
    ObjectSet    ("ZeroLine",OBJPROP_STYLE,STYLE_SOLID);
    ObjectSet    ("ZeroLine",OBJPROP_COLOR,White);
    ObjectSet    ("ZeroLine",OBJPROP_WIDTH,2);
    
    return(0);
  }
  
  int deinit()
  {
    ObjectsDeleteAll();
    return(0);
  }

  int start()
  {
    Draw_Line(Seek_Period_1,PT_Buffer_1);
    Draw_Line(Seek_Period_2,PT_Buffer_2);
    return(0) ;
  }

  void Draw_Line(int Bars_Seek,double &Array[])
  {
    int counted_bars = IndicatorCounted();
    if( counted_bars < 0 ) return(0);
    else  int  Limit = Bars-counted_bars-1;
    for(int i=Limit; i>=0; i--)
    {
      int P_Point  = (High[iHighest(NULL, 0, MODE_HIGH, Bars_Seek, i)] - Low[iLowest(NULL, 0, MODE_LOW, Bars_Seek, i)])/Pips_SL ;
      Array[i] = (Close[i]-iMA(NULL, 0, Range_Ratio*P_Point/Period(), 0, MODE_SMA,PRICE_WEIGHTED, i))*10000;
    }
  }

