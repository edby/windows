//+------------------------------------------------------------------+
//|                                                     非农1113.mq4 |
//|                                Copyright 2013, 智汇量化版权所有. |
//|                                       http://www.jinding9999.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, 智汇量化版权所有."
#property link      "http://www.jinding9999.com"
#include <WinUser32.mqh>

extern int 挂单间隔点数 = 50;
double Inte;
extern double 建仓手数 = 0.1;
double MyLots;
extern int 止损点数 = 50;
double SL;
extern int 止盈点数 = 60;
double TP;
extern int huadian = 5;
extern int 订单特征码 = 20130000;
int MyMagicNumFN;
extern int MinProfit = 50;
extern double 移动止损间隔=20;
double TrallingStop;

extern string 开仓时间 = "2013.11.20 15:30:00";   
string MyTimeStart;

extern int 提前几分钟=3;
int myPreTime;

extern double 同向挂单间隔=10;
double Interval_SA;
extern double 反向挂单间隔=10;
double Interval_OP;

int BuyGroupOrders, SellGroupOrders; //买入、卖出组成交持仓单数量总计
/*int BuyGroupFirstTicket, SellGroupFirstTicket; //买入、卖出组第一单单号
int BuyGroupLastTicket, SellGroupLastTicket; //买入、卖出组最后一单单号
int BuyGroupMaxProfitTicket, SellGroupMaxProfitTicket; //买入、卖出组最大盈利单单号
int BuyGroupMinProfitTicket, SellGroupMinProfitTicket; //买入、卖出组最小盈利单单号
int BuyGroupMaxLossTicket, SellGroupMaxLossTicket; //买入、卖出组最大亏损单单号
int BuyGroupMinLossTicket, SellGroupMinLossTicket; //买入、卖出组最小亏损单单号
double BuyGroupLots, SellGroupLots; //买入、卖出组成交持仓单开仓量总计
double BuyGroupProfit, SellGroupProfit; //买入、卖出组成交持仓单利润总计
int BuyLimitOrders, SellLimitOrders; //买入限制挂单、卖出限制挂单数量总计*/
int BuyStopOrders, SellStopOrders; //买入停止挂单、卖出停止挂单数量总计

double OrdersArray[][12];
double TempOrdersArray[][12];

double OpenPrice_SELLSTOP;
double OpenPrice_BUYSTOP;
bool StopFC = false;
double myTrallingStopPrice;//止损价位
datetime myCurrentTime=0;
datetime myTimeLocal=0;
double myPrice_B,myPrice_S;
double MyPoint;
int TZM;
int HAND_B,HAND_S;
int MyArrayRange; //数组记录数量

int MyMagicNum_Next;
int MyOpenTimes;
bool CFlag = false;
bool DFlag = false;

int Ticket_BUY;
int Ticket_SELL;
int  Ticket_BUYSTOP;
int  Ticket_SELLSTOP;

int MyMagicNumF;
//int MinProfit = 50;

