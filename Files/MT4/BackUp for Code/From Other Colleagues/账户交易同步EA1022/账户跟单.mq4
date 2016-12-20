//+------------------------------------------------------------------+
//|                                                     �˻�����.mq4 |
//|                            Copyright 2013, ���ǻ�������Ȩ����. |
//|                                       http://www.jinding9999.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, ���ǻ�������Ȩ����."
#property link      "http://www.jinding9999.com"

extern string �ļ�����  = "MyAccountData1.csv";
string MyFileName;
//extern string ��Ʒ2 = "GBPUSD";
extern bool ѡ����ҵ� = true;
bool GFlag;
extern double ������������ = 1;
double MyLotsPercent;
extern double �ҵ�������� = 30;
double MyInterval;
extern int ���� = 5;
double huadian;
extern double ���������� = 201310181638;
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
   if(Digits == 3 || Digits == 5)  MyPoint = Point / 0.1;  //Digits:��ǰ���ҶԵĻ���С��λ;Point:ͼ��ĵ�ֵ
   else MyPoint = Point;
   
   MyFileName = �ļ�����;
   GFlag = ѡ����ҵ�;
   MyLotsPercent = ������������;
   MyInterval = �ҵ��������*MyPoint;
   huadian = ����*MyPoint;
   MyMagicNum = ����������;
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
         Print("��Ʒ��ƥ�䣡");
         return;
      }
      
      MyOrdersCount = iOrdersCount();
      
     //  Print("MyOrdersCount="+MyOrdersCount);  
       //  Print("MyTotal="+MyTotal);  
      if(MyTotal == MyOrdersCount)     
         return;
      int iOrderType = 6;  
      if(MyTotal > MyOrdersCount) //����
      { //Print("��������");
         int MyType =  StrToInteger(GetType);
       //  Print("MyType="+MyType);
         if(MyType != 0 && MyType != 1)
            return;
         double MyLots = NormalizeDouble(StrToDouble(GetLots)*MyLotsPercent,2);  
         
         if(MyType == 0)
         {Print("��Kong��");
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
            { Print("�Ҷ൥");
               iOrderType = OP_BUYSTOP;
               MyOpenPrice = Ask + MyInterval;
            }
            else
            {Print("���൥");
               iOrderType = OP_BUY;
               MyOpenPrice = Ask; 
            }
         }   
         string MyCommentTiket = GetTicket;
         OrderSend(Symbol(),iOrderType,MyLots,MyOpenPrice,huadian,0,0,MyCommentTiket,MyMagicNum);
      }
      if(MyTotal < MyOrdersCount)//ƽ��
      {Print("ƽ��");
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
////TZM,Symbol(),OrdersArray[i][0],OrdersArray[i][3],OrdersArray[i][4],MyOrderTicket,"3��������","4������",
int MyReadFile(string FileName)
{  
   int MyHandle = FileOpen(FileName,FILE_BIN|FILE_READ);
   //Print("MyHandle="+MyHandle);
   if(MyHandle == -1)
      return(0);
   string MyValue = FileReadString(MyHandle,60);
   int MyCnt1 = StringFind(MyValue,",",0);   //�ܵ���
   MyOrdersTotal = StringSubstr(MyValue,0,MyCnt1);
   int MyCnt2 = MyCnt1;
   
   MyCnt1 = StringFind(MyValue,",",MyCnt2+1); //��Ʒ����
   GetSymbol = StringSubstr(MyValue,MyCnt2+1,MyCnt1 - MyCnt2 -1);
   MyCnt2 = MyCnt1;
   
   MyCnt1 = StringFind(MyValue,",",MyCnt2+1);//����������
   GetComment = StringSubstr(MyValue,MyCnt2+1,MyCnt1 - MyCnt2 -1);
   MyCnt2 = MyCnt1;
   
   MyCnt1 = StringFind(MyValue,",",MyCnt2+1); //����
   GetTicket = StringSubstr(MyValue,MyCnt2+1,MyCnt1 - MyCnt2 -1);
   MyCnt2 = MyCnt1;
   
   MyCnt1 = StringFind(MyValue,",",MyCnt2+1);//��������
   GetType = StringSubstr(MyValue,MyCnt2+1,MyCnt1 - MyCnt2 -1);
   MyCnt2 = MyCnt1;
   
   MyCnt1 = StringFind(MyValue,",",MyCnt2+1);//��������
   GetLots = StringSubstr(MyValue,MyCnt2+1,MyCnt1 - MyCnt2 -1);
   
   
   
   
   FileClose(MyHandle);
   return(1);
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

int iOrdersCount()
      {
         int iOrdersCount = 0;
      //   Print("OrdersTotal="+OrdersTotal());
         for(int i=0;i < OrdersTotal();i++)
         {
             iWait();
                  //ѡ�е�ǰ���Ҷ���سֲֶ���
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol()== Symbol() && OrderMagicNumber() == MyMagicNum)
            {
               iOrdersCount += 1; 
            }  
         }
         return(iOrdersCount);
      }