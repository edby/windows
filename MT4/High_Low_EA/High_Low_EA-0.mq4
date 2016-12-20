//+------------------------------------------------------------------+
//|                                                     High_Low.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

extern int Lots=1,Trade_Range=90,Sleep_Time_Bars=2; 
extern int Move_Stop_Small=40,Move_Stop_Big=80;  //Move_Stop_Loss()
extern int Seek_Period=30; //Get_High_Low()
int Sleep_Time;
int G_i,D_i; // Get_High_Low()
double Get_High,Get_Low; //Get_High_Low()



// Get_High_Low() function should be completed by indicator, Get_High and Get_Low,G_i and D_i should be saved in arrays.

int init()
  {
  Sleep_Time=(Time[2]-Time[1])*Sleep_Time_Bars;
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
  if(OrderCloseTime()-OrderOpenTime()<30&&OrderProfit()<0) Time_Start=OrderCloseTime(); //add OrderProfit()<0
  if(TimeCurrent()-Time_Start<Sleep_Time*60) return(0);
/*
  OrderSelect(0,SELECT_BY_POS,MODE_HISTORY);
  if(OrderCloseTime()-OrderOpenTime()<20) Sleep(1000*60*Sleep_Time);
*/

  Get_High_Low();
  
  if(Get_High!=0)
  { 
    Show_Refer_Point("High",G_i); // change it's location here from other place
    if(OrdersTotal()==0) 
    { 
      iWait();  
      OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+70*Point,0,0,0,0,0);
    }
    else if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)&&OrderType()==OP_BUY)
    {
      iWait(); 
      if(OrderClose(OrderTicket(),Lots,Ask,3,0))
      {
        iWait();
        OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+70*Point,0,0,0,0,0);
      }
    }
  }
  
   if(Get_Low!=0)
  {
    Show_Refer_Point("Low",D_i);
    if(OrdersTotal()==0) 
    {
      iWait(); 
      OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-70*Point,0,0,0,0,0);
    }
    else if(OrderSelect(0,SELECT_BY_POS,MODE_TRADES)&&OrderType()==OP_SELL)
    {
      iWait(); 
      if(OrderClose(OrderTicket(),Lots,Bid,3,0))
      {
        iWait();
        OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-70*Point,0,0,0,0,0);
      }
    }
  }
  Move_Stop_Loss();
  return(0);
}


void Move_Stop_Loss()             // Stop loss line will go when absolute value of (difference of current price and stop loss price)is  
{                                 // bigger than small stop level, and when order profit is more than 200 points, the stop level should 
  if(OrdersTotal()==0) return;    // be changed to big stop level from small small stop level.
  
  int Move_Stop;
  for(int i=OrdersTotal();i>0;i--)
  {
    Move_Stop=Move_Stop_Small;
    OrderSelect(i-1,SELECT_BY_POS);
    if(OrderProfit()>200*Point) Move_Stop=Move_Stop_Big;  //delete "||MathAbs(OrderStopLoss()-Close[0])>Move_Stop_Small"
    if(MathAbs(Close[0]-OrderStopLoss())<=Move_Stop*Point) continue;
    if(OrderType()==OP_BUY) {iWait();OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]-Move_Stop*Point,0,0,0);} 
    else  {iWait();OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]+Move_Stop*Point,0,0,0);}
  }
  return;
}


void Get_High_Low()
{  
  int P_CNT=Seek_Period;
  Get_High=0.0;
  while(P_CNT>=6)
  {
    G_i=iHighest(NULL,0,MODE_HIGH,P_CNT,0);
    double High_Refer_P=High[iHighest(NULL,0,MODE_HIGH,G_i+5,G_i-5)],Low_Refer_P=Low[iLowest(NULL,0,MODE_LOW,G_i,0)];
    double HL_Current_P=High[iHighest(NULL,0,MODE_HIGH,3,0)];
    if(
        G_i>=5&&High_Refer_P==High[G_i]&&High[G_i]-Low_Refer_P>=Move_Stop_Big*Point&& // peak confirm
        HL_Current_P!=High[G_i]&&HL_Current_P>=High[G_i]-Trade_Range*Point/2&&HL_Current_P<=High[G_i]+Trade_Range*Point&& //touch trading ranges
        Close[0]<Low[1]&&High[0]<High[1] //&&MathAbs(High[G_i]-Close[0])<Move_Stop_Big*Point/2   // triger trading
      )  {Get_High=High[G_i];break;}
    else P_CNT--;
  }
 
  P_CNT=Seek_Period;
  Get_Low=0.0;
  while(P_CNT>=6)
  {
    D_i=iLowest(NULL,0,MODE_LOW,P_CNT,0);
    Low_Refer_P=Low[iLowest(NULL,0,MODE_LOW,D_i+5,D_i-5)];High_Refer_P=High[iHighest(NULL,0,MODE_LOW,D_i,0)];
    HL_Current_P=Low[iLowest(NULL,0,MODE_LOW,3,0)];
    if(
        D_i>=5&&Low_Refer_P==Low[D_i]&&High_Refer_P-Low[D_i]>=Move_Stop_Big*Point&& // bottom confirm
        HL_Current_P!=Low[D_i]&&HL_Current_P<=Low[D_i]+Trade_Range/2*Point&&HL_Current_P>=Low[D_i]-Trade_Range*Point&& //touch trading ranges
        Close[0]>High[1]&&Low[0]>Low[1] //&&MathAbs(Low[D_i]-Close[0])<Move_Stop_Big*Point/2  //triger trading
      ) {Get_Low=Low[D_i];break;}
    else P_CNT--;
  }
  return;
}


void Show_Refer_Point(string HL_Sign,int Bar_Number)
{ 
  static int i=0,j=0;     
  static double High_Last_P,Low_Last_P; 
  static datetime High_Last_T,Low_Last_T;
  datetime HL_Current_T=Time[Bar_Number];
  
  if(HL_Sign=="High")     // Draw two lines, one of which connect all the marked peak and the other connect all the marked bottom
  { 
    double Price=High[Bar_Number]+10*Point;
    if(High_Last_T==HL_Current_T&&High_Last_P==High[Bar_Number]);
    else 
    {
      i++;
      if(High_Last_P!=0)
      {
        ObjectCreate("High"+DoubleToStr(i,0),OBJ_TREND,0,High_Last_T,High_Last_P,HL_Current_T,Price);
        ObjectSet("High"+DoubleToStr(i,0),OBJPROP_STYLE,STYLE_SOLID);
        ObjectSet("High"+DoubleToStr(i,0),OBJPROP_COLOR,Yellow);
        ObjectSet("High"+DoubleToStr(i,0),OBJPROP_WIDTH,1);
        ObjectSet("High"+DoubleToStr(i,0),OBJPROP_RAY,false);
      }
      High_Last_P=High[Bar_Number];High_Last_T=Time[Bar_Number];
    }
  }
  else
  { 
    Price=Low[Bar_Number]; 
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

 
  j++;                                                          // Mark the peak or bottom notes
  ObjectCreate(DoubleToStr(j,0),OBJ_TEXT,0,HL_Current_T,Price);
  ObjectSetText(DoubleToStr(j,0),HL_Sign,12,"Times New Roman",White);
}

void iWait()
{
  if(IsTradeContextBusy()||!IsTradeAllowed())
  Sleep(110);
  RefreshRates();
  return;
}

