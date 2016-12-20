//+------------------------------------------------------------------+
//|                           混沌理论之鳄鱼系统改进调整预案1230.mq4 |
//|                                Copyright 2013, 智汇量化版权所有. |
//|                                       http://www.jinding9999.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, 智汇量化版权所有."
#property link      "http://www.jinding9999.com"
#include <WinUser32.mqh>

extern int SL = 20;
//extern int TP = 50;
extern double Lots = 0.1;
int huadian = 5;
extern int MyMagicNum = 2013123001;

int MyOrdersTotal = 0,MyLossOrders_D = 0;//MyOrdersTotal_Q = 0,MyOrdersTotal_2,MyOrdersTotal_D = 0,,
double MyPoint;
static double  myLips, myTeeth, myJaw,myLips1,myTeeth1;
bool CFlag = false;
double MinLots,CloseLots;
double MSLV0,MSLV1,SLD,MinMSL;
datetime LastOpenTime,LastOpenTime2,LastOpenTimeD,LastLossTime;
int MPoint0 = 0,MPoint1 = 0;
int CBD = 0,CBD_S = 0;
double MainBands = 0;
double MyLots = 0;
double STLEV;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
      if(Digits == 2 || Digits == 3 || Digits == 5)  MyPoint = Point / 0.1;  //Digits:当前货币对的汇率小数位;Point:图表的点值
      else MyPoint = Point;
      MinLots = MarketInfo(Symbol(),MODE_MINLOT);
      STLEV = MarketInfo(Symbol(),MODE_STOPLEVEL);
      Print("MinLots  "+MinLots);
     
         MPoint0 = 80;
         MPoint1 = 120;
         MSLV0 = 20*MyPoint;
         MSLV1 = 15*MyPoint;
         SLD = SL*MyPoint;
         MinMSL = 15*MyPoint;
      
      LastOpenTime = Time[9];
     
      LastOpenTimeD = Time[9];
      LastLossTime = Time[9];
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
      iMain();
//----
   return(0);
  }
//+------------------------------------------------------------------+

void iMain()
{
   Info();
   OrderOpen(); 
   CloseOrMdfOrders();
  //OrdersDD();
   return;
}

void Info()
{
   //Profit = 0;
   MyOrdersTotal = 0;
   //MyOrdersTotal_Q = 0;
  // MyOrdersTotal_D = 0;
  // MyOrdersTotal_2 = 0;
   MyLossOrders_D = 0;
   datetime GetLossTime;
   for (int i=0;i<OrdersTotal();i++)  
  {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()==MyMagicNum)
      {
       //  Profit += OrderProfit();
         MyOrdersTotal += 1;
     /*    if(StringFind(OrderComment(),"Trend",0) >= 0)
            MyOrdersTotal_Q += 1;
         if(StringFind(OrderComment(),"开仓2",0) >= 0)
            MyOrdersTotal_2 += 1;
         if(StringFind(OrderComment(),"DingDi",0) >= 0)
            MyOrdersTotal_D += 1;*/
      }
  }
  for(i=OrdersHistoryTotal()-1;i>OrdersHistoryTotal()-3;i--)
  {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) && OrderSymbol()==Symbol() && OrderMagicNumber()==MyMagicNum)
      {
       //  Profit += OrderProfit();
         /*if(StringFind(OrderComment(),"DingDi",0) >= 0)
         {
            if(OrderProfit()<0)
              MyLossOrders_D += 1; 
            if(MyLossOrders_D == 1)
               GetLossTime = OrderCloseTime();
         }
         if(MyLossOrders_D == 2)
         {
            LastLossTime = GetLossTime;
         }*/
      }
  }
  return;
}

//-----------------------------------------------------------------------------+
//-----------------------------------------------------------------------------------------------------------------------------------------------------+

