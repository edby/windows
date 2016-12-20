//+------------------------------------------------------------------+
//|                                                     斜率判断.mq4 |
//|                            Copyright 2013, 金顶智汇量化版权所有. |
//|                                       http://www.jinding9999.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, 金顶智汇量化版权所有."
#property link      "http://www.jinding9999.com"

extern bool 是否显示最高最低点 = true;
bool SFlag;
extern int 高低点的时间周期 = 7;
int MyPeriod; 
extern double 超过点数 = 0;
double MorePrice;

extern double 建仓手数 = 0.1;
double MyLots2;
extern int 止损点数 = 30;
double SL;
extern int 止盈点数 = 75;
double TP;
extern int huadian = 5;
extern int MyMagicNum = 201311051319;

extern int 连续亏损次数限制 = 3;
int MySLTimes;
extern int 最高最低点差值限制点数 = 30;
double HTCL;
extern int 移动止损的盈利点数限制 = 50;
double PL;


int i = 0;
datetime Mytime = 0;
double MyPoint;
int TZM;
double HAND_B,HAND_S;
int BuyGroupOrders, SellGroupOrders;
int MyArrayRange; //数组记录数量

double LastHigh = 0;
double LastLow = 0;
bool HFlag = false;
bool LFlag = false;
bool OFlag = false;
double HighVal,LowVal;
double OpenHigh,OpenLow;
double GetHigh,GetLow;
int LastStarHour = 0;
double tempStartHour,tempEndHour;
int BullSignal = -1;
int OPTime = 0;
double HLC = 0;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
      if(Digits == 3 || Digits == 5)  MyPoint = Point / 0.1;  //Digits:当前货币对的汇率小数位;Point:图表的点值
      else MyPoint = Point;
      
      SFlag = 是否显示最高最低点;
      MyPeriod = 高低点的时间周期*60; 
      MorePrice = 超过点数*MyPoint;
      
      MyLots2 = 建仓手数;
      SL = 止损点数*MyPoint;
      TP = 止盈点数*MyPoint;
      
      MySLTimes = 连续亏损次数限制;
      
      HTCL = 最高最低点差值限制点数*MyPoint;
      PL = 移动止损的盈利点数限制*MyPoint;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----   
       iShowInfo();
         i +=1;
         MoveSL(PL);
         GetHL();
      //  BullCondition();
         //if(LastHigh != HighVal && Bid >= HighVal + MorePrice)
         if(SellGroupOrders == 0 && Bid >= GetHigh + MorePrice && OpenHigh != GetHigh && HLC > HTCL)// && BullSignal == 0 
         {
            OpenHigh = GetHigh;
            if(GetSLTimes(MySLTimes))
            {
               OPTime += 1;
            }
            else
               OPTime = 0;
            Print("OPTime "+OPTime);
            if(OPTime != 1)
            { Print("挂空");
              // OpenHigh = GetHigh;
              // double MyTP = NormalizeDouble(HLC*PL,Digits);
             // double MySL = NormalizeDouble(MyTP*PL,Digits);
               OrderSend(Symbol(),OP_SELL,MyLots2,Bid,huadian,Bid+SL,Bid-TP,0,MyMagicNum,0,CLR_NONE);
               OPTime = 0;
            }
         //   OFlag = false;
         } 
         if(BuyGroupOrders == 0 && Bid <= GetLow - MorePrice && OpenLow != GetLow && HLC > HTCL)// && BullSignal == 1  
         {
            OpenLow = GetLow;
            if(GetSLTimes(MySLTimes))
            {
               OPTime += 1;
            }
            else
               OPTime = 0;
            Print("OPTime "+OPTime);
            if(OPTime != 1)
            {Print("挂多");                      
               OrderSend(Symbol(),OP_BUY,MyLots2,Ask,huadian,Ask-SL,Ask+TP,0,MyMagicNum,0,CLR_NONE);
               OPTime = 0;
            }
         }     
//----
   return(0);
  }
  

