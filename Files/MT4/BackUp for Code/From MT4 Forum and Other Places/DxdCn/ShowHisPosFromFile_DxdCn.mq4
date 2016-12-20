//+------------------------------------------------------------------+
//|                                      Designed by OKwh, China    |

int SignalBS =0;
datetime startTime=NULL, endTime = NULL;
color    SignalPriceBUY = Red;//Yellow;
color    SignalPriceSELL = Lime;//Cyan;
double startPrice, endprice;

int init()  {}

bool fff = true;//用于保证只运行一次，Script本来就是一次，若用EA来做时需要
int start()
{
if (fff)
{  Print ("?? 从文件记录数据绘制交易历史");
string bs = "",tmp="";
fff = false;
string tmps ="";

ObjectsDeleteAll();

int i=0;
  int fh = FileOpen("better.csv",FILE_CSV|FILE_READ);
if(fh>0)
  {
    while(!FileIsLineEnding(fh) ) FileReadString(fh);//跳过第一行
    while(!FileIsLineEnding(fh) ) tmp =FileReadString(fh);//跳过第二行
    //Print("open file1 ",FileReadString(fh));
    while (!FileIsEnding(fh))
    {
      int code = FileReadNumber(fh);//"编号"
      if (FileReadString(fh)=="买")  SignalBS =1; //"买/卖"
      else  SignalBS =-1; 
      startTime = StrToTime(FileReadString(fh));//"开仓时间",
      endTime = StrToTime(FileReadString(fh));//"平仓时间",
  //  Print("open ",startPrice);
      FileReadString(fh);//"持仓时间"
      startPrice = FileReadNumber(fh);//"开仓价格"
      endprice = FileReadNumber(fh);//"平仓价格
  /*    if (code == 5166297) 
      {
      Print("open ",code," ",startPrice," ",endprice);
            Print("open ",code," ",TimeToStr(startTime)," ",TimeToStr(endTime));
            }
*/
      FileReadNumber(fh);//"盈亏点数"
      FileReadNumber(fh);//"止损"
      FileReadNumber(fh);//"止赢"
      FileReadString(fh);//"货币"
      FileReadNumber(fh);//"手数"
      FileReadNumber(fh);//"赢利金额"
      SetBS();
    }
    FileClose(fh);
  }
  else Alert("无法打开文件！检查文件是否存在！");
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