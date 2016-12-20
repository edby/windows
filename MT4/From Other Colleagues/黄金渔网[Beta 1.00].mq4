#property copyright "Copyright By Laoyee QQ:921795"
#property link      "http://www.docin.com/yiwence"
#include <WinUser32.mqh>

/*
【程序名称及版本号】
黄金移动网格[Beta 1.00]
【开发记录】
2012.09.12[1.01]
1、增加识别Gold品种 ---- ok
2、limit挂单有错误重复挂单，需要识别删除

2012.09.06[1.00]
1、空仓时，根据信号，市价开出买入单，开仓量为Lots
2、有1张买入持仓单时，双向挂单，BuyStop为PendingNum张，BuyLimit为PendingNum*2张，间隔为GridSpace，开仓量为Lots
3、价格上浮，触发新的BuyStop单，则网格上移一格，最高处间隔GridSpace增加1张新的BuyStop，最低处删除1张BuyLimit单
4、价格下浮，触发新的BuyLimit单，则网格下移一格，最低处间隔GridSpace增加1张新的BuyLimit，最高处删除1张BuyStop单
5、所有买入单均设置GridSpace止盈，如果现价超出止盈价(跳空)，则该单市价平仓
6、SellSignal+买入单持仓时，统计EMA线下持仓单数量，如果超过PendingNum*2张，全部市价平仓。止损策略
7、买入信号BuySignal：Ask<EMA(H1,120,0,2,6,1)，卖出信号SellSignal：Ask<EMA(H1,120,0,2,6,1)
8、卖出单规则相反
9、预设参数Lots=平台最小开仓量，PendingNum=5，GridSpace=StopLevel/2，
*/
//----程序预设参数
string str1 = "====系统预设参数====";
double Lots;
extern int PendingNum=3;
extern double GridDensity=1; //网格密度，数值越大密度越高
extern int GridSpace=0; //格子宽度=停止水平位/GridDensity

//订单控制参数
string MyOrderComment="lyGold";
int MyMagicNum=12090621;

//----程序控制参数
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
double OrdersArray[][12];//第1维:订单序号;第2维:订单信息
double TempOrdersArray[][12];//临时数组
int MyArrayRange; //数组记录数量
int Corner = 1; //交易信息显示四个角位置
int cnt, i, j; //计数器变量
string TextBarString; //蜡烛位置显示文字变量
string DotBarString; //蜡烛位置显示文字变量
string HLineBarString; //蜡烛位置显示文字变量
string VLineBarString; //蜡烛位置显示文字变量

int FontSize=10; //提示信息字体
double MinLots; //最小开仓量
double BasePrice; //基准价
double LastTakeProfit; //买入最高止盈价/卖出最低止盈价
int OrdersNow; //当前持仓单总数
bool BuwangBool=true; //允许补网
int LastHistoryTicket=-1; //最后一张历史订单号
bool FirstNet=true;
double myTempBuyStopPrice; //Stop挂单合规价


int start()
   {
      iMain();
      return(0);
   }

/*
函    数：主控程序
输入参数：
输出参数：
算    法：
*/
void iMain()
   {
//========================================
if (TimeCurrent()>D'2012.10.30') 
   {
      Comment("测试期限已到");
      return(0);
   }
if (Symbol()!="XAUUSD" || Symbol()!="Gold")
   {
      Comment("只能使用XAUUAD");
      return(0);
   }
if (!IsDemo())
   {
      Comment("只能用于测试账户");
      return(0);
   }
//========================================
      iShowInfo();
      //买入单设置止盈/平仓
      iLimitTakeProfit();
      //2、建网、补网。合规性修复
      iComplianceRepair();
      //1、建仓。空仓时，根据信号，市价开出买入单，开仓量为Lots
      if (BuyGroupOrders==0 && iTradingSignals()==0)
         {
            iWait();
            iDisplayInfo("TradeInfo", "市价买入开仓", 1, 5, 50, FontSize, "", Olive);
            OrderSend(Symbol(),OP_BUY,Lots,Ask,0,0,0,MyOrderComment+DoubleToStr(Ask,Digits),MyMagicNum);
         }
      return(0);
   }

