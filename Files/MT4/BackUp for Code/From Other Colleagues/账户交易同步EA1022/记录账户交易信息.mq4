//+------------------------------------------------------------------+
//|                                             ��¼�˻�������Ϣ.mq4 |
//|                            Copyright 2013, ���ǻ�������Ȩ����. |
//|                                       http://www.jinding9999.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, ���ǻ�������Ȩ����."
#property link      "http://www.jinding9999.com"
/*
extern string str1 = "--------Ӧ����Ʒ--------";
extern string ��Ʒ1  = "USDJPY";
extern string ��Ʒ2 = "GBPUSD";
*/

extern  string �ļ�д��·�������� = "\MyTrade_yihui\experts\files\MyAccountData1.csv";
string iFileName;

//----������Ʋ���
/*
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
*/
double OrdersArray[][12];//��1ά:�������;��2ά:������Ϣ
double TempOrdersArray[][12];//��ʱ����
int MyArrayRange; //�����¼����
//int Corner = 1; //������Ϣ��ʾ�ĸ���λ��
//int FontSize=10; //��ʾ��Ϣ�ֺ�
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
  // iDisplayInfo("TradeInfo", "��¼�˻�������Ϣ��", Corner, 5, 50, 9, "", Olive);
   iFileName = �ļ�д��·��������;
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
  // if(��Ʒ1 == Symbol())
      WriteMyAccountDate(iFileName);
 //  if(��Ʒ1 == Symbol())
 //    WriteMyAccountDate("\MyTrade_yihui\experts\files\MyAccountData2.csv");     
//----
   return(0);
  }
//+------------------------------------------------------------------+
//���˻���Ϣд���ļ�
  void WriteMyAccountDate(string MyFileName)//"MyAccountData1.csv"
   {   
      iShowInfo();

      if(MyOrdersTotal == TZM)
         return;
   //   if(TZM == 0) 
       //   FileDelete(MyFileName);
      if(MyOrdersTotal > TZM) //��ƽ��
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
         Print("��¼��Ϣ");
         int i =  TZM - 1;      
         FileWrite(handle,TZM,Symbol(),MyOrderTicket,OrdersArray[i][0],OrdersArray[i][3],OrdersArray[i][4],0);                
         FileClose(handle);
     // }    
      return;
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
      //MAXTZM=0;
      //HAND=0;
    /*  MyProfite = 0;
      MAXTZM_B=0;
      HAND_B=0;
      MAXTZM_S=0;
      HAND_S=0;
      BuyGroupOrders=0; SellGroupOrders=0; //���롢������ɽ��ֲֵ������ܼ�
      BuyGroupFirstTicket=0; SellGroupFirstTicket=0; //���롢�������һ�Ŷ�������
      BuyGroupLastTicket=0; SellGroupLastTicket=0; //���롢���������һ�Ŷ�����
      BuyGroupMaxProfitTicket=0; SellGroupMaxProfitTicket=0; //���롢���������ӯ��������
      BuyGroupMinProfitTicket=0; SellGroupMinProfitTicket=0; //���롢��������Сӯ��������
      BuyGroupMaxLossTicket=0; SellGroupMaxLossTicket=0; //���롢�����������𵥵���
      BuyGroupMinLossTicket=0; SellGroupMinLossTicket=0; //���롢��������С���𵥵���
      BuyGroupLots=0; SellGroupLots=0; //���롢������ɽ����ֲ���
      BuyGroupProfit=0; SellGroupProfit=0; //���롢������ɽ�������
  //    BuyLimitOrders=0; SellLimitOrders=0; //�������ƹҵ����������ƹҵ������ܼ�
      BuyStopOrders=0; SellStopOrders=0; //����ֹͣ�ҵ�������ֹͣ�ҵ������ܼ�*/
      //��ʼ����������
      MyArrayRange=OrdersTotal()+1;
      ArrayResize(OrdersArray, MyArrayRange); //���½綨����
      ArrayInitialize(OrdersArray, 0.0); //��ʼ������
      if (OrdersTotal()>0)
         {
            //�����ֲֵ�,��������
            for (int cnt=0; cnt<=MyArrayRange; cnt++)
               {
                 // iWait();
                  //ѡ�е�ǰ���Ҷ���سֲֶ���
                  if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()== Symbol())
                     {   
                        OrdersArray[TZM][0]=OrderTicket();//0������
                        OrdersArray[TZM][1]=OrderOpenTime();//1����ʱ��
                        OrdersArray[TZM][2]=OrderProfit();//2��������
                        OrdersArray[TZM][3]=OrderType();//3��������
                        OrdersArray[TZM][4]=OrderLots();//4������
                      //  OrdersArray[TZM][5]=OrderOpenPrice();//5���ּ�
                      //  OrdersArray[TZM][6]=OrderStopLoss();//6ֹ���
                       // OrdersArray[TZM][7]=OrderTakeProfit();//7ֹӮ��
                      // OrdersArray[TZM][8]=OrderMagicNumber();//8����������
                       // OrdersArray[TZM][9]=OrderCommission();//9����Ӷ��
                        //  OrdersArray[TZM][10]=OrderSwap();//10����
                        //OrdersArray[TZM][11]=OrderExpiration();//11�ҵ���Ч����
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
            //ͳ�ƻ�����Ϣ
   /*         for (cnt=0; cnt<MyArrayRange; cnt++)
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
               //   if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYLIMIT) BuyLimitOrders=BuyLimitOrders+1;
                  //���������ƹҵ��ܼ�
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLLIMIT) SellLimitOrders=SellLimitOrders+1;
                  //������ֹͣ�ҵ��ܼ�
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_BUYSTOP) BuyStopOrders=BuyStopOrders+1;
                  //������ֹͣ�ҵ��ܼ�
                  if (OrdersArray[cnt][0]!=0 && OrdersArray[cnt][3]==OP_SELLSTOP) SellStopOrders=SellStopOrders+1;
               }*/
 /*           //����������������β����
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
      /*
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
      iDisplayInfo(Symbol()+"SellGroupProfit", DoubleToStr(SellGroupProfit, 2), Corner, 10, 140, 10, "Arial", iObjectColor(SellGroupProfit));*/

      return(0);
   }

//=============================================================================================================== 
/*
��    �������׷�æ������ȴ������»�������
���������
���������
�㷨˵����
*//*
void iWait() 
   {
      while (!IsTradeAllowed() || IsTradeContextBusy()) Sleep(100);
      RefreshRates();
      return(0);
   }*/
//========================================================================================================  