//+------------------------------------------------------------------+
//|                                      Designed by OKwh, China    |

int SignalBS =0;
datetime startTime=NULL, endTime = NULL;
color    SignalPriceBUY = Red;//Yellow;
color    SignalPriceSELL = Lime;//Cyan;
double startPrice, endprice;

int init()  {}

bool fff = true;//���ڱ�ֻ֤����һ�Σ�Script��������һ�Σ�����EA����ʱ��Ҫ
int start()
{
if (fff)
{  Print ("?? ���ļ���¼���ݻ��ƽ�����ʷ");
string bs = "",tmp="";
fff = false;
string tmps ="";

ObjectsDeleteAll();

int i=0;
  int fh = FileOpen("better.csv",FILE_CSV|FILE_READ);
if(fh>0)
  {
    while(!FileIsLineEnding(fh) ) FileReadString(fh);//������һ��
    while(!FileIsLineEnding(fh) ) tmp =FileReadString(fh);//�����ڶ���
    //Print("open file1 ",FileReadString(fh));
    while (!FileIsEnding(fh))
    {
      int code = FileReadNumber(fh);//"���"
      if (FileReadString(fh)=="��")  SignalBS =1; //"��/��"
      else  SignalBS =-1; 
      startTime = StrToTime(FileReadString(fh));//"����ʱ��",
      endTime = StrToTime(FileReadString(fh));//"ƽ��ʱ��",
  //  Print("open ",startPrice);
      FileReadString(fh);//"�ֲ�ʱ��"
      startPrice = FileReadNumber(fh);//"���ּ۸�"
      endprice = FileReadNumber(fh);//"ƽ�ּ۸�
  /*    if (code == 5166297) 
      {
      Print("open ",code," ",startPrice," ",endprice);
            Print("open ",code," ",TimeToStr(startTime)," ",TimeToStr(endTime));
            }
*/
      FileReadNumber(fh);//"ӯ������"
      FileReadNumber(fh);//"ֹ��"
      FileReadNumber(fh);//"ֹӮ"
      FileReadString(fh);//"����"
      FileReadNumber(fh);//"����"
      FileReadNumber(fh);//"Ӯ�����"
      SetBS();
    }
    FileClose(fh);
  }
  else Alert("�޷����ļ�������ļ��Ƿ���ڣ�");
  }
  return(0);
}
//+------------------------------------------------------------------+


void SetBS()
{
int ttt = MathRand( );
if (SignalBS == 1)
  {
//  ObjectDelete("BUY SIGNAL: " + TimeToStr(startTime));
//  ObjectDelete("BUY : " + TimeToStr(endTime));
//  ObjectDelete("BUY Close: " + TimeToStr(endTime));
  ObjectCreate("BUY SIGNAL: " + TimeToStr(startTime)+ttt  ,OBJ_ARROW,0,startTime,startPrice);
  ObjectSet("BUY SIGNAL: " + TimeToStr(startTime)+ttt,OBJPROP_ARROWCODE,5);
  ObjectSet("BUY SIGNAL: " + TimeToStr(startTime)+ttt,OBJPROP_COLOR,SignalPriceBUY);
  ObjectCreate("BUY : " + TimeToStr(endTime)+ttt,OBJ_TREND,0,startTime,startPrice,endTime,endprice);
  ObjectSet("BUY : " + TimeToStr(endTime)+ttt,OBJPROP_COLOR,SignalPriceBUY);
  ObjectSet("BUY : " + TimeToStr(endTime)+ttt,OBJPROP_RAY,false);
  ObjectSet("BUY : " + TimeToStr(endTime)+ttt,OBJPROP_STYLE,STYLE_DOT);
  ObjectCreate("BUY Close: " + TimeToStr(endTime)+ttt,OBJ_ARROW,0,endTime,endprice);
  ObjectSet("BUY Close: " + TimeToStr(endTime)+ttt,OBJPROP_ARROWCODE,5);
  ObjectSet("BUY Close: " + TimeToStr(endTime)+ttt,OBJPROP_COLOR,Tan);
  }
if (SignalBS == -1)
  {
  
//  ObjectDelete("SELL SIGNAL: " + TimeToStr(startTime));
//  ObjectDelete("SELL : " + TimeToStr(endTime));
//  ObjectDelete("SELL Close: " + TimeToStr(endTime));  ObjectCreate("SELL SIGNAL: " + TimeToStr(startTime),OBJ_ARROW,0,startTime,startPrice);
  ObjectSet("SELL SIGNAL: " + TimeToStr(startTime)+ttt,OBJPROP_ARROWCODE,5);
  ObjectSet("SELL SIGNAL: " + TimeToStr(startTime)+ttt,OBJPROP_COLOR,SignalPriceSELL);
  ObjectCreate("SELL : " + TimeToStr(endTime)+ttt,OBJ_TREND,0,startTime,startPrice,endTime,endprice);
  ObjectSet("SELL : " + TimeToStr(endTime)+ttt,OBJPROP_COLOR,SignalPriceSELL);
  ObjectSet("SELL : " + TimeToStr(endTime)+ttt,OBJPROP_RAY,false);
  ObjectSet("SELL : " + TimeToStr(endTime)+ttt,OBJPROP_STYLE,STYLE_DOT);
  ObjectCreate("SELL Close: " + TimeToStr(endTime)+ttt,OBJ_ARROW,0,endTime,endprice);
  ObjectSet("SELL Close: " + TimeToStr(endTime)+ttt,OBJPROP_ARROWCODE,5);
  ObjectSet("SELL Close: " + TimeToStr(endTime)+ttt,OBJPROP_COLOR,Green);
  }
}