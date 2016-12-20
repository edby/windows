//+------------------------------------------------------------------+
//|                                                     斜率判断.mq4 |
//|                            Copyright 2013, 金顶智汇量化版权所有. |
//|                                       http://www.jinding9999.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, 金顶智汇量化版权所有."
#property link      "http://www.jinding9999.com"
extern string str0 = "----------鳄鱼睡了判断参数---------";
extern int 斜率周期Bar = 20;
int BarNum;
extern int 分块 = 2;
int Count;
extern double 临界倾斜角 = 8;
double LimitAngle;


extern string str1 = "--------区间最高最低点参数-------";
extern bool 是否显示最高最低点 = true;
bool SFlag;
extern int 高低点的时间周期 = 4;
int MyPeriod; 
extern double 超过点数 = 10;
double MorePrice;

extern string str2 = "----------建仓参数---------";
extern double 建仓手数 = 0.1;
double MyLots2;
extern int 止损点数 = 30;
double SL;
extern int 止盈点数 = 50;
double TP;
extern int huadian = 5;
extern int MyMagicNum = 201311051319;

double JawVal,TeethVal,LipsVal,LipsVal1;
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
double OpenHigh,OpenLow;
double GetHigh,GetLow;
int LastStarHour = 0;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
      if(Digits == 3 || Digits == 5)  MyPoint = Point / 0.1;  //Digits:当前货币对的汇率小数位;Point:图表的点值
      else MyPoint = Point;
      
      BarNum = 斜率周期Bar;
      Count = 分块;
      LimitAngle = 临界倾斜角;
      
      SFlag = 是否显示最高最低点;
      MyPeriod = 高低点的时间周期*60; 
      MorePrice = 超过点数*MyPoint;
      
      MyLots2 = 建仓手数;
      SL = 止损点数*MyPoint;
      TP = 止盈点数*MyPoint;
      //HLPriode = 最高最低点周期;
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
     // JawVal = iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMA,PRICE_MEDIAN,MODE_GATORJAW,0);  
    //  TeethVal = iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMA,PRICE_MEDIAN,MODE_GATORTEETH,0);
     // LipsVal = iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMA,PRICE_MEDIAN,MODE_GATORLIPS,0);
     // LipsVal1 = iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMA,PRICE_MEDIAN,MODE_GATORLIPS,BarNum);
      iShowInfo();
      if(Time[0] != Mytime && !OFlag)
      {      
         if(MyShape() == 1)//MathAbs(MyAngle) < LimitAngle //鱼睡了
         {
            Mytime = Time[0];
            i += 1;
            MyPointText("鱼睡了",i,Time[0],LipsVal);//,i
           // Print("i "+i);
           OFlag = true;
         }
       //  else
         //   i=0;
      }
      
      if(OFlag)
      {
         GetHL();
          if(Ask >= GetHigh + MorePrice && OpenHigh != GetHigh)
         {
            OpenHigh = GetHigh;
            OrderSend(Symbol(),OP_BUY,MyLots2,Ask,huadian,Ask-SL,Ask+TP,0,MyMagicNum,0,CLR_NONE);
            OFlag = false;
         } 
         if(Bid <= GetLow - MorePrice && OpenLow != GetLow)
         {
            OpenLow = GetLow;
            OrderSend(Symbol(),OP_SELL,MyLots2,Bid,huadian,Bid+SL,Bid-TP,0,MyMagicNum,0,CLR_NONE);  
            OFlag = false;
         }
         /*  if(Bid >= GetHigh + MorePrice && OpenHigh != GetHigh)
         {
            OpenHigh = GetHigh;
            OrderSend(Symbol(),OP_SELL,MyLots2,Bid,huadian,Bid+SL,Bid-TP,0,MyMagicNum,0,CLR_NONE);
            OFlag = false;
         } 
         if(Bid <= GetLow - MorePrice && OpenLow != GetLow)
         {
            OpenLow = GetLow;
            OrderSend(Symbol(),OP_BUY,MyLots2,Ask,huadian,Ask-SL,Ask+TP,0,MyMagicNum,0,CLR_NONE);  
            OFlag = false;
         }*/
            
      }
   
      
      
//----
   return(0);
  }
  
