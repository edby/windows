//+------------------------------------------------------------------+
//|                                               半人工趋势开仓.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#include <WinUser32.mqh>

//bool MyOrderSend;
extern double 建仓手数 = 0.1;
double MyLots;
extern double 挂单间隔点数 = 20;
double Inte;
extern int 止损点数 = 30;
double SL;
extern int 止盈点数 = 30;
double TP;
extern int 距第一单的移动损点数 = 60;//移动损条件
double MinMoveSLValue;
extern int 移动损离现价间隔点数=20;//移动损跟进点数
double TrallingStop;
extern double 较前单盈利加仓的点数 = 50;//加仓的条件
double ProfitLimit;
extern int 加仓单数的限制 = 3;
extern double MaxLots = 1.6;
extern double 加仓倍数 = 1;
double LotTimes;
extern double 平仓总盈利 = 100;
double MaxProfit;
int 最小手数小数的位数 = 2;
int DigitsNum;
int huadian = 5;
extern int MyMagicNum = 2013123000;
extern string 购买方式说明 = "4/5:BUYSTOP&&SELLSTOP";//,5:SELLSTOP&&BUYSTOP
extern int 购买方式 = 4;
int MaxOrders;
double MyPoint;
int BuyGroupOrders,SellGroupOrders;
int BuyStopOrders,SellStopOrders;
int LastOrderTicket = -1;
int LastOrderTick;
double MyOrderLots = 0;
bool MFlag;
bool CloseAll = false;
double  SL_OfAll;
double OpenPriceSum_B,OpenPriceSum_S,OpenPriceAve_B,OpenPriceAve_S;
double Profit;
double myTrallingStopPrice;//止损价位
int Ticket_BUY,Ticket_SELL;
int Ticket_BUYSTOP,Ticket_SELLSTOP;
double myPrice_B,myPrice_S;
//double OrdersArray[][12];//第1维:订单序号;第2维:订单信息
//double TempOrdersArray[][12];//临时数组
//int MyArrayRange; //数组记录数量
//int cnt, i, j; //计数器变量
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   if(Digits == 2 || Digits == 3 || Digits == 5)  MyPoint = Point / 0.1;  //Digits:当前货币对的汇率小数位;Point:图表的点值
   else MyPoint = Point;  
   
   Inte = 挂单间隔点数 * MyPoint;
   
   SL = 止损点数 * MyPoint;
   
   TP = 止盈点数 * MyPoint;
   
   MyLots = 建仓手数;
    
   ProfitLimit = 较前单盈利加仓的点数 * MyPoint;
  
   LotTimes = 加仓倍数;
  
   DigitsNum = 最小手数小数的位数;
  
   MinMoveSLValue = 距第一单的移动损点数 * MyPoint;
   
   TrallingStop = 移动损离现价间隔点数 * MyPoint;
  
   MaxProfit = 平仓总盈利;
  
   SL_OfAll = MarketInfo(Symbol(),MODE_SPREAD)*Point;
  