/*
函    数：合规性修复
输入参数：
输出参数：
算    法：反向limit挂单、正向Stop挂单、limit触发单设置止盈
按最后1张买入单所在位置，以基准价绘制网格数组，确保BuyStop为PendingNum张，BuyLimit为PendingNum*2张，挂单间隔为GridSpace，开仓量为Lots
*/
void iComplianceRepair()
   {
      int myNetNum;
      double myTempNetTop,myTempNetBot;
      if ((BuyGroupOrders+SellGroupOrders)==0) return(0);
      //获取基准价
      if (OrderSelect(BuyGroupLastTicket,SELECT_BY_TICKET,MODE_TRADES))
         {
            BasePrice=NormalizeDouble(StrToDouble(StringSubstr(OrderComment(),6,StringLen(OrderComment())-1)),Digits);
         }
      if (BasePrice==0) return(0); //基准价为0，返回
      //定义格子数组
      //----计算网格数量
      myNetNum=PendingNum*3; //网格总数
      double myGridArray[]; //定义格子数组
      ArrayResize(myGridArray,myNetNum); //重新界定格子数组维数
      ArrayInitialize(myGridArray, 0.0); //初始化格子数组
      myGridArray[0]=BasePrice+GridSpace*Point*PendingNum; //最高挂单价
      string myteststr=myGridArray[0]+"\n";
      //----格子数组赋值
      for (cnt=1;cnt<myNetNum;cnt++)
         {
            myGridArray[cnt]=myGridArray[cnt-1]-GridSpace*Point;
            myteststr=myteststr+myGridArray[cnt]+"\n";
         }
      //1、反向空档limit挂单 基准价：BasePrice，间隔：GridSpace，开仓量：MinLots，均分数量：OrdersNum
      string mystring,mytempstring;
      //清除/增加limit单
      //limit补网
      if (BuyLimitOrders<(PendingNum*2) && OrderSelect(iOrderSortTicket(2,3,1),SELECT_BY_TICKET,MODE_TRADES) && (BasePrice-OrderOpenPrice())/(GridSpace*Point)>(PendingNum*2))
         {
            double myTempLimitPrice1=OrderOpenPrice()-GridSpace*Point; //补网基准价
            iWait();
            iDisplayInfo("TradeInfo", "增补BuyLimit挂单", 1, 5, 50, FontSize, "", Olive);
            OrderSend(Symbol(),OP_BUYLIMIT,Lots,myTempLimitPrice1,0,0,0,MyOrderComment+DoubleToStr(myTempLimitPrice1,Digits),MyMagicNum);
         }
      if (BuyLimitOrders>(PendingNum*2) && OrderSelect(iOrderSortTicket(2,3,1),SELECT_BY_TICKET,MODE_TRADES) && (BasePrice-OrderOpenPrice())/(GridSpace*Point)>(PendingNum*2))
         {
            iWait();
            iDisplayInfo("TradeInfo", "删除BuyLimit挂单", 1, 5, 50, FontSize, "", Olive);
            OrderDelete(iOrderSortTicket(2,3,1));
         }
      for (cnt=0;cnt<=500;cnt++)
         {
            if (myGridArray[cnt]==0) break; //挂单类型为卖出、最高止盈价为0，不执行
            //比对成交持仓单是否有此价格 
            mytempstring="";
            for (i=0;cnt<=500;i++)
               {
                  if (OrdersArray[i][0]==0) break;
                  if (OrderSelect(OrdersArray[i][0],SELECT_BY_TICKET,MODE_TRADES)
                      && StringFind(OrderComment(),"Gold"+DoubleToStr(myGridArray[cnt],Digits),0)>0)
                     {
                        mytempstring=mytempstring+DoubleToStr(OrdersArray[i][0],0)+"*"+i; //订单号赋值
                     }
               }
            if (StringLen(mytempstring)==0 && myGridArray[cnt]<(Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) && myGridArray[cnt-1]!=0)
               {
                  iWait();
                  iDisplayInfo("TradeInfo", "BuyLimit挂单", 1, 5, 50, FontSize, "", Olive);
                  OrderSend(Symbol(),OP_BUYLIMIT,Lots,myGridArray[cnt],0,0,0,MyOrderComment+DoubleToStr(myGridArray[cnt],Digits),MyMagicNum);
                  mytempstring="补网";
               }
            mystring=mystring+DoubleToStr(myGridArray[cnt],Digits)+" : "+mytempstring+"\n";
         }

      //2、扩网  正向空档Stop挂单 基准价：BasePrice，间隔：GridSpace，开仓量：Lots，数量：PendingNum
      if (BuyStopOrders<PendingNum)
         {
            //计算Stop挂单价
            if (OrderSelect(iOrderSortTicket(4,3,0),SELECT_BY_TICKET,MODE_TRADES))
               {
                  myTempBuyStopPrice=NormalizeDouble(StrToDouble(StringSubstr(OrderComment(),6,StringLen(OrderComment())-1)),Digits)+GridSpace*Point;
               }
               else 
                  {
                     if (OrderSelect(iOrderSortTicket(0,3,0),SELECT_BY_TICKET,MODE_TRADES))
                        {
                           myTempBuyStopPrice=BasePrice+GridSpace*Point;
                        }
                  }
            //Stop挂单
            iWait();
            iDisplayInfo("TradeInfo", "BuyStop挂单", 1, 5, 50, FontSize, "", Olive);
            OrderSend(Symbol(),OP_BUYSTOP,Lots,myTempBuyStopPrice,0,0,0,MyOrderComment+DoubleToStr(myTempBuyStopPrice,Digits),MyMagicNum);
         }
      return(0);
   }
   
