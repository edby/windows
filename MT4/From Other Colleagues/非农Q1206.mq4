//+------------------------------------------------------------------+
//|                                                     ��ũ1113.mq4 |
//|                                Copyright 2013, �ǻ�������Ȩ����. |
//|                                       http://www.jinding9999.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, �ǻ�������Ȩ����."
#property link      "http://www.jinding9999.com"
#include <WinUser32.mqh>

extern int �ҵ�������� = 50;
double Inte;
extern double �������� = 0.1;
double MyLots;
extern int ֹ����� = 50;
double SL;
extern int ֹӯ���� = 60;
double TP;
extern int huadian = 5;
extern int ���������� = 20130000;
int MyMagicNumFN;
extern int MinProfit = 50;
extern double �ƶ�ֹ����=20;
double TrallingStop;

extern string ����ʱ�� = "2013.11.20 15:30:00";   
string MyTimeStart;

extern int ��ǰ������=3;
int myPreTime;

extern double ͬ��ҵ����=10;
double Interval_SA;
extern double ����ҵ����=10;
double Interval_OP;

int BuyGroupOrders, SellGroupOrders; //���롢������ɽ��ֲֵ������ܼ�
/*int BuyGroupFirstTicket, SellGroupFirstTicket; //���롢�������һ������
int BuyGroupLastTicket, SellGroupLastTicket; //���롢���������һ������
int BuyGroupMaxProfitTicket, SellGroupMaxProfitTicket; //���롢���������ӯ��������
int BuyGroupMinProfitTicket, SellGroupMinProfitTicket; //���롢��������Сӯ��������
int BuyGroupMaxLossTicket, SellGroupMaxLossTicket; //���롢�����������𵥵���
int BuyGroupMinLossTicket, SellGroupMinLossTicket; //���롢��������С���𵥵���
double BuyGroupLots, SellGroupLots; //���롢������ɽ��ֲֵ��������ܼ�
double BuyGroupProfit, SellGroupProfit; //���롢������ɽ��ֲֵ������ܼ�
int BuyLimitOrders, SellLimitOrders; //�������ƹҵ����������ƹҵ������ܼ�*/
int BuyStopOrders, SellStopOrders; //����ֹͣ�ҵ�������ֹͣ�ҵ������ܼ�

double OrdersArray[][12];
double TempOrdersArray[][12];

