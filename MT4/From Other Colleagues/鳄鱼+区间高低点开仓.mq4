//+------------------------------------------------------------------+
//|                                                     б���ж�.mq4 |
//|                            Copyright 2013, ���ǻ�������Ȩ����. |
//|                                       http://www.jinding9999.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, ���ǻ�������Ȩ����."
#property link      "http://www.jinding9999.com"
extern string str0 = "----------����˯���жϲ���---------";
extern int б������Bar = 20;
int BarNum;
extern int �ֿ� = 2;
int Count;
extern double �ٽ���б�� = 8;
double LimitAngle;


extern string str1 = "--------���������͵����-------";
extern bool �Ƿ���ʾ�����͵� = true;
bool SFlag;
extern int �ߵ͵��ʱ������ = 4;
int MyPeriod; 
extern double �������� = 10;
double MorePrice;

extern string str2 = "----------���ֲ���---------";
extern double �������� = 0.1;
double MyLots2;
extern int ֹ����� = 30;
double SL;
extern int ֹӯ���� = 50;
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
int MyArrayRange; //�����¼����

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
      if(Digits == 3 || Digits == 5)  MyPoint = Point / 0.1;  //Digits:��ǰ���ҶԵĻ���С��λ;Point:ͼ��ĵ�ֵ
      else MyPoint = Point;
      
      BarNum = б������Bar;
      Count = �ֿ�;
      LimitAngle = �ٽ���б��;
      
      SFlag = �Ƿ���ʾ�����͵�;
      MyPeriod = �ߵ͵��ʱ������*60; 
      MorePrice = ��������*MyPoint;
      
      MyLots2 = ��������;
      SL = ֹ�����*MyPoint;
      TP = ֹӯ����*MyPoint;
      //HLPriode = �����͵�����;
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
         if(MyShape() == 1)//MathAbs(MyAngle) < LimitAngle //��˯��
         {
            Mytime = Time[0];
            i += 1;
            MyPointText("��˯��",i,Time[0],LipsVal);//,i
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
//�ߵ͵㿪��λ��

   void GetHL()
   {
      int MyBars = NormalizeDouble(MyPeriod/Period(),0);
      //Print("MyBars :"+MyBars);
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
         if(SFlag)
         {     
            MyPointText("�ߵ�",i,iTime(NULL,0,myHightBar),GetHigh);//,i
            MyPointText("�͵�",i,iTime(NULL,0,myLowBar),GetLow);
         }
      }
      return;
   }

//+------------------------------------------------------------------+
//Ѱ����̬����
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
��    ��:����б��
�������:myLctY0:������1
         myLctY1:������2 
         myLctX01:�������ֵ      
