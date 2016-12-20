//+------------------------------------------------------------------+
//|                                                     账户跟单.mq4 |
//|                            Copyright 2013, 金顶智汇量化版权所有. |
//|                                       http://www.jinding9999.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, 金顶智汇量化版权所有."
#property link      "http://www.jinding9999.com"

extern string 文件名称  = "MyAccountData1.csv";
string MyFileName;
//extern string 商品2 = "GBPUSD";
extern bool 选择反向挂单 = true;
bool GFlag;
extern double 跟单手数比例 = 1;
double MyLotsPercent;
extern double 挂单间隔点数 = 30;
double MyInterval;
extern int 滑点 = 5;
double huadian;
extern double 订单特征码 = 201310181638;
double MyMagicNum;

string MyOrdersTotal,GetSymbol,GetTicket,GetType,GetLots,GetComment;
double MyPoint;
double MyOpenPrice = 0;
int MyOrdersCount;
int i;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   if(Digits == 3 || Digits == 5)  MyPoint = Point / 0.1;  //Digits:当前货币对的汇率小数位;Point:图表的点值
   else MyPoint = Point;
   
   MyFileName = 文件名称;
   GFlag = 选择反向挂单;
   MyLotsPercent = 跟单手数比例;
   MyInterval = 挂单间隔点数*MyPoint;
   huadian = 滑点*MyPoint;
   MyMagicNum = 订单特征码;
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
//TZM,Symbol(),OrdersArray[i][0],OrdersArray[i][3],OrdersArray[i][4],MyOrderTicket,
int start()
  {
//----     
      if(MyReadFile(MyFileName) == 0)
         return;
      int MyTotal =  StrToInteger(MyOrdersTotal); 
      if(MyTotal != 0 && Symbol()!= GetSymbol)
      {
         Print("商品不匹配！");
         return;
      }
      
      MyOrdersCount = iOrdersCount();
      
     //  Print("MyOrdersCount="+MyOrdersCount);  
       //  Print("MyTotal="+MyTotal);  
      if(MyTotal == MyOrdersCount)     
         return;
      int iOrderType = 6;  
      if(MyTotal > MyOrdersCount) //建仓
      { //Print("跟单建仓");
         int MyType =  StrToInteger(GetType);
       //  Print("MyType="+MyType);
         if(MyType != 0 && MyType != 1)
            return;
         double MyLots = NormalizeDouble(StrToDouble(GetLots)*MyLotsPercent,2);  
         
         if(MyType == 0)
         {Print("挂Kong单");
            if(GFlag == true)
            {   
               iOrderType = OP_SELLSTOP;
               MyOpenPrice = Bid - MyInterval;
            }
            else
            {
               iOrderType = OP_SELL;
               MyOpenPrice = Bid;
            }
         }   
         if(MyType == 1)
         { 
            if(GFlag == true)
            { Print("挂多单");
               iOrderType = OP_BUYSTOP;
               MyOpenPrice = Ask + MyInterval;
            }
            else
            {Print("开多单");
               iOrderType = OP_BUY;
               MyOpenPrice = Ask; 
            }
         }   
         string MyCommentTiket = GetTicket;
         OrderSend(Symbol(),iOrderType,MyLots,MyOpenPrice,huadian,0,0,MyCommentTiket,MyMagicNum);
      }
      if(MyTotal < MyOrdersCount)//平仓
      {Print("平仓");
         string  MyComment= GetComment;  
         Print("MyComment"+MyComment);
         for( i=0; i< OrdersTotal();i++)
         { // Print("i"+i); Print("OrdersTotal"+OrdersTotal()); 
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()== Symbol() && OrderMagicNumber() == MyMagicNum)
            {//Print("i"+i); 
               Print("OrderComment1"+OrderComment());
               if(OrderComment() == MyComment)
               {
                  Print("OrderType"+OrderType()); 
                  if(OrderType() == 0)
                     OrderClose(OrderTicket(),OrderLots(),Bid,huadian,CLR_NONE);
                  if(OrderType() == 1)
                     OrderClose(OrderTicket(),OrderLots(),Ask,huadian,CLR_NONE);
                  if(OrderType()== 4 || OrderType()== 5)
                     OrderDelete(OrderTicket());
                     break;
               }
            }          
         }
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+
////TZM,Symbol(),OrdersArray[i][0],OrdersArray[i][3],OrdersArray[i][4],MyOrderTicket,"3订单类型","4开仓量",
int MyReadFile(string FileName)
{  
   int MyHandle = FileOpen(FileName,FILE_BIN|FILE_READ);
   //Print("MyHandle="+MyHandle);
   if(MyHandle == -1)
      return(0);
   string MyValue = FileReadString(MyHandle,60);
   int MyCnt1 = StringFind(MyValue,",",0);   //总单数
   MyOrdersTotal = StringSubstr(MyValue,0,MyCnt1);
   int MyCnt2 = MyCnt1;
   
   MyCnt1 = StringFind(MyValue,",",MyCnt2+1); //商品名称
   GetSymbol = StringSubstr(MyValue,MyCnt2+1,MyCnt1 - MyCnt2 -1);
   MyCnt2 = MyCnt1;
   
   MyCnt1 = StringFind(MyValue,",",MyCnt2+1);//订单特征码
   GetComment = StringSubstr(MyValue,MyCnt2+1,MyCnt1 - MyCnt2 -1);
   MyCnt2 = MyCnt1;
   
   MyCnt1 = StringFind(MyValue,",",MyCnt2+1); //单号
   GetTicket = StringSubstr(MyValue,MyCnt2+1,MyCnt1 - MyCnt2 -1);
   MyCnt2 = MyCnt1;
   
   MyCnt1 = StringFind(MyValue,",",MyCnt2+1);//交易类型
   GetType = StringSubstr(MyValue,MyCnt2+1,MyCnt1 - MyCnt2 -1);
   MyCnt2 = MyCnt1;
   
   MyCnt1 = StringFind(MyValue,",",MyCnt2+1);//交易手数
   GetLots = StringSubstr(MyValue,MyCnt2+1,MyCnt1 - MyCnt2 -1);
   
   
   
   
   FileClose(MyHandle);
   return(1);
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

int iOrdersCount()
      {
         int iOrdersCount = 0;
      //   Print("OrdersTotal="+OrdersTotal());
         for(int i=0;i < OrdersTotal();i++)
         {
             iWait();
                  //选中当前货币对相关持仓订单
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()== Symbol() && OrderMagicNumber() == MyMagicNum)
            {
               iOrdersCount += 1; 
            }  
         }
         return(iOrdersCount);
      }