void OrderOpen()
{
   MainBands = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0);
   CBD = NormalizeDouble((Close[0] - MainBands)/MyPoint,0);
   CBD_S = NormalizeDouble((MainBands - Close[0])/MyPoint,0);
   if(CBD > MPoint0)
      MyLots = NormalizeDouble(0.5*Lots,2);  
   else 
      MyLots = Lots;      
   if(MyLots < MinLots)
   {
      MyLots = MinLots;
   }
   // Print(MyOrdersTotal_Q);
   if(MyOrdersTotal < 6 && iBarShift(Symbol(),0,LastOpenTime,true) >= 1)
   {
      //FUNAlSignal(1)==1 &&&& FUNGatorSignal(1)==1
      // 
      if((FUNAoSignal(1)==1 || FUNAoSignal(4)==6) && FUNAcSignal(1)==1 && FUNFrSignal()==1 && FUNKLineSignal(1)==1 && FUNBollSignal()==1 )//MyOrdersTotal==0 && MyLossOrders < 2 
      {  Print("趋势B"); 
         LastOpenTime = Time[0];
        // CHFlaged = false;       
         OrderSend(Symbol(),OP_BUY,MyLots,Ask,5,Ask-SLD,0,"Trend",MyMagicNum,0,CLR_NONE);//Ask+TP*MyPoint  myJaw
      }
  /*    
       //FUNAlSignal(1)==2 &&  && FUNGatorSignal(1)==1
      if(FUNAoSignal(1)==2 || FUNAoSignal(4)==5 && FUNAcSignal(1)==1 && FUNFrSignal()==2 && FUNKLineSignal(1)==2 && FUNBollSignal()==1 )//MyOrdersTotal==0 && MyLossOrders < 2  【漏Boll- Signal】
      {  Print("趋势S"); 
         LastOpenTime = Time[0];
        
         if(myJaw-Ask<STLEV*Point)
         {myTeeth=Ask+STLEV*Point;}
         else if(myTeeth - Close[0] > SLD)
         {
            myTeeth = Close[0] + SLD;
         } 
         OrderSend(Symbol(),OP_SELL,MyLots,Bid,5,myTeeth,0,"Trend",MyMagicNum,0,CLR_NONE);//Ask+TP*MyPoint
      }
   */   
   }   
   return;
} 


//鳄鱼线的排列信号   
int FUNAlSignal(int TypeNum)
   {  int myAlSignal=0;
     // FPSMMA=  iMA(Symbol(),0,5,1,MODE_SMMA,PRICE_WEIGHTED,0);//PRICE_WEIGHTED 6 Weighted close price, (high+low+close+close)/4. 
      myLips = iAlligator(Symbol(),0,13, 0, 8, 0, 5, 0,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,1);
      myTeeth = iAlligator(Symbol(),0, 13, 0, 8, 0, 5, 0,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,1);
      myJaw = iAlligator(Symbol(),0, 13, 0, 8, 0, 5, 0,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,1);//13,8,8,5,5,4,
      myLips1 = iAlligator(Symbol(),0,13, 0, 8, 0, 5, 0,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,2);
      myTeeth1 = iAlligator(Symbol(),0, 13, 0, 8, 0, 5, 0,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,2);
      if(TypeNum == 1)
      {
         if(myLips>myTeeth)// && myTheeth>myJaw&& myTheeth>myJawFPSMMA>myLips &&   && iClose(NULL,0,1)>myTheeth  
         {
            myAlSignal=1;         
         }
         if(myLips<myTeeth)//&& myTheeth<myJaw  FPSMMA<myLips &&    && iClose(NULL,0,1)<myTheeth  
         { 
            myAlSignal=2;         
         }
     }
      if(TypeNum == 2)
      {
         if(myLips>myTeeth && myTeeth>myJaw)// && myTheeth>myJawFPSMMA>myLips &&   && iClose(NULL,0,1)>myTheeth  
         {
            myAlSignal=3;         
         }
         if(myLips<myTeeth && myTeeth<myJaw)//  FPSMMA<myLips &&    && iClose(NULL,0,1)<myTheeth  
         { 
            myAlSignal=4;         
         }
      } 
      if(TypeNum == 3)//死叉
      {
         if(myLips < myTeeth && myLips1 > myTeeth1)
            myAlSignal = 5;
         if(myLips > myTeeth && myLips1 < myTeeth1)
            myAlSignal = 6;
      }
      if(TypeNum == 4)
      {
         if(Close[1]< myTeeth)
            myAlSignal = 1;
         if(Close[1] > myTeeth)
            myAlSignal = 2;
      }
      return(myAlSignal);
   }
   
   //AO  
