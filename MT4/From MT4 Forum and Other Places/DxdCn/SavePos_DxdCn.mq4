//+------------------------------------------------------------------+
//|                                      Designed by OKwh, China    |


int init()  {}

bool fff = true;//���ڱ�ֻ֤����һ�Σ�Script��������һ�Σ�����EA����ʱ��Ҫ
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
  FileWrite(fh," ������ʷ : ",HistoryTotal());
  FileWrite(fh,"���","��/��","����ʱ��","ƽ��ʱ��","�ֲ�ʱ��","���ּ۸�","ƽ�ּ۸�","ӯ������","ֹ��","ֹӮ",
    "����" ,"����","Ӯ�����");
  int    orders=HistoryTotal(); 
  if(orders >0)
  {
    for(i=orders;i>0;i--)
    { if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==true)  
    {csl = "��";cp="��";
      if (OrderType( )==OP_BUY) 
    {bs ="��";
    if (OrderTakeProfit( )>0.0) cp = DoubleToStr((-OrderOpenPrice()+OrderTakeProfit( ))/Point,0) ;
    if (OrderStopLoss( )>0.0) csl = DoubleToStr((-OrderStopLoss()+OrderOpenPrice( ))/Point,0) ;
      FileWrite(fh,OrderTicket(),bs ,TimeToStr(OrderOpenTime()),TimeToStr(OrderCloseTime ()),(OrderCloseTime ()-OrderOpenTime())/60,
        OrderOpenPrice(),OrderClosePrice (),-(OrderOpenPrice()-OrderClosePrice ())/Point,csl,cp,
    OrderSymbol( ) ,OrderLots(),OrderProfit( ));
    }
      else if (OrderType( )==OP_SELL) 
  {bs ="��";
  if (OrderTakeProfit( )>0.0) cp = DoubleToStr((OrderOpenPrice()-OrderTakeProfit( ))/Point,0) ;
    if (OrderStopLoss( )>0.0) csl = DoubleToStr((OrderStopLoss()-OrderOpenPrice( ))/Point,0) ;
    
        FileWrite(fh,OrderTicket(),bs ,TimeToStr(OrderOpenTime()),TimeToStr(OrderCloseTime ()),(OrderCloseTime ()-OrderOpenTime())/60,
        OrderOpenPrice(),OrderClosePrice (),(OrderOpenPrice()-OrderClosePrice ())/Point,csl,cp,
    OrderSymbol( ) ,OrderLots(),OrderProfit( ));
    }
    }
    }
    }
    else FileWrite(fh," û�м�¼�� ");
    FileClose(fh);
  }
    else Alert("�޷������ļ�������ļ��Ƿ���ڣ�");

  }
  return(0);
}
//+------------------------------------------------------------------+