int MyOralSpread = 80;
int MyNowSpread=0;
double MyFreeMarginCheck =0;
double MyOralLots =0.01;
double MyAccountLeverage;
double MyNowFreeMarginCheck;
bool SFlag = true;
string myCurrentTimeDay,myLastTimeDay;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
      if(Digits == 3 || Digits == 5)  MyPoint = Point / 0.1;  //Digits:当前货币对的汇率小数位;Point:图表的点值
      else MyPoint = Point;
      
      MyLots = 建仓手数;
      
      Inte = 挂单间隔点数 *MyPoint;
      
      Interval_SA = 同向挂单间隔 * MyPoint;
      
      Interval_OP = 反向挂单间隔 * MyPoint;

      SL = 止损点数 * MyPoint;

      TP = 止盈点数 * MyPoint;
      
      myPreTime = 提前几分钟;
      
      MyTimeStart = 开仓时间;
      
      TrallingStop = 移动止损间隔 * MyPoint;
      
      MyMagicNumFN = 订单特征码;
      
      MyMagicNumF = MyMagicNumFN;
      
       MyNowSpread = MarketInfo(Symbol(),MODE_SPREAD);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
     ObjectsDeleteAll();
     Comment ("");
     return(0);   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
   {
   //-------------------------------------------------------------------------------------------------------------------------------------------
   //   AccountBalance AccountCompany AccountCredit AccountCurrency AccountEquity AccountFreeMargin AccountFreeMarginCheck AccountFreeMarginMode
      
  //    AccountLeverage AccountMargin   AccountProfit  AccountStopoutLevel AccountStopoutMode    MarketInfo() MODE_SPREAD
     //-------------------------------------------------------------------------------------------------------------------------------------
        
         // if((MyNowSpread < MyOralSpread) == false)
          if(MyNowSpread > MyOralSpread && SFlag)
          {
             int ret = MessageBox("点差超过预设值,此时的点差为:"+DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),2)+ "\nContinue?","Spread ",MB_YESNO|MB_ICONQUESTION);//MB_YESNO|MB_ICONQUESTION
             Print("点差超过预设值，此时的点差为:",DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),2));
             if(ret == IDYES) SFlag = false;//MyOralSpread +=1;
             if(ret == IDNO) return(0);
             //if(ret == IDOK)
             
             
          }
       //-----------------------------------------------------------------------------------------
        
          MyFreeMarginCheck = AccountFreeMarginCheck(Symbol(),OP_BUY,MyOralLots);
      //    Print("此时的仓位保证金不够,值为:",MyFreeMarginCheck);
          if(MyFreeMarginCheck <= 0 || GetLastError() == 134)
          {
            Print("此时的仓位保证金不够,值为:",MyFreeMarginCheck);
            int sut = MessageBox("此时的保证金不够,值为"+MyFreeMarginCheck+"!\n","AccountFreeMarginCheck",MB_OK|MB_ICONEXCLAMATION);
            if(sut == IDOK) return(0);
          }
     //---------------------------------------------------------------------------
     //    Print(1 +"/" +100);
          MyAccountLeverage = AccountLeverage();
      //    Print(MyAccountLeverage);
          if(MyAccountLeverage > 400)  
          { 
        //    Print("此时的杠杆比率越界,值为:",MyAccountLeverage);
            int res = MessageBox("此时的杠杆比率越界,值为:"+AccountLeverage()+"\nContinue?","AccountLeverage",MB_YESNO|MB_ICONQUESTION);
            if(res == IDNO) return(0);
          }
     //------------------------------------------
          iMain_FN();
          iMain_Next();
    //--------------------------  
      return(0);
   }

//----------------------------
void iMain_FN()
   {      
   
      //iShowInfo(MyMagicNumF);
      if(OrdersTotal() == 0)
      {
           MyMagicNumF = MyMagicNumFN;
      }    
      myCurrentTime = TimeCurrent();
      myCurrentTimeDay = TimeToStr(myCurrentTime,TIME_DATE);
   //   if(Hour() == 19 && Minute() == 30 && Seconds() == 0)
     if(myLastTimeDay != myCurrentTimeDay && TimeHour(myCurrentTime) == TimeHour(StrToTime(MyTimeStart)) && TimeMinute(myCurrentTime) == TimeMinute(StrToTime(MyTimeStart))-myPreTime && TimeSeconds(myCurrentTime) == TimeSeconds(StrToTime(MyTimeStart)))  
     {  
          myLastTimeDay = myCurrentTimeDay;
          myPrice_B = Ask + Inte;
          myPrice_S = Bid - Inte;
          
         if(OrderSend(Symbol(),OP_BUYSTOP,MyLots,myPrice_B,huadian,myPrice_B-SL,myPrice_B+TP,0,MyMagicNumF,0,CLR_NONE)>0
            && OrderSend(Symbol(),OP_SELLSTOP,MyLots,myPrice_S,huadian,myPrice_S+SL,myPrice_S-TP,0,MyMagicNumF,0,CLR_NONE)>0)
         {
              MyMagicNum_Next = MyMagicNumF;  
              MyMagicNumF += 1;          
              MyOpenTimes += 1;
         }
   
  }
////---------

           
          
   }