int FUNAoSignal(int TypeNum)
   {  double AOD,AO1 = 0.0,AO2,AO3;
      int    myAoSignal = 0;     
      AO1 = iAO(Symbol(),0,0);
      AO2 = iAO(Symbol(),0,1);
      AO3 = iAO(Symbol(),0,2);
      AOD = AO1 - AO2;
      if(TypeNum == 1)
      {
         if(AOD>0 && AO1>0)      {  myAoSignal=1;     }
         if(AOD<0 && AO1<0)      {  myAoSignal=2;     }
      }
      if(TypeNum == 2)
      {       
         if(AO3 > AO2 && AO2 < AO1 && AO2 > 0)
         {
            myAoSignal = 3;
         } 
         if(AO3 < AO2 && AO2 > AO1 && AO2 < 0)
         {
            myAoSignal = 4;
         }        
      }
      if(TypeNum == 3)
      {
         if(AO1<0)
         {
            myAoSignal = 4;
         }
         if(AO1>0)
         {
            myAoSignal = 2;
         }
      }
      if(TypeNum == 4)
      {
         if(AOD<0 && AO1>0)      
         {  myAoSignal=5;     }
         if(AOD>0 && AO1<0)      
         {  myAoSignal=6;     }
      }
      if(TypeNum == 5)
      {
         if(AOD<0 && AO1-AO2<0)      
         {  myAoSignal=1;     }
         if(AOD>0 && AO1-AO2>0)      
         {  myAoSignal=2;     }
      }
      return(myAoSignal);
   }
//AC   
int FUNAcSignal(int TypeNum)
   { double ACD,AC1 = 0.0,dd=0;
     int    myAcSignal = 0;
     ACD=iAC(Symbol(),0,0)-iAC(Symbol(),0,1);
     AC1=iAC(Symbol(),0,0);
     if(TypeNum == 1)
     {
        if(ACD>0 && AC1>0)       {  myAcSignal=1;    }         
        if(ACD<0 && AC1<0)       {  myAcSignal=2;    }
     }
     if(TypeNum == 3)
     {
         if(Symbol() != "XAUUSD")
         {
            dd = 0.0005;
         }   
         else
         {
            dd = 2;
         }
        if(ACD<0 && MathAbs(AC1)>dd && Close[0]<Close[1]) 
        {
            myAcSignal=3;
        }
     }
     if(TypeNum == 4)
     {
         if(ACD>0)
            myAcSignal=4;
         if(ACD<0)
            myAcSignal=5;
     }
     return(myAcSignal);
   }
