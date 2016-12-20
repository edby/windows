//+------------------------------------------------------------------+
//|                                                autosendorder.mq4 |
//|                                                              ghy |
//|                                                              123 |
//+------------------------------------------------------------------+
#property copyright "ghy"
#property link      "123"
#property show_inputs
#include <WinUser32.mqh>
extern string 针对购买方式 = "0:BUY 1:SELL 2:BUYLIMIT";
extern string 说明如右 = "3:SELLLIMIT 4:BUYSTOP 5:SELLSTOP";
extern int 购买方式 = 4;
extern double 购买手数 = 0.1;
 double 收盘价格 = 1700.00;
extern int 允许滑点数=3;
extern double 止损水平 = 0.00;
extern double 盈利水平 = 0.00;
extern string 注释文本="jdzh";
extern int MagicNumber=111;


//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   while(true)
   {
      if(购买方式==0)//OP_BUY
      {
         收盘价格=Ask;
         PendSec();break;
      }
      else
      {
         if(购买方式==1)//OP_SELL
         {
         收盘价格=Bid;
         PendSec();break;}
      }
      if(Ask>收盘价格)
      {
         if(购买方式==2)//OP_BUYLIMIT
         {PendSec();break;}
         else
         {
            if(购买方式==5)//OP_SELLSTOP
            {PendSec();break;}
            else
            {
               Print("挂单信息有误！");break;
            }
         }
      }
      else
      {
         if(Ask<收盘价格)
         {
            if(购买方式==3)//OP_SELLLIMIT
            {PendSec();break;}
            else
            {
               if(购买方式==4)//OP_BUYSTOP
               {PendSec();break;}
               else
               {
                  Print("挂单信息有误！");break;
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
   if(!OrderSend(Symbol(),购买方式,购买手数,收盘价格,允许滑点数,止损水平,盈利水平,注释文本,MagicNumber))
   {Print("挂单失败！");}
   else{Print("ok");}
}
//=================================================================================
/*
函    数：交易繁忙，程序等待，更新缓存数据
输入参数：
输出参数：
算法说明：
*/
void iWait() 
   {
      while (!IsTradeAllowed() || IsTradeContextBusy()) Sleep(1000);
      RefreshRates();
      return(0);
   }

