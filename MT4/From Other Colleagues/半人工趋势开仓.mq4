//+------------------------------------------------------------------+
//|                                               ���˹����ƿ���.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#include <WinUser32.mqh>

//bool MyOrderSend;
extern double �������� = 0.1;
double MyLots;
extern double �ҵ�������� = 20;
double Inte;
extern int ֹ����� = 30;
double SL;
extern int ֹӯ���� = 30;
double TP;
extern int ���һ�����ƶ������ = 60;//�ƶ�������
double MinMoveSLValue;
extern int �ƶ������ּۼ������=20;//�ƶ����������
double TrallingStop;
extern double ��ǰ��ӯ���Ӳֵĵ��� = 50;//�Ӳֵ�����
double ProfitLimit;
extern int �Ӳֵ��������� = 3;
extern double MaxLots = 1.6;
extern double �Ӳֱ��� = 1;
double LotTimes;
extern double ƽ����ӯ�� = 100;
double MaxProfit;
int ��С����С����λ�� = 2;
int DigitsNum;
int huadian = 5;
extern int MyMagicNum = 2013123000;
extern string ����ʽ˵�� = "4/5:BUYSTOP&&SELLSTOP";//,5:SELLSTOP&&BUYSTOP
extern int ����ʽ = 4;
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
double myTrallingStopPrice;//ֹ���λ
int Ticket_BUY,Ticket_SELL;
int Ticket_BUYSTOP,Ticket_SELLSTOP;
double myPrice_B,myPrice_S;
//double OrdersArray[][12];//��1ά:�������;��2ά:������Ϣ
//double TempOrdersArray[][12];//��ʱ����
//int MyArrayRange; //�����¼����
//int cnt, i, j; //����������
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   if(Digits == 2 || Digits == 3 || Digits == 5)  MyPoint = Point / 0.1;  //Digits:��ǰ���ҶԵĻ���С��λ;Point:ͼ��ĵ�ֵ
   else MyPoint = Point;  
   
   Inte = �ҵ�������� * MyPoint;
   
   SL = ֹ����� * MyPoint;
   
   TP = ֹӯ���� * MyPoint;
   
   MyLots = ��������;
    
   ProfitLimit = ��ǰ��ӯ���Ӳֵĵ��� * MyPoint;
  
   LotTimes = �Ӳֱ���;
  
   DigitsNum = ��С����С����λ��;
  
   MinMoveSLValue = ���һ�����ƶ������ * MyPoint;
   
   TrallingStop = �ƶ������ּۼ������ * MyPoint;
  
   MaxProfit = ƽ����ӯ��;
  
   SL_OfAll = MarketInfo(Symbol(),MODE_SPREAD)*Point;
  