//iGator
/*
int FUNGatorSignal(int TypeNum)
{
   int myGaSignal = 0;
   double jaw_val = iGator(NULL, 0, 13, 0, 8, 0, 5, 0, MODE_SMMA, PRICE_MEDIAN, MODE_UPPER, 0);
   double lip_val = iGator(NULL, 0, 13, 0, 8, 0, 5, 0, MODE_SMMA, PRICE_MEDIAN, MODE_LOWER, 0);
   double jaw_valpre= iGator(NULL, 0, 13, 0, 8, 0, 5, 0, MODE_SMMA, PRICE_MEDIAN, MODE_UPPER,1);
   double lip_valpre = iGator(NULL, 0, 13, 0, 8, 0, 5, 0, MODE_SMMA, PRICE_MEDIAN, MODE_LOWER,1);//0, 13, 8, 8, 5, 5, 3,
 //  Print("jaw_val"+jaw_val+"lip_valpre"+lip_valpre);
 if(TypeNum == 1)
 {
   if((jaw_val>jaw_valpre && lip_val<lip_valpre) || (jaw_val<jaw_valpre && lip_val<lip_valpre && jaw_val<MathAbs(lip_val)))
   {
      myGaSignal = 1;
   }
   if(jaw_val<jaw_valpre && lip_val>lip_valpre )//&& jaw_val>MathAbs(lip_val)
   {
      myGaSignal = 2;
   }
  }
  if(TypeNum == 2)
  {
      if(jaw_val>jaw_valpre && lip_val<lip_valpre)
      {
         myGaSignal = 3;
      }
  }
  //Gator,上绿下红 且下绿大于上红 或 上下皆红。且上下柱的绝对值之和大于0.01[黄金3]
  if(TypeNum == 3)
  {   double GatorD;
      if(Symbol() == "XAUUSD")
      {
         GatorD = 3;
      }
      else
      {
         GatorD = 0.001;
      }
      if(lip_val>lip_valpre && jaw_val-lip_val>GatorD)
      {
         myGaSignal = 4;
      }
  }
   return(myGaSignal);
}
*/
//鳄鱼,取碎形中离现在最近的高低点和其左边的一Bar 的高低点  
int FUNFrSignal()
   { double PreFrac_up,HLowest,HLower,PreFrac_down,LHighest,LHigher,ARange;
     int    i=0,PreFrac_upIndex,HLowestIndex,HLowerIndex,m=0,PreFrac_downIndex,LHighestIndex,LHigherIndex,myFrSignal;
   //  double FrSMMA=  iMA(Symbol(),0,5,1,MODE_SMMA,PRICE_WEIGHTED,0);
       while(PreFrac_up==0)                               
       {   
           PreFrac_up=iFractals(Symbol(),0,MODE_UPPER,i);
           PreFrac_upIndex=i;
           i++;
       }
     HLowestIndex=ArrayMinimum(High,PreFrac_upIndex,0);
     HLowest     =High[HLowestIndex]; 
     HLower      =High[HLowestIndex+1];
     HLowerIndex =HLowestIndex+1; 
     while(PreFrac_down==0) 
      {  
         PreFrac_down=iFractals(Symbol(),0,MODE_LOWER,m);
         PreFrac_downIndex=m;
          m++;
      }
     LHighestIndex=ArrayMaximum(Low,PreFrac_downIndex,0);
     LHighest     =Low[LHighestIndex];
     LHigher      =Low[LHighestIndex+1];
     LHigherIndex =LHighestIndex+1;
     if(Symbol() != "XAUUSD")
      {  ARange = 30*MyPoint;}
     else
     {  ARange = 50*MyPoint; }
     
     for(i=1;i<4;i++)
     {
         if(High[i]>PreFrac_up)
         {
            PreFrac_up = High[i];
         }
     }
     for(i=1;i<4;i++)
     {
         if(Low[i]<PreFrac_down)
         {
            PreFrac_down = Low[i];
         }
     }
     if(Close[0]>PreFrac_up )//|| (PreFrac_up - HLower) > ARange
    // if(PreFrac_up>myTheeth && iClose(Symbol(),0,m-1)>myJaw && (iHigh(Symbol(),0,1)>HLower || iHigh(Symbol(),0,1)>PreFrac_up)) 
       { myFrSignal=1;     }
       
     if(Close[0]<PreFrac_down )//|| (LHigher-PreFrac_down) > ARange
     { myFrSignal=2;     }
     return(myFrSignal);
   }

//K线形态的排列
int FUNKLineSignal(int TypeNum)
  {  int    myKlSignal=0;
      double BandsSignal=iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_MAIN,0);
      //double BandSignalUp1 = iBands(NULL,0,20,1,0,PRICE_CLOSE,MODE_UPPER,0);
      if(TypeNum == 1)
      {
         if (Close[0]>BandsSignal && ((Close[1]<Open[1] && Close[0]>Open[1]) ||(Close[1]>Open[1] && Close[0]>Close[1]))) 
         { myKlSignal=1;          }
         if (Close[0]<BandsSignal && ((Close[1]<Open[1] && Close[0]<Close[1])||(Close[1]>Open[1] && Close[0]<Open[1] ))) // && iHigh(Symbol(),0,1)<TrendSignal  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         { myKlSignal=2;          }
      }
      if(TypeNum == 2)
      {
         if (Close[0] > BandsSignal && Close[0] < Low[1])//((Close[1]<Open[1] && Close[0]<Close[1])||(Close[1]>Open[1] && Close[0]<Open[1])) 
         { myKlSignal=1;          }
         if (Close[0] < BandsSignal && Close[0] > High[1])//((Close[1]<Open[1] && Close[0]<Close[1])||(Close[1]>Open[1] && Close[0]<Open[1])) 
         { myKlSignal=2;          }
      }
      if(TypeNum == 3)//    CHOSE THE BEST ONE FOR CLOSEORDERS !!!!!!!!!!!!!!!!!!!!!
      {//Close[0] < Low[iLowest(NULL,0,MODE_LOW,2,1)]
         if (Close[0]<Low[1])//((Close[1]<Open[1] && Close[0]<Close[1])||(Close[1]>Open[1] && Close[0]<Open[1])) 
         { myKlSignal=1;          }
         if (Close[0] > High[iHighest(NULL,0,MODE_HIGH,2,1)])//((Close[1]<Open[1] && Close[0]<Close[1])||(Close[1]>Open[1] && Close[0]<Open[1])) 
         { myKlSignal=2;          }
      }
      return(myKlSignal);
  }  
    //布林带限定信号