/*
函    数：计算交易信号
输入参数：
输出参数：9-无信号
          0-买入开仓信号
          1-卖出开仓信号
算    法：
*/
int iTradingSignals()
   {
      int myReturn=9;//预定义返回变量
      double myEMA=iMA(Symbol(),60,120,0,2,6,1);
      if (Ask>myEMA) myReturn=0;
      if (Bid<myEMA) myReturn=1;
      return(myReturn);
   }
   
/*
函    数：limit触发单设置止盈或平仓
输入参数：
输出参数：
算    法：
*/
void iLimitTakeProfit()
   {
      for (cnt=0;cnt<=OrdersTotal();cnt++)
         {
            if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==MyMagicNum && OrderSymbol()==Symbol() && OrderType()==OP_BUY)
               {
                  //买入单盈利超过止盈价，市价平仓
                  if (Bid>(OrderOpenPrice()+GridSpace*Point))
                     {
                        iWait();
                        iDisplayInfo("TradeInfo", OrderTicket()+"号单盈利平仓", 1, 5, 50, FontSize, "", Olive);
                        OrderClose(OrderTicket(),OrderLots(),Bid,0);
                        break;
                     }
                  //买入单设置止盈
                  double myTPPrice;
                  if (StringSubstr(OrderComment(),0,6)=="lyGold")
                     {
                        myTPPrice=NormalizeDouble(StrToDouble(StringSubstr(OrderComment(),6,StringLen(OrderComment())-1)),Digits)+GridSpace*Point;
                     }
                  if (OrderTakeProfit()!=myTPPrice && Bid<myTPPrice)
                     {
                        iWait();
                        iDisplayInfo("TradeInfo", OrderTicket()+"号单设置止盈", 1, 5, 50, FontSize, "", Olive);
                        OrderModify(OrderTicket(),OrderOpenPrice(),0,myTPPrice,0);
                     }
               }
         }
      return(0);
   }

