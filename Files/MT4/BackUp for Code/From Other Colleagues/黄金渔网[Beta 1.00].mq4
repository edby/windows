#property copyright "Copyright By Laoyee QQ:921795"
#property link      "http://www.docin.com/yiwence"
#include <WinUser32.mqh>

/*
���������Ƽ��汾�š�
�ƽ��ƶ�����[Beta 1.00]
��������¼��
2012.09.12[1.01]
1������ʶ��GoldƷ�� ---- ok
2��limit�ҵ��д����ظ��ҵ�����Ҫʶ��ɾ��

2012.09.06[1.00]
1���ղ�ʱ�������źţ��мۿ������뵥��������ΪLots
2����1������ֲֵ�ʱ��˫��ҵ���BuyStopΪPendingNum�ţ�BuyLimitΪPendingNum*2�ţ����ΪGridSpace��������ΪLots
3���۸��ϸ��������µ�BuyStop��������������һ����ߴ����GridSpace����1���µ�BuyStop����ʹ�ɾ��1��BuyLimit��
4���۸��¸��������µ�BuyLimit��������������һ����ʹ����GridSpace����1���µ�BuyLimit����ߴ�ɾ��1��BuyStop��
5���������뵥������GridSpaceֹӯ������ּ۳���ֹӯ��(����)����õ��м�ƽ��
6��SellSignal+���뵥�ֲ�ʱ��ͳ��EMA���³ֲֵ��������������PendingNum*2�ţ�ȫ���м�ƽ�֡�ֹ�����
7�������ź�BuySignal��Ask<EMA(H1,120,0,2,6,1)�������ź�SellSignal��Ask<EMA(H1,120,0,2,6,1)
8�������������෴
9��Ԥ�����Lots=ƽ̨��С��������PendingNum=5��GridSpace=StopLevel/2��
*/
//----����Ԥ�����
string str1 = "====ϵͳԤ�����====";
double Lots;
extern int PendingNum=3;
extern double GridDensity=1; //�����ܶȣ���ֵԽ���ܶ�Խ��
extern int GridSpace=0; //���ӿ��=ֹͣˮƽλ/GridDensity

//�������Ʋ���
string MyOrderComment="lyGold";
int MyMagicNum=12090621;

//----������Ʋ���
int BuyGroupOrders, SellGroupOrders; //���롢������ɽ��ֲֵ������ܼ�
int BuyGroupFirstTicket, SellGroupFirstTicket; //���롢�������һ������
int BuyGroupLastTicket, SellGroupLastTicket; //���롢���������һ������
int BuyGroupMaxProfitTicket, SellGroupMaxProfitTicket; //���롢���������ӯ��������
int BuyGroupMinProfitTicket, SellGroupMinProfitTicket; //���롢��������Сӯ��������
int BuyGroupMaxLossTicket, SellGroupMaxLossTicket; //���롢�����������𵥵���
int BuyGroupMinLossTicket, SellGroupMinLossTicket; //���롢��������С���𵥵���
double BuyGroupLots, SellGroupLots; //���롢������ɽ��ֲֵ��������ܼ�
double BuyGroupProfit, SellGroupProfit; //���롢������ɽ��ֲֵ������ܼ�
int BuyLimitOrders, SellLimitOrders; //�������ƹҵ����������ƹҵ������ܼ�
int BuyStopOrders, SellStopOrders; //����ֹͣ�ҵ�������ֹͣ�ҵ������ܼ�
//�ֲֶ���������Ϣ:0������,1����ʱ��,2��������,3��������,4������,5���ּ�,
//                 6ֹ���,7ֹӮ��,8����������,9����Ӷ��,10����,11�ҵ���Ч����
double OrdersArray[][12];//��1ά:�������;��2ά:������Ϣ
double TempOrdersArray[][12];//��ʱ����
int MyArrayRange; //�����¼����
int Corner = 1; //������Ϣ��ʾ�ĸ���λ��
int cnt, i, j; //����������
string TextBarString; //����λ����ʾ���ֱ���
string DotBarString; //����λ����ʾ���ֱ���
string HLineBarString; //����λ����ʾ���ֱ���
string VLineBarString; //����λ����ʾ���ֱ���

int FontSize=10; //��ʾ��Ϣ����
double MinLots; //��С������
double BasePrice; //��׼��
double LastTakeProfit; //�������ֹӯ��/�������ֹӯ��
int OrdersNow; //��ǰ�ֲֵ�����
bool BuwangBool=true; //������
int LastHistoryTicket=-1; //���һ����ʷ������
bool FirstNet=true;
double myTempBuyStopPrice; //Stop�ҵ��Ϲ��


int start()
   {
      iMain();
      return(0);
   }

/*
��    �������س���
���������
���������
��    ����
*/
void iMain()
   {
//========================================
if (TimeCurrent()>D'2012.10.30') 
   {
      Comment("���������ѵ�");
      return(0);
   }
if (Symbol()!="XAUUSD" || Symbol()!="Gold")
   {
      Comment("ֻ��ʹ��XAUUAD");
      return(0);
   }
if (!IsDemo())
   {
      Comment("ֻ�����ڲ����˻�");
      return(0);
   }
//========================================
      iShowInfo();
      //���뵥����ֹӯ/ƽ��
      iLimitTakeProfit();
      //2���������������Ϲ����޸�
      iComplianceRepair();
      //1�����֡��ղ�ʱ�������źţ��мۿ������뵥��������ΪLots
      if (BuyGroupOrders==0 && iTradingSignals()==0)
         {
            iWait();
            iDisplayInfo("TradeInfo", "�м����뿪��", 1, 5, 50, FontSize, "", Olive);
            OrderSend(Symbol(),OP_BUY,Lots,Ask,0,0,0,MyOrderComment+DoubleToStr(Ask,Digits),MyMagicNum);
         }
      return(0);
   }

/*
��    �����Ϲ����޸�
���������
���������
��    ��������limit�ҵ�������Stop�ҵ���limit����������ֹӯ
�����1�����뵥����λ�ã��Ի�׼�ۻ����������飬ȷ��BuyStopΪPendingNum�ţ�BuyLimitΪPendingNum*2�ţ��ҵ����ΪGridSpace��������ΪLots
*/
void iComplianceRepair()
   {
      int myNetNum;
      double myTempNetTop,myTempNetBot;
      if ((BuyGroupOrders+SellGroupOrders)==0) return(0);
      //��ȡ��׼��
      if (OrderSelect(BuyGroupLastTicket,SELECT_BY_TICKET,MODE_TRADES))
         {
            BasePrice=NormalizeDouble(StrToDouble(StringSubstr(OrderComment(),6,StringLen(OrderComment())-1)),Digits);
         }
      if (BasePrice==0) return(0); //��׼��Ϊ0������
      //�����������
      //----������������
      myNetNum=PendingNum*3; //��������
      double myGridArray[]; //�����������
      ArrayResize(myGridArray,myNetNum); //���½綨��������ά��
      ArrayInitialize(myGridArray, 0.0); //��ʼ����������
      myGridArray[0]=BasePrice+GridSpace*Point*PendingNum; //��߹ҵ���
      string myteststr=myGridArray[0]+"\n";
      //----�������鸳ֵ
      for (cnt=1;cnt<myNetNum;cnt++)
         {
            myGridArray[cnt]=myGridArray[cnt-1]-GridSpace*Point;
            myteststr=myteststr+myGridArray[cnt]+"\n";
         }
      //1������յ�limit�ҵ� ��׼�ۣ�BasePrice�������GridSpace����������MinLots������������OrdersNum
      string mystring,mytempstring;
      //���/����limit��
      //limit����
      if (BuyLimitOrders<(PendingNum*2) && OrderSelect(iOrderSortTicket(2,3,1),SELECT_BY_TICKET,MODE_TRADES) && (BasePrice-OrderOpenPrice())/(GridSpace*Point)>(PendingNum*2))
         {
            double myTempLimitPrice1=OrderOpenPrice()-GridSpace*Point; //������׼��
            iWait();
            iDisplayInfo("TradeInfo", "����BuyLimit�ҵ�", 1, 5, 50, FontSize, "", Olive);
            OrderSend(Symbol(),OP_BUYLIMIT,Lots,myTempLimitPrice1,0,0,0,MyOrderComment+DoubleToStr(myTempLimitPrice1,Digits),MyMagicNum);
         }
      if (BuyLimitOrders>(PendingNum*2) && OrderSelect(iOrderSortTicket(2,3,1),SELECT_BY_TICKET,MODE_TRADES) && (BasePrice-OrderOpenPrice())/(GridSpace*Point)>(PendingNum*2))
         {
            iWait();
            iDisplayInfo("TradeInfo", "ɾ��BuyLimit�ҵ�", 1, 5, 50, FontSize, "", Olive);
            OrderDelete(iOrderSortTicket(2,3,1));
         }
      for (cnt=0;cnt<=500;cnt++)
         {
            if (myGridArray[cnt]==0) break; //�ҵ�����Ϊ���������ֹӯ��Ϊ0����ִ��
            //�ȶԳɽ��ֲֵ��Ƿ��д˼۸� 
            mytempstring="";
            for (i=0;cnt<=500;i++)
               {
                  if (OrdersArray[i][0]==0) break;
                  if (OrderSelect(OrdersArray[i][0],SELECT_BY_TICKET,MODE_TRADES)
                      && StringFind(OrderComment(),"Gold"+DoubleToStr(myGridArray[cnt],Digits),0)>0)
                     {
                        mytempstring=mytempstring+DoubleToStr(OrdersArray[i][0],0)+"*"+i; //�����Ÿ�ֵ
                     }
               }
            if (StringLen(mytempstring)==0 && myGridArray[cnt]<(Bid-MarketInfo(Symbol(),MODE_STOPLEVEL)*Point) && myGridArray[cnt-1]!=0)
               {
                  iWait();
                  iDisplayInfo("TradeInfo", "BuyLimit�ҵ�", 1, 5, 50, FontSize, "", Olive);
                  OrderSend(Symbol(),OP_BUYLIMIT,Lots,myGridArray[cnt],0,0,0,MyOrderComment+DoubleToStr(myGridArray[cnt],Digits),MyMagicNum);
                  mytempstring="����";
               }
            mystring=mystring+DoubleToStr(myGridArray[cnt],Digits)+" : "+mytempstring+"\n";
         }

      //2������  ����յ�Stop�ҵ� ��׼�ۣ�BasePrice�������GridSpace����������Lots��������PendingNum
      if (BuyStopOrders<PendingNum)
         {
            //����Stop�ҵ���
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
            //Stop�ҵ�
            iWait();
            iDisplayInfo("TradeInfo", "BuyStop�ҵ�", 1, 5, 50, FontSize, "", Olive);
            OrderSend(Symbol(),OP_BUYSTOP,Lots,myTempBuyStopPrice,0,0,0,MyOrderComment+DoubleToStr(myTempBuyStopPrice,Digits),MyMagicNum);
         }
      return(0);
   }
   