int FUNBollSignal()
  { int myBoSignal=0;
     double BandSignalUp0  = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,0);
     double BandSignalLow0 = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,0);
     double BandSignalUp2  = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_UPPER,2);
     double BandSignalLow2 = iBands(NULL,0,20,2,0,PRICE_CLOSE,MODE_LOWER,2);
        if(BandSignalUp0-BandSignalLow0 > BandSignalUp2-BandSignalLow2) 
        { myBoSignal=1;}
        if(BandSignalUp0-BandSignalLow0 < BandSignalUp2-BandSignalLow2) 
        { myBoSignal=2;}
     return(myBoSignal);   
  }
  
//+-------------------------------------------------------------------------------------------------------------+
   void CloseOrMdfOrders()
   {
      if(MyOrdersTotal==0)
         return;//||  FUNAoSignal(5)==1

         if(MyOrdersTotal >= 3 && (FUNKLineSignal(3)==1 || FUNAlSignal(4) == 1))// FUNAoSignal(1)==2    || (FUNAcSignal(4)==5 && FUNGatorSignal(1)==2 && FUNAoSignal(4)==5)  || CFlag    
         {
            CloseAll(OP_BUY);
         }
         //SELL        FUNAoSignal(5)==2 
         else if(MyOrdersTotal >= 3 && (FUNKLineSignal(3)==2 || FUNAlSignal(4) == 2))// || FUNAoSignal(1)==1   || (FUNAcSignal(4)==4 && FUNGatorSignal(1)==2 && FUNAoSignal(4)==6)  || CFlag  
         {
            CloseAll(OP_SELL);
         }
  //-------------------------------------------改为点移动都      ！！！！！！！！！！！！！！！！！！！！！！！！！！
         else                                //按 成交 单数 情况，进行分级 点移动 ，不允许赚钱的单子赔钱出。
         {                                   // 出场条件需再细加斟酌
            MoveSL_P(SLD);  //共同点移动，最近1单未盈利一定额度下（先上后下再上就移动了？不同步，，），不能进行全部的 共同点移动止损跟进！！     
         }
      return;
   }
   
   //全平
void CloseAll(int CType)
{
   if(OrdersTotal() == 0)
      return;
  // CFlag = false;
   for (int cnt=0;cnt<= OrdersTotal();cnt++)
   {
      if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()== MyMagicNum)
      {Print("Close"+ OrderTicket()+OrderType());  
         iWait();
        // if(StringFind(OrderComment(),"DingDi",0) < 0)//
      //   {
            if(CType == OrderType())//CType == OP_BUY && OrderType() == OP_BUY
            {    Print("平仓Buy"+ OrderTicket()); 
               iWait();      
               if(!OrderClose(OrderTicket(),OrderLots(),Close[0],huadian,CLR_NONE))
               {
                  //CFlag = true;
                  Print("平仓失败"+ OrderTicket());
               }  
            }
            if(CType == OP_SELL && OrderType() == OP_SELL)
            {
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,huadian,CLR_NONE))
               {
                 // CFlag = true;
                  Print("平仓失败"+ OrderTicket());
               }  
            }
        // }
      }
   } 
   return;  
}

//------------------------------------------------------