/*
函    数：显示交易信息
输入参数：
输出参数：
算    法：
*/
void iShowInfo()
   {
      //初始化变量
      BuyGroupOrders=0; SellGroupOrders=0; //买入、卖出组成交持仓单数量总计
      BuyGroupFirstTicket=0; SellGroupFirstTicket=0; //买入、卖出组第一张订单单号
      BuyGroupLastTicket=0; SellGroupLastTicket=0; //买入、卖出组最后一张订单号
      BuyGroupMaxProfitTicket=0; SellGroupMaxProfitTicket=0; //买入、卖出组最大盈利单单号
      BuyGroupMinProfitTicket=0; SellGroupMinProfitTicket=0; //买入、卖出组最小盈利单单号
      BuyGroupMaxLossTicket=0; SellGroupMaxLossTicket=0; //买入、卖出组最大亏损单单号
      BuyGroupMinLossTicket=0; SellGroupMinLossTicket=0; //买入、卖出组最小亏损单单号
      BuyGroupLots=0; SellGroupLots=0; //买入、卖出组成交单持仓量
      BuyGroupProfit=0; SellGroupProfit=0; //买入、卖出组成交单利润
      BuyLimitOrders=0; SellLimitOrders=0; //买入限制挂单、卖出限制挂单数量总计
      BuyStopOrders=0; SellStopOrders=0; //买入停止挂单、卖出停止挂单数量总计
      //初始化订单数组
      MyArrayRange=OrdersTotal()+1;
      ArrayResize(OrdersArray, MyArrayRange); //重新界定数组
      ArrayInitialize(OrdersArray, 0.0); //初始化数组
      if (OrdersTotal()>0)
         {
            //遍历持仓单,创建数组
            for (cnt=0; cnt<=MyArrayRange; cnt++)
               {
                  iWait();
                  //选中当前货币对相关持仓订单
                  if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()==MyMagicNum)
                     {
                        OrdersArray[cnt][0]=OrderTicket();//0订单号
                        OrdersArray[cnt][1]=OrderOpenTime();//1开仓时间
                        OrdersArray[cnt][2]=OrderProfit();//2订单利润
                        OrdersArray[cnt][3]=OrderType();//3订单类型
                        OrdersArray[cnt][4]=OrderLots();//4开仓量
                        OrdersArray[cnt][5]=OrderOpenPrice();//5开仓价
                        OrdersArray[cnt][6]=OrderStopLoss();//6止损价
                        OrdersArray[cnt][7]=OrderTakeProfit();//7止赢价
                        OrdersArray[cnt][8]=OrderMagicNumber();//8订单特征码
                        OrdersArray[cnt][9]=OrderCommission();//9订单佣金
                        OrdersArray[cnt][10]=OrderSwap();//10掉期
                        OrdersArray[cnt][11]=OrderExpiration();//11挂单有效日期
                     }
               }
            //统计基本信息
            for (cnt=0; cnt<MyArrayRange; cnt++)
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
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYLIMIT) BuyLimitOrders=BuyLimitOrders+1;
                  //卖出组限制挂单总计
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLLIMIT) SellLimitOrders=SellLimitOrders+1;
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
            SellGroupMinLossTicket=iOrderSortTicket(1,2,1); //卖出组最小亏损单单号
         }
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
      iDisplayInfo(Symbol()+"SellGroupProfit", DoubleToStr(SellGroupProfit, 2), Corner, 10, 140, 10, "Arial", iObjectColor(SellGroupProfit));
      OrdersNow=BuyGroupOrders+SellGroupOrders+BuyLimitOrders+SellLimitOrders+BuyStopOrders+SellStopOrders;
      iDisplayInfo(Symbol()+"-OrdersTotal", "持仓单总数:"+OrdersNow, Corner, 10, 160, 12, "Arial", Red);

      return(0);
   }