// LeastStopValue = MarketInfo(Symbol(),MODE_STOPLEVEL)*Point;

   MaxOrders = 加仓单数的限制;
  
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
    //-----这里可以加用程序进行下单条件的判断
   // Print(LeastStopValue);
    iShowInfo();
    if(BuyGroupOrders == 0 && SellGroupOrders == 0 && BuyStopOrders ==0 && SellStopOrders==0 )//&& BuyStopOrders ==0 && SellStopOrders==0 
    {
      MFlag = false;
      CloseAll = false;
      LastOrderTicket = -1;
      myPrice_B = Ask + Inte;
      myPrice_S = Bid - Inte;
        
      string TradeInformationBuy = "BUY";
      string TradeInformationSell = "SELL";
      
      int MsgBoxInfoBuy = MessageBox("下"+TradeInformationBuy+"单选择按钮:是"+"\n"+"下"+TradeInformationSell+"单选择按钮:否"+"\n","交易提示窗口",MB_YESNOCANCEL|MB_ICONWARNING);
      Print("返回信息:"+MsgBoxInfoBuy);
  
      if(MsgBoxInfoBuy == IDYES )    
      {
         LastOrderTick=OrderSend(Symbol(),OP_BUY,MyLots,Ask,huadian,Ask-SL,0,0,MyMagicNum,0,CLR_NONE);
         if(LastOrderTick==-1)
         {
            Print("出现错误:"+GetLastError());
         }
     
      }
      else if(MsgBoxInfoBuy == IDNO )
      {
         LastOrderTick=OrderSend(Symbol(),OP_SELL,MyLots,Bid,huadian,Bid+SL,0,0,MyMagicNum,0,CLR_NONE);
         if(LastOrderTick==-1)
         {
            Print("出现错误:"+GetLastError());
         }
      }
      else if(MsgBoxInfoBuy == IDCANCEL)
      {
         
         if( 购买方式==4 || 购买方式==5 )//Ask<收盘价格 && 购买方式==4, Ask>收盘价格 && 购买方式==5 
         {
            OrderSend(Symbol(),OP_BUYSTOP,MyLots,Ask+Inte,huadian,Ask+Inte-SL,0,0,MyMagicNum);
            OrderSend(Symbol(),OP_SELLSTOP,MyLots,Bid-Inte,huadian,Bid-Inte+SL,0,0,MyMagicNum);
         }
       }
       
   // 双向挂单测试
  //  OrderSend(Symbol(),OP_BUYSTOP,MyLots,myPrice_B,huadian,myPrice_B-TL,0,0,MyMagicNum,0,CLR_NONE);
  //  OrderSend(Symbol(),OP_SELLSTOP,MyLots,myPrice_S,huadian,myPrice_S+TL,0,0,MyMagicNum,0,CLR_NONE);
  //  成交单的测试
  //  OrderSend(Symbol(),OP_BUY,MyLots,Ask,huadian,Ask-SL,0,0,MyMagicNum,0,CLR_NONE);
   // OrderSend(Symbol(),OP_SELL,MyLots,Bid,huadian,Bid+TL,0,0,MyMagicNum,0,CLR_NONE);
  //------- 
   }
   else 
   {
      //....进行仓内单子的分析判断
      iShowInfo();
      if(BuyGroupOrders > 0 )
      {
         if(Ticket_SELLSTOP > 0 )//&& Ticket_BUY > 0  && OrderSymbol() == Symbol(),这在iShowInfo里已经满足了,这里就不用再重复了
         {
            OrderDelete(Ticket_SELLSTOP,CLR_NONE);
         }
            LastOrderTicket = Ticket_BUY;
      } 
      else if(SellGroupOrders > 0 )
      {
         if(Ticket_BUYSTOP > 0   )// && Ticket_SELL > 0 &&  OrderSymbol() == Symbol()
         {
            OrderDelete(Ticket_BUYSTOP,CLR_NONE); 
         }
            LastOrderTicket = Ticket_SELL;
      }
      
      if( OrderSelect( LastOrderTicket,SELECT_BY_TICKET,MODE_TRADES ) )//OrderProfit()
      {//Print("111");
             
          int  Ticket = -1;  
          if( OrderType() == OP_BUY && (Close[0] - OrderOpenPrice()) >= ProfitLimit && BuyGroupOrders < MaxOrders )    //盈利 顺势挂buy单    OrderProfit()&& MyCounts <=3 && !MslFlag
          {
               MyOrderLots = NormalizeDouble( OrderLots()*LotTimes,DigitsNum ); // 调整手数  
                        
               if( MyOrderLots > MaxLots )   
                      
                  return;
                  
               Ticket = OrderSend( Symbol(),OP_BUY,MyOrderLots,Ask,huadian,Bid-SL,0,0,MyMagicNum,0,CLR_NONE );//此单之止损，有时候会丢失
                
               if( Ticket == -1 )
               {
                  Print( "下单错误"+GetLastError() );
                  return;
               }  
               else
               {
                  MFlag = true;
             //     MyCounts +=1;                 
               }
                              
            }
            if( OrderType() == OP_SELL && (OrderOpenPrice()-Close[0]) >= ProfitLimit && SellGroupOrders <= MaxOrders )   //盈利 顺势挂sell单  OrderProfit()&& MyCounts <=3&& !MslFlag
             {
               MyOrderLots = NormalizeDouble( OrderLots()*LotTimes,DigitsNum ); // 调整手数  
                        
               if( MyOrderLots > MaxLots )          
               
                  return;
                  
               Ticket = OrderSend( Symbol(),OP_SELL,MyOrderLots,Bid,huadian,Bid+SL,0,0,MyMagicNum,0,CLR_NONE ); 
                
               if( Ticket == -1 )
               {
                  Print("下单错误"+GetLastError());
                  
                  return;
               } 
               else 
               {
                  MFlag = true;       //趋势下单成功 
               //   MyCounts +=1;
               }
                        
            }
            
         }
          iShowInfo();
          MSL(SL_OfAll);
          
         if(Profit >= MaxProfit || CloseAll)
         {//Print("平");Print("Profit :"+Profit);Print("MaxProfit :"+MaxProfit);
         //   Print(Profit);
         //  Print(MaxProfit);
            CloseAll();       
         }
   //---------
    }
   