double OpenPrice_SELLSTOP;
double OpenPrice_BUYSTOP;
bool StopFC = false;
double myTrallingStopPrice;//ֹ���λ
datetime myCurrentTime=0;
datetime myTimeLocal=0;
double myPrice_B,myPrice_S;
double MyPoint;
int TZM;
int HAND_B,HAND_S;
int MyArrayRange; //�����¼����

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
      if(Digits == 3 || Digits == 5)  MyPoint = Point / 0.1;  //Digits:��ǰ���ҶԵĻ���С��λ;Point:ͼ��ĵ�ֵ
      else MyPoint = Point;
      
      MyLots = ��������;
      
      Inte = �ҵ�������� *MyPoint;
      
      Interval_SA = ͬ��ҵ���� * MyPoint;
      
      Interval_OP = ����ҵ���� * MyPoint;

      SL = ֹ����� * MyPoint;

      TP = ֹӯ���� * MyPoint;
      
      myPreTime = ��ǰ������;
      
      MyTimeStart = ����ʱ��;
      
      TrallingStop = �ƶ�ֹ���� * MyPoint;
      
      MyMagicNumFN = ����������;
      
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
             int ret = MessageBox("����Ԥ��ֵ,��ʱ�ĵ��Ϊ:"+DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),2)+ "\nContinue?","Spread ",MB_YESNO|MB_ICONQUESTION);//MB_YESNO|MB_ICONQUESTION
             Print("����Ԥ��ֵ����ʱ�ĵ��Ϊ:",DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),2));
             if(ret == IDYES) SFlag = false;//MyOralSpread +=1;
             if(ret == IDNO) return(0);
             //if(ret == IDOK)
             
             
          }
       //-----------------------------------------------------------------------------------------
        
          MyFreeMarginCheck = AccountFreeMarginCheck(Symbol(),OP_BUY,MyOralLots);
      //    Print("��ʱ�Ĳ�λ��֤�𲻹�,ֵΪ:",MyFreeMarginCheck);
          if(MyFreeMarginCheck <= 0 || GetLastError() == 134)
          {
            Print("��ʱ�Ĳ�λ��֤�𲻹�,ֵΪ:",MyFreeMarginCheck);
            int sut = MessageBox("��ʱ�ı�֤�𲻹�,ֵΪ"+MyFreeMarginCheck+"!\n","AccountFreeMarginCheck",MB_OK|MB_ICONEXCLAMATION);
            if(sut == IDOK) return(0);
          }
     //---------------------------------------------------------------------------
     //    Print(1 +"/" +100);
          MyAccountLeverage = AccountLeverage();
      //    Print(MyAccountLeverage);
          if(MyAccountLeverage > 400)  
          { 
        //    Print("��ʱ�ĸܸ˱���Խ��,ֵΪ:",MyAccountLeverage);
            int res = MessageBox("��ʱ�ĸܸ˱���Խ��,ֵΪ:"+AccountLeverage()+"\nContinue?","AccountLeverage",MB_YESNO|MB_ICONQUESTION);
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
 
    
///////////////////----------�ƶ�ֹ��--------------//////  

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
                   //ִ���ƶ�ֹ��
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
��    ������ʾ������Ϣ
���������
���������
��    ����
*/

void iShowInfo(int MagicNum)
   {
      Ticket_BUY = 0;
      Ticket_SELL = 0;
      Ticket_BUYSTOP = 0;
      Ticket_SELLSTOP = 0;
      
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
  //    BuyLimitOrders=0; SellLimitOrders=0; //�������ƹҵ����������ƹҵ������ܼ�*/
      BuyStopOrders=0; SellStopOrders=0; //����ֹͣ�ҵ�������ֹͣ�ҵ������ܼ�
      //��ʼ����������
      MyArrayRange = OrdersTotal()+1;
      ArrayResize(OrdersArray, MyArrayRange); //���½綨����
      ArrayInitialize(OrdersArray, 0.0); //��ʼ������
      if (OrdersTotal()>0)
         {
            //�����ֲֵ�,��������
            for (int cnt=0; cnt < MyArrayRange-1; cnt++)
               {
           //       iWait();
                  //ѡ�е�ǰ���Ҷ���سֲֶ���
                  if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()== MagicNum)
                  {   
                        TZM=TZM+1;
                        OrdersArray[cnt][0]=OrderTicket();//0������
                        OrdersArray[cnt][1]=OrderOpenTime();//1����ʱ��
                        OrdersArray[cnt][2]=OrderProfit();//2��������
                        OrdersArray[cnt][3]=OrderType();//3��������
                        OrdersArray[cnt][4]=OrderLots();//4������
           //           HAND =HAND+OrderLots();
                        OrdersArray[cnt][5]=OrderOpenPrice();//5���ּ�
                        //MAXTZM=MAXTZM+(OrderOpenPrice()*OrderLots());
                        OrdersArray[cnt][6]=OrderStopLoss();//6ֹ���
                        OrdersArray[cnt][7]=OrderTakeProfit();//7ֹӮ��
                        OrdersArray[cnt][8]=OrderMagicNumber();//8����������
                        OrdersArray[cnt][9]=OrderCommission();//9����Ӷ��
                        OrdersArray[cnt][10]=OrderSwap();//10����
                        OrdersArray[cnt][11]=OrderExpiration();//11�ҵ���Ч���� 
                     
                        
 //////////////////--------------------------------------------------------------�����ֲֵ�                       
                       if(OrderType() == OP_BUY)
                       {
                          // MAXTZM_B = MAXTZM_B + (OrderOpenPrice()*OrderLots());
                           HAND_B += OrderLots();
                           Ticket_BUY = OrderTicket();
                         
                           BuyGroupOrders += 1; //�����鶩������
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
 ///////----------------------------------------------------------------- //ͳ�ƻ�����Ϣ
  /*          for (cnt=0; cnt<MyArrayRange; cnt++)
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
      iDisplayInfo("AccountInfo8","������ʱ�䣺"+TimeToStr(TimeCurrent(),TIME_SECONDS),1,20,10,12,"",Snow);         
      iDisplayInfo("AccountInfo1","�ܸ˱����� 1 : "+AccountLeverage(),0,20,12,12,"",Snow);
      iDisplayInfo("AccountInfo2","�˻���ѱ�֤��"+DoubleToStr(AccountFreeMargin(),Digits),0,20,30,12,"",Snow);
      iDisplayInfo("AccountInfo3","BUY/SELL��λ��֤��"+DoubleToStr(AccountFreeMarginCheck(Symbol(),OP_BUY|OP_SELL,1),4),0,20,50,12,"",Snow);
      iDisplayInfo("AccountInfo4","��С���֣�"+DoubleToStr(MarketInfo(Symbol(),MODE_MINLOT),4),0,20,70,12,"",Snow);
      iDisplayInfo("AccountInfo5","��󿪲֣�"+DoubleToStr(MarketInfo(Symbol(),MODE_MAXLOT),4),0,20,90,12,"",Snow);
      iDisplayInfo("AccountInfo6","���׵�"+DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),4),0,20,110,12,"",Snow);
      iDisplayInfo("AccountInfo7","����ֵ��"+DoubleToStr(MarketInfo(Symbol(),MODE_MARGINREQUIRED),4),0,20,130,12,"",Snow);
      
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
//===============================================================================================================   