//+------------------------------------------------------------------+ 
//高低点开仓位置

   void GetHL()
   {
      int MyBars = NormalizeDouble(MyPeriod/Period(),0);
      //Print("MyBars :"+MyBars);
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
         if(SFlag)
         {     
            MyPointText("高点",i,iTime(NULL,0,myHightBar),GetHigh);//,i
            MyPointText("低点",i,iTime(NULL,0,myLowBar),GetLow);
         }
      }
      return;
   }

//+------------------------------------------------------------------+
//寻找形态走势
int MyShape()
{
   double GetAngle[];
   ArrayResize(GetAngle,Count);
   ArrayInitialize(GetAngle,0.0);
   int AddNum = NormalizeDouble(BarNum/Count,0);
   
   for(int i=0;i<Count;i++)
   {
      LipsVal = iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMA,PRICE_MEDIAN,MODE_GATORLIPS,i*AddNum);
      LipsVal1 = iAlligator(Symbol(),0,13,8,8,5,5,3,MODE_SMA,PRICE_MEDIAN,MODE_GATORLIPS,(i+1)*AddNum);
      GetAngle[i] = getSlop(LipsVal,LipsVal1,AddNum);
   }
   
   for(i = 0;i<Count;i++)
   {
      if(MathAbs(GetAngle[i]) > LimitAngle)
      {
         return(0);
      }
   }
   return(1);
 }

//+------------------------------------------------------------------+
/*
函    数:计算斜率
输入参数:myLctY0:纵坐标1
         myLctY1:纵坐标2 
         myLctX01:横坐标差值      
输出参数:返回倾斜角度值（单位：度）
算    法：
*/
double getSlop(double myLctY0,double myLctY1,double myLctX01)
{
   double mySlop = 0;
   double Y_Value = myLctY0-myLctY1;
   double LJ = Y_Value / 100;
   while(MathAbs(LJ) < 1)
   {
      Y_Value *= 10;
      LJ = Y_Value / 100;
   }
  // Print("Y_Value "+Y_Value);
   mySlop = Y_Value*0.01/myLctX01;
   mySlop = MathArctan(mySlop)*180/3.14;
   mySlop = NormalizeDouble(mySlop,Digits);
  //  Print("mySlop "+mySlop);
   return(mySlop);
}