/*
��    �������㽻���ź�
���������
���������9-���ź�
          0-���뿪���ź�
          1-���������ź�
��    ����
*/
int iTradingSignals()
   {
      int myReturn=9;//Ԥ���巵�ر���
      double myEMA=iMA(Symbol(),60,120,0,2,6,1);
      if (Ask>myEMA) myReturn=0;
      if (Bid<myEMA) myReturn=1;
      return(myReturn);
   }
   
/*
��    ����limit����������ֹӯ��ƽ��
���������
���������
��    ����
*/
void iLimitTakeProfit()
   {
      for (cnt=0;cnt<=OrdersTotal();cnt++)
         {
            if (OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==MyMagicNum && OrderSymbol()==Symbol() && OrderType()==OP_BUY)
               {
                  //���뵥ӯ������ֹӯ�ۣ��м�ƽ��
                  if (Bid>(OrderOpenPrice()+GridSpace*Point))
                     {
                        iWait();
                        iDisplayInfo("TradeInfo", OrderTicket()+"�ŵ�ӯ��ƽ��", 1, 5, 50, FontSize, "", Olive);
                        OrderClose(OrderTicket(),OrderLots(),Bid,0);
                        break;
                     }
                  //���뵥����ֹӯ
                  double myTPPrice;
                  if (StringSubstr(OrderComment(),0,6)=="lyGold")
                     {
                        myTPPrice=NormalizeDouble(StrToDouble(StringSubstr(OrderComment(),6,StringLen(OrderComment())-1)),Digits)+GridSpace*Point;
                     }
                  if (OrderTakeProfit()!=myTPPrice && Bid<myTPPrice)
                     {
                        iWait();
                        iDisplayInfo("TradeInfo", OrderTicket()+"�ŵ�����ֹӯ", 1, 5, 50, FontSize, "", Olive);
                        OrderModify(OrderTicket(),OrderOpenPrice(),0,myTPPrice,0);
                     }
               }
         }
      return(0);
   }

