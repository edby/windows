//+------------------------------------------------------------------+
//|                                                autosendorder.mq4 |
//|                                                              ghy |
//|                                                              123 |
//+------------------------------------------------------------------+
#property copyright "ghy"
#property link      "123"
#property show_inputs
#include <WinUser32.mqh>
extern string ��Թ���ʽ = "0:BUY 1:SELL 2:BUYLIMIT";
extern string ˵������ = "3:SELLLIMIT 4:BUYSTOP 5:SELLSTOP";
extern int ����ʽ = 4;
extern double �������� = 0.1;
 double ���̼۸� = 1700.00;
extern int ��������=3;
extern double ֹ��ˮƽ = 0.00;
extern double ӯ��ˮƽ = 0.00;
extern string ע���ı�="jdzh";
extern int MagicNumber=111;


//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   while(true)
   {
      if(����ʽ==0)//OP_BUY
      {
         ���̼۸�=Ask;
         PendSec();break;
      }
      else
      {
         if(����ʽ==1)//OP_SELL
         {
         ���̼۸�=Bid;
         PendSec();break;}
      }
      if(Ask>���̼۸�)
      {
         if(����ʽ==2)//OP_BUYLIMIT
         {PendSec();break;}
         else
         {
            if(����ʽ==5)//OP_SELLSTOP
            {PendSec();break;}
            else
            {
               Print("�ҵ���Ϣ����");break;
            }
         }
      }
      else
      {
         if(Ask<���̼۸�)
         {
            if(����ʽ==3)//OP_SELLLIMIT
            {PendSec();break;}
            else
            {
               if(����ʽ==4)//OP_BUYSTOP
               {PendSec();break;}
               else
               {
                  Print("�ҵ���Ϣ����");break;
               }
            }
         }
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+
void PendSec()
{
   iWait();
   if(!OrderSend(Symbol(),����ʽ,��������,���̼۸�,��������,ֹ��ˮƽ,ӯ��ˮƽ,ע���ı�,MagicNumber))
   {Print("�ҵ�ʧ�ܣ�");}
   else{Print("ok");}
}
//=================================================================================
/*
��    �������׷�æ������ȴ������»�������
���������
���������
�㷨˵����
*/
void iWait() 
   {
      while (!IsTradeAllowed() || IsTradeContextBusy()) Sleep(1000);
      RefreshRates();
      return(0);
   }

