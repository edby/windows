//+------------------------------------------------------------------+
//|                                             记录账户交易信息.mq4 |
//|                            Copyright 2013, 金顶智汇量化版权所有. |
//|                                       http://www.jinding9999.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, 金顶智汇量化版权所有."
#property link      "http://www.jinding9999.com"
/*
extern string str1 = "--------应用商品--------";
extern string 商品1  = "USDJPY";
extern string 商品2 = "GBPUSD";
*/

extern  string 文件写入路径及名称 = "\MyTrade_yihui\experts\files\MyAccountData1.csv";
string iFileName;

//----程序控制参数
/*
int BuyGroupOrders, SellGroupOrders; //买入、卖出组成交持仓单数量总计
int BuyGroupFirstTicket, SellGroupFirstTicket; //买入、卖出组第一单单号
int BuyGroupLastTicket, SellGroupLastTicket; //买入、卖出组最后一单单号
int BuyGroupMaxProfitTicket, SellGroupMaxProfitTicket; //买入、卖出组最大盈利单单号
int BuyGroupMinProfitTicket, SellGroupMinProfitTicket; //买入、卖出组最小盈利单单号
int BuyGroupMaxLossTicket, SellGroupMaxLossTicket; //买入、卖出组最大亏损单单号
int BuyGroupMinLossTicket, SellGroupMinLossTicket; //买入、卖出组最小亏损单单号
double BuyGroupLots, SellGroupLots; //买入、卖出组成交持仓单开仓量总计
double BuyGroupProfit, SellGroupProfit; //买入、卖出组成交持仓单利润总计
int BuyLimitOrders, SellLimitOrders; //买入限制挂单、卖出限制挂单数量总计
int BuyStopOrders, SellStopOrders; //买入停止挂单、卖出停止挂单数量总计
//持仓订单基本信息:0订单号,1开仓时间,2订单利润,3订单类型,4开仓量,5开仓价,
//                 6止损价,7止赢价,8订单特征码,9订单佣金,10掉期,11挂单有效日期
*/
double OrdersArray[][12];//第1维:订单序号;第2维:订单信息
double TempOrdersArray[][12];//临时数组
int MyArrayRange; //数组记录数量
//int Corner = 1; //交易信息显示四个角位置
//int FontSize=10; //提示信息字号
int TZM;
//double MyPoint = 0,MAXTZM,HAND,MyProfite;
//double MAXTZM_B,HAND_B,MAXTZM_S,HAND_S; 

int MyOrdersTotal = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
  // iDisplayInfo("TradeInfo", "记录账户交易信息！", Corner, 5, 50, 9, "", Olive);
   iFileName = 文件写入路径及名称;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  // int  counted_bars = IndicatorCounted();
//----
  // if(商品1 == Symbol())
      WriteMyAccountDate(iFileName);
 //  if(商品1 == Symbol())
 //    WriteMyAccountDate("\MyTrade_yihui\experts\files\MyAccountData2.csv");     
//----
   return(0);
  }