/*
函    数:计算特定条件的订单
输入参数:myOrderType:订单类型 0-Buy,1-Sell,2-BuyLimit,3-SellLimit,4-BuyStop,5-SellStop
         myOrderSort:排序类型 0-按时间,1-按盈利,2-按亏损,3-按开仓价
         myMaxMin:最值 0-最大,1-最小
输出参数:返回订单号
算    法：
*/
int iOrderSortTicket(int myOrderType,int myOrderSort,int myMaxMin)
   {
      int myTicket=0;
      int myArraycnt=0; //时间序列
      int myArraycnt1=0; //盈亏序列
      int myArraycnt2=0; //开仓价序列
      int myType;
      //创建临时数组
      double myTempArray[][12]; //定义临时数组
      ArrayResize(myTempArray, MyArrayRange); //重新界定临时数组
      ArrayInitialize(myTempArray, 0.0); //初始化临时数组
      double myTempOrdersArray[][12]; //定义临时数组
      myArraycnt=BuyGroupOrders+SellGroupOrders;
      if (myArraycnt==0) return(0);
      myArraycnt2=MyArrayRange;
      myArraycnt1=myArraycnt;
      myArraycnt=myArraycnt-1;
      //将原始数组数据复制到myTempOrdersArray数组
      ArrayResize(myTempOrdersArray, myArraycnt1); //重新界定临时数组
      ArrayInitialize(myTempOrdersArray, 0.0); //初始化临时数组
      for (cnt=0; cnt<=MyArrayRange; cnt++)
         {
            if ((OrdersArray[cnt][3]==0 || OrdersArray[cnt][3]==1) && OrdersArray[cnt][0]!=0)
               {
                  myTempOrdersArray[myArraycnt][0]=OrdersArray[cnt][0];
                  myTempOrdersArray[myArraycnt][1]=OrdersArray[cnt][1];
                  myTempOrdersArray[myArraycnt][2]=OrdersArray[cnt][2];
                  myTempOrdersArray[myArraycnt][3]=OrdersArray[cnt][3];
                  myTempOrdersArray[myArraycnt][4]=OrdersArray[cnt][4];
                  myTempOrdersArray[myArraycnt][5]=OrdersArray[cnt][5];
                  myTempOrdersArray[myArraycnt][6]=OrdersArray[cnt][6];
                  myTempOrdersArray[myArraycnt][7]=OrdersArray[cnt][7];
                  myTempOrdersArray[myArraycnt][8]=OrdersArray[cnt][8];
                  myTempOrdersArray[myArraycnt][9]=OrdersArray[cnt][9];
                  myTempOrdersArray[myArraycnt][10]=OrdersArray[cnt][10];
                  myTempOrdersArray[myArraycnt][11]=OrdersArray[cnt][11];
                  myArraycnt=myArraycnt-1;
               }
         }
      //按时间降序排列数组  原始数组重新排序
      if (myOrderSort==0)
         {
            for (i=0; i<=MyArrayRange; i++)
               {
                  for (j=MyArrayRange; j>i; j--)
                     {
                        if (OrdersArray[j][1]>OrdersArray[j-1][1])
                           {
                              myTempArray[0][0]=OrdersArray[j-1][0];
                              myTempArray[0][1]=OrdersArray[j-1][1];
                              myTempArray[0][2]=OrdersArray[j-1][2];
                              myTempArray[0][3]=OrdersArray[j-1][3];
                              myTempArray[0][4]=OrdersArray[j-1][4];
                              myTempArray[0][5]=OrdersArray[j-1][5];
                              myTempArray[0][6]=OrdersArray[j-1][6];
                              myTempArray[0][7]=OrdersArray[j-1][7];
                              myTempArray[0][8]=OrdersArray[j-1][8];
                              myTempArray[0][9]=OrdersArray[j-1][9];
                              myTempArray[0][10]=OrdersArray[j-1][10];
                              myTempArray[0][11]=OrdersArray[j-1][11];
                              
                              OrdersArray[j-1][0]=OrdersArray[j][0];
                              OrdersArray[j-1][1]=OrdersArray[j][1];
                              OrdersArray[j-1][2]=OrdersArray[j][2];
                              OrdersArray[j-1][3]=OrdersArray[j][3];
                              OrdersArray[j-1][4]=OrdersArray[j][4];
                              OrdersArray[j-1][5]=OrdersArray[j][5];
                              OrdersArray[j-1][6]=OrdersArray[j][6];
                              OrdersArray[j-1][7]=OrdersArray[j][7];
                              OrdersArray[j-1][8]=OrdersArray[j][8];
                              OrdersArray[j-1][9]=OrdersArray[j][9];
                              OrdersArray[j-1][10]=OrdersArray[j][10];
                              OrdersArray[j-1][11]=OrdersArray[j][11];
                              
                              OrdersArray[j][0]=myTempArray[0][0];
                              OrdersArray[j][1]=myTempArray[0][1];
                              OrdersArray[j][2]=myTempArray[0][2];
                              OrdersArray[j][3]=myTempArray[0][3];
                              OrdersArray[j][4]=myTempArray[0][4];
                              OrdersArray[j][5]=myTempArray[0][5];
                              OrdersArray[j][6]=myTempArray[0][6];
                              OrdersArray[j][7]=myTempArray[0][7];
                              OrdersArray[j][8]=myTempArray[0][8];
                              OrdersArray[j][9]=myTempArray[0][9];
                              OrdersArray[j][10]=myTempArray[0][10];
                              OrdersArray[j][11]=myTempArray[0][11];
                           }
                     }
               }
         }
      //按利润降序排列数组 myTempOrdersArray
      if (myOrderSort==1 || myOrderSort==2)
         {
            double myTempArray1[][12]; //定义临时数组
            ArrayResize(myTempArray1, myArraycnt1); //重新界定临时数组
            ArrayInitialize(myTempArray1, 0.0); //初始化临时数组
            for (i=0; i<=myArraycnt1; i++)
               {
                  for (j=myArraycnt1-1; j>i; j--)
                     {
                        if (myTempOrdersArray[j][2]>myTempOrdersArray[j-1][2])
                           {
                              myTempArray1[0][0]=myTempOrdersArray[j-1][0];
                              myTempArray1[0][1]=myTempOrdersArray[j-1][1];
                              myTempArray1[0][2]=myTempOrdersArray[j-1][2];
                              myTempArray1[0][3]=myTempOrdersArray[j-1][3];
                              myTempArray1[0][4]=myTempOrdersArray[j-1][4];
                              myTempArray1[0][5]=myTempOrdersArray[j-1][5];
                              myTempArray1[0][6]=myTempOrdersArray[j-1][6];
                              myTempArray1[0][7]=myTempOrdersArray[j-1][7];
                              myTempArray1[0][8]=myTempOrdersArray[j-1][8];
                              myTempArray1[0][9]=myTempOrdersArray[j-1][9];
                              myTempArray1[0][10]=myTempOrdersArray[j-1][10];
                              myTempArray1[0][11]=myTempOrdersArray[j-1][11];
                              
                              myTempOrdersArray[j-1][0]=myTempOrdersArray[j][0];
                              myTempOrdersArray[j-1][1]=myTempOrdersArray[j][1];
                              myTempOrdersArray[j-1][2]=myTempOrdersArray[j][2];
                              myTempOrdersArray[j-1][3]=myTempOrdersArray[j][3];
                              myTempOrdersArray[j-1][4]=myTempOrdersArray[j][4];
                              myTempOrdersArray[j-1][5]=myTempOrdersArray[j][5];
                              myTempOrdersArray[j-1][6]=myTempOrdersArray[j][6];
                              myTempOrdersArray[j-1][7]=myTempOrdersArray[j][7];
                              myTempOrdersArray[j-1][8]=myTempOrdersArray[j][8];
                              myTempOrdersArray[j-1][9]=myTempOrdersArray[j][9];
                              myTempOrdersArray[j-1][10]=myTempOrdersArray[j][10];
                              myTempOrdersArray[j-1][11]=myTempOrdersArray[j][11];
                              
                              myTempOrdersArray[j][0]=myTempArray1[0][0];
                              myTempOrdersArray[j][1]=myTempArray1[0][1];
                              myTempOrdersArray[j][2]=myTempArray1[0][2];
                              myTempOrdersArray[j][3]=myTempArray1[0][3];
                              myTempOrdersArray[j][4]=myTempArray1[0][4];
                              myTempOrdersArray[j][5]=myTempArray1[0][5];
                              myTempOrdersArray[j][6]=myTempArray1[0][6];
                              myTempOrdersArray[j][7]=myTempArray1[0][7];
                              myTempOrdersArray[j][8]=myTempArray1[0][8];
                              myTempOrdersArray[j][9]=myTempArray1[0][9];
                              myTempOrdersArray[j][10]=myTempArray1[0][10];
                              myTempOrdersArray[j][11]=myTempArray1[0][11];
                           }
                     }
               }
         }

      //按订单开仓价降序排列数组
      if (myOrderSort==3)
         {
            double myTempArray2[][12]; //定义临时数组
            ArrayResize(myTempArray2, myArraycnt2); //重新界定临时数组
            ArrayInitialize(myTempArray2, 0.0); //初始化临时数组
            for (i=0; i<=myArraycnt2; i++)
               {
                  for (j=myArraycnt2-1; j>i; j--)
                     {
                        if (OrdersArray[j][5]>OrdersArray[j-1][5])
                           {
                              myTempArray2[0][0]=OrdersArray[j-1][0];
                              myTempArray2[0][1]=OrdersArray[j-1][1];
                              myTempArray2[0][2]=OrdersArray[j-1][2];
                              myTempArray2[0][3]=OrdersArray[j-1][3];
                              myTempArray2[0][4]=OrdersArray[j-1][4];
                              myTempArray2[0][5]=OrdersArray[j-1][5];
                              myTempArray2[0][6]=OrdersArray[j-1][6];
                              myTempArray2[0][7]=OrdersArray[j-1][7];
                              myTempArray2[0][8]=OrdersArray[j-1][8];
                              myTempArray2[0][9]=OrdersArray[j-1][9];
                              myTempArray2[0][10]=OrdersArray[j-1][10];
                              myTempArray2[0][11]=OrdersArray[j-1][11];
                              
                              OrdersArray[j-1][0]=OrdersArray[j][0];
                              OrdersArray[j-1][1]=OrdersArray[j][1];
                              OrdersArray[j-1][2]=OrdersArray[j][2];
                              OrdersArray[j-1][3]=OrdersArray[j][3];
                              OrdersArray[j-1][4]=OrdersArray[j][4];
                              OrdersArray[j-1][5]=OrdersArray[j][5];
                              OrdersArray[j-1][6]=OrdersArray[j][6];
                              OrdersArray[j-1][7]=OrdersArray[j][7];
                              OrdersArray[j-1][8]=OrdersArray[j][8];
                              OrdersArray[j-1][9]=OrdersArray[j][9];
                              OrdersArray[j-1][10]=OrdersArray[j][10];
                              OrdersArray[j-1][11]=OrdersArray[j][11];
                              
                              OrdersArray[j][0]=myTempArray2[0][0];
                              OrdersArray[j][1]=myTempArray2[0][1];
                              OrdersArray[j][2]=myTempArray2[0][2];
                              OrdersArray[j][3]=myTempArray2[0][3];
                              OrdersArray[j][4]=myTempArray2[0][4];
                              OrdersArray[j][5]=myTempArray2[0][5];
                              OrdersArray[j][6]=myTempArray2[0][6];
                              OrdersArray[j][7]=myTempArray2[0][7];
                              OrdersArray[j][8]=myTempArray2[0][8];
                              OrdersArray[j][9]=myTempArray2[0][9];
                              OrdersArray[j][10]=myTempArray2[0][10];
                              OrdersArray[j][11]=myTempArray2[0][11];
                           }
                     }
               }
         }

      //X订单类型最低开仓价单
      if (myOrderSort==3 && myMaxMin==0)
         {
            for (cnt=0; cnt<=OrdersTotal(); cnt++)
               {
                  myType=NormalizeDouble(OrdersArray[cnt][3],0);
                  if (OrdersArray[cnt][5]!=0 && myType==myOrderType) 
                     {
                        myTicket=NormalizeDouble(OrdersArray[cnt][0],0);
                        break;
                     }
               }
         }

      //X订单类型最高开仓价单
      if (myOrderSort==3 && myMaxMin==1)
         {
            for (cnt=OrdersTotal(); cnt>=0; cnt--)
               {
                  myType=NormalizeDouble(OrdersArray[cnt][3],0);
                  if (OrdersArray[cnt][5]!=0 && myType==myOrderType) 
                     {
                        myTicket=NormalizeDouble(OrdersArray[cnt][0],0);
                        break;
                     }
               }
         }


      //X订单类型最小亏损单
      if (myOrderSort==2 && myMaxMin==1)
         {
            for (cnt=0; cnt<=myArraycnt1; cnt++)
               {
                  myType=NormalizeDouble(myTempOrdersArray[cnt][3],0);
                  if (myTempOrdersArray[cnt][2]<0 && myType==myOrderType) 
                     {
                        myTicket=NormalizeDouble(myTempOrdersArray[cnt][0],0);
                        break;
                     }
               }
         }
      //X订单类型最大亏损单
      if (myOrderSort==2 && myMaxMin==0)
         {
            for (cnt=myArraycnt1; cnt>=0; cnt--)
               {
                  myType=NormalizeDouble(myTempOrdersArray[cnt][3],0);
                  if (myTempOrdersArray[cnt][2]<0 && myType==myOrderType) 
                     {
                        myTicket=NormalizeDouble(myTempOrdersArray[cnt][0],0);
                        break;
                     }
               }
         }
      //X订单类型最大盈利单
      if (myOrderSort==1 && myMaxMin==0)
         {
            for (cnt=0; cnt<=myArraycnt1; cnt++)
               {
                  myType=NormalizeDouble(myTempOrdersArray[cnt][3],0);
                  if (myTempOrdersArray[cnt][2]>0 && myType==myOrderType) 
                     {
                        myTicket=NormalizeDouble(myTempOrdersArray[cnt][0],0);
                        break;
                     }
               }
         }
      //X订单类型最小盈利单
      if (myOrderSort==1 && myMaxMin==1)
         {
            for (cnt=myArraycnt1; cnt>=0; cnt--)
               {
                  myType=NormalizeDouble(myTempOrdersArray[cnt][3],0);
                  if (myTempOrdersArray[cnt][2]>0 && myType==myOrderType) 
                     {
                        myTicket=NormalizeDouble(myTempOrdersArray[cnt][0],0);
                        break;
                     }
               }
         }

      //X订单类型第1开仓单
      if (myOrderSort==0 && myMaxMin==1)
         {
            for (cnt=MyArrayRange; cnt>=0; cnt--)
               {
                  myType=NormalizeDouble(OrdersArray[cnt][3],0);
                  if (OrdersArray[cnt][0]!=0 && myType==myOrderType) 
                     {
                        myTicket=NormalizeDouble(OrdersArray[cnt][0],0);
                        break;
                     }
               }
         }
      //X类型最后开仓单
      if (myOrderSort==0 && myMaxMin==0)
         {
            for (cnt=0; cnt<=MyArrayRange; cnt++)
               {
                  myType=NormalizeDouble(OrdersArray[cnt][3],0);
                  if (OrdersArray[cnt][0]!=0 && myType==myOrderType) 
                     {
                        myTicket=NormalizeDouble(OrdersArray[cnt][0],0);
                        break;
                     }
               }
         }
      return(myTicket);
   }

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