//--------
   return(0);
 }
//+------------------------------------------------------------------+

void MSL( double SLC)
  {
      if( BuyGroupOrders + SellGroupOrders == 0 )
         return;     
      int pos = 0;
      double MySL = 0;
      int FristTicket = -1;
      int MDT = 0;
      bool MslFlag = false;
      double ModfySL = 0;
     
      for ( int cnt=0;cnt < OrdersTotal();cnt++ )//----0s修改集体止损
       {   
         if( OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() )//&& OrderMagicNumber()== MyMagicNum
         {      
            //--------1s修改集体止损，且为第一单的情况时
             pos += 1; 
             
             if( pos == 1  )
             {
                 MySL = OrderOpenPrice();
               
                 FristTicket = OrderTicket();
             }
            //------
            if( MySL != 0 && OrderType() == OP_BUY && Ask - MySL > MinMoveSLValue )//|| OrderType() == OP_BUY
            {
               MslFlag = true;
            }
            if( MySL != 0 && OrderType() == OP_SELL && Bid - MySL > MinMoveSLValue )//|| OrderType() == OP_BUY
            {
               MslFlag = true;
            }
            //------
            if( MFlag && !MslFlag && ( BuyGroupOrders > 2 || SellGroupOrders > 2 ) ) // 
            {
               
               if( OrderType() == OP_BUY && OrderStopLoss() < OpenPriceAve_B + SLC * BuyGroupOrders ) // SLC,点差的和
               {  
              
                  if( !OrderModify(OrderTicket(),OrderOpenPrice(),OpenPriceAve_B + SLC * BuyGroupOrders,0,0,CLR_NONE ) )// ttt8881
                   {
                     Print("修改多单止损失败"+GetLastError()+"Ask:"+Ask+",OpenPriceAve_B "+OpenPriceAve_B);
                   }                  
               }
               if( OrderType() == OP_SELL && OrderStopLoss() > OpenPriceAve_S - SLC * SellGroupOrders )// 
               {
                  if( !OrderModify( OrderTicket(),OrderOpenPrice(),OpenPriceAve_S - SLC * SellGroupOrders,0,0,CLR_NONE ) ) 
                  
                     Print("修改空单止损失败"+GetLastError()+"Bid:"+Bid+",OpenPriceAve_S "+OpenPriceAve_S );
                                      
               }
               
                //   MFlag = false;   
            }
            //------2s修改集体止损，且某一类型成交单总数为两单的情况时
            else if( MFlag && ( BuyGroupOrders == 2 || SellGroupOrders == 2 ) )
            {               
                  if( OrderType() == OP_BUY ) //
                  { 
                 /* pos += 1; 
                  if(pos == 1)
                  {
                     MySL = OrderOpenPrice();
                     FristTicket = OrderTicket();
                  }else*/
                  
                     if( pos == 2 && (OrderStopLoss()!=MySL || MDT < 2 ) )//MDT：限制每次加仓之后之进行一次的修改集体止损
                     {   
                       //  Print(OrderStopLoss());
                       //  Print(MySL);
                         MDT += 1;
                     
                        if( MDT == 1 && OrderStopLoss() == MySL)//第二单的止损等于第一单的开仓价时
                        { 
                            if(OrderModify( FristTicket,MySL,MySL,0,0,CLR_NONE )) //这里是修改的第一单的止损 
                              MFlag = false; 
                        }
                        else if(!( OrderModify( OrderTicket(),OrderOpenPrice(),MySL,0,0,CLR_NONE ) && OrderModify( FristTicket,MySL,MySL,0,0,CLR_NONE ) ) )//
                        { 
                              Print("修改多单止损失败"+GetLastError()+"Ask:"+Ask+",MySL "+MySL); 
                        } 
                        else
                            MFlag = false; 
                         
                    }                  
               }
               if( OrderType() == OP_SELL )//
               {
                /*  pos += 1; 
                  if(pos == 1)
                  {
                     MySL = OrderOpenPrice();
                     FristTicket = OrderTicket();
                  }else*/
                  if( pos == 2 && OrderStopLoss() != MySL || MDT < 2)// 
                  {  
                     MDT += 1;
                     
                     if( MDT == 1 && OrderStopLoss() == MySL )
                     {
                       if(OrderModify( FristTicket,MySL,MySL,0,0,CLR_NONE ))
                       
                           MFlag = false; 
                     } 
                     else if( !(OrderModify( OrderTicket(),OrderOpenPrice(),MySL,0,0,CLR_NONE ) && OrderModify( FristTicket,MySL,MySL,0,0,CLR_NONE ) ) ) 
                     {
                        Print("修改空单止损失败"+GetLastError()+"Bid:"+Bid+",MySL "+MySL); 
                     }
                     else
                          MFlag = false;
                  }        
                       
               }
                 //  MFlag = false;   
            }
             
            //------------3s进行止损位的移动
            if( MslFlag )
            {
               MoveSl();
               
               MslFlag = false;
            }
         }
      }
      return;    
}
//-------------------------------------------------------------------+