�������:������б�Ƕ�ֵ����λ���ȣ�
��    ����
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
   ObjectSetText(MyPointName,MyPointPreName,11,"����",White);//+DoubleToStr(MyPointNum,0)
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
      HAND_B=0;
    //  MAXTZM_S=0;
      HAND_S=0;
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
      MyArrayRange = OrdersTotal() + 1;
     // ArrayResize(OrdersArray, MyArrayRange); //���½綨����
     // ArrayInitialize(OrdersArray, 0.0); //��ʼ������
      if (OrdersTotal()>0)
         {
            //�����ֲֵ�,��������
            for (int cnt=0; cnt<=MyArrayRange; cnt++)
               {
                  iWait();
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
                           HAND_B += OrderLots();
                           BuyGroupOrders += 1; //�����鶩������
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
            //ͳ�ƻ�����Ϣ
          /*  for (cnt=0; cnt<MyArrayRange; cnt++)
               {
                  //����ֲֵ�
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUY)
                     {
                        BuyGroupOrders=BuyGroupOrders+1; //�����鶩������
                      //  BuyGroupLots=BuyGroupLots+OrdersArray[cnt][4]; //�����鿪����
                       // BuyGroupProfit=BuyGroupProfit+OrdersArray[cnt][2]; //����������
                     }
                  //�����ֲֵ�
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELL)
                     {
                        SellGroupOrders=SellGroupOrders+1; //�����鶩������
                       // SellGroupLots=SellGroupLots+OrdersArray[cnt][4]; //�����鿪����
                       // SellGroupProfit=SellGroupProfit+OrdersArray[cnt][2]; //����������
                     }*/
                  //���������ƹҵ��ܼ�
               //   if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYLIMIT) BuyLimitOrders=BuyLimitOrders+1;
                  //���������ƹҵ��ܼ�
 /*                 if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLLIMIT) SellLimitOrders=SellLimitOrders+1;
                  //������ֹͣ�ҵ��ܼ�
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYSTOP) BuyStopOrders=BuyStopOrders+1;
                  //������ֹͣ�ҵ��ܼ�
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLSTOP) SellStopOrders=SellStopOrders+1;
               }
            //����������������β����
            BuyGroupFirstTicket=iOrderSortTicket(0,0,1); //�������1������
            SellGroupFirstTicket=iOrderSortTicket(1,0,1); //�������1������
            BuyGroupLastTicket=iOrderSortTicket(0,0,0); //���������1������
            SellGroupLastTicket=iOrderSortTicket(1,0,0); //���������1������
            
            BuyGroupMinProfitTicket=iOrderSortTicket(0,1,1); //��������Сӯ��������
            SellGroupMinProfitTicket=iOrderSortTicket(1,1,1); //��������Сӯ��������
            BuyGroupMaxProfitTicket=iOrderSortTicket(0,1,0); //���������ӯ��������
            SellGroupMaxProfitTicket=iOrderSortTicket(1,1,0); //���������ӯ��������
            BuyGroupMaxLossTicket=iOrderSortTicket(0,2,0); //�����������𵥵���
            SellGroupMaxLossTicket=iOrderSortTicket(1,2,0); //�����������𵥵���
            BuyGroupMinLossTicket=iOrderSortTicket(0,2,1); //��������С���𵥵���
            SellGroupMinLossTicket=iOrderSortTicket(1,2,1); //��������С���𵥵���*/
         }
      //��ʾ������Ϣ
   /*   iDisplayInfo(Symbol()+"-BuyGroup", "������", Corner, 70, 70, 12, "Arial", Red);
      iDisplayInfo(Symbol()+"-Ask", DoubleToStr(Ask, Digits), Corner, 70, 90, 12, "Arial", Red);
      iDisplayInfo(Symbol()+"-SellGroup", "������", Corner, 5, 70, 12, "Arial", Green);
      iDisplayInfo(Symbol()+"-Bid", DoubleToStr(Bid, Digits), Corner, 5, 90, 12, "Arial", Green);
      //��ʾ��������Ϣ
      iDisplayInfo(Symbol()+"-BuyGroup", "������", Corner, 70, 70, 12, "Arial", Red);
      iDisplayInfo(Symbol()+"-Ask", DoubleToStr(Ask, Digits), Corner, 70, 90, 12, "Arial", Red);
      iDisplayInfo(Symbol()+"BuyOrders", BuyGroupOrders, Corner, 80, 110, 10, "Arial", iObjectColor(BuyGroupProfit));
      iDisplayInfo(Symbol()+"BuyGroupLots", DoubleToStr(BuyGroupLots, 2), Corner, 80, 125, 10, "Arial", iObjectColor(BuyGroupProfit));
      iDisplayInfo(Symbol()+"BuyGroupProfit", DoubleToStr(BuyGroupProfit, 2), Corner, 80, 140, 10, "Arial", iObjectColor(BuyGroupProfit));
      //��ʾ��������Ϣ
      iDisplayInfo(Symbol()+"-SellGroup", "������", Corner, 5, 70, 12, "Arial", Green);
      iDisplayInfo(Symbol()+"-Bid", DoubleToStr(Bid, Digits), Corner, 5, 90, 12, "Arial", Green);
      iDisplayInfo(Symbol()+"SellOrders", SellGroupOrders, Corner, 10, 110, 10, "Arial", iObjectColor(SellGroupProfit));
      iDisplayInfo(Symbol()+"SellGroupLots", DoubleToStr(SellGroupLots, 2), Corner, 10, 125, 10, "Arial", iObjectColor(SellGroupProfit));
      iDisplayInfo(Symbol()+"SellGroupProfit", DoubleToStr(SellGroupProfit, 2), Corner, 10, 140, 10, "Arial", iObjectColor(SellGroupProfit));
*/
      return(0);
   }

//=============================================================================================================== 
/*
��    �������׷�æ������ȴ������»�������
���������
���������
�㷨˵����
*/
void iWait() 
   {
      while (!IsTradeAllowed() || IsTradeContextBusy()) Sleep(100);
      RefreshRates();
      return(0);
   }
//========================================================================================================   