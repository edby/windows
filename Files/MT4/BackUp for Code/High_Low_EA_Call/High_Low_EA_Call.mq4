//+------------------------------------------------------------------+
//|                                                                  |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+

extern int Lots=1,Trade_Range=9,Sleep_Time_Bars=2; 
extern int Move_Stop_Small=10,Move_Stop_Big=20;  //Move_Stop_Loss()
extern int Seek_Period=15; //Get_High_Low()
int Sleep_Time,Stop_Loss=8;
int Mini_Swing=6; // Get_High_Low()
double Point_Adapted;

int init()
  {
   Sleep_Time=(Time[2]-Time[1])*Sleep_Time_Bars;
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
  static datetime Time_Start;
  OrderSelect(0,SELECT_BY_POS,MODE_HISTORY);
  if(OrderCloseTime()-OrderOpenTime()<30&&OrderProfit()<0) Time_Start=OrderCloseTime(); 
  if(TimeCurrent()-Time_Start<Sleep_Time*60) return(0);
/*
  OrderSelect(0,SELECT_BY_POS,MODE_HISTORY);
  if(OrderCloseTime()-OrderOpenTime()<20) Sleep(1000*60*Sleep_Time);
*/

  double Trade_Sig=iCustom(NULL,0,"High_Low_Ind",15,6,9,2,0);
  int Shift_Bar=iCustom(NULL,0,"High_Low_Ind",15,6,9,2,1);
  
  int Trade_CNT=0;
  if(MathAbs(Trade_Sig+1.0)<Point)
  {  
    if(OrdersTotal()==0) 
    { 
      iWait();  
      Trade_CNT++;
      OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+Stop_Loss*Point_Adapted,0,0,0,0,0);
    }
    else if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)&&OrderType()==OP_BUY)
    {
      iWait(); 
      if(OrderClose(OrderTicket(),Lots,Ask,3,0))
      {
        iWait();
        Trade_CNT++;
        OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+Stop_Loss*Point_Adapted,0,0,0,0,0);
      }
    }
    if(Trade_CNT>0)    Show_Refer_Point("High",Shift_Bar,1);
  }
  
   Trade_CNT=0;
   if(MathAbs(Trade_Sig-1.0)<Point)
  {
    if(OrdersTotal()==0) 
    {
      iWait(); 
      Trade_CNT++;
      OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-Stop_Loss*Point_Adapted,0,0,0,0,0);
    }
    else if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)&&OrderType()==OP_SELL)
    {
      iWait(); 
      if(OrderClose(OrderTicket(),Lots,Bid,3,0))
      {
        iWait();
        Trade_CNT++;
        OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-Stop_Loss*Point_Adapted,0,0,0,0,0);
      }
    }
    if(Trade_CNT>0)    Show_Refer_Point("Low",Shift_Bar,1);
  }
  Move_Stop_Loss();
  return(0);
}


void Move_Stop_Loss()             // Stop loss line will go when absolute value of (difference of current price and stop loss price)is  
{                                 // bigger than small stop level, and when order profit is more than 20 points, the stop level should 
  if(OrdersTotal()==0) return;    // be changed to big stop level from small small stop level.
  for(int i=OrdersTotal();i>0;i--)
  {
    if(OrderSelect(i-1,SELECT_BY_POS))
    {
      int Profit_Point=NormalizeDouble(MathAbs(Close[0]-OrderOpenPrice())/Point,0); 
      int Move_Stop=100;
      if(Profit_Point>0&&Profit_Point<=500) Move_Stop=400;
    //  if(Pro*Close[0]/100000>500*Point)Move_Stop=50;
      if(MathAbs(Close[0]-OrderStopLoss())>Move_Stop*Point)
      if(OrderType()==OP_BUY) {iWait();OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]-Move_Stop*Point,0,0,0);}
      else if(OrderType()==OP_SELL) {iWait();OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]+Move_Stop*Point,0,0,0);}
    } 
}
  return;
}


void Show_Refer_Point(string HL_Sign,int Bar_Number,int Text_Or_Line)
{ 
  static int i=0,j=0;     
  static double High_Last_P,Low_Last_P; 
  static datetime High_Last_T,Low_Last_T;
  datetime HL_Current_T=Time[Bar_Number];
  color Color_Line;

  if(HL_Sign=="High"){ double Price=High[Bar_Number];Color_Line=Yellow;}
  else {Price=Low[Bar_Number];Color_Line=Red;}
  
  if(HL_Sign=="High"&&Text_Or_Line==0)     // Draw two lines, one of which connect all peaks and the other connect all bottoms
  { 
    if(High_Last_T==HL_Current_T&&High_Last_P==High[Bar_Number]);
    else
    {
      i++;
      if(High_Last_P!=0)
      {
        ObjectCreate("High"+DoubleToStr(i,0),OBJ_TREND,0,High_Last_T,High_Last_P,HL_Current_T,Price);
        ObjectSet("High"+DoubleToStr(i,0),OBJPROP_STYLE,STYLE_SOLID);
        ObjectSet("High"+DoubleToStr(i,0),OBJPROP_COLOR,Color_Line);
        ObjectSet("High"+DoubleToStr(i,0),OBJPROP_WIDTH,1);
        ObjectSet("High"+DoubleToStr(i,0),OBJPROP_RAY,false);
      }
      High_Last_P=High[Bar_Number];High_Last_T=Time[Bar_Number];
    }
  }

  if(HL_Sign=="Low"&&Text_Or_Line==0)
  { 
    if(Low_Last_T==HL_Current_T&&Low_Last_P==Low[Bar_Number]);
    else 
    {
      i++;
      if(Low_Last_P!=0)
      {
        ObjectCreate("Low"+DoubleToStr(i,0),OBJ_TREND,0,Low_Last_T,Low_Last_P,HL_Current_T,Price);
        ObjectSet("Low"+DoubleToStr(i,0),OBJPROP_STYLE,STYLE_SOLID);
        ObjectSet("Low"+DoubleToStr(i,0),OBJPROP_COLOR,Red);
        ObjectSet("Low"+DoubleToStr(i,0),OBJPROP_WIDTH,1);
        ObjectSet("Low"+DoubleToStr(i,0),OBJPROP_RAY,false);
      }
      Low_Last_P=Low[Bar_Number];Low_Last_T=Time[Bar_Number];
    }
  }

  if(Text_Or_Line==1)                                                    // Mark the refered peaks or bottoms
  {
    j++;                                                          
    ObjectCreate(DoubleToStr(j,0),OBJ_TEXT,0,HL_Current_T,Price);
    ObjectSetText(DoubleToStr(j,0),HL_Sign,12,"Times New Roman",White);
  }

 return;
}

void iWait()
{
  if(IsTradeContextBusy()||!IsTradeAllowed())
  Sleep(110);
  RefreshRates();
  return;
}