/*
��    ������ʾ������Ϣ
���������
���������
��    ����
*/
void iShowInfo()
   {
      //��ʼ������
      BuyGroupOrders=0; SellGroupOrders=0; //���롢������ɽ��ֲֵ������ܼ�
      BuyGroupFirstTicket=0; SellGroupFirstTicket=0; //���롢�������һ�Ŷ�������
      BuyGroupLastTicket=0; SellGroupLastTicket=0; //���롢���������һ�Ŷ�����
      BuyGroupMaxProfitTicket=0; SellGroupMaxProfitTicket=0; //���롢���������ӯ��������
      BuyGroupMinProfitTicket=0; SellGroupMinProfitTicket=0; //���롢��������Сӯ��������
      BuyGroupMaxLossTicket=0; SellGroupMaxLossTicket=0; //���롢�����������𵥵���
      BuyGroupMinLossTicket=0; SellGroupMinLossTicket=0; //���롢��������С���𵥵���
      BuyGroupLots=0; SellGroupLots=0; //���롢������ɽ����ֲ���
      BuyGroupProfit=0; SellGroupProfit=0; //���롢������ɽ�������
      BuyLimitOrders=0; SellLimitOrders=0; //�������ƹҵ����������ƹҵ������ܼ�
      BuyStopOrders=0; SellStopOrders=0; //����ֹͣ�ҵ�������ֹͣ�ҵ������ܼ�
      //��ʼ����������
      MyArrayRange=OrdersTotal()+1;
      ArrayResize(OrdersArray, MyArrayRange); //���½綨����
      ArrayInitialize(OrdersArray, 0.0); //��ʼ������
      if (OrdersTotal()>0)
         {
            //�����ֲֵ�,��������
            for (cnt=0; cnt<=MyArrayRange; cnt++)
               {
                  iWait();
                  //ѡ�е�ǰ���Ҷ���سֲֶ���
                  if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()==MyMagicNum)
                     {
                        OrdersArray[cnt][0]=OrderTicket();//0������
                        OrdersArray[cnt][1]=OrderOpenTime();//1����ʱ��
                        OrdersArray[cnt][2]=OrderProfit();//2��������
                        OrdersArray[cnt][3]=OrderType();//3��������
                        OrdersArray[cnt][4]=OrderLots();//4������
                        OrdersArray[cnt][5]=OrderOpenPrice();//5���ּ�
                        OrdersArray[cnt][6]=OrderStopLoss();//6ֹ���
                        OrdersArray[cnt][7]=OrderTakeProfit();//7ֹӮ��
                        OrdersArray[cnt][8]=OrderMagicNumber();//8����������
                        OrdersArray[cnt][9]=OrderCommission();//9����Ӷ��
                        OrdersArray[cnt][10]=OrderSwap();//10����
                        OrdersArray[cnt][11]=OrderExpiration();//11�ҵ���Ч����
                     }
               }
            //ͳ�ƻ�����Ϣ
            for (cnt=0; cnt<MyArrayRange; cnt++)
               {
                  //����ֲֵ�
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUY)
                     {
                        BuyGroupOrders=BuyGroupOrders+1; //�����鶩������
                        BuyGroupLots=BuyGroupLots+OrdersArray[cnt][4]; //�����鿪����
                        BuyGroupProfit=BuyGroupProfit+OrdersArray[cnt][2]; //����������
                     }
                  //�����ֲֵ�
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELL)
                     {
                        SellGroupOrders=SellGroupOrders+1; //�����鶩������
                        SellGroupLots=SellGroupLots+OrdersArray[cnt][4]; //�����鿪����
                        SellGroupProfit=SellGroupProfit+OrdersArray[cnt][2]; //����������
                     }
                  //���������ƹҵ��ܼ�
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYLIMIT) BuyLimitOrders=BuyLimitOrders+1;
                  //���������ƹҵ��ܼ�
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLLIMIT) SellLimitOrders=SellLimitOrders+1;
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
            SellGroupMinLossTicket=iOrderSortTicket(1,2,1); //��������С���𵥵���
         }
      //��ʾ������Ϣ
      iDisplayInfo(Symbol()+"-BuyGroup", "������", Corner, 70, 70, 12, "Arial", Red);
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
      OrdersNow=BuyGroupOrders+SellGroupOrders+BuyLimitOrders+SellLimitOrders+BuyStopOrders+SellStopOrders;
      iDisplayInfo(Symbol()+"-OrdersTotal", "�ֲֵ�����:"+OrdersNow, Corner, 10, 160, 12, "Arial", Red);

      return(0);
   }

