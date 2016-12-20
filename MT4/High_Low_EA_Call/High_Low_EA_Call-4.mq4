//+------------------------------------------------------------------+
//|                                                                  |
//|              select last historical order                        |
//|                                                                  |
//+------------------------------------------------------------------+

extern int Lots=1,Sleep_Time_Bars=2; 
extern int Move_Stop_Small=10,Move_Stop_Big=20;  //Move_Stop_Loss()
int Sleep_Time,Stop_Loss=8;
double Point_Adapted;

int init()
  {
   Sleep_Time=(Time[1]-Time[2])*Sleep_Time_Bars;
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
  OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY);
  if(OrderCloseTime()-OrderOpenTime()<30&&OrderProfit()<0) Time_Start=OrderCloseTime(); 
  if(TimeCurrent()-Time_Start<Sleep_Time) return(0);
/*
  OrderSelect(0,SELECT_BY_POS,MODE_HISTORY);
  if(OrderCloseTime()-OrderOpenTime()<20) Sleep(1000*60*Sleep_Time);
*/

  double Trade_Sig=iCustom(NULL,0,"Test_Ind",30,10,9,2,0);
  int Shift_Bar=iCustom(NULL,0,"Test_Ind",30,10,9,2,1);
  
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
      if(OrderClose(OrderTicket(),Lots,Bid,3,0))
      {
        iWait();
        Trade_CNT++;
        OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+Stop_Loss*Point_Adapted,0,0,0,0,0);
      }
    }
    if(Trade_CNT>0)    Show_Refer_Point("High",Shift_Bar);
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
      if(OrderClose(OrderTicket(),Lots,Ask,3,0))
      {
        iWait();
        Trade_CNT++;
        OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-Stop_Loss*Point_Adapted,0,0,0,0,0);
      }
    }
    if(Trade_CNT>0)    Show_Refer_Point("Low",Shift_Bar);
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
     // if(Profit_Point>500)Move_Stop=100;
      if(MathAbs(Close[0]-OrderStopLoss())>Move_Stop*Point)
      if(OrderType()==OP_BUY) {iWait();OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]-Move_Stop*Point,0,0,0);}
      else if(OrderType()==OP_SELL) {iWait();OrderModify(OrderTicket(),OrderOpenPrice(),Close[0]+Move_Stop*Point,0,0,0);}
    } 
}
  return;
}


void Show_Refer_Point(string HL_Sign,int Bar_Number)  // Mark the refered peaks or bottoms
{ 
  static int i=0; 
  if(HL_Sign=="High") double Price=High[Bar_Number]+10*Point;
  else Price=Low[Bar_Number];
  
  i++;                                                          
  ObjectCreate(DoubleToStr(i,0),OBJ_TEXT,0,Time[Bar_Number],Price);
  ObjectSetText(DoubleToStr(i,0),HL_Sign,12,"Times New Roman",White);
    
  return;
}

void iWait()
{
  if(IsTradeContextBusy()||!IsTradeAllowed())
  Sleep(110);
  RefreshRates();
  return;
}

