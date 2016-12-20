//+------------------------------------------------------------------+
//|                                      Designed by OKwh, China    |


int init()  {}

bool fff = true;//用于保证只运行一次，Script本来就是一次，若用EA来做时需要
int start()
{
if (fff)
{  Print ("?? ",IsExpertEnabled( )," ",OrdersTotal( ),"  ",HistoryTotal());
string bs = "",csl="",cp="";
fff = false;
int i=0;
  int fh = FileOpen("better.csv",FILE_CSV|FILE_WRITE);
if(fh>0)
  {
  FileWrite(fh," 交易历史 : ",HistoryTotal());
  FileWrite(fh,"编号","买/卖","开仓时间","平仓时间","持仓时间","开仓价格","平仓价格","盈亏点数","止损","止赢",
    "货币" ,"手数","赢利金额");
  int    orders=HistoryTotal(); 
  if(orders >0)
  {
    for(i=orders;i>0;i--)
    { if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)  
    {csl = "无";cp="无";
      if (OrderType( )==OP_BUY) 
    {bs ="买";
    if (OrderTakeProfit( )>0.0) cp = DoubleToStr((-OrderOpenPrice()+OrderTakeProfit( ))/Point,0) ;
    if (OrderStopLoss( )>0.0) csl = DoubleToStr((-OrderStopLoss()+OrderOpenPrice( ))/Point,0) ;
      FileWrite(fh,OrderTicket(),bs ,TimeToStr(OrderOpenTime()),TimeToStr(OrderCloseTime ()),(OrderCloseTime ()-OrderOpenTime())/60,
        OrderOpenPrice(),OrderClosePrice (),-(OrderOpenPrice()-OrderClosePrice ())/Point,csl,cp,
    OrderSymbol( ) ,OrderLots(),OrderProfit( ));
    }
      else if (OrderType( )==OP_SELL) 
  {bs ="卖";
  if (OrderTakeProfit( )>0.0) cp = DoubleToStr((OrderOpenPrice()-OrderTakeProfit( ))/Point,0) ;
    if (OrderStopLoss( )>0.0) csl = DoubleToStr((OrderStopLoss()-OrderOpenPrice( ))/Point,0) ;
    
        FileWrite(fh,OrderTicket(),bs ,TimeToStr(OrderOpenTime()),TimeToStr(OrderCloseTime ()),(OrderCloseTime ()-OrderOpenTime())/60,
        OrderOpenPrice(),OrderClosePrice (),(OrderOpenPrice()-OrderClosePrice ())/Point,csl,cp,
    OrderSymbol( ) ,OrderLots(),OrderProfit( ));
    }
    }
    }
    }
    else FileWrite(fh," 没有记录！ ");
    FileClose(fh);
  }
    else Alert("无法创建文件！检查文件是否存在！");

  }
  return(0);
}
//+------------------------------------------------------------------+