//----------------------------------------------------------------------+
/*  void BullCondition()
   {
      BullSignal = -1;
      double MyBandsUp = NormalizeDouble(iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,0),Digits);
      double MyBandsLow = NormalizeDouble(iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,0),Digits);
      if(Close[1] < MyBandsUp && Close[2] > MyBandsUp)
         BullSignal = 0;     
      if(Close[1] > MyBandsLow && Close[2] < MyBandsLow)
         BullSignal = 1; 
     return;     
   }*/
//------------------------------------------------------------------+

   void GetHL()
   {
      int MyBars = NormalizeDouble(MyPeriod/Period(),0);
    //  Print("MyBars :"+MyBars);
      int myBarTime = iTime(NULL,0,0);
      int myStartHour=StrToTime(TimeYear(myBarTime)+"."+TimeMonth(myBarTime)+"."+TimeDay(myBarTime)+" "+TimeHour(myBarTime))+0*60*60;
     // Print("myStartHour ："+myStartHour);
      if(myStartHour-LastStarHour >= MyPeriod*60)
      {//Print("myStartHour ："+myStartHour);Print("LastStarHour :"+LastStarHour);
         LastStarHour = myStartHour;
         
         int myHightBar=iHighest(NULL,0,MODE_HIGH,MyBars,0);
          double myHightPrice=High[myHightBar];
         int myLowBar=iLowest(NULL,0,MODE_LOW,MyBars,0);
         double myLowPrice=Low[myLowBar];

         GetHigh = myHightPrice;
         GetLow = myLowPrice;
         HLC = GetHigh - GetLow;
         if(SFlag)
         {     
            MyPointText("高点",i,iTime(NULL,0,myHightBar),GetHigh);//,i
            MyPointText("低点",i,iTime(NULL,0,myLowBar),GetLow);
         }
     }
     return;
   }

//-----------------------------------------------------------------------------------------------------

void MyPointText(string MyPointPreName,int MyBarPos,datetime MyPointTime,double MyPointPrice)//,int MyPointNum
{
   string MyPointName = MyPointPreName + DoubleToStr(MyBarPos,0);
   ObjectCreate(MyPointName,OBJ_TEXT,0,MyPointTime,MyPointPrice);
   ObjectSetText(MyPointName,MyPointPreName,11,"黑体",White);//+DoubleToStr(MyPointNum,0)
}
//---------------------------------------------------------------------------------------------------+
//判断连续亏损次数是否等于N

bool GetSLTimes(int N)
{
   int MyTradeTotal = OrdersHistoryTotal();
   int LossTimes = 0;
   int cnt = 1;
   for(int i=MyTradeTotal-cnt;cnt<=N;cnt++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) && OrderProfit()<0)
      {
         LossTimes += 1;
      }
   }
   Print("SLT :"+LossTimes);
    if(LossTimes == N)
      {
         return(true);
      }
   return(false);
}

//+------------------------------------------------------------------+  
/*
函    数：显示交易信息
输入参数：
输出参数：
算    法：
*/