//-----------------------------------------------------------------------------------
void MyPointText(string MyPointPreName,int MyBarPos,datetime MyPointTime,double MyPointPrice)//,int MyPointNum
{
   string MyPointName = MyPointPreName + DoubleToStr(MyBarPos,0);
   ObjectCreate(MyPointName,OBJ_TEXT,0,MyPointTime,MyPointPrice);
   ObjectSetText(MyPointName,MyPointPreName,11,"黑体",White);//+DoubleToStr(MyPointNum,0)
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
      HAND_B=0;
    //  MAXTZM_S=0;
      HAND_S=0;
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
      MyArrayRange = OrdersTotal() + 1;
     // ArrayResize(OrdersArray, MyArrayRange); //重新界定数组
     // ArrayInitialize(OrdersArray, 0.0); //初始化数组
      if (OrdersTotal()>0)
         {
            //遍历持仓单,创建数组
            for (int cnt=0; cnt<=MyArrayRange; cnt++)
               {
                  iWait();
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
                           HAND_B += OrderLots();
                           BuyGroupOrders += 1; //买入组订单数量
                        }
                        if(OrderType() == OP_SELL)
                        {
                          // MAXTZM_S = MAXTZM_S + (OrderOpenPrice()*OrderLots());
                           HAND_S += OrderLots();
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
            //统计基本信息
          /*  for (cnt=0; cnt<MyArrayRange; cnt++)
               {
                  //买入持仓单
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUY)
                     {
                        BuyGroupOrders=BuyGroupOrders+1; //买入组订单数量
                      //  BuyGroupLots=BuyGroupLots+OrdersArray[cnt][4]; //买入组开仓量
                       // BuyGroupProfit=BuyGroupProfit+OrdersArray[cnt][2]; //买入组利润
                     }
                  //卖出持仓单
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELL)
                     {
                        SellGroupOrders=SellGroupOrders+1; //卖出组订单数量
                       // SellGroupLots=SellGroupLots+OrdersArray[cnt][4]; //卖出组开仓量
                       // SellGroupProfit=SellGroupProfit+OrdersArray[cnt][2]; //卖出组利润
                     }*/
                  //买入组限制挂单总计
               //   if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYLIMIT) BuyLimitOrders=BuyLimitOrders+1;
                  //卖出组限制挂单总计
 /*                 if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLLIMIT) SellLimitOrders=SellLimitOrders+1;
                  //买入组停止挂单总计
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYSTOP) BuyStopOrders=BuyStopOrders+1;
                  //卖出组停止挂单总计
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLSTOP) SellStopOrders=SellStopOrders+1;
               }
            //计算买入卖出组首尾单号
            BuyGroupFirstTicket=iOrderSortTicket(0,0,1); //买入组第1单单号
            SellGroupFirstTicket=iOrderSortTicket(1,0,1); //卖出组第1单单号
            BuyGroupLastTicket=iOrderSortTicket(0,0,0); //买入组最后1单单号
            SellGroupLastTicket=iOrderSortTicket(1,0,0); //卖出组最后1单单号
            
            BuyGroupMinProfitTicket=iOrderSortTicket(0,1,1); //买入组最小盈利单单号
            SellGroupMinProfitTicket=iOrderSortTicket(1,1,1); //卖出组最小盈利单单号
            BuyGroupMaxProfitTicket=iOrderSortTicket(0,1,0); //买入组最大盈利单单号
            SellGroupMaxProfitTicket=iOrderSortTicket(1,1,0); //卖出组最大盈利单单号
            BuyGroupMaxLossTicket=iOrderSortTicket(0,2,0); //买入组最大亏损单单号
            SellGroupMaxLossTicket=iOrderSortTicket(1,2,0); //卖出组最大亏损单单号
            BuyGroupMinLossTicket=iOrderSortTicket(0,2,1); //买入组最小亏损单单号
            SellGroupMinLossTicket=iOrderSortTicket(1,2,1); //卖出组最小亏损单单号*/
         }
      //显示订单信息
   /*   iDisplayInfo(Symbol()+"-BuyGroup", "买入组", Corner, 70, 70, 12, "Arial", Red);
      iDisplayInfo(Symbol()+"-Ask", DoubleToStr(Ask, Digits), Corner, 70, 90, 12, "Arial", Red);
      iDisplayInfo(Symbol()+"-SellGroup", "卖出组", Corner, 5, 70, 12, "Arial", Green);
      iDisplayInfo(Symbol()+"-Bid", DoubleToStr(Bid, Digits), Corner, 5, 90, 12, "Arial", Green);
      //显示买入组信息
      iDisplayInfo(Symbol()+"-BuyGroup", "买入组", Corner, 70, 70, 12, "Arial", Red);
      iDisplayInfo(Symbol()+"-Ask", DoubleToStr(Ask, Digits), Corner, 70, 90, 12, "Arial", Red);
      iDisplayInfo(Symbol()+"BuyOrders", BuyGroupOrders, Corner, 80, 110, 10, "Arial", iObjectColor(BuyGroupProfit));
      iDisplayInfo(Symbol()+"BuyGroupLots", DoubleToStr(BuyGroupLots, 2), Corner, 80, 125, 10, "Arial", iObjectColor(BuyGroupProfit));
      iDisplayInfo(Symbol()+"BuyGroupProfit", DoubleToStr(BuyGroupProfit, 2), Corner, 80, 140, 10, "Arial", iObjectColor(BuyGroupProfit));
      //显示卖出组信息
      iDisplayInfo(Symbol()+"-SellGroup", "卖出组", Corner, 5, 70, 12, "Arial", Green);
      iDisplayInfo(Symbol()+"-Bid", DoubleToStr(Bid, Digits), Corner, 5, 90, 12, "Arial", Green);
      iDisplayInfo(Symbol()+"SellOrders", SellGroupOrders, Corner, 10, 110, 10, "Arial", iObjectColor(SellGroupProfit));
      iDisplayInfo(Symbol()+"SellGroupLots", DoubleToStr(SellGroupLots, 2), Corner, 10, 125, 10, "Arial", iObjectColor(SellGroupProfit));
      iDisplayInfo(Symbol()+"SellGroupProfit", DoubleToStr(SellGroupProfit, 2), Corner, 10, 140, 10, "Arial", iObjectColor(SellGroupProfit));
*/
      return(0);
   }

//=============================================================================================================== 
/*
函    数：交易繁忙，程序等待，更新缓存数据
输入参数：
输出参数：
算法说明：
*/
void iWait() 
   {
      while (!IsTradeAllowed() || IsTradeContextBusy()) Sleep(100);
      RefreshRates();
      return(0);
   }
//========================================================================================================   