// LeastStopValue = MarketInfo(Symbol(),MODE_STOPLEVEL)*Point;

   MaxOrders = �Ӳֵ���������;
  
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
    //-----������Լ��ó�������µ��������ж�
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
      
      int MsgBoxInfoBuy = MessageBox("��"+TradeInformationBuy+"��ѡ��ť:��"+"\n"+"��"+TradeInformationSell+"��ѡ��ť:��"+"\n","������ʾ����",MB_YESNOCANCEL|MB_ICONWARNING);
      Print("������Ϣ:"+MsgBoxInfoBuy);
  
      if(MsgBoxInfoBuy == IDYES )    
      {
         LastOrderTick=OrderSend(Symbol(),OP_BUY,MyLots,Ask,huadian,Ask-SL,0,0,MyMagicNum,0,CLR_NONE);
         if(LastOrderTick==-1)
         {
            Print("���ִ���:"+GetLastError());
         }
     
      }
      else if(MsgBoxInfoBuy == IDNO )
      {
         LastOrderTick=OrderSend(Symbol(),OP_SELL,MyLots,Bid,huadian,Bid+SL,0,0,MyMagicNum,0,CLR_NONE);
         if(LastOrderTick==-1)
         {
            Print("���ִ���:"+GetLastError());
         }
      }
      else if(MsgBoxInfoBuy == IDCANCEL)
      {
         
         if( ����ʽ==4 || ����ʽ==5 )//Ask<���̼۸� && ����ʽ==4, Ask>���̼۸� && ����ʽ==5 
         {
            OrderSend(Symbol(),OP_BUYSTOP,MyLots,Ask+Inte,huadian,Ask+Inte-SL,0,0,MyMagicNum);
            OrderSend(Symbol(),OP_SELLSTOP,MyLots,Bid-Inte,huadian,Bid-Inte+SL,0,0,MyMagicNum);
         }
       }
       
   // ˫��ҵ�����
  //  OrderSend(Symbol(),OP_BUYSTOP,MyLots,myPrice_B,huadian,myPrice_B-TL,0,0,MyMagicNum,0,CLR_NONE);
  //  OrderSend(Symbol(),OP_SELLSTOP,MyLots,myPrice_S,huadian,myPrice_S+TL,0,0,MyMagicNum,0,CLR_NONE);
  //  �ɽ����Ĳ���
  //  OrderSend(Symbol(),OP_BUY,MyLots,Ask,huadian,Ask-SL,0,0,MyMagicNum,0,CLR_NONE);
   // OrderSend(Symbol(),OP_SELL,MyLots,Bid,huadian,Bid+TL,0,0,MyMagicNum,0,CLR_NONE);
  //------- 
   }
   else 
   {
      //....���в��ڵ��ӵķ����ж�
      iShowInfo();
      if(BuyGroupOrders > 0 )
      {
         if(Ticket_SELLSTOP > 0 )//&& Ticket_BUY > 0  && OrderSymbol() == Symbol(),����iShowInfo���Ѿ�������,����Ͳ������ظ���
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
          if( OrderType() == OP_BUY && (Close[0] - OrderOpenPrice()) >= ProfitLimit && BuyGroupOrders < MaxOrders )    //ӯ�� ˳�ƹ�buy��    OrderProfit()&& MyCounts <=3 && !MslFlag
          {
               MyOrderLots = NormalizeDouble( OrderLots()*LotTimes,DigitsNum ); // ��������  
                        
               if( MyOrderLots > MaxLots )   
                      
                  return;
                  
               Ticket = OrderSend( Symbol(),OP_BUY,MyOrderLots,Ask,huadian,Bid-SL,0,0,MyMagicNum,0,CLR_NONE );//�˵�ֹ֮����ʱ��ᶪʧ
                
               if( Ticket == -1 )
               {
                  Print( "�µ�����"+GetLastError() );
                  return;
               }  
               else
               {
                  MFlag = true;
             //     MyCounts +=1;                 
               }
                              
            }
            if( OrderType() == OP_SELL && (OrderOpenPrice()-Close[0]) >= ProfitLimit && SellGroupOrders <= MaxOrders )   //ӯ�� ˳�ƹ�sell��  OrderProfit()&& MyCounts <=3&& !MslFlag
             {
               MyOrderLots = NormalizeDouble( OrderLots()*LotTimes,DigitsNum ); // ��������  
                        
               if( MyOrderLots > MaxLots )          
               
                  return;
                  
               Ticket = OrderSend( Symbol(),OP_SELL,MyOrderLots,Bid,huadian,Bid+SL,0,0,MyMagicNum,0,CLR_NONE ); 
                
               if( Ticket == -1 )
               {
                  Print("�µ�����"+GetLastError());
                  
                  return;
               } 
               else 
               {
                  MFlag = true;       //�����µ��ɹ� 
               //   MyCounts +=1;
               }
                        
            }
            
         }
          iShowInfo();
          MSL(SL_OfAll);
          
         if(Profit >= MaxProfit || CloseAll)
         {//Print("ƽ");Print("Profit :"+Profit);Print("MaxProfit :"+MaxProfit);
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
     
      for ( int cnt=0;cnt < OrdersTotal();cnt++ )//----0s�޸ļ���ֹ��
       {   
         if( OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() )//&& OrderMagicNumber()== MyMagicNum
         {      
            //--------1s�޸ļ���ֹ����Ϊ��һ�������ʱ
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
               
               if( OrderType() == OP_BUY && OrderStopLoss() < OpenPriceAve_B + SLC * BuyGroupOrders ) // SLC,���ĺ�
               {  
              
                  if( !OrderModify(OrderTicket(),OrderOpenPrice(),OpenPriceAve_B + SLC * BuyGroupOrders,0,0,CLR_NONE ) )// ttt8881
                   {
                     Print("�޸Ķ൥ֹ��ʧ��"+GetLastError()+"Ask:"+Ask+",OpenPriceAve_B "+OpenPriceAve_B);
                   }                  
               }
               if( OrderType() == OP_SELL && OrderStopLoss() > OpenPriceAve_S - SLC * SellGroupOrders )// 
               {
                  if( !OrderModify( OrderTicket(),OrderOpenPrice(),OpenPriceAve_S - SLC * SellGroupOrders,0,0,CLR_NONE ) ) 
                  
                     Print("�޸Ŀյ�ֹ��ʧ��"+GetLastError()+"Bid:"+Bid+",OpenPriceAve_S "+OpenPriceAve_S );
                                      
               }
               
                //   MFlag = false;   
            }
            //------2s�޸ļ���ֹ����ĳһ���ͳɽ�������Ϊ���������ʱ
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
                  
                     if( pos == 2 && (OrderStopLoss()!=MySL || MDT < 2 ) )//MDT������ÿ�μӲ�֮��֮����һ�ε��޸ļ���ֹ��
                     {   
                       //  Print(OrderStopLoss());
                       //  Print(MySL);
                         MDT += 1;
                     
                        if( MDT == 1 && OrderStopLoss() == MySL)//�ڶ�����ֹ����ڵ�һ���Ŀ��ּ�ʱ
                        { 
                            if(OrderModify( FristTicket,MySL,MySL,0,0,CLR_NONE )) //�������޸ĵĵ�һ����ֹ�� 
                              MFlag = false; 
                        }
                        else if(!( OrderModify( OrderTicket(),OrderOpenPrice(),MySL,0,0,CLR_NONE ) && OrderModify( FristTicket,MySL,MySL,0,0,CLR_NONE ) ) )//
                        { 
                              Print("�޸Ķ൥ֹ��ʧ��"+GetLastError()+"Ask:"+Ask+",MySL "+MySL); 
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
                        Print("�޸Ŀյ�ֹ��ʧ��"+GetLastError()+"Bid:"+Bid+",MySL "+MySL); 
                     }
                     else
                          MFlag = false;
                  }        
                       
               }
                 //  MFlag = false;   
            }
             
            //------------3s����ֹ��λ���ƶ�
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
                              //ִ���ƶ�ֹ��
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
                     
                     if( myTrallingStopPrice < OrderStopLoss() )// (OpenPriceAve_B - SL_OfAll)������ô����
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

bool CloseAll()//ȫ��ƽ��
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
      //Print("ȫ��ƽ�֣� :",tick[j]);    
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
               Print("��ͷƽ��ʧ��"+GetLastError());
            } 
         } 
         if( OrderType()==OP_SELL )
         {
            if( OrderClose(OrderTicket(),OrderLots(),Ask,0)==false )
            {
               CloseAll = true;
               Print("��ͷƽ��ʧ��"+GetLastError());
            } 
         } 
 
         if( OrderType()==OP_BUYSTOP )
         {
            if( OrderDelete(OrderTicket(),CLR_NONE)==false )
            {
               CloseAll=true;
               Print("��ͷ�ҵ�����ʧ��"+GetLastError());
            } 
         } 
     
         if( OrderType()==OP_SELLSTOP )
         {
            if( OrderDelete(OrderTicket(),CLR_NONE)==false )
            {
               CloseAll=true;
               Print("��ͷ�ҵ�����ʧ��"+GetLastError());
            } 
         }     
      }
   }
   return;
}
//-------------------------------------------------------------------+