//+------------------------------------------------------------------+
//将账户信息写入文件
  void WriteMyAccountDate(string MyFileName)//"MyAccountData1.csv"
   {   
      iShowInfo();

      if(MyOrdersTotal == TZM)
         return;
   //   if(TZM == 0) 
       //   FileDelete(MyFileName);
      if(MyOrdersTotal > TZM) //有平仓
      {
         OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY);
         int MyOrderTicket = OrderTicket();
      }   
      MyOrdersTotal = TZM;
     // FileDelete(MyFileName);
      int handle;
      if(OrdersTotal() == 0)
      {
         handle = FileOpen(MyFileName,FILE_BIN|FILE_READ,",");
         if(handle > 0)       
            FileDelete(MyFileName);
      } 
         handle = FileOpen(MyFileName,FILE_CSV|FILE_WRITE,",");
         Print("记录信息");
         int i =  TZM - 1;      
         FileWrite(handle,TZM,Symbol(),MyOrderTicket,OrdersArray[i][0],OrdersArray[i][3],OrdersArray[i][4],0);                
         FileClose(handle);
     // }    
      return;
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
      //MAXTZM=0;
      //HAND=0;
    /*  MyProfite = 0;
      MAXTZM_B=0;
      HAND_B=0;
      MAXTZM_S=0;
      HAND_S=0;
      BuyGroupOrders=0; SellGroupOrders=0; //买入、卖出组成交持仓单数量总计
      BuyGroupFirstTicket=0; SellGroupFirstTicket=0; //买入、卖出组第一张订单单号
      BuyGroupLastTicket=0; SellGroupLastTicket=0; //买入、卖出组最后一张订单号
      BuyGroupMaxProfitTicket=0; SellGroupMaxProfitTicket=0; //买入、卖出组最大盈利单单号
      BuyGroupMinProfitTicket=0; SellGroupMinProfitTicket=0; //买入、卖出组最小盈利单单号
      BuyGroupMaxLossTicket=0; SellGroupMaxLossTicket=0; //买入、卖出组最大亏损单单号
      BuyGroupMinLossTicket=0; SellGroupMinLossTicket=0; //买入、卖出组最小亏损单单号
      BuyGroupLots=0; SellGroupLots=0; //买入、卖出组成交单持仓量
      BuyGroupProfit=0; SellGroupProfit=0; //买入、卖出组成交单利润
  //    BuyLimitOrders=0; SellLimitOrders=0; //买入限制挂单、卖出限制挂单数量总计
      BuyStopOrders=0; SellStopOrders=0; //买入停止挂单、卖出停止挂单数量总计*/
      //初始化订单数组
      MyArrayRange=OrdersTotal()+1;
      ArrayResize(OrdersArray, MyArrayRange); //重新界定数组
      ArrayInitialize(OrdersArray, 0.0); //初始化数组
      if (OrdersTotal()>0)
         {
            //遍历持仓单,创建数组
            for (int cnt=0; cnt<=MyArrayRange; cnt++)
               {
                 // iWait();
                  //选中当前货币对相关持仓订单
                  if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()== Symbol())
                     {   
                        OrdersArray[TZM][0]=OrderTicket();//0订单号
                        OrdersArray[TZM][1]=OrderOpenTime();//1开仓时间
                        OrdersArray[TZM][2]=OrderProfit();//2订单利润
                        OrdersArray[TZM][3]=OrderType();//3订单类型
                        OrdersArray[TZM][4]=OrderLots();//4开仓量
                      //  OrdersArray[TZM][5]=OrderOpenPrice();//5开仓价
                      //  OrdersArray[TZM][6]=OrderStopLoss();//6止损价
                       // OrdersArray[TZM][7]=OrderTakeProfit();//7止赢价
                      // OrdersArray[TZM][8]=OrderMagicNumber();//8订单特征码
                       // OrdersArray[TZM][9]=OrderCommission();//9订单佣金
                        //  OrdersArray[TZM][10]=OrderSwap();//10掉期
                        //OrdersArray[TZM][11]=OrderExpiration();//11挂单有效日期
                        TZM = TZM + 1;
                     /*   HAND = HAND + OrderLots();
                        MyProfite += OrderProfit(); 
                        if(OrderType() == OP_BUY)
                        {
                           MAXTZM_B = MAXTZM_B + (OrderOpenPrice()*OrderLots());
                           HAND_B += OrderLots();
                        }
                        if(OrderType() == OP_SELL)
                        {
                           MAXTZM_S = MAXTZM_S + (OrderOpenPrice()*OrderLots());
                           HAND_S += OrderLots();
                        }
                        if(OrderType() == OP_BUYSTOP)
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
   /*         for (cnt=0; cnt<MyArrayRange; cnt++)
               {
                  //买入持仓单
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUY)
                     {
                        BuyGroupOrders=BuyGroupOrders+1; //买入组订单数量
                        BuyGroupLots=BuyGroupLots+OrdersArray[cnt][4]; //买入组开仓量
                        BuyGroupProfit=BuyGroupProfit+OrdersArray[cnt][2]; //买入组利润
                     }
                  //卖出持仓单
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELL)
                     {
                        SellGroupOrders=SellGroupOrders+1; //卖出组订单数量
                        SellGroupLots=SellGroupLots+OrdersArray[cnt][4]; //卖出组开仓量
                        SellGroupProfit=SellGroupProfit+OrdersArray[cnt][2]; //卖出组利润
                     }
                  //买入组限制挂单总计
               //   if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYLIMIT) BuyLimitOrders=BuyLimitOrders+1;
                  //卖出组限制挂单总计
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLLIMIT) SellLimitOrders=SellLimitOrders+1;
                  //买入组停止挂单总计
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYSTOP) BuyStopOrders=BuyStopOrders+1;
                  //卖出组停止挂单总计
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLSTOP) SellStopOrders=SellStopOrders+1;
               }*/
 /*           //计算买入卖出组首尾单号
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
      /*
      //显示订单信息
      iDisplayInfo(Symbol()+"-BuyGroup", "买入组", Corner, 70, 70, 12, "Arial", Red);
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
      iDisplayInfo(Symbol()+"SellGroupProfit", DoubleToStr(SellGroupProfit, 2), Corner, 10, 140, 10, "Arial", iObjectColor(SellGroupProfit));*/

      return(0);
   }

//=============================================================================================================== 
/*
函    数：交易繁忙，程序等待，更新缓存数据
输入参数：
输出参数：
算法说明：
*//*
void iWait() 
   {
      while (!IsTradeAllowed() || IsTradeContextBusy()) Sleep(100);
      RefreshRates();
      return(0);
   }*/
//========================================================================================================  