//-------------------------------------------------------------------------

   
void iMain_Next()
   {
  //    if(MyOpenTimes == 0) return;
          
      for(int i=0;i < MyOpenTimes;i++)//2
      {
         int MyMagicNum_N = MyMagicNum_Next - i;
         
         iShowInfo(MyMagicNum_N); //1,2.....
         
     //    if(Ticket_BUY == 0 && Ticket_SELL == 0) continue;
      
         if(Ticket_BUY > 0 && Ticket_SELLSTOP > 0)//&& OrderSymbol() == Symbol()
         {
           OrderDelete(Ticket_SELLSTOP,CLR_NONE);
      
         }
         if(Ticket_SELL > 0 && Ticket_BUYSTOP > 0)// &&  OrderSymbol() == Symbol()
         {
           OrderDelete(Ticket_BUYSTOP,CLR_NONE);
         }      
         Tmanage_1(MyMagicNum_N);
   
      }
   }
    
/////////////////////////////////------------------------////////////    
 
    
///////////////////----------移动止损--------------//////  

void Tmanage_1(int MagicNum)
   {      

      for(int i =0; i < OrdersTotal(); i++)  
      {           
         if(OrderSelect(i, SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber() == MagicNum && OrderSymbol() == Symbol())
         {          
            if(OrderType()==OP_BUY && OrderProfit() > 0)
            {             
         //----------------------------------------------------------------------------------------------------------------------------         
              if(Bid - OrderOpenPrice() > MinProfit * MyPoint)
              {                    
                  myTrallingStopPrice = Bid - TrallingStop;                 
               //    Print(MyPoint);             
                   if(myTrallingStopPrice > OrderOpenPrice() && myTrallingStopPrice > OrderStopLoss())
                   {
                   //执行移动止损
                      iWait();
                      OrderModify(OrderTicket(),OrderOpenPrice(),myTrallingStopPrice,0,0);
                   }
               }
            }
            
            if(OrderType()==OP_SELL &&  OrderProfit() > 0)
           {
             if(OrderOpenPrice() - Ask > MinProfit * MyPoint)
             {
               myTrallingStopPrice = Ask + TrallingStop;
               
               if(myTrallingStopPrice < OrderOpenPrice() && myTrallingStopPrice < OrderStopLoss())
               {
                   iWait();                  
                  OrderModify(OrderTicket(),OrderOpenPrice(),myTrallingStopPrice,0,0);
               }
             }
           }
        }
         
    } 
  
/*
      for(i=0; i< OrdersTotal(); i++)  
      {           
         if(OrderSelect(i, SELECT_BY_POS,MODE_TRADES)&& OrderMagicNumber() == MagicNum && OrderSymbol() == Symbol())
         {
           if(OrderType()==OP_SELL)
           {
             if(OrderOpenPrice() - Ask < MinProfit * MyPoint)
             {
               myTrallingStopPrice = Ask + TrallingStop * MyPoint;
               
               if(myTrallingStopPrice < OrderOpenPrice())
               {
                   iWait();
                   
                  OrderModify(OrderTicket(),OrderOpenPrice(),myTrallingStopPrice,0,0);
               }
             }
           }
        }

   }*/
   return;
}

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+  
/*
函    数：显示交易信息
输入参数：
输出参数：
算    法：
*/

void iShowInfo(int MagicNum)
   {
      Ticket_BUY = 0;
      Ticket_SELL = 0;
      Ticket_BUYSTOP = 0;
      Ticket_SELLSTOP = 0;
      
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
  //    BuyLimitOrders=0; SellLimitOrders=0; //买入限制挂单、卖出限制挂单数量总计*/
      BuyStopOrders=0; SellStopOrders=0; //买入停止挂单、卖出停止挂单数量总计
      //初始化订单数组
      MyArrayRange = OrdersTotal()+1;
      ArrayResize(OrdersArray, MyArrayRange); //重新界定数组
      ArrayInitialize(OrdersArray, 0.0); //初始化数组
      if (OrdersTotal()>0)
         {
            //遍历持仓单,创建数组
            for (int cnt=0; cnt < MyArrayRange-1; cnt++)
               {
           //       iWait();
                  //选中当前货币对相关持仓订单
                  if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()== MagicNum)
                  {   
                        TZM=TZM+1;
                        OrdersArray[cnt][0]=OrderTicket();//0订单号
                        OrdersArray[cnt][1]=OrderOpenTime();//1开仓时间
                        OrdersArray[cnt][2]=OrderProfit();//2订单利润
                        OrdersArray[cnt][3]=OrderType();//3订单类型
                        OrdersArray[cnt][4]=OrderLots();//4开仓量
           //           HAND =HAND+OrderLots();
                        OrdersArray[cnt][5]=OrderOpenPrice();//5开仓价
                        //MAXTZM=MAXTZM+(OrderOpenPrice()*OrderLots());
                        OrdersArray[cnt][6]=OrderStopLoss();//6止损价
                        OrdersArray[cnt][7]=OrderTakeProfit();//7止赢价
                        OrdersArray[cnt][8]=OrderMagicNumber();//8订单特征码
                        OrdersArray[cnt][9]=OrderCommission();//9订单佣金
                        OrdersArray[cnt][10]=OrderSwap();//10掉期
                        OrdersArray[cnt][11]=OrderExpiration();//11挂单有效日期 
                     
                        
 //////////////////--------------------------------------------------------------遍历持仓单                       
                       if(OrderType() == OP_BUY)
                       {
                          // MAXTZM_B = MAXTZM_B + (OrderOpenPrice()*OrderLots());
                           HAND_B += OrderLots();
                           Ticket_BUY = OrderTicket();
                         
                           BuyGroupOrders += 1; //买入组订单数量
                        }
                        
                        if(OrderType() == OP_SELL)
                        {
                          // MAXTZM_S = MAXTZM_S + (OrderOpenPrice()*OrderLots());
                           HAND_S += OrderLots();
                           Ticket_SELL = OrderTicket();
                          
                           SellGroupOrders += 1;
                        }
                    
                        if(OrderType() == OP_BUYSTOP)
                        {
                           Ticket_BUYSTOP = OrderTicket();
                           OpenPrice_BUYSTOP= OrderOpenPrice();
                           BuyStopOrders=BuyStopOrders+1;
                        }
                        if(OrderType() == OP_SELLSTOP)
                        {
                           Ticket_SELLSTOP = OrderTicket();
                           OpenPrice_SELLSTOP= OrderOpenPrice();
                           SellStopOrders=SellStopOrders+1;
                        }
                  }
               }
            }
 ///////----------------------------------------------------------------- //统计基本信息
  /*          for (cnt=0; cnt<MyArrayRange; cnt++)
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
      iDisplayInfo("AccountInfo8","服务器时间："+TimeToStr(TimeCurrent(),TIME_SECONDS),1,20,10,12,"",Snow);         
      iDisplayInfo("AccountInfo1","杠杆比例： 1 : "+AccountLeverage(),0,20,12,12,"",Snow);
      iDisplayInfo("AccountInfo2","账户免费保证金："+DoubleToStr(AccountFreeMargin(),Digits),0,20,30,12,"",Snow);
      iDisplayInfo("AccountInfo3","BUY/SELL仓位保证金："+DoubleToStr(AccountFreeMarginCheck(Symbol(),OP_BUY|OP_SELL,1),4),0,20,50,12,"",Snow);
      iDisplayInfo("AccountInfo4","最小开仓："+DoubleToStr(MarketInfo(Symbol(),MODE_MINLOT),4),0,20,70,12,"",Snow);
      iDisplayInfo("AccountInfo5","最大开仓："+DoubleToStr(MarketInfo(Symbol(),MODE_MAXLOT),4),0,20,90,12,"",Snow);
      iDisplayInfo("AccountInfo6","交易点差："+DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),4),0,20,110,12,"",Snow);
      iDisplayInfo("AccountInfo7","点差价值："+DoubleToStr(MarketInfo(Symbol(),MODE_MARGINREQUIRED),4),0,20,130,12,"",Snow);
      
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
//===============================================================================================================   