void MoveSL_P(double MinSLD)
   {
      if(OrdersTotal() == 0)
         return;
      for(int cnt=0;cnt< OrdersTotal();cnt++)
      {
         if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()== MyMagicNum)
         {
            //Print("C "+(Close[0] - OrderOpenPrice()));
            //Print("P "+OrderProfit());
           // if(StringFind(OrderComment(),"DingDi",0) < 0)
           // {
               if(OrderType() == OP_BUY   && OrderStopLoss() < Close[0]- MinSLD)//30*MyPoint  && Bid-OrderOpenPrice()>=MinSLD
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Close[0] - MinSLD,0,0,CLR_NONE);
               }
               if(OrderType() == OP_SELL  && OrderStopLoss() > Close[0]+ MinSLD)//30*MyPoint  && OrderOpenPrice()-Ask>=MinSLD
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Close[0] + MinSLD,0,0,CLR_NONE);
               }
           // }
         }
      }
      return;       
   }
//-------------------------------------------------------------------------------------------------------//+
/*
多头条件下顶部开空仓
开仓条件：3条鳄鱼线多头排列。唇>牙>鄂
　　　　　AO[0]>0,颜色为红
　　　　　AC[0]<0,为红柱.
　　　　　Gator,上绿下红 或 上下皆红。且上下柱的绝对值之和大于0.01。【黄金3】
　　　　　K线，大于中轨 && 小于前一根K线最低价                   
　　　　　Boll，现K线位置布林带上轨与下轨差，小于前第二根K线的上轨与下轨差
　　　　　
平仓条件：跟进止损，止损出场。
*/
  /* void OrdersDD()
   {
      double iSL = 0,MSL_D = 0;
      if(Symbol()== "XAUUSD")
      {
            iSL = 50*MyPoint;
            MSL_D = 40*MyPoint;
      }
      else
      {
         iSL = 30*MyPoint;//30
         MSL_D = 20*MyPoint;//20
           /* if(Symbol()== "USDJPY")
            {
               MSL_D = 10*MyPoint;
            }*/
    //  }
    
   /*   if(MyOrdersTotal_D == 0 && iBarShift(Symbol(),0,LastOpenTimeD,true)>2 && iBarShift(Symbol(),0,LastLossTime,true)>3)
      {
         if(FUNAlSignal(2) == 3 && FUNAoSignal(4)==5 && FUNAcSignal(1)==2 && FUNGatorSignal(3) == 4 && FUNKLineSignal(2)==1 && FUNBollSignal() == 2)
         {Print("顶底S");
            LastOpenTimeD = Time[0];
         
            Print("MSL_D :"+MSL_D);
            OrderSend(Symbol(),OP_SELL,Lots,Bid,5,Ask+iSL,0,"DingDi",MyMagicNum,0,CLR_NONE);//
         }
         if(FUNAlSignal(2) == 4 && FUNAoSignal(4)==6 && FUNAcSignal(1)==1 && FUNGatorSignal(3) == 4 && FUNKLineSignal(2)==2 && FUNBollSignal() == 2)
         {Print("顶底B");
            LastOpenTimeD = Time[0];
            OrderSend(Symbol(),OP_BUY,Lots,Ask,5,Bid-iSL,0,"DingDi",MyMagicNum,0,CLR_NONE);//
         }
      }
     // Print("MSL_D :"+MSL_D);
      MoveSL_D(MSL_D,MSL_D,"DingDi");
      return;
   }*/
//-----------------------------------------------------------------------------
 /*  
 void MoveSL_D(double MinPL,double MSLD,string iComment)
 {  
    if(OrdersTotal() == 0)
         return;
   for(int cnt=0;cnt< OrdersTotal();cnt++)
   {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()== MyMagicNum)
      {
            //Print("C "+(Close[0] - OrderOpenPrice()));
            //Print("P "+OrderProfit());
         if(StringFind(OrderComment(),iComment,0) >= 0)
         {
            if(OrderType() == OP_BUY)
            {
               //
               if(Close[0] - OrderOpenPrice() >= MinPL && Close[0] - OrderStopLoss() >= 2*MSLD)//30*MyPoint
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Close[0] - MSLD,OrderTakeProfit(),0,CLR_NONE);
               }
               
            }
            if(OrderType() == OP_SELL)
            {
               if((OrderOpenPrice() - Close[0] >= MinPL) && OrderStopLoss() - Close[0] >= 2*MSLD)//30*MyPoint
               {
                  OrderModify(OrderTicket(),OrderOpenPrice(),Close[0] + MSLD,OrderTakeProfit(),0,CLR_NONE);
               }
            }
         }
      }
   }
   return;    
}*/
 
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
 