void iShowInfo()
   {
      //��ʼ������
    //  TZM=0;
      Profit = 0;
      OpenPriceSum_B = 0;
      OpenPriceSum_S = 0;
      OpenPriceAve_B = 0;
      OpenPriceAve_S = 0;
      Ticket_SELLSTOP =-1;//���漸�������ĳ�ʼ��һ��Ҫ�ڱ�������ȥ������֤ÿ�α�����ͳ����Ϣʱ�����Ĵ�����
      Ticket_BUYSTOP =-1;
      Ticket_BUY =-1;
      Ticket_SELL =-1;
    //  MAXTZM=0;
    //  HAND=0;
     // MAXTZM_B=0;
    //  HAND_B=0;
    //  MAXTZM_S=0;
     // HAND_S=0;
      BuyGroupOrders=0; SellGroupOrders=0; //���롢������ɽ��ֲֵ������ܼ�
      BuyStopOrders=0; SellStopOrders=0; //����ֹͣ�ҵ�������ֹͣ�ҵ������ܼ�
    /*  BuyGroupFirstTicket=0; SellGroupFirstTicket=0; //���롢�������һ�Ŷ�������
      BuyGroupLastTicket=0; SellGroupLastTicket=0; //���롢���������һ�Ŷ�����
      BuyGroupMaxProfitTicket=0; SellGroupMaxProfitTicket=0; //���롢���������ӯ��������
      BuyGroupMinProfitTicket=0; SellGroupMinProfitTicket=0; //���롢��������Сӯ��������
      BuyGroupMaxLossTicket=0; SellGroupMaxLossTicket=0; //���롢�����������𵥵���
      BuyGroupMinLossTicket=0; SellGroupMinLossTicket=0; //���롢��������С���𵥵���
      BuyGroupLots=0; SellGroupLots=0; //���롢������ɽ����ֲ���
      BuyGroupProfit=0; SellGroupProfit=0; //���롢������ɽ�������
  //    BuyLimitOrders=0; SellLimitOrders=0; //�������ƹҵ����������ƹҵ������ܼ�*/
      //��ʼ����������
     // MyArrayRange = OrdersTotal() + 1;
     // ArrayResize(OrdersArray, MyArrayRange); //���½綨����
     // ArrayInitialize(OrdersArray, 0.0); //��ʼ������
    
      if (OrdersTotal()>0)
         {
           
            //�����ֲֵ�,��������
            for (int cnt=0; cnt<OrdersTotal(); cnt++)
               {
               //   iWait();
                  //ѡ�е�ǰ���Ҷ���سֲֶ���
                  if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()== MyMagicNum)//
                  {   
                    //    TZM=TZM+1;
                        Profit += OrderProfit();
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
                           OpenPriceSum_B += OrderOpenPrice();
                          // MAXTZM_B = MAXTZM_B + (OrderOpenPrice()*OrderLots());
                          // HAND_B += OrderLots();
                           Ticket_BUY = OrderTicket();
             
                           BuyGroupOrders += 1; //�����鶩������
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