//+------------------------------------------------------------------+
//|                                                     б���ж�.mq4 |
//|                            Copyright 2013, ���ǻ�������Ȩ����. |
//|                                       http://www.jinding9999.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, ���ǻ�������Ȩ����."
#property link      "http://www.jinding9999.com"

extern bool �Ƿ���ʾ�����͵� = true;
bool SFlag;
extern int �ߵ͵��ʱ������ = 7;
int MyPeriod; 
extern double �������� = 0;
double MorePrice;

extern double �������� = 0.1;
double MyLots2;
extern int ֹ����� = 30;
double SL;
extern int ֹӯ���� = 75;
double TP;
extern int huadian = 5;
extern int MyMagicNum = 201311051319;

extern int ��������������� = 3;
int MySLTimes;
extern int �����͵��ֵ���Ƶ��� = 30;
double HTCL;
extern int �ƶ�ֹ���ӯ���������� = 50;
double PL;


int i = 0;
datetime Mytime = 0;
double MyPoint;
int TZM;
double HAND_B,HAND_S;
int BuyGroupOrders, SellGroupOrders;
int MyArrayRange; //�����¼����

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
      if(Digits == 3 || Digits == 5)  MyPoint = Point / 0.1;  //Digits:��ǰ���ҶԵĻ���С��λ;Point:ͼ��ĵ�ֵ
      else MyPoint = Point;
      
      SFlag = �Ƿ���ʾ�����͵�;
      MyPeriod = �ߵ͵��ʱ������*60; 
      MorePrice = ��������*MyPoint;
      
      MyLots2 = ��������;
      SL = ֹ�����*MyPoint;
      TP = ֹӯ����*MyPoint;
      
      MySLTimes = ���������������;
      
      HTCL = �����͵��ֵ���Ƶ���*MyPoint;
      PL = �ƶ�ֹ���ӯ����������*MyPoint;
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
            { Print("�ҿ�");
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
            {Print("�Ҷ�");                      
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
     // Print("myStartHour ��"+myStartHour);
      if(myStartHour-LastStarHour >= MyPeriod*60)
      {//Print("myStartHour ��"+myStartHour);Print("LastStarHour :"+LastStarHour);
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
            MyPointText("�ߵ�",i,iTime(NULL,0,myHightBar),GetHigh);//,i
            MyPointText("�͵�",i,iTime(NULL,0,myLowBar),GetLow);
         }
     }
     return;
   }

//-----------------------------------------------------------------------------------------------------

void MyPointText(string MyPointPreName,int MyBarPos,datetime MyPointTime,double MyPointPrice)//,int MyPointNum
{
   string MyPointName = MyPointPreName + DoubleToStr(MyBarPos,0);
   ObjectCreate(MyPointName,OBJ_TEXT,0,MyPointTime,MyPointPrice);
   ObjectSetText(MyPointName,MyPointPreName,11,"����",White);//+DoubleToStr(MyPointNum,0)
}
//---------------------------------------------------------------------------------------------------+
//�ж�������������Ƿ����N

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
��    ������ʾ������Ϣ
���������
���������
��    ����
*/

void iShowInfo()
   {
      //��ʼ������
      TZM=0;
    //  MAXTZM=0;
    //  HAND=0;
     // MAXTZM_B=0;
    //  HAND_B=0;
    //  MAXTZM_S=0;
     // HAND_S=0;
      BuyGroupOrders=0; SellGroupOrders=0; //���롢������ɽ��ֲֵ������ܼ�
    /*  BuyGroupFirstTicket=0; SellGroupFirstTicket=0; //���롢�������һ�Ŷ�������
      BuyGroupLastTicket=0; SellGroupLastTicket=0; //���롢���������һ�Ŷ�����
      BuyGroupMaxProfitTicket=0; SellGroupMaxProfitTicket=0; //���롢���������ӯ��������
      BuyGroupMinProfitTicket=0; SellGroupMinProfitTicket=0; //���롢��������Сӯ��������
      BuyGroupMaxLossTicket=0; SellGroupMaxLossTicket=0; //���롢�����������𵥵���
      BuyGroupMinLossTicket=0; SellGroupMinLossTicket=0; //���롢��������С���𵥵���
      BuyGroupLots=0; SellGroupLots=0; //���롢������ɽ����ֲ���
      BuyGroupProfit=0; SellGroupProfit=0; //���롢������ɽ�������
  //    BuyLimitOrders=0; SellLimitOrders=0; //�������ƹҵ����������ƹҵ������ܼ�
      BuyStopOrders=0; SellStopOrders=0; //����ֹͣ�ҵ�������ֹͣ�ҵ������ܼ�
   */   //��ʼ����������
    //  MyArrayRange = OrdersTotal() + 1;
     // ArrayResize(OrdersArray, MyArrayRange); //���½綨����
     // ArrayInitialize(OrdersArray, 0.0); //��ʼ������
      if (OrdersTotal()>0)
         {
            //�����ֲֵ�,��������
            for (int cnt=0; cnt< OrdersTotal(); cnt++)
               {
                  //iWait();
                  //ѡ�е�ǰ���Ҷ���سֲֶ���
                  if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()== MyMagicNum)
                  {   
                        TZM=TZM+1;
                     /*   OrdersArray[cnt][0]=OrderTicket();//0������
                        OrdersArray[cnt][1]=OrderOpenTime();//1����ʱ��
                        OrdersArray[cnt][2]=OrderProfit();//2��������
                        OrdersArray[cnt][3]=OrderType();//3��������
                        OrdersArray[cnt][4]=OrderLots();//4������
                        HAND =HAND+OrderLots();
                        OrdersArray[cnt][5]=OrderOpenPrice();//5���ּ�
                        MAXTZM=MAXTZM+(OrderOpenPrice()*OrderLots());
                        OrdersArray[cnt][6]=OrderStopLoss();//6ֹ���
                        OrdersArray[cnt][7]=OrderTakeProfit();//7ֹӮ��
                        OrdersArray[cnt][8]=OrderMagicNumber();//8����������
                        OrdersArray[cnt][9]=OrderCommission();//9����Ӷ��
                        OrdersArray[cnt][10]=OrderSwap();//10����
                        OrdersArray[cnt][11]=OrderExpiration();//11�ҵ���Ч���� */
                        if(OrderType() == OP_BUY)
                        {
                          // MAXTZM_B = MAXTZM_B + (OrderOpenPrice()*OrderLots());
                         //  HAND_B += OrderLots();
                           BuyGroupOrders += 1; //�����鶩������
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