/*
��    ��:�����ض������Ķ���
�������:myOrderType:�������� 0-Buy,1-Sell,2-BuyLimit,3-SellLimit,4-BuyStop,5-SellStop
         myOrderSort:�������� 0-��ʱ��,1-��ӯ��,2-������,3-�����ּ�
         myMaxMin:��ֵ 0-���,1-��С
�������:���ض�����
��    ����
*/
int iOrderSortTicket(int myOrderType,int myOrderSort,int myMaxMin)
   {
      int myTicket=0;
      int myArraycnt=0; //ʱ������
      int myArraycnt1=0; //ӯ������
      int myArraycnt2=0; //���ּ�����
      int myType;
      //������ʱ����
      double myTempArray[][12]; //������ʱ����
      ArrayResize(myTempArray, MyArrayRange); //���½綨��ʱ����
      ArrayInitialize(myTempArray, 0.0); //��ʼ����ʱ����
      double myTempOrdersArray[][12]; //������ʱ����
      myArraycnt=BuyGroupOrders+SellGroupOrders;
      if (myArraycnt==0) return(0);
      myArraycnt2=MyArrayRange;
      myArraycnt1=myArraycnt;
      myArraycnt=myArraycnt-1;
      //��ԭʼ�������ݸ��Ƶ�myTempOrdersArray����
      ArrayResize(myTempOrdersArray, myArraycnt1); //���½綨��ʱ����
      ArrayInitialize(myTempOrdersArray, 0.0); //��ʼ����ʱ����
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
      //��ʱ�併����������  ԭʼ������������
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
      //���������������� myTempOrdersArray
      if (myOrderSort==1 || myOrderSort==2)
         {
            double myTempArray1[][12]; //������ʱ����
            ArrayResize(myTempArray1, myArraycnt1); //���½綨��ʱ����
            ArrayInitialize(myTempArray1, 0.0); //��ʼ����ʱ����
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

      //���������ּ۽�����������
      if (myOrderSort==3)
         {
            double myTempArray2[][12]; //������ʱ����
            ArrayResize(myTempArray2, myArraycnt2); //���½綨��ʱ����
            ArrayInitialize(myTempArray2, 0.0); //��ʼ����ʱ����
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

      //X����������Ϳ��ּ۵�
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

      //X����������߿��ּ۵�
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


      //X����������С����
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
      //X��������������
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
      //X�����������ӯ����
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
      //X����������Сӯ����
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

      //X�������͵�1���ֵ�
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
      //X������󿪲ֵ�
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

/*
��    ��������Ļ����ʾ���ֱ�ǩ
���������string LableName ��ǩ���ƣ������ʾ����ı������Ʋ�����ͬ
          string LableDoc �ı�����
          int Corner �ı���ʾ��
          int LableX ��ǩXλ������
          int LableY ��ǩYλ������
          int DocSize �ı��ֺ�
          string DocStyle �ı�����
          color DocColor �ı���ɫ
�����������ָ����λ�ã�X,Y������ָ�����ֺš����弰��ɫ��ʾָ�����ı�
�㷨˵����
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
��    ���������ɫ
�����������ֵ
�����������ɫ
��    ��������Ϊ��ɫ������Ϊ��ɫ��0Ϊ��ɫ
*/
color iObjectColor(double myInput)
   {
      color myColor;
      if (myInput > 0)
         myColor = Green; //������ɫΪ��ɫ
      if (myInput < 0)
         myColor = Red; //������ɫΪ��ɫ
      if (myInput == 0)
         myColor = DarkGray; //0��ɫΪ��ɫ
      return(myColor);
   }

int init()
   {
      //��ʾ������Ϣ
      iDisplayInfo("Author", "����:���� QQ:921795", Corner, 18, 15, 8, "", SlateGray);
      iDisplayInfo("Symbol", Symbol(), Corner, 25, 30, 14, "Arial Bold", DodgerBlue);
      iDisplayInfo("TradeInfo", "��ӭʹ�ã�", Corner, 5, 50, FontSize, "", Olive);
      iShowInfo();
      //��ʼ��Ԥ�����
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