void MoveSl()
   {      
      for(int i =0; i < OrdersTotal(); i++)  
      {           
       
          if( OrderSelect(i, SELECT_BY_POS,MODE_TRADES) && OrderSymbol() == Symbol() )// && OrderMagicNumber() == MagicNum 
           {    
                             
                     if( OrderType()==OP_BUY && OrderProfit() > 0 )
                     {            
                       // if(Bid - OrderOpenPrice() > MinProfit * MyPoint)
                       // {                    
                            myTrallingStopPrice = Bid - TrallingStop;
                            
                           if( myTrallingStopPrice > OrderStopLoss() )//(OpenPriceAve_B + SL_OfAll)
                           {
                              //执行移动止损
                            //  iWait();
                              OrderModify( OrderTicket(),OrderOpenPrice(),myTrallingStopPrice,0,0,CLR_NONE );
                           }
                      
                       // }
                     }
          }
         if( OrderSelect(i, SELECT_BY_POS,MODE_TRADES) && OrderSymbol() == Symbol() )//&& OrderMagicNumber() == MagicNum
         {
        
                if( OrderType()==OP_SELL )
                {
                 // if(OrderOpenPrice() - Ask < MinProfit * MyPoint)
                 // {
                     myTrallingStopPrice = Ask + TrallingStop * MyPoint;
                     
                     if( myTrallingStopPrice < OrderStopLoss() )// (OpenPriceAve_B - SL_OfAll)这里怎么处理？
                     {
                        // iWait();
                         OrderModify( OrderTicket(),OrderOpenPrice(),myTrallingStopPrice,0,0,CLR_NONE );
                     }
                  //}
                }
             }
     } 
 //-----   
   return; 
   }
//-------------------------------------------------------------------+

bool CloseAll()//全部平仓
 {
   int j=0;
   int tick[200];   
   for( int i=0;i<OrdersTotal();i++ )
   {
      if( OrderSelect(i, SELECT_BY_POS, MODE_TRADES )&& OrderSymbol() == Symbol() )//&& OrderMagicNumber()==MagicNum
     // if(OrderSymbol() == Symbol())
      {
         j+=1;
         tick[j] = OrderTicket();      
      //Print("全部平仓！ :",tick[j]);    
      }
   }
   if ( j!=0 )
   {
      for( i=1;i <= j;i++ )
      {
         RefreshRates();
         OrderSelect( tick[i], SELECT_BY_TICKET );
         if( OrderType()==OP_BUY )
         { 
            if( OrderClose( OrderTicket(),OrderLots(),Bid,0 ) == false )
            {
               CloseAll = true;
               Print("多头平仓失败"+GetLastError());
            } 
         } 
         if( OrderType()==OP_SELL )
         {
            if( OrderClose(OrderTicket(),OrderLots(),Ask,0)==false )
            {
               CloseAll = true;
               Print("空头平仓失败"+GetLastError());
            } 
         } 
 
         if( OrderType()==OP_BUYSTOP )
         {
            if( OrderDelete(OrderTicket(),CLR_NONE)==false )
            {
               CloseAll=true;
               Print("多头挂单撤销失败"+GetLastError());
            } 
         } 
     
         if( OrderType()==OP_SELLSTOP )
         {
            if( OrderDelete(OrderTicket(),CLR_NONE)==false )
            {
               CloseAll=true;
               Print("空头挂单撤销失败"+GetLastError());
            } 
         }     
      }
   }
   return;
}
//-------------------------------------------------------------------+

