//+------------------------------------------------------------------+
//|                                                                  |
//|               Move_Stop_Loss()'s Logic is correct now            |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

extern int Lots=1,Trade_Range=9,Sleep_Time_Bars=2; 
extern int Move_Stop_Small=10,Move_Stop_Big=20;  //Move_Stop_Loss()
extern int Seek_Period=15; //Get_High_Low()
int Sleep_Time,Stop_Loss=8;
int G_i,D_i,Mini_Swing=6; // Get_High_Low()
double Get_High,Get_Low; //Get_High_Low()
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

  Get_High_Low();
  
  int Trade_CNT=0;
  if(Get_High!=0)
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
    if(Trade_CNT>0)    Show_Refer_Point("High",G_i,1);
  }
  
   Trade_CNT=0;
   if(Get_Low!=0)
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
    if(Trade_CNT>0)    Show_Refer_Point("Low",D_i,1);
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
      int Profit_Point=NormalizeDouble(OrderProfit()*Close[0]/100000/Point+50*Point,0); 
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


void Get_High_Low()
{  
  int P_CNT=Seek_Period,Show_Con=0;
  Get_High=0.0;
  while(P_CNT>=6)
  {
    G_i=iHighest(NULL,0,MODE_HIGH,P_CNT,0);
    double High_Refer_P=High[iHighest(NULL,0,MODE_HIGH,10,G_i-5)],Low_Refer_P=Low[iLowest(NULL,0,MODE_LOW,G_i,0)];
    double HL_Current_P=High[iHighest(NULL,0,MODE_HIGH,3,0)]; 
    if(G_i>=5&&High_Refer_P==High[G_i]&&High[G_i]-Low_Refer_P>=Mini_Swing*Point_Adapted) // peak confirm
    { 
      if(Show_Con==0){Show_Refer_Point("High",G_i,0);Show_Con=1;}
      if( HL_Current_P!=High[0]&&HL_Current_P>=High[G_i]-Trade_Range*Point_Adapted/2&&HL_Current_P<=High[G_i]+Trade_Range*Point_Adapted&& //touch trading ranges
          Close[0]<Low[1] //&&MathAbs(High[G_i]-Close[0])<Mini_Swing*Point_Adapted/2   // triger trading
        )  {Get_High=High[G_i];break;}
     }
     P_CNT--;
  }
 
  P_CNT=Seek_Period;
  Get_Low=0.0;
  Show_Con=0;
  while(P_CNT>=6)
  {
    D_i=iLowest(NULL,0,MODE_LOW,P_CNT,0);
    Low_Refer_P=Low[iLowest(NULL,0,MODE_LOW,10,D_i-5)];High_Refer_P=High[iHighest(NULL,0,MODE_LOW,D_i,0)];
    HL_Current_P=Low[iLowest(NULL,0,MODE_LOW,3,0)];
    if(D_i>=5&&Low_Refer_P==Low[D_i]&&High_Refer_P-Low[D_i]>=Mini_Swing*Point_Adapted) // bottom confirm
    { 
      if(Show_Con==0){Show_Refer_Point("Low",D_i,0);Show_Con=1;}
      if(HL_Current_P!=Low[0]&&HL_Current_P<=Low[D_i]+Trade_Range/2*Point_Adapted&&HL_Current_P>=Low[D_i]-Trade_Range*Point_Adapted&& //touch trading ranges
          Close[0]>High[1] //&&MathAbs(Low[D_i]-Close[0])<Mini_Swing*Point_Adapted/2  //triger trading
        ) {Get_Low=Low[D_i];break;}
    }
    P_CNT--;
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