void iShowInfo()
   {
      //初始化变量
      TZM=0;
    //  MAXTZM=0;
    //  HAND=0;
     // MAXTZM_B=0;
    //  HAND_B=0;
    //  MAXTZM_S=0;
     // HAND_S=0;
      BuyGroupOrders=0; SellGroupOrders=0; //买入、卖出组成交持仓单数量总计
    /*  BuyGroupFirstTicket=0; SellGroupFirstTicket=0; //买入、卖出组第一张订单单号
      BuyGroupLastTicket=0; SellGroupLastTicket=0; //买入、卖出组最后一张订单号
      BuyGroupMaxProfitTicket=0; SellGroupMaxProfitTicket=0; //买入、卖出组最大盈利单单号
      BuyGroupMinProfitTicket=0; SellGroupMinProfitTicket=0; //买入、卖出组最小盈利单单号
      BuyGroupMaxLossTicket=0; SellGroupMaxLossTicket=0; //买入、卖出组最大亏损单单号
      BuyGroupMinLossTicket=0; SellGroupMinLossTicket=0; //买入、卖出组最小亏损单单号
      BuyGroupLots=0; SellGroupLots=0; //买入、卖出组成交单持仓量
      BuyGroupProfit=0; SellGroupProfit=0; //买入、卖出组成交单利润
  //    BuyLimitOrders=0; SellLimitOrders=0; //买入限制挂单、卖出限制挂单数量总计
      BuyStopOrders=0; SellStopOrders=0; //买入停止挂单、卖出停止挂单数量总计
   */   //初始化订单数组
    //  MyArrayRange = OrdersTotal() + 1;
     // ArrayResize(OrdersArray, MyArrayRange); //重新界定数组
     // ArrayInitialize(OrdersArray, 0.0); //初始化数组
      if (OrdersTotal()>0)
         {
            //遍历持仓单,创建数组
            for (int cnt=0; cnt< OrdersTotal(); cnt++)
               {
                  //iWait();
                  //选中当前货币对相关持仓订单
                  if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()== MyMagicNum)
                  {   
                        TZM=TZM+1;
                     /*   OrdersArray[cnt][0]=OrderTicket();//0订单号
                        OrdersArray[cnt][1]=OrderOpenTime();//1开仓时间
                        OrdersArray[cnt][2]=OrderProfit();//2订单利润
                        OrdersArray[cnt][3]=OrderType();//3订单类型
                        OrdersArray[cnt][4]=OrderLots();//4开仓量
                        HAND =HAND+OrderLots();
                        OrdersArray[cnt][5]=OrderOpenPrice();//5开仓价
                        MAXTZM=MAXTZM+(OrderOpenPrice()*OrderLots());
                        OrdersArray[cnt][6]=OrderStopLoss();//6止损价
                        OrdersArray[cnt][7]=OrderTakeProfit();//7止赢价
                        OrdersArray[cnt][8]=OrderMagicNumber();//8订单特征码
                        OrdersArray[cnt][9]=OrderCommission();//9订单佣金
                        OrdersArray[cnt][10]=OrderSwap();//10掉期
                        OrdersArray[cnt][11]=OrderExpiration();//11挂单有效日期 */
                        if(OrderType() == OP_BUY)
                        {
                          // MAXTZM_B = MAXTZM_B + (OrderOpenPrice()*OrderLots());
                         //  HAND_B += OrderLots();
                           BuyGroupOrders += 1; //买入组订单数量
                        }
                        if(OrderType() == OP_SELL)
                        {
                          // MAXTZM_S = MAXTZM_S + (OrderOpenPrice()*OrderLots());
                         //  HAND_S += OrderLots();
                           SellGroupOrders += 1;
                        }
                   /*     if(OrderType() == OP_BUYSTOP)
                        {
                           Ticket_BUYSTOP = OrderTicket();
                           OpenPrice_BUYSTOP= OrderOpenPrice();
                        }
                        if(OrderType() == OP_SELLSTOP)
                        {
                           Ticket_SELLSTOP = OrderTicket();
                           OpenPrice_SELLSTOP= OrderOpenPrice();
                        }*/
                  }
               }


         }

      return(0);
   }

//=============================================================================================================== 

//---------------------------------------------------------------------------------------------------------+
//pingsun

   void MoveSL(double MinPL)
   {
      if(OrdersTotal() == 0)
         return;
      for (int cnt=0;cnt< OrdersTotal();cnt++)
      {
         if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()== MyMagicNum)
         {
            //double MSL = OrderOpenPrice();
            //Print("C "+(Close[0] - OrderOpenPrice()));
            //Print("P "+OrderProfit());

            if(OrderType() == OP_BUY && (Close[0] - OrderOpenPrice() > MinPL) && OrderStopLoss() != OrderOpenPrice())//30*MyPoint
            {
               
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,CLR_NONE);
            }
             if(OrderType() == OP_SELL && (OrderOpenPrice() - Close[0] > MinPL) && OrderStopLoss() != OrderOpenPrice())//30*MyPoint
            {
               OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,CLR_NONE);
            }
         }
      }
      return;       
   }