void iShowInfo()
   {
      //初始化变量
    //  TZM=0;
      Profit = 0;
      OpenPriceSum_B = 0;
      OpenPriceSum_S = 0;
      OpenPriceAve_B = 0;
      OpenPriceAve_S = 0;
      Ticket_SELLSTOP =-1;//下面几个变量的初始化一定要在本函数中去做，保证每次遍历和统计信息时变量的纯洁性
      Ticket_BUYSTOP =-1;
      Ticket_BUY =-1;
      Ticket_SELL =-1;
    //  MAXTZM=0;
    //  HAND=0;
     // MAXTZM_B=0;
    //  HAND_B=0;
    //  MAXTZM_S=0;
     // HAND_S=0;
      BuyGroupOrders=0; SellGroupOrders=0; //买入、卖出组成交持仓单数量总计
      BuyStopOrders=0; SellStopOrders=0; //买入停止挂单、卖出停止挂单数量总计
    /*  BuyGroupFirstTicket=0; SellGroupFirstTicket=0; //买入、卖出组第一张订单单号
      BuyGroupLastTicket=0; SellGroupLastTicket=0; //买入、卖出组最后一张订单号
      BuyGroupMaxProfitTicket=0; SellGroupMaxProfitTicket=0; //买入、卖出组最大盈利单单号
      BuyGroupMinProfitTicket=0; SellGroupMinProfitTicket=0; //买入、卖出组最小盈利单单号
      BuyGroupMaxLossTicket=0; SellGroupMaxLossTicket=0; //买入、卖出组最大亏损单单号
      BuyGroupMinLossTicket=0; SellGroupMinLossTicket=0; //买入、卖出组最小亏损单单号
      BuyGroupLots=0; SellGroupLots=0; //买入、卖出组成交单持仓量
      BuyGroupProfit=0; SellGroupProfit=0; //买入、卖出组成交单利润
  //    BuyLimitOrders=0; SellLimitOrders=0; //买入限制挂单、卖出限制挂单数量总计*/
      //初始化订单数组
     // MyArrayRange = OrdersTotal() + 1;
     // ArrayResize(OrdersArray, MyArrayRange); //重新界定数组
     // ArrayInitialize(OrdersArray, 0.0); //初始化数组
    
      if (OrdersTotal()>0)
         {
           
            //遍历持仓单,创建数组
            for (int cnt=0; cnt<OrdersTotal(); cnt++)
               {
               //   iWait();
                  //选中当前货币对相关持仓订单
                  if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()== MyMagicNum)//
                  {   
                    //    TZM=TZM+1;
                        Profit += OrderProfit();
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
                           OpenPriceSum_B += OrderOpenPrice();
                          // MAXTZM_B = MAXTZM_B + (OrderOpenPrice()*OrderLots());
                          // HAND_B += OrderLots();
                           Ticket_BUY = OrderTicket();
             
                           BuyGroupOrders += 1; //买入组订单数量
                        }
                        if(OrderType() == OP_SELL)
                        {
                           OpenPriceSum_S += OrderOpenPrice();
                          // MAXTZM_S = MAXTZM_S + (OrderOpenPrice()*OrderLots());
                          // HAND_S += OrderLots();
                           Ticket_SELL = OrderTicket();
                          
                           SellGroupOrders += 1;
                        }
                        if(OrderType() == OP_BUYSTOP)
                        {
                           Ticket_BUYSTOP = OrderTicket();
                           BuyStopOrders += 1;
                         //  OpenPrice_BUYSTOP= OrderOpenPrice();
                        }
                        if(OrderType() == OP_SELLSTOP)
                        {
                           Ticket_SELLSTOP = OrderTicket();
                           SellStopOrders += 1;
                        //   OpenPrice_SELLSTOP= OrderOpenPrice();
                        }
                     
                  }
               }
               if(BuyGroupOrders != 0)
         
               OpenPriceAve_B = NormalizeDouble(OpenPriceSum_B/BuyGroupOrders,Digits);
            
               if(SellGroupOrders != 0)
         
               OpenPriceAve_S = NormalizeDouble(OpenPriceSum_S/SellGroupOrders,Digits);
            
             //  Print("pingjunjia"+OpenPriceAve_B);
         }
    
         
      return(0);
   }
//------------------------------------------------------------------------------------