/*
函    数：在屏幕上显示文字标签
输入参数：string LableName 标签名称，如果显示多个文本，名称不能相同
          string LableDoc 文本内容
          int Corner 文本显示角
          int LableX 标签X位置坐标
          int LableY 标签Y位置坐标
          int DocSize 文本字号
          string DocStyle 文本字体
          color DocColor 文本颜色
输出参数：在指定的位置（X,Y）按照指定的字号、字体及颜色显示指定的文本
算法说明：
*/
void iDisplayInfo(string LableName,string LableDoc,int Corner,int LableX,int LableY,int DocSize,string DocStyle,color DocColor)
   {
      if (Corner == -1) return(0);
      ObjectCreate(LableName, OBJ_LABEL, 0, 0, 0);
      ObjectSetText(LableName, LableDoc, DocSize, DocStyle,DocColor);
      ObjectSet(LableName, OBJPROP_CORNER, Corner);
      ObjectSet(LableName, OBJPROP_XDISTANCE, LableX);
      ObjectSet(LableName, OBJPROP_YDISTANCE, LableY);
   }

/*
函    数：物件颜色
输入参数：数值
输出参数：颜色
算    法：负数为红色，正数为绿色，0为灰色
*/
color iObjectColor(double myInput)
   {
      color myColor;
      if (myInput > 0)
         myColor = Green; //正数颜色为绿色
      if (myInput < 0)
         myColor = Red; //负数颜色为红色
      if (myInput == 0)
         myColor = DarkGray; //0颜色为灰色
      return(myColor);
   }

int init()
   {
      //显示基本信息
      iDisplayInfo("Author", "作者:老易 QQ:921795", Corner, 18, 15, 8, "", SlateGray);
      iDisplayInfo("Symbol", Symbol(), Corner, 25, 30, 14, "Arial Bold", DodgerBlue);
      iDisplayInfo("TradeInfo", "欢迎使用！", Corner, 5, 50, FontSize, "", Olive);
      iShowInfo();
      //初始化预设变量
      Lots=MarketInfo(Symbol(),MODE_MINLOT);
      if (PendingNum<3) PendingNum=3;
      if (GridDensity<1) GridDensity=1;
      if (GridSpace==0) GridSpace=(MarketInfo(Symbol(),MODE_STOPLEVEL)*2)/GridDensity;
      if (GridSpace!=0) GridSpace=GridSpace*2/GridDensity;
      return(0);
   }

int deinit()
   {
      ObjectsDeleteAll();
      Comment ("");
      return(0);
   }

