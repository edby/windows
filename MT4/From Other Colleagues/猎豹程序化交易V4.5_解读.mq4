#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#include <WinUser32.mqh>

extern string sNameEA = "_______ �Ա� 4.5 _______";
extern string sCopyright = "Copyright 2013, Forex Team";
extern double LicenseKey = 6128910;
extern string sDescript10 = "_______ 1.   _______";
extern string sDescript11 = "0 - 1 -  (BUY&SELL), 2 -  BUY, 3 -   SELL";
extern string sSymbols1 = "AUDCAD: 1; AUDCHF: 1; AUDJPY: 1; AUDNZD: 1; AUDUSD: 1; CADCHF: 1; CADJPY: 1; CHFJPY: 1; EURAUD: 1; EURCAD: 1; EURCHF: 1; EURGBP: 1; EURJPY: 1; EURNZD: 1; EURUSD: 1";
extern string sSymbols2 = "GBPAUD: 1; GBPCAD: 1; GBPCHF: 1; GBPJPY: 1; GBPNZD: 1; GBPUSD: 1; NZDCAD: 1; NZDCHF: 1; NZDGBP: 1; NZDJPY: 1; NZDUSD: 1; USDCAD: 1; USDCHF: 1; USDJPY: 1";
extern string sSymbols3 = "#AA: 2; #AIG: 2; #AXP: 2; #BA: 2; #BAC: 2; #C: 2; #CAT: 2; #CSCO: 2; #CVX: 2; #DD: 2; #DIS: 2; #EK: 2; #GE: 2; #HD: 2; #HON: 2; #HPQ: 2; #IBM: 2; #INTC: 2";
extern string sSymbols4 = "#IP: 2; #JNJ: 2; #JPM: 2; #KO: 2; #KFT: 2; #MCD: 2; #MMM: 2; #MO: 2; #MRK: 2; #MSFT: 2; #PFE: 2; #PG: 2; #T: 2; #TRV: 2; #UTX: 2; #VZ: 2; #WMT: 2; #XOM: 2";
extern string sSymbols5 = "GOLD: 1; SILVER: 1";
extern int CountOfCycles = 5;//�������ҶԵļ��
extern string sUseBuy = "";//
extern string sUseSell = "";//
extern int dUseOnlyPlusSwaps = 0;//
extern string sUseOnlyPlusSwaps = "";//
extern int dMaxSpreadForTradeSymbol = 12;//
extern string sMaxSpreadForTradeSymbol = "GOLD: 100";
string gs_232 = "";
string gs_240 = "";
string gs_248 = "";
string gs_256 = "";
extern string sDescript20 = "_________ 2.   _________";
extern double dRisk = 0.01;
extern string sRisk = "";
extern int MaxOrdersCount = 0;//������0�����������н�ִ��if (OrdersTotal() >= MaxOrdersCount) continue;
extern int dMaxSymbolOrdersCount = 7;
extern string sMaxSymbolOrdersCount = "";
extern double MaxOpenValPosition = 7.0;
extern int dUseOneWayRealOrdersB = 1;
extern string sUseOneWayRealOrdersB = "";
extern int dUseOneWayRealOrdersS = 1;
extern string sUseOneWayRealOrdersS = "";
extern double dMinDistanceRealOrdersB_PR = 3.0;
extern string sMinDistanceRealOrdersB_PR = "";
extern double dMinDistanceRealOrdersS_PR = 3.0;
extern string sMinDistanceRealOrdersS_PR = "";
extern string sDescript30 = "_______ 3.   _______";//���ڳɽ��ֲֵ��Ĵ���
extern int dFixedTakeProfit = 0;//�̶�TP
extern string sFixedTakeProfit = "";
extern int dFixedStopLoss = 0;//�̶�SL
extern string sFixedStopLoss = "";
extern int dTimeStopLoss_Minutes = 0;
extern string sTimeStopLoss_Minutes = "";
extern double TimeSL_OnlyAfterDistance_PR = 0.0;
extern double dProfitForBreakevenSL_PR = 0.5;//�ƶ�ֹ��ʱ���ּ۸߳�����ڿ��ּ۵ı���
extern int dTrailingStop = 0;
extern string sTrailingStop = "";
extern int dStepTrailingStop = 0;
extern string sStepTrailingStop = "";
extern double dTrailingStop_PR = 1.0;//�ƶ�ֹ��ʱ�����ּ۵ı������ּ۱Ƚ�
extern double dStepTrailingStop_PR = 0.1;//�ƶ�ֹ��ʱ�����ּ۵ı������ּ۱Ƚ�
extern int dDeleteTPWhenTrailing = 1;//�ƶ�ֹ��ʱ����ֹӯΪ��
extern int CloseOrdersOppositeTrend_OsMA = 0;
extern int CloseOrdersOppositeTrend_SAR = 0;
extern int CloseOrdersOppositeTrend_ALL = 1;
extern int CloseOOT_OnlyAfterMinutes = 0;//����=0��ƽ��ʱ��ﵽTimeCurrent() - OrderOpenTime() < 60 * CloseOOT_OnlyAfterMinutes��������ƽ
extern double CloseOOT_OnlyAfterDistance_PR = 0.0;//����=0��ƽ��ʱ�۸���ﵽһ����������ƽ���൱��һ��ֹ��
extern int BlockOpenWorseOrder_Minutes = 1440;
int gi_unused_500 = 0;
int gi_504 = 0;
int gi_508 = 0;
string gs_512 = "";
int gi_520 = 0;
string gs_524 = "";
int gi_532 = 0;
string gs_536 = "";
int gi_544 = 17;
string gs_548 = "";
int gi_556 = 17;
string gs_560 = "";
int gi_568 = 83;
string gs_572 = "";
int gi_580 = 83;
string gs_584 = "";
int gi_592 = 0;
string gs_596 = "";
int gi_604 = 0;
string gs_608 = "";
int gi_616 = 0;
string gs_620 = "";
int gi_628 = 0;
string gs_632 = "";
int gi_640 = 0;
string gs_644 = "";
int gi_652 = 0;
string gs_656 = "";
extern string sDescript40 = "_______ 4.   _______";
extern int CR_UseCorrection = 1;
extern double CR_WaitCorrectionAfterMove_PR = 1.2;
extern double CR_WaitCorrectionAfterFlat_PR = 0.2;
extern double CR_MaxDistanceFromBottom_PR = 0.1; 
extern double CR_SizeCorrection_PR = 0.4;
extern double CR_StopLoss_PR = 0.0;//SL����Ϊ�ּ����µİٷֱ�
extern int CR_StopLoss_UseSAR = 0;//CR_StopLoss_UseSAR,SL: gd_2400 = g_isar_2640;
extern int CR_UseTrailingStop = 1;
extern int CR_AnalizMove_Period = 5;
extern int CR_AnalizMove_CountBars = 6;
extern int CR_AnalizFlat_Period = 2;
extern int CR_AnalizFlat_CountBars = 2;
extern string sDescript50 = "_______ 5.   _______";//FlatIndicator��ص�
extern int dUseFlatIndicator = 1;
extern string sUseFlatIndicator = "";
extern double diFL_MinWidthCanal_PR = 0.1;
extern string siFL_MinWidthCanal_PR = "";
extern double diFL_MaxWidthCanal_PR = 0.4;
extern string siFL_MaxWidthCanal_PR = "";
extern int diFL_MinExtremumsCount = 1;
extern string siFL_MinExtremumsCount = "";
extern int diFL_Period = 2;
extern string siFL_Period = "";
extern int diFL_CountBars = 8;
extern string siFL_CountBars = "";
extern int diFL_UseConditionTakeOver = 1;
extern int diFL_PeriodTakeOver = 4;
extern int diFL_CountBarsTakeOver = 2;
extern double diFL_StopLoss_PR = 0.0;
extern string siFL_StopLoss_PR = "";
extern int diFL_StopLoss_UseSAR = 0;
extern int FL_UseTrailingStop = 0;
extern double diFL_LotSizeMultiply = 1.0;
extern string siFL_LotSizeMultiply = "";
extern string sDescript60 = "_______ 6.   _______";
extern string sDescript61 = "6.1.  Parabolic SAR"; //���ڼ���SAR���õ��Ĳ���
extern int dUseTrendOrders_ParabolicSAR = 0;
extern int diSAR_RO_TimeFrame = 5;
extern double diSAR_RO_Step = 0.02;//
extern double diSAR_RO_Maximum = 0.2;
extern string sDescript62 = "6.2.   Stochastic";
extern int dUseOrders_Stochastic = 1;
extern int diStoch_RO_TimeFrame = 5;
extern int diStoch_RO_KPeriod = 5;
extern int diStoch_RO_DPeriod = 3;
extern int diStoch_RO_Slowing = 3;
extern int diStoch_RO_Method = 2;
extern int diStoch_RO_Price = 0;
extern double diStoch_RO_TakeProfit_PR = 1.0;
extern double diStoch_RO_StopLoss_PR = 0.0;
extern int diStoch_RO_ReverseClose = 1;
extern int diStoch_RO_RevCloseOnlyProfit = 1;
extern int diStoch_RO_UseAverageTP = 0;
extern string sDescript63 = "6.3.   ADX";
extern int dUseTrendOrders_ADX = 1;
extern int diADX_RO_TimeFrame = 5;
extern int diADX_RO_Period = 14;
extern int diADX_RO_TypePrice = 6;
extern double diADX_RO_ValueToCloseOrders = 60.0;
extern double diADX_RO_ValueSignalTrend = 20.0;
extern double diADX_RO_ValueSignalEndTrend = 15.0;
extern double diADX_RO_TakeProfit_PR = 3.0;
extern double diADX_RO_StopLoss_PR = 0.0;
extern int diADX_RO_CloseOnlyProfit = 1;
extern int diADX_RO_UseAverageTP = 0;
extern string sDescript64 = "6.4.   CCI";
extern int dUseOrders_CCI = 1;
extern int diCCI_RO_TimeFrame = 6;
extern int diCCI_RO_Period_Slow = 125;
extern int diCCI_RO_Period_Medium = 25;
extern int diCCI_RO_Period_Fast = 5;
extern int diCCI_RO_TypePrice = 0;
extern double diCCI_RO_TakeProfit_PR = 3.0;
extern double diCCI_RO_StopLoss_PR = 0.0;
extern int diCCI_RO_ReverseClose = 1;
extern int diCCI_RO_RevCloseOnlyProfit = 1;
int gi_1112 = 0;
extern string sDescript80 = "_______ 8.  _______";
extern string sDescript81 = "8.1  Accelerator";
extern int dUseAcceleratorIndicator = 0;
extern string sUseAcceleratorIndicator = "";
extern int diAC_CountBars = 3;
extern string siAC_CountBars = "";
extern int diAC_CountTimeFrames = 1;
extern string siAC_CountTimeFrames = "";
extern int diAC_StartTimeFrame = 1;
extern string siAC_StartTimeFrame = "";
extern string sDescript82 = "8.2.  Speed";
extern int dUseSpeedIndicator = 1;
extern string sUseSpeedIndicator = "";
extern int diSP_CountBars = 2;
extern string siSP_CountBars = "";
extern int diSP_CountTimeFrames = 2;
extern string siSP_CountTimeFrames = "";
extern int diSP_StartTimeFrame = 1;
extern string siSP_StartTimeFrame = "";
int gi_1236 = 0;
string gs_1240 = "";
double gd_1248 = 0.0005;
string gs_1256 = "";
int gi_1264 = 1;
string gs_1268 = "";
int gi_1276 = 35;
string gs_1280 = "";
extern string sDescript83 = "8.3. HighLowLimit";
extern int dCountHighLowLimits = 2;
extern string sCountHighLowLimits = "";
extern double diHL_LimitDistance1_PR = 1.0;
extern string siHL_LimitDistance1_PR = "";
extern int diHL_Period1 = 5;
extern string siHL_Period1 = "";
extern int diHL_CountBars1 = 6;
extern string siHL_CountBars1 = "";
extern double diHL_LimitDistance2_PR = 5.0;
extern string siHL_LimitDistance2_PR = "";
extern int diHL_Period2 = 7;
extern string siHL_Period2 = "";
extern int diHL_CountBars2 = 2;
extern string siHL_CountBars2 = "";
extern string sDescript84 = "8.4  OsMA";//�����ƶ���ƽ������ָ��Ĳ���
extern int dUseTrendFilterOsMA = 1;
extern int diOsMA_TimeFrame = 6;//1��Ϊ����
extern int diOsMA_FastEMA = 12;
extern int diOsMA_SlowEMA = 26;
extern int diOsMA_SignalSMA = 9;
extern int diOsMA_TypePrice = 6;
extern string sDescript85 = "8.5 Parabolic SAR";//diSAR_Filter_TimeFrame
extern int dUseTrendFilterSAR = 1;
extern int diSAR_Filter_TimeFrame = 6;
extern double diSAR_Filter_Step = 0.02;
extern double diSAR_Filter_Maximum = 0.2;
extern string sDescript86 = "8.6.   ADX";
extern int dUseTrendFilterADX = 1;
extern int diADX_Filter_TimeFrame = 5;
extern int diADX_Filter_Period = 14;
extern int diADX_Filter_TypePrice = 6;
extern double diADX_Filter_ValueSignalTrend = 20.0;
extern string sDescript87 = "8.7  ";
extern int dUseFilterMaxMin = 1;
extern int dMaxMin_Filter_TimeFrame = 7;
extern int dMaxMin_Filter_CountBars = 12;
extern double dMaxMin_LimitDistance_PR = 0.4;
extern string sDescript90 = "_______ 9.  _______";
extern string sDescript91 = "TypeOfQuoteDigits -  : 0 - 1 -  2 -";
extern int TypeOfQuoteDigits = 0;
extern string sDescript92 = "CustomNameForCurrencyPair -";
extern string CustomNameForCurrencyPair = "AAABBB";
extern double dMinLotSize = 0.01;
extern string sMinLotSize = "";
extern double dMaxLotSize = 0.0;
extern string sMaxLotSize = "";
extern double dStepLotSize = 0.01;
extern string sStepLotSize = "";
extern int dSlipPage = 0;
extern string sSlipPage = "";
extern int Set_TP_SL_ByModifyOrder = 0; ////����1ʱ�����ݶ���ע���޸�ֹӯֹ��Ĵ�С
extern bool TestingOneSymbolMode = FALSE;
extern int InverseTrading = 0;
extern int OwnMagicPrefix = 5732;
extern string PrefixOrderComment = "�Ա� ";
extern bool PrintInfoOpenValPosition = FALSE;
extern bool CommentOrderOperations = TRUE; //ƽ�ֹ����е������Ϣ��ӡ���
extern bool PlaySoundWhenOpenOrder = FALSE;
extern string FileNameSoundOpenOrder = "alert.wav";
int gi_1652 = 1;
string gs_1656 = "";
int gi_1664 = 0;
int gi_1668 = 10;
string gs_1672 = "";
int gi_1680 = 50;
string gs_1684 = "";
int gi_1692 = 10;
int gi_unused_1696 = 0;
int gi_1700;
string gsa_1704[];
double gda_1708[];//MarketInfo(gsa_1704[li_0], MODE_POINT);��ǰ��λ�Ĵ�С��
double gda_1712[];//MarketInfo(gsa_1704[li_0], MODE_DIGITS);�ڻ��Ҷ�ֵ��С�����ļ�����
double gda_1716[];//MarketInfo(gsa_1704[l_index_0], MODE_SWAPLONG);���ǲ�λ���ڡ�
double gda_1720[];//MarketInfo(gsa_1704[l_index_0], MODE_SWAPSHORT);���ղ�λ����
int gia_1724[];//dUseOnlyPlusSwaps=0
int gia_1728[];
int gia_1732[];
double gda_1736[];
double gda_1740[];
double gda_1744[];
int gia_1748[];//dMaxSpreadForTradeSymbol = 12;
int gia_1752[];
int gia_1756[];
int gia_1760[];
int gia_1764[];
int gia_1768[];
int gia_1772[];
int gia_1776[];
int gia_1780[];
int gia_1784[];
int gia_1788[];
int gia_1792[];
int gia_1796[];
int gia_1800[];
int gia_1804[];
int gia_1808[];
int gia_1812[];
int gia_1816[];
int gia_1820[];
double gda_1824[];
double gda_1828[];
int gia_1832[];
int gia_1836[];
int gia_1840[];
int gia_1844[];
int gia_1848[];
int gia_1852[];
int gia_1856[];
int gia_1860[];
int gia_1864[];
int gia_1868[];
int gia_1872[];
double gda_1876[];
double gda_1880[];
double gda_1884[];
int gia_1888[];
double gda_1892[];
int gia_1896[];
int gia_1900[];
double gda_1904[];
int gia_1908[];
int gia_1912[];
int gia_1916[];
double gda_1920[];
double gda_1924[];
int gia_1928[];
int gia_1932[];
int gia_1936[];
double gda_1940[];
double gda_1944[];
double gda_1948[];//MAX��dMinLotSize=0.01��MODE_MINLOT��
double gda_1952[];//MIN(dMaxLotSize==0.0,MODE_MAXLOT)
double gda_1956[];//MAX(dStepLotSize=0.01, MODE_LOTSTEP)
int gia_1960[];//gi_1652 = 1
int gia_1964[];//dMaxSymbolOrdersCount = 7;
int gia_1968[];
int gia_1972[];
int gia_1976[];
string g_symbol_1980;
double gd_1988;
double gd_1996;
double g_bid_2004;
double g_ask_2012;
double g_spread_2020;
double g_stoplevel_2028;
double gd_2036;
int gi_2044;
int gi_2048;
int gi_2052;
int gi_2056;
int gi_2060;
int gi_2064;//TP�й�
int gi_2068;//SL�й�
int gi_2072;
int gi_2076;
int gi_2080;
int gi_2084;
int gi_2088;
int gi_2092;
int gi_2096;
int gi_2100;
int gi_2104;
int gi_2108;
int gi_2112;
int gi_2116;
double gd_2120;
double gd_2128;
int gi_2136;
int gi_2140;
int gi_2144;
int gi_2148;
int gi_2152;
int gi_2156;
int gi_2160;
int gi_2164;
int gi_2168;
int gi_2172;
int gi_2176;
double gd_2180;
int gi_2188;
int gi_2192;
int gi_2196;
double gd_2200;
int gi_2208;
int gi_2212;
double gd_2216;
int gi_2224;
int gi_2228;
int gi_2232;
double gd_2236;
double gd_2244;
int gi_2252;
int gi_2256;
int gi_2260;
double gd_2264;
double gd_2272;
int gi_2280;
double gd_2284;
double gd_2292;
double gd_2300;
int gi_2308;
int gi_2312;
int gi_2316;
bool gi_2320 = FALSE;
int g_day_2324 = 0;
int gi_2328;//OrderMagicNumber���
int g_count_2332 = 0;
int gi_2336;
double gd_unused_2340;
string g_acc_number_2348;
int gi_2356;//����������OrderType 
int gi_2360;
double gd_2368;//�������
double gd_2376;//�������
double gd_2384;
double gd_2400;
double gd_2408;
string gs_2416;
double g_price_2424;
double gd_2432;
double gd_2440;
double gd_2448;
double gd_2456;
double gd_2464;
int g_ticket_2472;
int gi_2476;//OrderType��������ʽ
int gi_2480;
int g_str2int_2484;
bool gi_2488;
bool gi_2492;
string gs_2496; //OrderType
int gi_2504;
int g_ord_total_2508 = 0;
string gsa_2512[]; //�洢��Ӧ���ҶԵ�����
double gda_2516[];
double gda_2520[];
double gd_2524;
double gda_2532[];
double gda_2536[];  ///ÿ�����������͵�ͳ��
int gia_2540[6]; ////��¼ÿ�����Ͷ����ĵ���
double gda_2544[6];////�洢ÿ�����Ͷ������ּ۵���Сֵ
double gda_2548[6];//�洢ÿ�����Ͷ������ּ۵����ֵ
double gda_2552[6];//�洢ÿ�����Ͷ���������
double gd_2556;//����,��gd_2556���أ�1:������-1��˥����0����һ��
double gd_2564;
double gda_2572[2];
double gda_2576[2];
double gd_2580;
double gd_2588;
bool gi_2596;
double g_ilow_2600;//FlatIndicator����ѡ�����м۸����Сֵ
double g_ihigh_2608;//FlatIndicator����ѡ�����м۸�����ֵ
double gd_2616;////gd_2616�����߼۵Ĳ�ֵ
double gd_2624;////=LicenseKey
double g_iosma_2632;
double g_isar_2640;//iSAR()
double gd_2648;
int gi_2656 = 0;
int gi_2660 = 1;
int gi_2664 = 2;
int gi_2668 = 3;
int gi_2672 = 4;
int gi_2676 = 5;
int gia_2680[10] = {1, 5, 15, 30, 60, 240, 1440, 10080, 43200, 0};

int init() 
{
   int l_count_4;
   int li_12;
   int li_16;
   bool li_20;
   string ls_24;
   string ls_32;
   string ls_40;
   string lsa_48[];
   string ls_52;
   double ld_60;
   int li_68;
   string ls_72;
   string ls_80;
   string ls_88;
   if (!CheckParameters()) //�����ⲿ����OwnMagicPrefix������214747�Ƚϴ�С���������򷵻�false��С�ڷ���true
   {
   //   MessageBox(" .", " ", MB_ICONHAND);
  //    gi_2320 = TRUE;
    //  Sleep(86400000);
   }
//---------------------------------------------------------------------------
//��ȡ��ǰ�˻���LicenseKey
   gd_unused_2340 = AccountNumber();
   g_acc_number_2348 = AccountNumber(); //��ǰ�˻�����

      if (StringLen(g_acc_number_2348) > 2) ls_52 = StringSubstr(g_acc_number_2348, 1, StringLen(g_acc_number_2348) - 2);
      else ls_52 = g_acc_number_2348; //�Ե�ǰ�˻����ֵĲ���ls_52
      li_68 = StrToInteger(ls_52);
      li_68 = li_68 % 123 + 123;
      ld_60 = li_68 * li_68;//�Ե�ǰ�˻����ֵĲ���ls_52��li_68��ld_60
      l_count_4 = 0;
      for (int li_0 = 0; li_0 < StringLen(g_acc_number_2348); li_0 += 2) {
         ls_52 = StringSubstr(g_acc_number_2348, li_0, 1);
         li_68 = StrToInteger(ls_52);
         if (li_68 != 0) {
            if (l_count_4 == 0) ld_60 *= li_68;
            else ld_60 += li_68;
         }
         l_count_4 = 1 - l_count_4;
      }
      for (li_0 = 1; li_0 < StringLen(g_acc_number_2348); li_0 += 2) {
         ls_52 = StringSubstr(g_acc_number_2348, li_0, 1);
         li_68 = StrToInteger(ls_52);
         if (li_68 != 0) {
            if (l_count_4 == 0) ld_60 *= li_68;
            else ld_60 += li_68;
         }
         l_count_4 = 1 - l_count_4;
      }
  //-----------------------------------------------------------------
      if (ld_60 != LicenseKey) {
         ls_72 = "  ";
         ls_80 = "  ";
         ls_88 = "e-mail: duxin@gmail.com";
         Print(ls_72);
         Print(ls_80);
         Print(ls_88);
      //   MessageBox(StringConcatenate(ls_72, 
        //    "\n", ls_80, 
      //   "\n", ls_88), " ", MB_ICONHAND);
     //    gi_2320 = TRUE;
       //  Sleep(86400000);
      }
//-----------------------------------------------------------------
//��ȡ���Ҷԣ��������Ϣ
   gi_2328 = 10000 * OwnMagicPrefix;
   gi_1700 = 0;
   for (int l_index_8 = 1; l_index_8 <= 5; l_index_8++) 
   {
      switch (l_index_8) {
      case 1:
         ls_24 = sSymbols1;
         break;
      case 2:
         ls_24 = sSymbols2;
         break;
      case 3:
         ls_24 = sSymbols3;
         break;
      case 4:
         ls_24 = sSymbols4;
         break;
      case 5:
         ls_24 = sSymbols5;
      }
      li_16 = glSeparateStringInArray(ls_24,lsa_48, ";");//��ls_24�еĻ��Ҷ����ͷֿ�������������lsa_48[]�У���󷵻��ܸ�����ֵ��li_16
      for (li_0 = 0; li_0 < li_16; li_0++) 
      {
         li_12 = StringFind(lsa_48[li_0], ":");
         if (li_12 != -1) 
         {
            ls_40 = glStringTrimAll(StringSubstr(lsa_48[li_0], li_12 + 1));//��ȡ���ҶԵ���������,����ls_40
            if (ls_40 == "1" || ls_40 == "2" || ls_40 == "3") //���ڱ������и������ⲿ����û�е���3�����
            {
               ls_32 = glStringTrimAll(StringSubstr(lsa_48[li_0], 0, li_12)); //һ����ȡ��Ӧ�Ļ��ҶԲ�������������ls_32��
               gi_1700++;        //��¼sSymbolsi�л��ҶԵĸ���
               ArrayResize(gsa_1704, gi_1700);
               ArrayResize(gia_1728, gi_1700);
               ArrayResize(gia_1732, gi_1700);
               gsa_1704[gi_1700 - 1] = ls_32; //�洢sSymbolsi�л��Ҷ�
               gia_1728[gi_1700 - 1] = 0; 
               gia_1732[gi_1700 - 1] = 0;
               if (ls_40 == "1" || ls_40 == "2") gia_1728[gi_1700 - 1] = 1; //ls_40==3ʱ��qia_1728[]=0   //���ڴ˳�����û��3�����
               if (ls_40 == "1" || ls_40 == "3") gia_1732[gi_1700 - 1] = 1; //��ô�����1��  ls_40==2ʱ��qia_1732[]=0
            }
         }
      }
   }
   ArrayResize(gda_1708, gi_1700);
   for (li_0 = 0; li_0 < gi_1700; li_0++) gda_1708[li_0] = MarketInfo(gsa_1704[li_0], MODE_POINT);
   ArrayResize(gda_1712, gi_1700);
   for (li_0 = 0; li_0 < gi_1700; li_0++) gda_1712[li_0] = MarketInfo(gsa_1704[li_0], MODE_DIGITS);
   ArrayResize(gda_1716, gi_1700);
   ArrayResize(gda_1720, gi_1700);
//--------------------------------------------------------------
//���Ӷ�Ӧ���Ҷ�CustomNameForCurrencyPair����ȡ���������ַ�����������gsa_2512[]
   gi_2504 = 0;
   ArrayResize(gsa_2512, gi_2504);
   for (li_0 = 0; li_0 < gi_1700; li_0++) 
   {
      if (IsCurrencyPair(gsa_1704[li_0], CustomNameForCurrencyPair)) 
      {
         for (l_count_4 = 0; l_count_4 < 2; l_count_4++) 
         {
            ls_32 = GetCurrencyFromSymbol(gsa_1704[li_0], l_count_4 + 1, CustomNameForCurrencyPair);
            li_20 = FALSE;
            for (l_index_8 = 0; l_index_8 < gi_2504; l_index_8++) 
            {
               if (gsa_2512[l_index_8] == ls_32) 
               {
                  li_20 = TRUE;
                  break;
               }
            }   //
            if (!li_20)   
            {    
               gi_2504++;
               ArrayResize(gsa_2512, gi_2504);
               gsa_2512[gi_2504 - 1] = ls_32;
            }
         }
      }
   }//gi_2504=2
//----------------------------------------------------
   ArrayResize(gda_2516, gi_2504); //�����СΪ2
   ArrayResize(gda_2520, gi_2504);
   ArrayResize(gda_2532, gi_2504);
   ArrayResize(gda_2536, gi_2504);
   GetSymbolsSettingsFromStrings();
   myGetSymbolSettingsDay();
   myAnalizCurrentStateGeneral();
   return (0);
}
//---------------------------------------------------------------------------------
//�����ⲿ����OwnMagicPrefix������214747�Ƚϴ�С���������򷵻�false��С�ڷ���true
bool CheckParameters() 
{
   bool li_ret_0 = TRUE;
   if (OwnMagicPrefix < 0) OwnMagicPrefix = -OwnMagicPrefix;
   if (OwnMagicPrefix > 214747) 
   {
      li_ret_0 = FALSE;
   }
   return (li_ret_0);
}
//--------------------------------------------------------------------------------------
//ȡ�û��ҶԶ�Ӧ�ĸ�����������
bool myGetSymbolParameters(int ai_0) 
{
   gi_2044 = gia_1728[ai_0];//�������� 0��1
   gi_2048 = gia_1732[ai_0];
   if (gi_2044 == 0 && gi_2048 == 0) return (FALSE);  //�������ֲ�Ϊ1ʱ���򷵻�false
   gd_1988 = gda_1708[ai_0]; //MODE_POINT
   gd_1996 = gda_1712[ai_0]; //MODE_DIGITS
   if (gd_1988 == 0.0) return (FALSE); //MIN_POINTΪ0.0ʱ������ִ���ҷ���false
   g_bid_2004 = MarketInfo(g_symbol_1980, MODE_BID);//����������
   g_ask_2012 = MarketInfo(g_symbol_1980, MODE_ASK);//�����������
   g_spread_2020 = MarketInfo(g_symbol_1980, MODE_SPREAD);//��۵㡣
   g_stoplevel_2028 = MarketInfo(g_symbol_1980, MODE_STOPLEVEL);//ֹͣˮƽ��
   gi_2052 = gia_1752[ai_0];  //sFixedTakeProfit���������֣�����ΪdFixedTakeProfit(0)
   gi_2056 = gia_1756[ai_0];  //sFixedStopLoss���������� ,����ΪdFixedStopLoss(0)
   gi_2060 = gia_1760[ai_0];  // gi_592 = 0;  gs_596=""/MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1760[l_index_0]);
   gi_2064 = gia_1764[ai_0];  // gi_604  =0   gs_608=""/MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1764[l_index_0]);
   gi_2068 = gia_1768[ai_0];  // gi_616 = 0;  gs_620=""/MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1768[l_index_0]);
   gi_2072 = gia_1772[ai_0];  // gi_628 = 0;  gs_632="/MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1772[l_index_0]);
   if (gi_2052 > 0) 
   {
      gi_2052 = MathMax(MarketInfo(g_symbol_1980, MODE_STOPLEVEL), gi_2052);
      gi_2060 = gi_2052;
      gi_2064 = gi_2052;
   }
   if (gi_2056 > 0) 
   {
      gi_2056 = MathMax(MarketInfo(g_symbol_1980, MODE_STOPLEVEL), gi_2056);
      gi_2068 = gi_2056;
      gi_2072 = gi_2056;
   }
   gi_2076 = gia_1776[ai_0];//dTimeStopLoss_Minutes=0
   gi_2080 = gia_1780[ai_0]; //gi_640=0
   gi_2084 = gia_1784[ai_0];//gi_652 = 0; MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1784[l_index_0]);
   gi_2088 = gia_1788[ai_0];//dTrailingStop = 0;    sTrailingStop/MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1788[l_index_0]);
   gi_2092 = gia_1792[ai_0];//dStepTrailingStop=0.1 sStepTrailingStop=""
   gi_2096 = gia_1800[ai_0];//gi_544=17 gs_548=""
   gi_2100 = gia_1804[ai_0];//gi_556=17 gs_560=""
   gi_2104 = gia_1808[ai_0];//gi_568=83 gs_572=""
   gi_2108 = gia_1812[ai_0];//gi_580=83 gs_584=""
   gi_2112 = gia_1816[ai_0];//dUseOneWayRealOrdersB=1           sUseOneWayRealOrdersB=""
   gi_2116 = gia_1820[ai_0];//dUseOneWayRealOrdersS=1           sUseOneWayRealOrdersS=""
   gd_2120 = gda_1824[ai_0];//dMinDistanceRealOrdersB_PR = 3.0; sMinDistanceRealOrdersB_PR=""
   gd_2128 = gda_1828[ai_0];//dMinDistanceRealOrdersS_PR = 3.0; sMinDistanceRealOrdersS_PR
   gi_2136 = gia_1832[ai_0];//gi_508 = 0; gs_512=""
   gi_2140 = gia_1836[ai_0];//gi_520 = 0; gs_524=""
   gd_2036 = gd_2292 + 56.0;//=34.0*LincenseKey+56.0
   gi_2144 = gia_1840[ai_0];//dUseAcceleratorIndicator = 0;sUseAcceleratorIndicator
   gi_2148 = gia_1844[ai_0];//diAC_CountBars = 3; siAC_CountBars
   gi_2152 = gia_1848[ai_0];//diAC_CountTimeFrames = 1;siAC_CountTimeFrames
   gi_2156 = gia_1852[ai_0];//diAC_StartTimeFrame = 1;siAC_StartTimeFrame
   gi_2160 = gia_1856[ai_0];//dUseSpeedIndicator = 1; sUseSpeedIndicator
   gi_2164 = gia_1860[ai_0];//diSP_CountBars = 2;    siSP_CountBars
   gi_2168 = gia_1864[ai_0];//diSP_CountTimeFrames = 2;  siSP_CountTimeFrames
   gi_2172 = gia_1868[ai_0];//diSP_StartTimeFrame = 1;   siSP_StartTimeFrame
   gi_2176 = gia_1872[ai_0];//gi_1236 = 0; gs_1240=""
   gd_2180 = gda_1876[ai_0];//gd_1248 = 0.0005; gd_1256=""
   gi_2188 = gda_1880[ai_0];//gi_1264 = 1;  gs_1268=""
   gi_2192 = gda_1884[ai_0];//gi_1276 = 35; gs_1280=""
   gi_2196 = gia_1888[ai_0];//dCountHighLowLimits=2
   gd_2200 = gda_1892[ai_0];//siHL_LimitDistance1_PR���������֣���diHL_LimitDistance1_PR
   gi_2208 = gia_1896[ai_0];//diHL_Period1=5
   gi_2212 = gia_1900[ai_0];//diHL_CountBars1=6
   gd_2216 = gda_1904[ai_0];//diHL_LimitDistance2_PR = 5.0; siHL_LimitDistance2_PR = ""
   gi_2224 = gia_1908[ai_0];//diHL_Period2=7
   gi_2228 = gia_1912[ai_0];//diHL_CountBars2=2
   gi_2232 = gia_1916[ai_0];//  UseFlatIndicator=1
   gd_2236 = gda_1920[ai_0];//diFL_MinWidthCanal_PR=0.1
   gd_2244 = gda_1924[ai_0];//diFL_MaxWidthCanal_PR=0.4
   gi_2252 = gia_1928[ai_0];//diFL_MinExtremumsCount=1
   gi_2256 = gia_1932[ai_0];//2
   gi_2260 = gia_1936[ai_0];//diFL_CountBars=8
   gd_2264 = gda_1940[ai_0];//DiFL_stopLoss_PR=0.0 
   gd_2272 = gda_1944[ai_0];//diFL_LotSizeMultiply = 1.0; siFL_LotSizeMultiply=""
   gi_2280 = gia_1960[ai_0];//gi_1652 = 1;  gi_1656=""
   gd_2284 = gda_1736[ai_0];//0��  gs_232 gs_240    
   gd_2300 = gda_1740[ai_0];//0��  gs_248 gs_256
   gi_2308 = gia_1964[ai_0];//dMaxSymbolOrdersCount =7
   gi_2312 = gia_1968[ai_0];//gi_1668 = 10; gs_1672=""
   gi_2316 = gia_1972[ai_0];//gi_1680 = 50; gs_1684=""
   return (TRUE);
}
//----------------------------------------------------------------------------

int deinit() 
{
   return (0);
}
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//GetSymbolsSettingsFromStrings();1* ����init�еĳ������飬Ҳ����������ص�����ֵ
// myGetSymbolSettingsDay();      2*
 //myAnalizCurrentStateGeneral(); 3*
int start() 
{
   myCheckAllowWorking();
   if (!( AccountNumber()== 217777804 || AccountNumber()== 607104 || AccountNumber()== 91147076 || AccountNumber()== 2205918 || AccountNumber()== 91350792 || AccountNumber()== 91349549 || AccountNumber()== 1293 || AccountNumber()== 91142736 || AccountNumber()== 91142735 || AccountNumber()== 11239985  || AccountNumber()== 50039342  || AccountNumber()== 91142705  || AccountNumber()== 115857 || AccountNumber()==2164612 || AccountNumber()==2164444 || AccountNumber()==2162307  || AccountNumber()==909546 || AccountNumber()== 2495499  || AccountNumber()==2162307 || AccountNumber()==43110 || AccountNumber()==42529 || AccountNumber()==2156298 || AccountNumber()==909733|| AccountNumber()==11528 ||AccountNumber()== 10970179||AccountNumber()== 8800189||AccountNumber()== 401489 || AccountNumber() == 768810 ||AccountNumber() == 3342573 || AccountNumber() == 2052673 || AccountNumber() == 116593 || AccountNumber() == 8800190 || AccountNumber() == 8800229 || AccountNumber() == 2495499 || AccountNumber() == 114845 || AccountNumber() == 115857|| AccountNumber() == 509875|| AccountNumber() == 201159))return ;
   if (Day() != g_day_2324) myGetSymbolSettingsDay(); //2*��EA֮������Ҫ�޸�һЩ�����Ĳ����磺ֹ���
   for (int l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) //gi_1700�����л��ҶԵĸ���
   {
      if (l_index_0 % CountOfCycles == g_count_2332)  //��֤ѭ�������ڱ������ҶԵļ��Ϊ5�Ļ���֮��
      {
         g_symbol_1980 = gsa_1704[l_index_0]; //���ҶԸ�ֵ������g_symbol_1980
         if (IsTesting() || IsOptimization() && g_symbol_1980 != Symbol()) continue; //�ڲ��Ի��Ż��в��һ��ҶԲ�Ϊ��ǰ���Ҷԣ�����ִ��
         if (!IsTesting() && MarketInfo(g_symbol_1980, MODE_TRADEALLOWED) == 0.0) continue; //���ҶԱ���ֹ����ʱ������ִ��
         if (myGetSymbolParameters(l_index_0)) ///ȡ�û��ҶԶ�Ӧ�ĸ�����������
         {
            if (myAnalizCurrentStateGeneral()) //3*/���ڶ������������ݼ����������ֵ�����������������������ݣ�����ѡ��Ľ����ҶԳֲֵ����������Ϣ��ʾ��ͼ���ϣ���¼���ܵ���������ɹ����ʱ������true 
            {
               if (myAnalizCurrentStateSymbol()) //ͳ��ÿ�����Ͷ�������ߡ���Ϳ��ּۡ��ܶ����������������ɹ��󷵻�true������false
               {
                  if (gia_1748[l_index_0] != 0)//gia_1748[]=120
                     if (g_spread_2020 > gia_1748[l_index_0]) continue;//�����ҶԵĵ��g_spread_2020����gia_1748[l_index_0]��=120��,ִ����һ�����ҶԵ��ж�
                  myCalculateIndicators();////�������"ָ��"��ֵ
                  myControlOpenOrdersSymbol();////�й�ƽ�֡��޸�ֹ���Լ�ɾ���ҵ�
                  if (MaxOrdersCount > 0)//  MaxOrdersCount �ⲿ����Ĳ���
                     if (OrdersTotal() >= MaxOrdersCount) continue;
                  if (IsTesting() || IsOptimization()) gd_2524 = 0; //gd_2524�����ŵ��Ǵ�������˺�����
                  else gd_2524 = gd_2464; //Key  gd_2464 ������myControlOpenOrdersSymbol()��������ʹ��
                  if (myAnalizCurrentStateGeneral()) 
                  {
                     if (myAnalizCurrentStateSymbol()) 
                     {
                        gd_2368 = myGetLotSize(l_index_0); //gd_2368�������������myTradeSymbol�е�myCheckAndOpenDO_FigureLevels
                                                            //��myCheckAndPrepareRO_Flat����ʹ��
                        if (AccountFreeMargin() < 1000.0 * gd_2368)//��֤���ܱ�֤1000�ܸ���������ʱ��Ч
                           if (gia_2540[gi_2656] + gia_2540[gi_2660] == 0) continue;//������û��BUY��SELL��
                        myTradeSymbol(l_index_0);//OrderSend�ڴ�
                     }
                  }
               }
            }                          
         }
      }
   }
   g_count_2332++;
   if (g_count_2332 >= CountOfCycles) g_count_2332 = 0;
   return (0);
}
//--------------------------------------------------------------------
//���ҶԽ��׵ĺ���ʵ��
void myTradeSymbol(int ai_0) 
{
   double ld_16;
   for (int l_count_4 = 0; l_count_4 < 2; l_count_4++) 
   {
      if (l_count_4 == 0) //BUY
      {
         gi_2476 = gi_2656;
         gs_2496 = "BUY";
         g_price_2424 = g_ask_2012;
      } 
      else {         //SELL
         gi_2476 = gi_2660;
         gs_2496 = "SELL";
         g_price_2424 = g_bid_2004;
      }
      gd_2432 = 100.0 * MathFloor(g_price_2424 / gd_1988 / 100.0) * gd_1988;//��ǰ�۸񰴻��ҶԵĵ����Ĵ���
      gd_2624 = (gd_2036 - 56.0) / 34.0;//=LicenseKey
      if (IsDemo()) gd_2524 = 0; //IsDemo()������ܽ�����ģ���˻����У����� TRUE �����򣬷���FALSE
      if (gi_2280 == 1) ////dMaxSymbolOrdersCount = 7;gi_2280 = gia_1960[ai_0];
      {
         gi_2492 = FALSE; 
         if (!gi_2492 && CR_UseCorrection == 1) myCheckAndPrepareRO_Correction();//BUY��SELL����ֹӯֹ��ȡ�ã��ɹ�ʱgi_2492 = TRUE;gd_2384 = g_price_2424; ������ţ�gi_2360 = gi_2328 + 400;
         if (!gi_2492 && gi_2232 == 1 && gi_2596) myCheckAndPrepareRO_Flat();//��������������ֹӯֹ���ֵ��������+200,�ɹ�ʱgi_2492 = TRUE;
         if (!gi_2492 && gi_2160 == 1 && gi_2176 == 1 && MathAbs(gd_2556) > gd_2180) myCheckAndPrepareRO_Speed();//TP��Sl��Ӧ�����µ����ã��ɹ���gi_2492=true�������ţ� gi_2360 = gi_2328 + 300;gd_2180 = gda_1876[ai_0];
         if (!gi_2492 && dUseTrendOrders_ParabolicSAR == 1) myCheckAndPrepareRO_Trend_PSAR();
         if (!gi_2492 && dUseOrders_Stochastic == 1) myCheckAndPrepareRO_Stochastic();
         if (!gi_2492 && dUseTrendOrders_ADX == 1) myCheckAndPrepareRO_Trend_ADX();
         if (!gi_2492 && dUseOrders_CCI == 1) myCheckAndPrepareRO_CCI();
         if (!gi_2492 && gi_1112 == 1) myCheckAndPrepareRO_EDX2();
         if (gi_2492)//TP��SL����ɹ� 
         {
            gd_2376 = gd_2368;
            if (gi_2360 == gi_2328 + 200) //myCheckAndPrepareRO_Flat()ʱ
            {
               if (gd_2272 > 0.0 && gd_2272 != 1.0 && gd_2368 > gda_1948[ai_0]) //gd_2272 == 1.0 
               {
                  gd_2376 = glDoubleRound(gd_2368 * gd_2272, gda_1956[ai_0]);
                  if (gd_2376 > gda_1952[ai_0]) gd_2376 = gda_1952[ai_0]; //gda_1952[ai_0]�������
               }
            }
            if (gi_2052 > 0) //ֹӯ����
            {
               if (gi_2356 == 0) gd_2408 = gd_2384 + gi_2052 * gd_1988;
               else
                  if (gi_2356 == 1) gd_2408 = gd_2384 - gi_2052 * gd_1988;
            }
            if (gi_2056 > 0) //ֹ�����
            {
               if (gi_2356 == 0) gd_2400 = gd_2384 - gi_2056 * gd_1988;
               else
                  if (gi_2356 == 1) gd_2400 = gd_2384 + gi_2056 * gd_1988;
            }
            if (gi_2356 == 0) //BUY
            {
               if (gd_2408 != 0.0 && gd_2408 - gd_2384 < g_stoplevel_2028 * gd_1988) gd_2408 = gd_2384 + g_stoplevel_2028 * gd_1988;
               if (gd_2400 != 0.0 && gd_2384 - gd_2400 < g_stoplevel_2028 * gd_1988) gd_2400 = gd_2384 - g_stoplevel_2028 * gd_1988;
            }
            if (gi_2356 == 1) //SELL
            {
               if (gd_2408 != 0.0 && gd_2384 - gd_2408 < g_stoplevel_2028 * gd_1988) gd_2408 = gd_2384 - g_stoplevel_2028 * gd_1988;
               if (gd_2400 != 0.0 && gd_2400 - gd_2384 < g_stoplevel_2028 * gd_1988) gd_2400 = gd_2384 + g_stoplevel_2028 * gd_1988;
            }
            if (InverseTrading == 1) //��������,�Գ壿
            {
               ld_16 = g_spread_2020 * gd_1988;
               if (gi_2356 == 0) 
               {
                  gi_2356 = 1;
                  gi_2476 = gi_2660;
                  if (gd_2400 != 0.0) gd_2400 = gd_2384 - ld_16 + (gd_2384 - gd_2400);
                  if (gd_2408 != 0.0) gd_2408 = gd_2384 - ld_16 - (gd_2408 - gd_2384);
                  gd_2384 -= ld_16;
                  g_price_2424 = g_bid_2004;
               } 
               else 
               {
                  if (gi_2356 == 1) {
                     gi_2356 = 0;
                     gi_2476 = gi_2656;
                     if (gd_2400 != 0.0) gd_2400 = gd_2384 + ld_16 - (gd_2400 - gd_2384);
                     if (gd_2408 != 0.0) gd_2408 = gd_2384 + ld_16 + (gd_2384 - gd_2408);
                     gd_2384 += ld_16;
                     g_price_2424 = g_ask_2012;
                  }
               }
            }
         }
         if (gi_2308 != 0)//gi_2308 = gia_1964[ai_0];//dMaxSymbolOrdersCount =7
            if (gia_2540[gi_2656] + gia_2540[gi_2660] >= gi_2308) gi_2492 = FALSE;//���������
         if (gi_2356 == 0) //BUY
         {
            if (gi_2044 == 0) gi_2492 = FALSE;
            if (gia_1724[ai_0] == 1 && gda_1716[ai_0] <= 0.0) gi_2492 = FALSE;//gia_1724[ai_0] =dUseOnlyPlusSwaps=0;gda_1716:MODE_SWAPLONG
         } 
         else //SELL
         {
            if (gi_2356 == 1) 
            {
               if (gi_2048 == 0) gi_2492 = FALSE;
               if (gia_1724[ai_0] == 1 && gda_1720[ai_0] <= 0.0) gi_2492 = FALSE;//gda_1720:MODE_SWAPSHORT
            }
         }
         if (gi_2492)
            if (!myCheckOrderBeforeAdding(gd_2384, gi_2476, gi_2356, g_price_2424)) gi_2492 = FALSE;
         if (gi_2492)
            if (!myCheckDistanceFromOneWayReal(gd_2384, gi_2476, gs_2496, gd_2440)) gi_2492 = FALSE;
         if (gi_2492)
            if (!myCheckHighLowLimit(gd_2384, gi_2476, gs_2496)) gi_2492 = FALSE;
         if (gi_2492)
            if (!myCheckOpenOrdersBeforeAdding(gd_2384, gi_2356, g_price_2424)) gi_2492 = FALSE;
         if (gi_2492) 
         {
            if (gi_504 == 1) 
            {
            }
            gs_2416 = "";
            g_ticket_2472 = myOrderSend(g_symbol_1980, gi_2356, gd_2376, gd_2384, gia_1976[ai_0], gd_2400, gd_2408, gs_2416, gi_2360, 0, Green);
            if (g_ticket_2472 > 0) {
               if (OrderSelect(g_ticket_2472, SELECT_BY_TICKET, MODE_TRADES)) {
                  if (!(myAnalizCurrentStateSymbol())) break;
                  continue;
               }
            }
         }
      }
      if (gia_1796[ai_0] == 1) myCheckAndOpenDO_FigureLevels();
   }
}
//----------------------------------------------------------------------------------------//
void myCheckAndOpenDO_FigureLevels() {
   for (int l_count_0 = 0; l_count_0 < 2; l_count_0++) {
      gi_2360 = gi_2328 + 0;
      if (l_count_0 == 0) {
         if (gi_2476 == gi_2656) {
            if (gi_2096 < 0) continue;
            gi_2356 = 4;
            gi_2480 = gi_2672;
            if (g_price_2424 < gd_2432 + gi_2096 * gd_1988) gd_2384 = gd_2432 + gi_2096 * gd_1988;
            else gd_2384 = gd_2432 + (gi_2096 + 100) * gd_1988;
         } else {
            if (gi_2104 < 0) continue;
            gi_2356 = 5;
            gi_2480 = gi_2676;
            if (g_price_2424 < gd_2432 + gi_2104 * gd_1988) gd_2384 = gd_2432 - (100 - gi_2104) * gd_1988;
            else gd_2384 = gd_2432 + gi_2104 * gd_1988;
         }
      } else {
         if (gi_2476 == gi_2656) {
            if (gi_2100 < 0) continue;
            gi_2356 = 2;
            gi_2480 = gi_2664;
            if (g_price_2424 < gd_2432 + gi_2100 * gd_1988) gd_2384 = gd_2432 - (100 - gi_2100) * gd_1988;
            else gd_2384 = gd_2432 + gi_2100 * gd_1988;
         } else {
            if (gi_2108 < 0) continue;
            gi_2356 = 3;
            gi_2480 = gi_2668;
            if (g_price_2424 < gd_2432 + gi_2108 * gd_1988) gd_2384 = gd_2432 + gi_2108 * gd_1988;
            else gd_2384 = gd_2432 + (gi_2108 + 100) * gd_1988;
         }
      }
      gs_2496 = glGetOrderTypeStr(gi_2356);
      if (gi_2476 == gi_2656) {
         gd_2408 = gd_2384 + gi_2060 * gd_1988;
         if (gi_2068 > 0) gd_2400 = gd_2384 - gi_2068 * gd_1988;
         else gd_2400 = 0;
      } else {
         gd_2408 = gd_2384 - gi_2064 * gd_1988;
         if (gi_2072 > 0) gd_2400 = gd_2384 + gi_2072 * gd_1988;
         else gd_2400 = 0;
      }
      gi_2488 = TRUE;
      if (gi_2488)
         if (!myCheckOrderBeforeAdding(gd_2384, gi_2476, gi_2356, g_price_2424)) gi_2488 = FALSE;
      if (gi_2488) {
         if (gi_2312 != 0)
            if (MathAbs(gd_2384 - g_price_2424) < gi_2312 * gd_1988) gi_2488 = FALSE;
         if (gi_2316 != 0)
            if (MathAbs(gd_2384 - g_price_2424) > gi_2316 * gd_1988) gi_2488 = FALSE;
      }
      if (gi_2488)
         if (gia_2540[gi_2476] > 0 && l_count_0 == 1) gi_2488 = FALSE;
      if (gi_2488) {
         if (gia_2540[gi_2480] > 0) {
            if (gi_2480 == gi_2672 || gi_2480 == gi_2668) gd_2448 = gda_2544[gi_2480];
            else gd_2448 = gda_2548[gi_2480];
            if (gi_1692 != 0) gd_2456 = gi_1692 * gd_1988;
            else gd_2456 = 1;
            if (gi_2480 == gi_2672 || gi_2480 == gi_2668) {
               if (gd_2384 > gd_2448 - gd_2456) gi_2488 = FALSE;
            } else
               if (gd_2384 < gd_2448 + gd_2456) gi_2488 = FALSE;
         }
      }
      if (gi_2488 && gia_2540[gi_2476] > 0) {
         if (myCheckDistanceFromOneWayReal(gd_2384, gi_2476, gs_2496, gd_2440)) {
            if ((gi_2476 == gi_2656 && gi_2136 == 1) || (gi_2476 == gi_2660 && gi_2140 == 1)) {
               gd_2408 = (gd_2384 + gd_2440) / 2.0;
               gi_2360 = gi_2328 + 100;
            }
         } else gi_2488 = FALSE;
      }
      if (gi_2488 && gi_2196 > 0)
         if (!myCheckHighLowLimit(gd_2384, gi_2476, gs_2496)) gi_2488 = FALSE;
      if (gi_2488)
         if (!myCheckOpenOrdersBeforeAdding(gd_2384, gi_2356, g_price_2424)) gi_2488 = FALSE;
      if (gi_2488) {
         gd_2376 = gd_2368;
         gs_2416 = "";
         g_ticket_2472 = myOrderSend(g_symbol_1980, gi_2356, gd_2376, gd_2384, 0, gd_2400, gd_2408, gs_2416, gi_2360, 0, Green);
         if (g_ticket_2472 > 0) {
            if (OrderSelect(g_ticket_2472, SELECT_BY_TICKET, MODE_TRADES))
               if (!(myAnalizCurrentStateSymbol())) break;
         }
      }
   }
}
//---------------------------------------------------------------------------------------------------------
//��������������ֹӯֹ���ֵ��������+200
void myCheckAndPrepareRO_Flat() 
{
   double ld_0 = g_spread_2020 * gd_1988;//����С
   if (gi_2476 == gi_2656 && g_bid_2004 > g_ilow_2600 && g_bid_2004 <= g_ilow_2600 + (gd_2616 - ld_0) / 4.0) //BUY��
   {
      if (iOpen(g_symbol_1980, gia_2680[0], 0) >= iClose(g_symbol_1980, gia_2680[0], 1) && iClose(g_symbol_1980, gia_2680[0], 1) > iClose(g_symbol_1980, gia_2680[0], 2) &&
         iClose(g_symbol_1980, gia_2680[0], 2) > iClose(g_symbol_1980, gia_2680[0], 3)) //1MIn���ڶ������3������۸���������
      {
         gi_2492 = TRUE;
         gi_2356 = 0;
         gd_2384 = g_price_2424;
         gd_2408 = gd_2384 + NormalizeDouble((gd_2616 - ld_0) / 2.0, gd_1996);//TP
         if (gd_2264 > 0.0) gd_2400 = gd_2384 - NormalizeDouble(g_price_2424 * gd_2264 / 100.0, gd_1996);//SL
         else //gd_2264 = gda_1940[ai_0];//DiFL_stopLoss_PR=0.0
         {
            if (diFL_StopLoss_UseSAR == 1 && g_isar_2640 != 0.0 && g_isar_2640 < gd_2384) gd_2400 = g_isar_2640;//SL
            else gd_2400 = 0;
         }
      }
   }
   if (gi_2476 == gi_2660 && g_bid_2004 < g_ihigh_2608 && g_bid_2004 >= g_ihigh_2608 - (gd_2616 - ld_0) / 4.0) //SELL
   {
      if (iOpen(g_symbol_1980, gia_2680[0], 0) <= iClose(g_symbol_1980, gia_2680[0], 1) && iClose(g_symbol_1980, gia_2680[0], 1) < iClose(g_symbol_1980, gia_2680[0], 2) &&
         iClose(g_symbol_1980, gia_2680[0], 2) < iClose(g_symbol_1980, gia_2680[0], 3)) ////1MIn���ڶ������3������۸��µ�����
      {
         gi_2492 = TRUE;
         gi_2356 = 1;
         gd_2384 = g_price_2424;
         gd_2408 = gd_2384 - NormalizeDouble((gd_2616 - ld_0) / 2.0, gd_1996);//TP
         if (gi_2064 > 0)//�̶�ֹӯ
            if (gd_2408 < gd_2384 - gi_2064 * gd_1988) gd_2408 = gd_2384 - gi_2064 * gd_1988;
         if (gd_2264 > 0.0) gd_2400 = gd_2384 + NormalizeDouble(g_price_2424 * gd_2264 / 100.0, gd_1996);
         else {
            if (diFL_StopLoss_UseSAR == 1 && g_isar_2640 != 0.0 && g_isar_2640 > gd_2384) gd_2400 = g_isar_2640;
            else gd_2400 = 0;
         }
      }
   }
   if (gi_2492) gi_2360 = gi_2328 + 200;
}
//---------------------------------------------------------------------------
//BUY��SELL����ֹӯֹ��ȡ�ã��ɹ�ʱgi_2492 = TRUE;gd_2384 = g_price_2424; ������ţ�gi_2360 = gi_2328 + 400;
void myCheckAndPrepareRO_Correction() 
{
   int li_4;
   int li_8;
   double l_ilow_12;
   double l_ihigh_20;
   double l_ilow_28 = 0;
   double l_ihigh_36 = 0;
   double l_ilow_44 = 0;
   double l_ihigh_52 = 0;
   for (int li_0 = 0; li_0 < CR_AnalizMove_CountBars; li_0++) {//CR_AnalizMove_CountBars=6
      l_ilow_12 = iLow(g_symbol_1980, gia_2680[CR_AnalizMove_Period], li_0);//gia_2680 ��������
      l_ihigh_20 = iHigh(g_symbol_1980, gia_2680[CR_AnalizMove_Period], li_0);//CR_AnalizMove_Period=5
      if (l_ilow_12 > 0.0) {
         if (l_ilow_28 == 0.0 || l_ilow_12 < l_ilow_28) {
            l_ilow_28 = l_ilow_12; //�����ڵ���Сֵ
            li_4 = li_0; //��¼��Сֵ���ֵ���
         }
      }
      if (l_ihigh_20 > 0.0) {
         if (l_ihigh_36 == 0.0 || l_ihigh_20 > l_ihigh_36) {
            l_ihigh_36 = l_ihigh_20;
            li_8 = li_0;
         }
      }
   }
   for (li_0 = 0; li_0 < CR_AnalizFlat_CountBars; li_0++) //2
   {
      l_ilow_12 = iLow(g_symbol_1980, gia_2680[CR_AnalizFlat_Period], li_0);
      l_ihigh_20 = iHigh(g_symbol_1980, gia_2680[CR_AnalizFlat_Period], li_0);
      if (l_ilow_12 > 0.0)
         if (l_ilow_44 == 0.0 || l_ilow_12 < l_ilow_44) l_ilow_44 = l_ilow_12;//Сֵ
      if (l_ihigh_20 > 0.0)
         if (l_ihigh_52 == 0.0 || l_ihigh_20 > l_ihigh_52) l_ihigh_52 = l_ihigh_20;//��ֵ
   }
   if (l_ilow_28 == 0.0 || l_ihigh_36 == 0.0 || l_ilow_44 == 0.0 || l_ihigh_52 == 0.0) return;
   if (l_ihigh_36 - l_ilow_28 >= g_price_2424 * CR_WaitCorrectionAfterMove_PR / 100.0) //CR_=1.2
   {
      if (l_ihigh_52 - l_ilow_44 <= g_price_2424 * CR_WaitCorrectionAfterFlat_PR / 100.0) //=0.2
      {
         if (gi_2476 == gi_2656 && g_price_2424 <= l_ilow_28 + g_price_2424 * CR_MaxDistanceFromBottom_PR / 100.0) //BUY�����ּ�<=
         {
            for (li_0 = 0; li_0 < li_4; li_0++) //����ͼ�������ǰ��
            {
               l_ihigh_20 = iHigh(g_symbol_1980, gia_2680[CR_AnalizMove_Period], li_0);
               if (l_ihigh_20 > l_ilow_28 + g_price_2424 * (CR_MaxDistanceFromBottom_PR + CR_WaitCorrectionAfterMove_PR) / 100.0) return;
            }
            gi_2492 = TRUE;
            gi_2356 = 0; //BUY
            gd_2384 = g_price_2424;
            gd_2408 = gd_2384 + NormalizeDouble(g_price_2424 * CR_SizeCorrection_PR / 100.0, gd_1996);//gd_2408:TP
            if (CR_StopLoss_PR > 0.0) gd_2400 = gd_2384 - NormalizeDouble(g_price_2424 * CR_StopLoss_PR / 100.0, gd_1996); //gd_2400:SL
            else 
            {
               if (CR_StopLoss_UseSAR == 1 && g_isar_2640 != 0.0 && g_isar_2640 < gd_2384) gd_2400 = g_isar_2640;
               else gd_2400 = 0;
            }
         }
         if (gi_2476 == gi_2660 && g_price_2424 >= l_ihigh_36 - g_price_2424 * CR_MaxDistanceFromBottom_PR / 100.0) //0.1
         {
            for (li_0 = 0; li_0 < li_8; li_0++) 
            {
               l_ilow_12 = iLow(g_symbol_1980, gia_2680[CR_AnalizMove_Period], li_0);
               if (l_ilow_12 < l_ihigh_36 - g_price_2424 * (CR_MaxDistanceFromBottom_PR + CR_WaitCorrectionAfterMove_PR) / 100.0) return;
            }
            gi_2492 = TRUE;
            gi_2356 = 1;//sell
            gd_2384 = g_price_2424;
            gd_2408 = gd_2384 - NormalizeDouble(g_price_2424 * CR_SizeCorrection_PR / 100.0, gd_1996);//0.4
            if (CR_StopLoss_PR > 0.0) gd_2400 = gd_2384 + NormalizeDouble(g_price_2424 * CR_StopLoss_PR / 100.0, gd_1996);//gd2004����ֹ�𣿣�����
            else 
            {
               if (CR_StopLoss_UseSAR == 1 && g_isar_2640 != 0.0 && g_isar_2640 > gd_2384) gd_2400 = g_isar_2640;
               else gd_2400 = 0;
            }
         }
         if (gi_2492) gi_2360 = gi_2328 + 400;
      }
   }
}
//
void myCheckAndPrepareRO_Trend_PSAR() 
{
   double l_isar_0 = iSAR(g_symbol_1980, gia_2680[diSAR_RO_TimeFrame], diSAR_RO_Step, diSAR_RO_Maximum, 0);
   double l_isar_8 = iSAR(g_symbol_1980, gia_2680[diSAR_RO_TimeFrame], diSAR_RO_Step, diSAR_RO_Maximum, 1);
   double l_isar_16 = iSAR(g_symbol_1980, gia_2680[diSAR_RO_TimeFrame], diSAR_RO_Step, diSAR_RO_Maximum, 2);
   double l_isar_24 = iSAR(g_symbol_1980, gia_2680[diSAR_RO_TimeFrame], diSAR_RO_Step, diSAR_RO_Maximum, 3);
   double l_iclose_32 = iClose(g_symbol_1980, gia_2680[diSAR_RO_TimeFrame], 1);
   double l_iclose_40 = iClose(g_symbol_1980, gia_2680[diSAR_RO_TimeFrame], 2);
   double l_iclose_48 = iClose(g_symbol_1980, gia_2680[diSAR_RO_TimeFrame], 3);
   if (gi_2476 == gi_2656 && l_isar_0 < g_price_2424 && l_isar_8 < l_iclose_32 && l_isar_16 > l_iclose_40 && l_isar_24 > l_iclose_48) 
   {
      gi_2492 = TRUE;
      gi_2356 = 0;
      gd_2384 = g_price_2424;
      gd_2408 = 0;
      gd_2400 = 0;
   }
   if (gi_2476 == gi_2660 && l_isar_0 > g_price_2424 && l_isar_8 > l_iclose_32 && l_isar_16 < l_iclose_40 && l_isar_24 < l_iclose_48) 
   {
      gi_2492 = TRUE;
      gi_2356 = 1;
      gd_2384 = g_price_2424;
      gd_2408 = 0;
      gd_2400 = 0;
   }
   if (gi_2492) gi_2360 = gi_2328 + 610;
}
//------------------------------------------------------
void myCheckAndPrepareRO_Stochastic() 
{
   double ld_48;
   bool li_56;
   int l_ord_total_60;
   bool li_64;
   double l_istochastic_0 = iStochastic(g_symbol_1980, gia_2680[diStoch_RO_TimeFrame], diStoch_RO_KPeriod, diStoch_RO_DPeriod, diStoch_RO_Slowing, diStoch_RO_Method, diStoch_RO_Price, MODE_MAIN, 0);
   double l_istochastic_8 = iStochastic(g_symbol_1980, gia_2680[diStoch_RO_TimeFrame], diStoch_RO_KPeriod, diStoch_RO_DPeriod, diStoch_RO_Slowing, diStoch_RO_Method, diStoch_RO_Price, MODE_SIGNAL, 0);
   double l_istochastic_16 = iStochastic(g_symbol_1980, gia_2680[diStoch_RO_TimeFrame], diStoch_RO_KPeriod, diStoch_RO_DPeriod, diStoch_RO_Slowing, diStoch_RO_Method, diStoch_RO_Price, MODE_MAIN, 1);
   double l_istochastic_24 = iStochastic(g_symbol_1980, gia_2680[diStoch_RO_TimeFrame], diStoch_RO_KPeriod, diStoch_RO_DPeriod, diStoch_RO_Slowing, diStoch_RO_Method, diStoch_RO_Price, MODE_SIGNAL, 1);
   double l_istochastic_32 = iStochastic(g_symbol_1980, gia_2680[diStoch_RO_TimeFrame], diStoch_RO_KPeriod, diStoch_RO_DPeriod, diStoch_RO_Slowing, diStoch_RO_Method, diStoch_RO_Price, MODE_MAIN, 2);
   double l_istochastic_40 = iStochastic(g_symbol_1980, gia_2680[diStoch_RO_TimeFrame], diStoch_RO_KPeriod, diStoch_RO_DPeriod, diStoch_RO_Slowing, diStoch_RO_Method, diStoch_RO_Price, MODE_SIGNAL, 2);
   if (gi_2476 == gi_2656 && l_istochastic_8 < l_istochastic_0 && l_istochastic_24 < l_istochastic_16 && l_istochastic_40 > l_istochastic_32) {
      gi_2492 = TRUE;
      gi_2356 = 0;
      gd_2384 = g_price_2424;
      gd_2408 = 0;
      gd_2400 = 0;
      if (diStoch_RO_TakeProfit_PR > 0.0) gd_2408 = gd_2384 + NormalizeDouble(g_price_2424 * diStoch_RO_TakeProfit_PR / 100.0, gd_1996);
      if (diStoch_RO_StopLoss_PR > 0.0) gd_2400 = gd_2384 - NormalizeDouble(g_price_2424 * diStoch_RO_StopLoss_PR / 100.0, gd_1996);
      if (diStoch_RO_UseAverageTP == 1 && gia_2540[gi_2356] != 0) {
         ld_48 = gda_2544[gi_2356];
         if (ld_48 > gd_2384) gd_2408 = gd_2384 + (ld_48 - gd_2384) / 2.0;
      }
   }
   if (gi_2476 == gi_2660 && l_istochastic_8 > l_istochastic_0 && l_istochastic_24 > l_istochastic_16 && l_istochastic_40 < l_istochastic_32) {
      gi_2492 = TRUE;
      gi_2356 = 1;
      gd_2384 = g_price_2424;
      gd_2408 = 0;
      gd_2400 = 0;
      if (diStoch_RO_TakeProfit_PR > 0.0) gd_2408 = gd_2384 - NormalizeDouble(g_price_2424 * diStoch_RO_TakeProfit_PR / 100.0, gd_1996);
      if (diStoch_RO_StopLoss_PR > 0.0) gd_2400 = gd_2384 + NormalizeDouble(g_price_2424 * diStoch_RO_StopLoss_PR / 100.0, gd_1996);
      if (diStoch_RO_UseAverageTP == 1 && gia_2540[gi_2356] != 0) {
         ld_48 = gda_2548[gi_2356];
         if (ld_48 < gd_2384) gd_2408 = gd_2384 - (gd_2384 - ld_48) / 2.0;
      }
   }
   if (gi_2492) {
      gi_2360 = gi_2328 + 620;
      if (diStoch_RO_ReverseClose == 1) {
         if (gi_2356 == 0) li_56 = TRUE;
         else
            if (gi_2356 == 1) li_56 = FALSE;
         if (diStoch_RO_RevCloseOnlyProfit == 1) li_64 = TRUE;
         else li_64 = FALSE;
         l_ord_total_60 = OrdersTotal();
         glCloseAllOrders(li_56, g_symbol_1980, 1, li_64, gi_2360);
         if (OrdersTotal() != l_ord_total_60) myAnalizCurrentStateSymbol();
      }
   }
}

void myCheckAndPrepareRO_Trend_ADX() {
   double lda_16[3];
   int l_ord_total_20;
   bool li_24;
   gi_2360 = gi_2328 + 630;
   double l_iadx_0 = iADX(g_symbol_1980, gia_2680[diADX_RO_TimeFrame], diADX_RO_Period, diADX_RO_TypePrice, MODE_PLUSDI, 0);
   double l_iadx_8 = iADX(g_symbol_1980, gia_2680[diADX_RO_TimeFrame], diADX_RO_Period, diADX_RO_TypePrice, MODE_MINUSDI, 0);
   lda_16[0] = iADX(g_symbol_1980, gia_2680[diADX_RO_TimeFrame], diADX_RO_Period, diADX_RO_TypePrice, MODE_MAIN, 0);
   lda_16[1] = iADX(g_symbol_1980, gia_2680[diADX_RO_TimeFrame], diADX_RO_Period, diADX_RO_TypePrice, MODE_MAIN, 1);
   lda_16[2] = iADX(g_symbol_1980, gia_2680[diADX_RO_TimeFrame], diADX_RO_Period, diADX_RO_TypePrice, MODE_MAIN, 2);
   if (diADX_RO_CloseOnlyProfit != -1) {
      if (diADX_RO_CloseOnlyProfit == 1) li_24 = TRUE;
      else li_24 = FALSE;
      l_ord_total_20 = OrdersTotal();
      if (diADX_RO_ValueToCloseOrders != 0.0 && lda_16[1] >= diADX_RO_ValueToCloseOrders && lda_16[0] < lda_16[1] && lda_16[1] < lda_16[2]) glCloseAllOrders(-1, g_symbol_1980, 1, 1, gi_2360);
      if (lda_16[0] < lda_16[1] && lda_16[1] < lda_16[2] && lda_16[1] < diADX_RO_ValueSignalEndTrend && lda_16[2] >= diADX_RO_ValueSignalEndTrend) glCloseAllOrders(-1, g_symbol_1980, 1, li_24, gi_2360);
      if (l_iadx_0 < l_iadx_8) glCloseAllOrders(OP_BUY, g_symbol_1980, 1, li_24, gi_2360);
      if (l_iadx_0 > l_iadx_8) glCloseAllOrders(OP_SELL, g_symbol_1980, 1, li_24, gi_2360);
      if (OrdersTotal() != l_ord_total_20) myAnalizCurrentStateSymbol();
   }
   if (lda_16[0] > lda_16[1] && lda_16[1] > lda_16[2] && lda_16[1] >= diADX_RO_ValueSignalTrend && lda_16[2] < diADX_RO_ValueSignalTrend) {
      if (gi_2476 == gi_2656 && l_iadx_0 > l_iadx_8) {
         gi_2492 = TRUE;
         gi_2356 = 0;
         gd_2384 = g_price_2424;
         gd_2408 = 0;
         gd_2400 = 0;
         if (diADX_RO_TakeProfit_PR > 0.0) gd_2408 = gd_2384 + NormalizeDouble(g_price_2424 * diADX_RO_TakeProfit_PR / 100.0, gd_1996);
         if (diADX_RO_StopLoss_PR > 0.0) gd_2400 = gd_2384 - NormalizeDouble(g_price_2424 * diADX_RO_StopLoss_PR / 100.0, gd_1996);
         if (!(diADX_RO_UseAverageTP == 1 && gia_2540[gi_2356] != 0)) return;
         gd_2440 = gda_2544[gi_2356];
         if (gd_2440 <= gd_2384) return;
         gd_2408 = gd_2384 + (gd_2440 - gd_2384) / 2.0;
         return;
      }
      if (gi_2476 == gi_2660 && l_iadx_0 < l_iadx_8) {
         gi_2492 = TRUE;
         gi_2356 = 1;
         gd_2384 = g_price_2424;
         gd_2408 = 0;
         gd_2400 = 0;
         if (diADX_RO_TakeProfit_PR > 0.0) gd_2408 = gd_2384 - NormalizeDouble(g_price_2424 * diADX_RO_TakeProfit_PR / 100.0, gd_1996);
         if (diADX_RO_StopLoss_PR > 0.0) gd_2400 = gd_2384 + NormalizeDouble(g_price_2424 * diADX_RO_StopLoss_PR / 100.0, gd_1996);
         if (diADX_RO_UseAverageTP == 1 && gia_2540[gi_2356] != 0) {
            gd_2440 = gda_2548[gi_2356];
            if (gd_2440 < gd_2384) gd_2408 = gd_2384 - (gd_2384 - gd_2440) / 2.0;
         }
      }
   }
}

void myCheckAndPrepareRO_CCI() {
   bool li_24;
   int l_ord_total_28;
   bool li_32;
   double l_icci_0 = iCCI(g_symbol_1980, gia_2680[diCCI_RO_TimeFrame], diCCI_RO_Period_Slow, diCCI_RO_TypePrice, 0);
   double l_icci_8 = iCCI(g_symbol_1980, gia_2680[diCCI_RO_TimeFrame], diCCI_RO_Period_Medium, diCCI_RO_TypePrice, 0);
   double l_icci_16 = iCCI(g_symbol_1980, gia_2680[diCCI_RO_TimeFrame], diCCI_RO_Period_Fast, diCCI_RO_TypePrice, 0);
   if (gi_2476 == gi_2656 && l_icci_8 <= 0.0 && l_icci_0 >= 0.0 && l_icci_16 > 0.0) {
      gi_2492 = TRUE;
      gi_2356 = 0;
      gd_2384 = g_price_2424;
      gd_2408 = 0;
      gd_2400 = 0;
      if (diCCI_RO_TakeProfit_PR > 0.0) gd_2408 = gd_2384 + NormalizeDouble(g_price_2424 * diCCI_RO_TakeProfit_PR / 100.0, gd_1996);
      if (diCCI_RO_StopLoss_PR > 0.0) gd_2400 = gd_2384 - NormalizeDouble(g_price_2424 * diCCI_RO_StopLoss_PR / 100.0, gd_1996);
   }
   if (gi_2476 == gi_2660 && l_icci_8 >= 0.0 && l_icci_0 <= 0.0 && l_icci_16 < 0.0) {
      gi_2492 = TRUE;
      gi_2356 = 1;
      gd_2384 = g_price_2424;
      gd_2408 = 0;
      gd_2400 = 0;
      if (diCCI_RO_TakeProfit_PR > 0.0) gd_2408 = gd_2384 - NormalizeDouble(g_price_2424 * diCCI_RO_TakeProfit_PR / 100.0, gd_1996);
      if (diCCI_RO_StopLoss_PR > 0.0) gd_2400 = gd_2384 + NormalizeDouble(g_price_2424 * diCCI_RO_StopLoss_PR / 100.0, gd_1996);
   }
   if (gi_2492) {
      gi_2360 = gi_2328 + 640;
      if (diCCI_RO_ReverseClose == 1) {
         if (gi_2356 == 0) li_24 = TRUE;
         else
            if (gi_2356 == 1) li_24 = FALSE;
         if (diCCI_RO_RevCloseOnlyProfit == 1) li_32 = TRUE;
         else li_32 = FALSE;
         l_ord_total_28 = OrdersTotal();
         glCloseAllOrders(li_24, g_symbol_1980, 1, li_32, gi_2360);
         if (OrdersTotal() != l_ord_total_28) myAnalizCurrentStateSymbol();
      }
   }
}

void myCheckAndPrepareRO_EDX2() {
   if (gi_2492) gi_2360 = gi_2328 + 710;
}
//---------------------------------------------------------
//TP��Sl��Ӧ�����µ����ã��ɹ���gi_2492=true�������ţ� gi_2360 = gi_2328 + 300;
void myCheckAndPrepareRO_Speed() 
{
   if (gi_2476 == gi_2656 && gd_2556 > 0.0) //BUY����������
   {
      gi_2492 = TRUE;
      gi_2356 = 0;
      gd_2384 = g_price_2424;
      if (gi_2188 == 1) gd_2408 = gd_2384 + MarketInfo(g_symbol_1980, MODE_STOPLEVEL) * gd_1988;
      if (gi_2192 > 0) gd_2400 = gd_2384 - gi_2192 * gd_1988;
      else gd_2400 = 0;
   }
   if (gi_2476 == gi_2660 && gd_2556 < 0.0) 
   {
      gi_2492 = TRUE;
      gi_2356 = 1;
      gd_2384 = g_price_2424;
      if (gi_2188 == 1) gd_2408 = gd_2384 - MarketInfo(g_symbol_1980, MODE_STOPLEVEL) * gd_1988;
      else gd_2408 = gd_2384 - gi_2064 * gd_1988;
      if (gi_2192 > 0) gd_2400 = gd_2384 + gi_2192 * gd_1988;
      else gd_2400 = 0;
   }
   if (gi_2492) gi_2360 = gi_2328 + 300;
}
//-------------------------------------------------------------------------------------------
//
bool myCheckOrderBeforeAdding(double ad_0, int ai_8, int a_cmd_12, double ad_unused_16) 
{
   int l_hist_total_36;
   double ld_40;
   string ls_48;
   double l_ilow_56;
   double l_ihigh_64;
   double l_ilow_72;
   double l_ihigh_80;
   double l_iadx_88;
   double l_iadx_96;
   double l_iadx_104;
   if (ai_8 == gi_2656) //BUY
   {
      if (gi_2044 == 0) return (FALSE);
      if (a_cmd_12 == OP_BUY && gi_2280 == 0) return (FALSE);//
      if (gd_2284 > 0.0 && ad_0 >= gd_2284) return (FALSE);
   }
   if (ai_8 == gi_2660) 
   {
      if (gi_2048 == 0) return (FALSE);
      if (a_cmd_12 == OP_SELL && gi_2280 == 0) return (FALSE);
      if (gd_2300 > 0.0 && ad_0 <= gd_2300) return (FALSE);
   }
   if (MaxOpenValPosition > 0.0) //7.0
   {
      if (IsCurrencyPair(g_symbol_1980, CustomNameForCurrencyPair)) 
      {
         for (int l_count_28 = 0; l_count_28 < 2; l_count_28++) 
         {
            ls_48 = GetCurrencyFromSymbol(g_symbol_1980, l_count_28 + 1, CustomNameForCurrencyPair);
            ld_40 = 0;
            for (int l_index_32 = 0; l_index_32 < gi_2504; l_index_32++) {
               if (gsa_2512[l_index_32] == ls_48) {
                  ld_40 = gda_2516[l_index_32] - gda_2520[l_index_32];//������ֵ
                  if (!((ai_8 == gi_2656 && l_count_28 == 1) || (ai_8 == gi_2660 && l_count_28 == 0))) break;
                  ld_40 = -ld_40;
                  break;
               }
            }
            if (ld_40 > gd_2368 * MaxOpenValPosition) return (FALSE);
         }
      }
   }
   if (BlockOpenWorseOrder_Minutes > 0) {
      l_hist_total_36 = OrdersHistoryTotal();  //?
      for (int l_pos_24 = 0; l_pos_24 < l_hist_total_36; l_pos_24++) {
         if (OrderSelect(l_pos_24, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() == g_symbol_1980) {
               if (myIsOwnOrder()) {
                  if (OrderType() == a_cmd_12) {
                     if (TimeCurrent() - OrderCloseTime() <= 60 * BlockOpenWorseOrder_Minutes) {
                        if (a_cmd_12 == OP_BUY) {
                           if (ad_0 < OrderClosePrice()) continue;
                           return (FALSE);  
                        }
                        if (a_cmd_12 == OP_SELL)
                           if (ad_0 <= OrderClosePrice()) return (FALSE);
                     }
                  }
               }
            }
         }
      }
   }
   if (dUseFilterMaxMin == 1) {
      l_ilow_72 = 0;
      l_ihigh_80 = 0;
      for (l_pos_24 = 0; l_pos_24 < dMaxMin_Filter_CountBars; l_pos_24++) {
         l_ilow_56 = iLow(g_symbol_1980, gia_2680[dMaxMin_Filter_TimeFrame], l_pos_24);
         l_ihigh_64 = iHigh(g_symbol_1980, gia_2680[dMaxMin_Filter_TimeFrame], l_pos_24);
         if (l_ilow_56 > 0.0)
            if (l_ilow_72 == 0.0 || l_ilow_56 < l_ilow_72) l_ilow_72 = l_ilow_56;
         if (l_ihigh_64 > 0.0)
            if (l_ihigh_80 == 0.0 || l_ihigh_64 > l_ihigh_80) l_ihigh_80 = l_ihigh_64;
      }
      if (ai_8 == gi_2656 && l_ihigh_80 > 0.0 && ad_0 >= l_ihigh_80 - ad_0 * dMaxMin_LimitDistance_PR / 100.0) return (FALSE);
      if (ai_8 == gi_2660 && l_ilow_72 > 0.0 && ad_0 <= l_ilow_72 + ad_0 * dMaxMin_LimitDistance_PR / 100.0) return (FALSE);
   }
   if (gi_2160 == 1) {
      if (ai_8 == gi_2656 && gd_2556 < 0.0) return (FALSE); //BUY,�����½�
      if (ai_8 == gi_2660 && gd_2556 > 0.0) return (FALSE);
   }
   if (gi_2144 == 1) {
      if (ai_8 == gi_2656 && gd_2564 < 0.0) return (FALSE);
      if (ai_8 == gi_2660 && gd_2564 > 0.0) return (FALSE);
   }
   if (dUseTrendFilterOsMA == 1) {
      if (g_iosma_2632 != 0.0) {
         if (ai_8 == gi_2656 && g_iosma_2632 < 0.0) return (FALSE);
         if (ai_8 == gi_2660 && g_iosma_2632 > 0.0) return (FALSE);
      }
   }
   if (dUseTrendFilterSAR == 1) {
      if (g_isar_2640 != 0.0) {
         if (ai_8 == gi_2656 && g_isar_2640 > ad_0) return (FALSE);
         if (ai_8 == gi_2660 && g_isar_2640 < ad_0) return (FALSE);
      }
   }
   if (dUseTrendFilterADX == 1) {
      l_iadx_88 = iADX(g_symbol_1980, gia_2680[diADX_Filter_TimeFrame], diADX_Filter_Period, diADX_Filter_TypePrice, MODE_PLUSDI, 0);
      l_iadx_96 = iADX(g_symbol_1980, gia_2680[diADX_Filter_TimeFrame], diADX_Filter_Period, diADX_Filter_TypePrice, MODE_MINUSDI, 0);
      l_iadx_104 = iADX(g_symbol_1980, gia_2680[diADX_Filter_TimeFrame], diADX_Filter_Period, diADX_Filter_TypePrice, MODE_MAIN, 0);
      if (l_iadx_88 != 0.0 && l_iadx_96 != 0.0 && l_iadx_104 >= diADX_Filter_ValueSignalTrend) {
         if (ai_8 == gi_2656 && l_iadx_96 > l_iadx_88) return (FALSE);
         if (ai_8 == gi_2660 && l_iadx_88 > l_iadx_96) return (FALSE);
      }
   }
   return (TRUE);
}
//-------------------------------------------------------------------------------------
////������������dMaxSymbolOrdersCountʱ��ɾ�����ּ����ּ���Զ�Ĺҵ�
bool myCheckOpenOrdersBeforeAdding(double ad_0, int ai_8, double ad_12) 
{
   int l_ord_total_32;
   int l_count_36;
   int l_cmd_40;
   int l_ticket_44;
   double ld_48;
   double ld_56;
   if (ai_8 == 0 || ai_8 == 2)
      if (!glDeleteAllDeferOrders(OP_BUYLIMIT, g_symbol_1980)) return (FALSE);
   if (ai_8 == 1 || ai_8 == 3)
      if (!glDeleteAllDeferOrders(OP_SELLLIMIT, g_symbol_1980)) return (FALSE);
   if (gi_2308 != 0) {
      l_count_36 = 0;
      l_ord_total_32 = OrdersTotal();
      for (int l_pos_20 = 0; l_pos_20 < l_ord_total_32; l_pos_20++) {
         if (OrderSelect(l_pos_20, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == g_symbol_1980)
               if (myIsOwnOrder()) l_count_36++;
         }
      }
      while (l_count_36 >= gi_2308) //������������dMaxSymbolOrdersCountʱ��ɾ�����ּ����ּ���Զ�Ĺҵ�
      {
         ld_56 = 0;
         for (l_pos_20 = 0; l_pos_20 < l_ord_total_32; l_pos_20++) {
            if (OrderSelect(l_pos_20, SELECT_BY_POS, MODE_TRADES)) {
               if (OrderSymbol() == g_symbol_1980) {
                  if (myIsOwnOrder()) {
                     l_cmd_40 = OrderType();
                     if (l_cmd_40 == OP_BUYLIMIT || l_cmd_40 == OP_BUYSTOP) ld_48 = MathAbs(g_ask_2012 - OrderOpenPrice());
                     else {
                        if (!(l_cmd_40 == OP_SELLLIMIT || l_cmd_40 == OP_SELLSTOP)) continue;
                        ld_48 = MathAbs(g_bid_2004 - OrderOpenPrice());
                     }
                     if (ld_48 > ld_56) {
                        ld_56 = ld_48;
                        l_ticket_44 = OrderTicket();
                     }
                  }
               }
            }
         }
         if (ld_56 > MathAbs(ad_0 - ad_12)) 
         {
            if (myOrderDelete(l_ticket_44)) 
            {
               l_count_36--;
               l_ord_total_32 = OrdersTotal();
               continue;
            }
            return (FALSE);
         }
         return (FALSE);
      }
   }
   return (TRUE);
}
//����BUY��SELL���Ŀ��ּ۸������Сֵ�й�
bool myCheckDistanceFromOneWayReal(double ad_0, int ai_8, string as_unused_12, double &ad_20) {
   double ld_28;
   if (gia_2540[ai_8] == 0) return (TRUE);
   if (ai_8 == gi_2656 && gi_2112 == 0) return (FALSE);
   if (ai_8 == gi_2660 && gi_2116 == 0) return (FALSE);
   if (ai_8 == gi_2656) 
   {
      ad_20 = gda_2544[ai_8];
      ld_28 = gda_2548[ai_8] * gd_2120 / 100.0;
   } 
   else 
   {
      ad_20 = gda_2548[ai_8];
      ld_28 = gda_2548[ai_8] * gd_2128 / 100.0;
   }
   if (ai_8 == gi_2656) 
   {
      if (ad_0 > ad_20 - ld_28) return (FALSE);
   } 
   else
      if (ad_0 < ad_20 + ld_28) return (FALSE);
   return (TRUE);
}
//---------------------------------------------------------------------------------
/*
   double ad_0,  
   int ai_8,  ��������
   string as_unused_12   û����
*/
bool myCheckHighLowLimit(double ad_0, int ai_8, string as_unused_12) 
{
   for (int l_index_28 = 0; l_index_28 < gi_2196; l_index_28++) {
      switch (l_index_28) 
      {
      case 0:
         gd_2588 = gd_2200;
         break;
      case 1:
         gd_2588 = gd_2216;
         break;
      default:
         continue;
      }
      if (ai_8 == gi_2656 && gda_2572[l_index_28] > 0.0 && ad_0 >= gda_2572[l_index_28] + ad_0 * gd_2588 / 100.0) return (FALSE);//������Сֵad_0+��1%
      if (ai_8 == gi_2660 && gda_2576[l_index_28] > 0.0 && ad_0 <= gda_2576[l_index_28] - ad_0 * gd_2588 / 100.0) return (FALSE);//С�����ֵad_0-��5%
   }
   return (TRUE);
}
//--------------------------------------------------------------------------------------------------------
//���������Ĺ���С
double myGetLotSize(int ai_0) 
{
   double ld_ret_4;
   if (gda_1744[ai_0] > 0.0) ld_ret_4 = glDoubleRound(AccountFreeMargin() / 1000.0 * gda_1744[ai_0], gda_1956[ai_0]);//gda_1744[]=Max(dRisk=0.01,MODE_LOTSTEP)
   else ld_ret_4 = gda_1948[ai_0];//MINLot
   if (ld_ret_4 < gda_1948[ai_0]) ld_ret_4 = gda_1948[ai_0];//MINLOT ��֤����С������Ϊgda_1948[ai_0]
   if (ld_ret_4 > gda_1952[ai_0]) ld_ret_4 = gda_1952[ai_0];// MAXLOT ��֤����������gda_1952[ai_0]
   return (ld_ret_4);
}
//--------------------------------------------------------------------
//���ڶ������������ݼ����������ֵ�����������������������ݣ�����ѡ��Ľ����ҶԳֲֵ����������Ϣ��ʾ��ͼ���ϣ���¼���ܵ���������ɹ����ʱ������true 
bool myAnalizCurrentStateGeneral() 
{
   int l_cmd_16;
   double l_ord_open_price_20;
   double l_ord_lots_28;
   string ls_36;
   string ls_44;
   string ls_52;
   int l_ord_total_12 = OrdersTotal();
   for (int l_pos_0 = 0; l_pos_0 < gi_2504; l_pos_0++) 
   {
      gda_2516[l_pos_0] = 0;
      gda_2520[l_pos_0] = 0;
      gda_2532[l_pos_0] = 0;
      gda_2536[l_pos_0] = 0;
   }
   gd_2648 = gd_2580 * gd_2580;//�˻����ִ���
   for (l_pos_0 = 0; l_pos_0 < l_ord_total_12; l_pos_0++) 
   {
      if (!OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES)) return (FALSE);
      l_cmd_16 = OrderType();
      l_ord_open_price_20 = OrderOpenPrice();
      l_ord_lots_28 = OrderLots();
      if (IsCurrencyPair(OrderSymbol(), CustomNameForCurrencyPair)) 
      {
         for (int l_count_4 = 0; l_count_4 < 2; l_count_4++) 
         {
           //string GetCurrencyFromSymbol(string as_0, int ai_8 = 1, string as_12 = "AAABBB")
            ls_36 = GetCurrencyFromSymbol(OrderSymbol(), l_count_4 + 1, CustomNameForCurrencyPair);//��OrderSymbol()�� CustomNameForCurrencyPairһ�µ�ǰ���£���as_12�н�ȡǰ�棨ai_8 = 1�������һ���֣�ai_8 = 2������ȡ�ɹ�������ȡ���ַ��������򷵻ؿ��ַ���
            for (int l_index_8 = 0; l_index_8 < gi_2504; l_index_8++) 
            {
               if (gsa_2512[l_index_8] == ls_36) //gsa_2512 �����ŵ���һ�����Ļ�������
               {
                  if ((l_cmd_16 == OP_BUY && l_count_4 == 0) || (l_cmd_16 == OP_SELL && l_count_4 == 1)) 
                  {
                     gda_2532[l_index_8] += l_ord_lots_28;//gda_2532[l_index_8]��¼���Ҷ�CustomNameForCurrencyPair��������ΪBUY��gda_2532[0]����sell��gda_2532[1]�� ��������
                     if (!(myIsOwnOrder())) break;
                     gda_2516[l_index_8] += l_ord_lots_28;//��¼���Ҷ�CustomNameForCurrencyPairָ��������ŵĶ�������ΪBUY��gda_2516[0]����sell��gda_2516[1]�� ��������
                     break;
                  }
                  if (!((l_cmd_16 == OP_BUY && l_count_4 == 1) || (l_cmd_16 == OP_SELL && l_count_4 == 0))) break;
                  gda_2536[l_index_8] += l_ord_lots_28;//gda_2532[l_index_8]��¼���Ҷ�CustomNameForCurrencyPair��������Ϊsell(gda_2536[0])��BUY(gda_2536[1])��������
                  if (!(myIsOwnOrder())) break;
                  gda_2520[l_index_8] += l_ord_lots_28;  //��¼��¼���Ҷ�CustomNameForCurrencyPairָ��������ŵĶ�������Ϊsell(gda_2520[0])��BUY(gda_2520[1])��������
                  break;
               }
            }
         }
      }
   }
   //
   if (PrintInfoOpenValPosition && l_ord_total_12 != g_ord_total_2508) //��������������ʱ
   {
      ls_44 = "\nOpen VAL-position:";
      for (l_index_8 = 0; l_index_8 < gi_2504; l_index_8++) //2
      {
         if (gda_2516[l_index_8] - gda_2520[l_index_8] == 0.0) ls_52 = "0";//���������������������ls_52 = "0"������ls_52 =���߲�ֵ
         else ls_52 = DoubleToStr(gda_2516[l_index_8] - gda_2520[l_index_8], 2);
         if (gda_2532[l_index_8] - gda_2536[l_index_8] - (gda_2516[l_index_8] - gda_2520[l_index_8]) == 0.0) ls_52 = ls_52 + " / 0";
         else ls_52 = ls_52 + " / " + DoubleToStr(gda_2532[l_index_8] - gda_2536[l_index_8] - (gda_2516[l_index_8] - gda_2520[l_index_8]), 2);
         if (gda_2532[l_index_8] - gda_2536[l_index_8] == 0.0) ls_52 = ls_52 + " / 0";
         else ls_52 = ls_52 + " / " + DoubleToStr(gda_2532[l_index_8] - gda_2536[l_index_8], 2);
         ls_44 = ls_44 
            + "\n" 
         + gsa_2512[l_index_8] + ": " + ls_52;//gsa_2512�洢���Ƿ��뿪�Ļ��Ҷ�
      }
      Comment(ls_44);
   }
   g_ord_total_2508 = l_ord_total_12;   //����OrdersTotal() 
   return (TRUE);
}
//-------------------------------------------------------------------------------------------
//ͳ��ÿ�����Ͷ�������ߡ���Ϳ��ּۡ��ܶ����������������ɹ��󷵻�true������false
bool myAnalizCurrentStateSymbol() 
{
   int l_cmd_16;
   int li_20;
   double l_ord_open_price_24;
   double l_ord_lots_32;
   int l_ord_total_12 = OrdersTotal();
   for (int l_pos_0 = 0; l_pos_0 < 6; l_pos_0++) 
   {
      gda_2544[l_pos_0] = -1; //�����ӿ��ּ۵���Сֵ
      gda_2548[l_pos_0] = -1; //���е��ӿ��ּ۵����ֵ
      gda_2552[l_pos_0] = 0;
      gia_2540[l_pos_0] = 0; //��¼ÿ�����Ͷ����ĵ���
   }
   for (l_pos_0 = 0; l_pos_0 < l_ord_total_12; l_pos_0++) 
   {
      if (!OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES)) return (FALSE);
      if (OrderSymbol() == g_symbol_1980) {
         if (myIsOwnOrder()) 
         {
            l_cmd_16 = OrderType();
            l_ord_open_price_24 = OrderOpenPrice();
            l_ord_lots_32 = OrderLots();
            li_20 = myGetNormalOrderType(l_cmd_16); //ȡ�ö������� ͬl_cmd_16 = OrderType();ȡֵ0~5Ϊ���ֵ�������
            if (li_20 == -1) return (FALSE);
            gia_2540[li_20]++;//��¼ÿ�����Ͷ������ܵ���
            if (gda_2544[li_20] == -1.0 || l_ord_open_price_24 < gda_2544[li_20]) gda_2544[li_20] = l_ord_open_price_24;   //�洢ÿ�����Ͷ������ּ۵���Сֵ
            if (gda_2548[li_20] == -1.0 || l_ord_open_price_24 > gda_2548[li_20]) gda_2548[li_20] = l_ord_open_price_24;   //�洢ÿ�����Ͷ������ּ۵����ֵ
            gda_2552[li_20] += l_ord_lots_32; //��¼���趨���������ͬ��ÿ�ֻ��ҶԶ���������
         }
      }
   }
   return (TRUE);
}
//----------------------------------------------------------------------------------------------------------------------------
//��as_4����as_28���ҵ����Ҷ���":"���������ҶԵı�ʾ���֣��洢��asa_0[]�У������С��l_count_44��¼�������ش�ֵ
int myGetSettingsFromString(string &asa_0[], string as_4, string as_12 = ";", string as_20 = "<def>", string as_28 = "") 
{
   int li_40;
   string ls_48;
   string l_str_concat_56;
   string ls_64;
   int l_count_44 = 0;
   ArrayResize(asa_0, gi_1700);
   for (int l_index_36 = 0; l_index_36 < gi_1700; l_index_36++) 
   {
      l_str_concat_56 = StringConcatenate(gsa_1704[l_index_36], ":"); //�����Ҷ���:��������
      li_40 = StringFind(as_4, l_str_concat_56); 
      if (li_40 != -1) ls_48 = as_4;  //��as_4���ҵ����������ӵĻ��Ҷԣ�����¼���as_4�ַ���
      else 
      {
         li_40 = StringFind(as_28, l_str_concat_56);
         ls_48 = as_28;    //��as_28���ҵ����������ӵĻ��Ҷԣ�����¼���as_28�ַ���
      }//-----------------�������ڲ���as_4��as_20���ҵ��������Ӧ���Ҷ��ַ���������ls_48�С�
      if (li_40 != -1) 
      {
         ls_64 = StringSubstr(ls_48, li_40 + StringLen(l_str_concat_56)); //��ȡ���Ҷ���:�Ժ���ַ���
         li_40 = StringFind(ls_64, as_12); //�ҵ��ַ����Ľ���λ�÷�;�š�
         if (li_40 != -1) ls_64 = StringSubstr(ls_64, 0, li_40);     //��ȡ���Ҷ���:�Ժ�,";"��ǰ���ַ����л��ҶԵı�ʾ����
         asa_0[l_index_36] = glStringTrimAll(ls_64);        //���������ּ���asa_0[]
         l_count_44++;
      } 
      else asa_0[l_index_36] = as_20;//���ַ�����û��Ҫ�ҵĻ��Ҷ���asa_0[l_index_36]="<def>"
   }
   return (l_count_44);//���� ȡ���������ֵĸ���
   Print("ȡ���������ֵĸ���l_count_44 =",DoubleToStr(l_count_44,0));
}
//----------------------------------------------------------------------
//��gi_2320==false&&IsTradeAllowed()==true ,�򷵻�true,����false
bool myCheckAllowWorking() 
{
   if (gi_2320) return (FALSE);
   if (!IsTradeAllowed()) return (FALSE);
   return (TRUE);
}
//-------------------------------------------------------
//�й�ƽ�֡��޸�ֹ���Լ�ɾ���ҵ�
int myControlOpenOrdersSymbol() 
{
   int l_ord_total_12;
   int li_16;
   int li_20;
   int l_cmd_24;
   int l_magic_28;
   int l_str2int_36;
   double l_ord_open_price_40;
   double ld_48;
   double ld_56;
   double l_str2dbl_64;
   double l_str2dbl_72;
   double ld_80;
   string ls_88;
   string ls_96;
   bool li_104;
   bool li_108;
   double ld_112;
   double ld_120;
   if (Set_TP_SL_ByModifyOrder == 1) //�����������Ϊ0 //����1ʱ�����ݶ���ע���޸�ֹӯֹ��Ĵ�С
   {
      l_ord_total_12 = OrdersTotal();
      for (int l_pos_0 = 0; l_pos_0 < l_ord_total_12; l_pos_0++) 
      {
         OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
         if (myIsOwnOrder()) 
         {
            if (OrderStopLoss() == 0.0 && OrderTakeProfit() == 0.0) 
            {
               ls_88 = OrderComment();
               li_16 = StringFind(ls_88, "{TP=");
               if (li_16 != -1) 
               {
                  li_20 = StringFind(ls_88, "}", li_16);
                  if (li_20 != -1) 
                  {
                     l_str2dbl_64 = StrToDouble(StringSubstr(ls_88, li_16 + 4, li_20 - li_16 - 4));//��ȡ{TP=��}֮����ַ���ת��Ϊ˫�����ͣ�ֹӯ��С
                     li_16 = StringFind(ls_88, "{SL=");
                     if (li_16 != -1) {
                        li_20 = StringFind(ls_88, "}", li_16);
                        if (li_20 != -1) {
                           l_str2dbl_72 = StrToDouble(StringSubstr(ls_88, li_16 + 4, li_20 - li_16 - 4));//ֹ���С
                           if (l_str2dbl_64 == 0.0 && l_str2dbl_72 == 0.0) continue;// ��ע����ֹӯֹ���Ϊ0�����޸�
                           myOrderModify(OrderTicket(), OrderOpenPrice(), l_str2dbl_72, l_str2dbl_64, 0);
                        }
                     }
                  }
               }
            }
         }
      }
   }
   gd_2464 = gd_2648;//= gd_2580 * gd_2580;//�˻����ִ���
   int li_32 = 0;
   for (l_pos_0 = 0; l_pos_0 < StringLen(g_acc_number_2348); l_pos_0 += 2) //�˻����ֵ�����λ����������gd_2464
   {
      ls_96 = StringSubstr(g_acc_number_2348, l_pos_0, 1);
      l_str2int_36 = StrToInteger(ls_96);
      if (l_str2int_36 != 0) 
      {
         if (li_32 == 0) gd_2464 *= l_str2int_36;
         else gd_2464 += l_str2int_36;
      }
      li_32 = 1 - li_32;
   }
   if (gi_2076 > 0) //�������������=0����gi_2076 > 0&&TimeSL_OnlyAfterDistance_PR=0����ֻ��ʱ������ƽ��
   {
      l_ord_total_12 = OrdersTotal();
      for (l_pos_0 = l_ord_total_12 - 1; l_pos_0 >= 0; l_pos_0--) 
      {
         OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == g_symbol_1980) 
         {
            if (myIsOwnOrder()) 
            {
               l_cmd_24 = OrderType();
               if (l_cmd_24 == OP_BUY || l_cmd_24 == OP_SELL) 
               {
                  if (TimeCurrent() - OrderOpenTime() > 60 * gi_2076) 
                  {
                     li_104 = TRUE;
                     if (TimeSL_OnlyAfterDistance_PR != 0.0) //�������ⲿ����TimeSL_OnlyAfterDistance_PR=0
                      {
                        l_ord_open_price_40 = OrderOpenPrice();
                        if (l_cmd_24 == OP_BUY) //�����ּ۴���������ۣ��Ҵ��������ռ���ּ۵ı���С��TimeSL_OnlyAfterDistance_PR / 100.0ʱ��li_104 = FALSE;
                        {
                           ld_80 = g_bid_2004; 
                           if (l_ord_open_price_40 > ld_80 && (l_ord_open_price_40 - ld_80) / l_ord_open_price_40 < TimeSL_OnlyAfterDistance_PR / 100.0) li_104 = FALSE;
                           else
                              if (l_ord_open_price_40 <= ld_80) li_104 = FALSE;//�����ּ۴����������
                        } 
                        else 
                        {
                           if (l_cmd_24 == OP_SELL) 
                           {
                              ld_80 = g_ask_2012;
                              if (ld_80 > l_ord_open_price_40 && (ld_80 - l_ord_open_price_40) / l_ord_open_price_40 < TimeSL_OnlyAfterDistance_PR / 100.0) li_104 = FALSE;
                              else
                                 if (ld_80 <= l_ord_open_price_40) li_104 = FALSE;
                           }
                        }
                     }
                     if (li_104) glOrderClose(CommentOrderOperations);//��TimeSL_OnlyAfterDistance_PR == 0.0ʱ��ֻҪʱ��������������ƽ��
                  }
               }
            }
         }
      }
   }
   for (l_pos_0 = 1; l_pos_0 < StringLen(g_acc_number_2348); l_pos_0 += 2) //�˻����ֵ�ż��λ��������gd_2464
   {
      ls_96 = StringSubstr(g_acc_number_2348, l_pos_0, 1);
      l_str2int_36 = StrToInteger(ls_96);
      if (l_str2int_36 != 0) 
      {
         if (li_32 == 0) gd_2464 *= l_str2int_36;
         else gd_2464 += l_str2int_36;
      }
      li_32 = 1 - li_32;
   }
   if (CloseOrdersOppositeTrend_OsMA == 1 || CloseOrdersOppositeTrend_SAR == 1 || CloseOrdersOppositeTrend_ALL == 1) 
   {
      l_ord_total_12 = OrdersTotal();
      for (l_pos_0 = l_ord_total_12 - 1; l_pos_0 >= 0; l_pos_0--) 
      {
         li_108 = FALSE;
         OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == g_symbol_1980) 
         {
            if (myIsOwnOrder()) 
            {
               l_cmd_24 = OrderType();
               l_ord_open_price_40 = OrderOpenPrice();
               if (l_cmd_24 == OP_BUY) 
               {
                  if (CloseOrdersOppositeTrend_OsMA == 1 && CloseOrdersOppositeTrend_ALL == 0)
                     if (g_iosma_2632 < 0.0) li_108 = TRUE;
                  if (CloseOrdersOppositeTrend_SAR == 1 && CloseOrdersOppositeTrend_ALL == 0)
                     if (g_isar_2640 != 0.0 && g_isar_2640 > g_ask_2012) li_108 = TRUE;
                  if (CloseOrdersOppositeTrend_ALL == 1)//���ⲿ��������
                     if (g_iosma_2632 < 0.0 && (g_isar_2640 != 0.0 && g_isar_2640 > g_ask_2012)) li_108 = TRUE;
               }
               if (l_cmd_24 == OP_SELL) 
               {
                  if (CloseOrdersOppositeTrend_OsMA == 1 && CloseOrdersOppositeTrend_ALL == 0)
                     if (g_iosma_2632 > 0.0) li_108 = TRUE;
                  if (CloseOrdersOppositeTrend_SAR == 1 && CloseOrdersOppositeTrend_ALL == 0)
                     if (g_isar_2640 != 0.0 && g_isar_2640 < g_bid_2004) li_108 = TRUE;
                  if (CloseOrdersOppositeTrend_ALL == 1)//���ⲿ��������
                     if (g_iosma_2632 > 0.0 && (g_isar_2640 != 0.0 && g_isar_2640 < g_bid_2004)) li_108 = TRUE;
               }
               if (li_108 && CloseOOT_OnlyAfterMinutes != 0)
                  if (TimeCurrent() - OrderOpenTime() < 60 * CloseOOT_OnlyAfterMinutes) li_108 = FALSE;
               if (li_108 && CloseOOT_OnlyAfterDistance_PR != 0.0) 
               {
                  if (l_cmd_24 == OP_BUY) 
                  {
                     ld_80 = g_bid_2004;
                     if (l_ord_open_price_40 > ld_80 && (l_ord_open_price_40 - ld_80) / l_ord_open_price_40 < CloseOOT_OnlyAfterDistance_PR / 100.0) li_108 = FALSE;
                  } //���ּ۴�����ۣ���������Σ�ʱ���൱��Ҫ�ﵽֹ��Ż��������
                  else 
                  {
                     if (l_cmd_24 == OP_SELL) 
                     {
                        ld_80 = g_ask_2012;
                        if (ld_80 > l_ord_open_price_40 && (ld_80 - l_ord_open_price_40) / l_ord_open_price_40 < CloseOOT_OnlyAfterDistance_PR / 100.0) li_108 = FALSE;
                     }//���ּ�С�����ۣ���������Σ�ʱ���൱��Ҫ�ﵽֹ��Ż��������
                  }
               }
               if (li_108) glOrderClose(CommentOrderOperations);
            }
         }
      }
   }
   if (gia_2540[gi_2656] != 0 && gia_2540[gi_2664] != 0) glDeleteAllDeferOrders(gi_2664, g_symbol_1980);//����BUY��BUYLimit����ɾ��limit��
   if (gia_2540[gi_2660] != 0 && gia_2540[gi_2668] != 0) glDeleteAllDeferOrders(gi_2668, g_symbol_1980);//����Sell��sellLimit����ɾ��limit��
   if (gia_2540[gi_2656] != 0 && gia_2540[gi_2672] != 0 && gda_2548[gi_2672] >= gda_2544[gi_2656]) glDeleteAllDeferOrders(gi_2672, g_symbol_1980, gda_2544[gi_2656], 0);//����BUY��BUYStop������Stop�����ּ����ֵ��С��Buy�����ּ���Сֵ,ɾ��Stop��
   if (gia_2540[gi_2660] != 0 && gia_2540[gi_2676] != 0 && gda_2544[gi_2676] <= gda_2548[gi_2660]) glDeleteAllDeferOrders(gi_2676, g_symbol_1980, 0, gda_2548[gi_2660]);//����Sell��sellStop����Stop�����ּ���Сֵ������Buy�����ּ����ֵ,ɾ��Stop��
   if (dProfitForBreakevenSL_PR > 0.0) //�ƶ�ֹ�����
   {
      l_ord_total_12 = OrdersTotal();
      for (l_pos_0 = 0; l_pos_0 < l_ord_total_12; l_pos_0++) 
      {
         OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == g_symbol_1980) {
            if (myIsOwnOrder()) {
               l_ord_open_price_40 = OrderOpenPrice();
               ld_56 = OrderTakeProfit();
               if (OrderType() == OP_BUY) {
                  if (g_bid_2004 > l_ord_open_price_40 * (dProfitForBreakevenSL_PR / 100.0 + 1.0))//��۴��ڿ��ּ�һ�ξ���
                     if (OrderStopLoss() == 0.0 || OrderStopLoss() < l_ord_open_price_40) myOrderModify(OrderTicket(), l_ord_open_price_40, l_ord_open_price_40, ld_56, 0); //�ƶ�ֹ��
               } else {
                  if (OrderType() == OP_SELL) {
                     if (g_ask_2012 < l_ord_open_price_40 * (1 - dProfitForBreakevenSL_PR / 100.0))
                        if (OrderStopLoss() == 0.0 || OrderStopLoss() > l_ord_open_price_40) myOrderModify(OrderTicket(), l_ord_open_price_40, l_ord_open_price_40, ld_56, 0);
                  }
               }
            }
         }
      }
   }
   if (gi_2088 > 0 || dTrailingStop_PR > 0.0) //dTrailingStop_PR=1 ,gi_2088=0
   {
      l_ord_total_12 = OrdersTotal();
      for (l_pos_0 = 0; l_pos_0 < l_ord_total_12; l_pos_0++) {
         OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() == g_symbol_1980) {
            if (myIsOwnOrder()) 
            {
               if (CR_UseTrailingStop == 0)
                  if (OrderMagicNumber() == gi_2328 + 400) continue;
               if (FL_UseTrailingStop == 0)
                  if (OrderMagicNumber() == gi_2328 + 200) continue;
               if (gi_2088 > 0) ld_112 = gd_1988 * gi_2088;
               else ld_112 = OrderOpenPrice() * dTrailingStop_PR / 100.0;
               ld_120 = 0;
               if (gi_2092 > 0) ld_120 = gd_1988 * gi_2092;
               else
                  if (dStepTrailingStop_PR > 0.0) ld_120 = OrderOpenPrice() * dStepTrailingStop_PR / 100.0;
               if (dDeleteTPWhenTrailing == 1) ld_56 = 0;
               else ld_56 = OrderTakeProfit();
               if (OrderType() == OP_BUY) {
                  if (g_bid_2004 > OrderOpenPrice() + ld_112)
                     if (OrderStopLoss() == 0.0 || OrderStopLoss() < g_bid_2004 - ld_112 - ld_120) 
                        myOrderModify(OrderTicket(), OrderOpenPrice(), g_bid_2004 - ld_112, ld_56, 0);
               } else {
                  if (OrderType() == OP_SELL) {
                     if (g_ask_2012 < OrderOpenPrice() - ld_112)
                        if (OrderStopLoss() == 0.0 || OrderStopLoss() > g_ask_2012 + ld_112 + ld_120)
                           myOrderModify(OrderTicket(), OrderOpenPrice(), g_ask_2012 + ld_112, ld_56, 0);
                  }
               }
            }
         }
      }
   }
   if (gia_2540[gi_2656] != 0 && gia_2540[gi_2660] != 0) {
      if ((gi_2080 != 0 && gi_2080 != gi_2060 || gi_2080 != gi_2064) || (gi_2084 != 0 && gi_2084 != gi_2068 || gi_2084 != gi_2072)) {
         ld_80 = (g_ask_2012 + g_bid_2004) / 2.0;
         l_ord_total_12 = OrdersTotal();
         for (l_pos_0 = 0; l_pos_0 < l_ord_total_12; l_pos_0++) {
            if (!OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES)) return (0);
            if (OrderSymbol() == g_symbol_1980) {
               if (myIsOwnOrder()) {
                  l_cmd_24 = OrderType();
                  l_ord_open_price_40 = OrderOpenPrice();
                  ld_56 = OrderTakeProfit();
                  ld_48 = OrderStopLoss();
                  l_magic_28 = OrderMagicNumber();
                  if (l_magic_28 != gi_2328 + 100) {
                     if (l_cmd_24 == OP_BUY && l_ord_open_price_40 == gda_2544[gi_2656]) {
                        if (ld_56 < l_ord_open_price_40 + gi_2080 * gd_1988)
                           if (myOrderModify(OrderTicket(), l_ord_open_price_40, ld_48, l_ord_open_price_40 + gi_2080 * gd_1988, 0)) ld_56 = l_ord_open_price_40 + gi_2080 * gd_1988;
                        if (gi_2084 != 0 && l_ord_open_price_40 > gda_2548[gi_2660] && l_ord_open_price_40 - gda_2548[gi_2660] > 2.2 * gi_2084 * gd_1988 && MathAbs(l_ord_open_price_40 - ld_80) < MathAbs(gda_2548[gi_2660] - ld_80) &&
                           ld_48 < l_ord_open_price_40 - gi_2084 * gd_1988)
                           if (myOrderModify(OrderTicket(), l_ord_open_price_40, l_ord_open_price_40 - gi_2084 * gd_1988, ld_56, 0)) ld_48 = l_ord_open_price_40 - gi_2084 * gd_1988;
                     } else {
                        if (l_cmd_24 == OP_SELL && l_ord_open_price_40 == gda_2548[gi_2660]) {
                           if (ld_56 > l_ord_open_price_40 - gi_2080 * gd_1988)
                              if (myOrderModify(OrderTicket(), l_ord_open_price_40, ld_48, l_ord_open_price_40 - gi_2080 * gd_1988, 0)) ld_56 = l_ord_open_price_40 - gi_2080 * gd_1988;
                           if (gi_2084 != 0 && l_ord_open_price_40 < gda_2544[gi_2656] && gda_2544[gi_2656] - l_ord_open_price_40 > 2.2 * gi_2084 * gd_1988 && MathAbs(l_ord_open_price_40 - ld_80) < MathAbs(gda_2544[gi_2656] - ld_80) &&
                              ld_48 > l_ord_open_price_40 + gi_2084 * gd_1988)
                              if (myOrderModify(OrderTicket(), l_ord_open_price_40, l_ord_open_price_40 + gi_2084 * gd_1988, ld_56, 0)) ld_48 = l_ord_open_price_40 + gi_2084 * gd_1988;
                        }
                     }
                  }
               }
            }
         }
      }
   }
   if (gi_2144 == 1 && gd_2564 != 0.0) {
      if (gi_1664 == 1) {
         if (gd_2564 > 0.0) glDeleteAllDeferOrders(gi_2668, g_symbol_1980);
         if (gd_2564 < 0.0) glDeleteAllDeferOrders(gi_2664, g_symbol_1980);
      }
   }
   if (gi_2160 == 1 && gd_2556 != 0.0) {
      if (gi_1664 == 1) {
         if (gd_2556 > 0.0 && gia_2540[gi_2668] > 0 && gda_2544[gi_2668] < g_bid_2004 + 20.0 * gd_1988) glDeleteAllDeferOrders(gi_2668, g_symbol_1980);
         if (gd_2556 < 0.0 && gia_2540[gi_2664] > 0 && gda_2548[gi_2664] > g_ask_2012 - 20.0 * gd_1988) glDeleteAllDeferOrders(gi_2664, g_symbol_1980);
      }
   }
   if (gi_2196 > 0) {
      if (gi_1664 == 1) {
         for (int l_index_8 = 0; l_index_8 < gi_2196; l_index_8++) {
            switch (l_index_8) {
            case 0:
               gd_2588 = gd_2200;
               break;
            case 1:
               gd_2588 = gd_2216;
               break;
            default:
               continue;
            }
            if (gia_2540[gi_2672] != 0 && gda_2572[l_index_8] > 0.0 && gda_2548[gi_2672] >= gda_2572[l_index_8] + gda_2572[l_index_8] * gd_2588 / 100.0) glDeleteAllDeferOrders(gi_2672, g_symbol_1980, gda_2572[l_index_8] + gda_2572[l_index_8] * gd_2588 / 100.0, 0);
            if (!(gia_2540[gi_2676] != 0 && gda_2576[l_index_8] > 0.0 && gda_2544[gi_2676] <= gda_2576[l_index_8] - gda_2576[l_index_8] * gd_2588 / 100.0)) continue;
            glDeleteAllDeferOrders(gi_2676, g_symbol_1980, 0, gda_2576[l_index_8] - gda_2576[l_index_8] * gd_2588 / 100.0);
         }
      }
   }
   return (0);
}
//----------------------------------------------------------------------------------
//�������"ָ��"��ֵ
void myCalculateIndicators() 
{
   gd_2564 = 0;
   if (gi_2144 == 1) myIndicator_Accelerator();//����������ʾgi_2144 == 0��gi_2144 = gia_1840[ai_0];
   gd_2556 = 0;
   if (gi_2160 == 1) myIndicator_Speed();//gi_2160 == 1//��ȡ���Ʋ���gd_2556���أ�1:������-1��˥����0����һ��
   if (gi_2196 > 0) myIndicator_HighLowLimit();//��¼gi_2196(=2)��ͼ�������С��ڸ��Ե�ƫ��Bars��Χ�ڵ���ߣ���ͼ�//gda_2572[l_index_16]��¼������Bar����Сֵ//gda_2576[l_index_16]��¼������Bar�����ֵ
   if (gi_2232 == 1) myIndicator_Flat();////g_ilow_2600 = l_ilow_0; //��Сֵ��g_ihigh_2608 = l_ihigh_8;//���ֵ��gd_2616 = g_ihigh_2608 - g_ilow_2600; //gd_2616�����߼۵Ĳ�ֵ��gi_2596
   g_iosma_2632 = 0;
   //g_iosma_2632 = iOsMA //�ƶ���ƽ������ָ��
   if (dUseTrendFilterOsMA == 1 || CloseOrdersOppositeTrend_OsMA == 1 || CloseOrdersOppositeTrend_ALL) g_iosma_2632 = iOsMA(g_symbol_1980, gia_2680[diOsMA_TimeFrame], diOsMA_FastEMA, diOsMA_SlowEMA, diOsMA_SignalSMA, diOsMA_TypePrice, 0);
   
   g_isar_2640 = 0;//= iSAR��������״ֹ��ͷ�תָ�겢��������ֵ
   if (dUseTrendFilterSAR == 1 || CloseOrdersOppositeTrend_SAR == 1 || CloseOrdersOppositeTrend_ALL || CR_StopLoss_UseSAR == 1 || diFL_StopLoss_UseSAR == 1) g_isar_2640 = iSAR(g_symbol_1980, gia_2680[diSAR_Filter_TimeFrame], diSAR_Filter_Step, diSAR_Filter_Maximum, 0);
}
//-----------------------------------------------------------------------------------------
//
void myIndicator_Accelerator() 
{
   double lda_0[10][10];
   int lia_4[10];
   for (int l_index_8 = 0; l_index_8 < gi_2152; l_index_8++) //gi_2152 �����ǵ�һ��ʹ��
   {
      for (int li_12 = 0; li_12 < gi_2148; li_12++) //gi_2148 = gia_1844[ai_0];
      lda_0[l_index_8][li_12] = iAC(g_symbol_1980, gia_2680[gi_2156 + l_index_8], li_12);//gi_2156 = gia_1852[ai_0];gia_1852[l_index_0] = diAC_StartTimeFrame ���ⲿ�����������
      if (lda_0[l_index_8][gi_2148 - 2] > lda_0[l_index_8][gi_2148 - 1]) lia_4[l_index_8] = 1;//��������iACС������������ģ���lia_4[l_index_8] = 1
      else 
      {
         if (lda_0[l_index_8][gi_2148 - 2] < lda_0[l_index_8][gi_2148 - 1]) lia_4[l_index_8] = -1;//��������iAC��������������ģ���lia_4[l_index_8] = -1
         else 
         {
            lia_4[l_index_8] = 0;  //������ȣ���lia_4[l_index_8] = 0
            break;
         }
      }
      for (li_12 = gi_2148 - 3; li_12 >= 0; li_12--) 
      {
         if (lia_4[l_index_8] == 1 && lda_0[l_index_8][li_12] <= lda_0[l_index_8][li_12 + 1]) //������Ǻ�ǰ������iACһ����������lia_4[l_index_8] = 0;
         {
            lia_4[l_index_8] = 0;
            break;
         }
         if (lia_4[l_index_8] == -1 && lda_0[l_index_8][li_12] >= lda_0[l_index_8][li_12 + 1]) //������Ǻ�ǰ������iACһ���ǽ�����lia_4[l_index_8] = 0;
         {
            lia_4[l_index_8] = 0;
            break;
         }
      }
   }
   gd_2564 = lia_4[0];// ��¼�ڵ�һ��ʱ��������iAC����ͼ���Bar �ϵ��������
   for (l_index_8 = 1; l_index_8 < gi_2152; l_index_8++) 
   {
      if (lia_4[l_index_8] != gd_2564) 
      {
         gd_2564 = 0;
         break;
      }
   }
   if (gd_2564 != 0.0) gd_2564 = lda_0[0][0] - lda_0[0][1];//5������-15������
}
//-------------------------------------------------------------------------------------
//��ȡ���Ʋ���gd_2556���أ�1:������-1��˥����0����һ��
void myIndicator_Speed() 
{
   double lda_0[10][10];
   int lia_4[10];
   double ld_8;
   double ld_16;                      //gi_2168=2; gi_2164=2
   for (int l_index_24 = 0; l_index_24 < gi_2168; l_index_24++) //5MIn��15Minʱ������
   {
      for (int l_count_28 = 0; l_count_28 < gi_2164; l_count_28++) //��ǰ��1��2��2��3�� �����ͺ����̼�2����ƽ��ֵ
      {                                                            //gi_2172=gia_1868[ai_0];
         ld_8 = (iHigh(g_symbol_1980, gia_2680[gi_2172 + l_index_24], l_count_28 + 2) + iLow(g_symbol_1980, gia_2680[gi_2172 + l_index_24], l_count_28 + 2) + 2.0 * iClose(g_symbol_1980, gia_2680[gi_2172 + l_index_24], l_count_28 + 2)) / 4.0;
         ld_16 = (iHigh(g_symbol_1980, gia_2680[gi_2172 + l_index_24], l_count_28 + 1) + iLow(g_symbol_1980, gia_2680[gi_2172 + l_index_24], l_count_28 + 1) + 2.0 * iClose(g_symbol_1980, gia_2680[gi_2172 + l_index_24], l_count_28 + 1)) / 4.0;
         if (ld_8 > 0.0) lda_0[l_index_24][l_count_28] = (ld_16 - ld_8) / ld_8; //�ض����������������ƽ��ֵ��������
         else lda_0[l_index_24][l_count_28] = 0;
      }
      if (l_index_24 == 0 && gi_2172 == 0) //������Ĳ�������gi_2172==1 //����1MIN���ڡ���ǰ���ķ���
      {
         if (g_bid_2004 > iOpen(g_symbol_1980, gia_2680[0], 0)) lia_4[0] = 1;
         else {
            if (g_bid_2004 < iOpen(g_symbol_1980, gia_2680[0], 0)) lia_4[0] = -1;
            else {
               if (lda_0[l_index_24][0] > 0.0) lia_4[l_index_24] = 1; //ͬһ���Ĳ�ͬ����ʱ��ֵ�ж�
               else {
                  if (lda_0[l_index_24][0] < 0.0) lia_4[l_index_24] = -1;//
                  else {
                     lia_4[l_index_24] = 0;
                     break;
                  }
               }
            }
         }   //lda_0[l_index_24][l_count_28]��ʾ����������
      } 
      else //����5��15MIN���ڡ���ǰ������������1-2�ķ���
      {
         if (iOpen(g_symbol_1980, gia_2680[gi_2172 + l_index_24], 0) > iClose(g_symbol_1980, gia_2680[gi_2172 + l_index_24], 1)) 
            lia_4[l_index_24] = 1;
         else {
            if (iOpen(g_symbol_1980, gia_2680[gi_2172 + l_index_24], 0) < iClose(g_symbol_1980, gia_2680[gi_2172 + l_index_24], 1)) 
               lia_4[l_index_24] = -1;
            else {  //==
               if (lda_0[l_index_24][0] > 0.0) lia_4[l_index_24] = 1;
               else {
                  if (lda_0[l_index_24][0] < 0.0) lia_4[l_index_24] = -1;
                  else {
                     lia_4[l_index_24] = 0;
                     break;
                  }
               }
            }
         }
      }
      if ((lda_0[l_index_24][gi_2164 - 1]) * lia_4[l_index_24] <= 0.0) //2-3���������ʺ͵�ǰ����1-2�������Ʋ�һ��ʱ��lia_4[l_index_24] = 0
      {
         lia_4[l_index_24] = 0;
         break;
      }
      for (l_count_28 = gi_2164 - 2; l_count_28 >= 0; l_count_28--) //��ǰ�������l_count_28==0  //�����Ƿ�һ��
      {
         if (lia_4[l_index_24] == 1 && lda_0[l_index_24][l_count_28] <= lda_0[l_index_24][l_count_28 + 1]) //�����ģ����治��ǰ�������Ŀ�lia_4[l_index_24] = 0��break
         {
            lia_4[l_index_24] = 0;
            break;
         }
         if (lia_4[l_index_24] == -1 && lda_0[l_index_24][l_count_28] >= lda_0[l_index_24][l_count_28 + 1])//���ٵģ����治��ǰ����ٵĿ�lia_4[l_index_24] = 0��break 
         {
            lia_4[l_index_24] = 0;
            break;
         }
      }
   }///---�������һ��for��
   gd_2556 = lia_4[0];//��¼5Min��������;1:������-1��˥����0����һ��
   for (l_index_24 = 1; l_index_24 < gi_2168; l_index_24++) //�ж�5��15Min�������Ƿ�һ��1:������-1��˥����0����һ��
   {
      if (lia_4[l_index_24] != gd_2556) 
      {
         gd_2556 = 0;
         break;
      }
   }
   if (gd_2556 != 0.0) //5��15Min������һ��
   {
      ld_8 = iOpen(g_symbol_1980, gia_2680[0], 0);//��ǰ����һ���������ϵĿ��̼�
      ld_16 = g_bid_2004;
      if (gi_2172 == 0 && ld_8 != ld_16 && ld_8 > 0.0) //�˳������������
      {
         gd_2556 = (ld_16 - ld_8) / ld_8;
         return;
      }
      gd_2556 = lda_0[0][0];//��ǰ����5MIN����
   }
}//----------------------------�����Ľ���λ��
//--------------------------------------------------------------------------
//��¼��ͼ�������С��ڸ��Ե�ƫ��Bars��Χ�ڵ���ߣ���ͼ�//gda_2572[l_index_16]��¼������Bar����Сֵ//gda_2576[l_index_16]��¼������Bar�����ֵ
void myIndicator_HighLowLimit() 
{
   int li_0;
   int li_4;
   double l_ilow_20;
   double l_ihigh_28;
   for (int l_index_16 = 0; l_index_16 < gi_2196; l_index_16++) //gi_2196==2
   {
      gda_2572[l_index_16] = 0; //gda_2572[2]��da_2576[2]��ʼ��
      gda_2576[l_index_16] = 0;
      switch (l_index_16) 
      {
      case 0:
         li_4 = gi_2208; //5  //����ѡ��4Hour
         li_0 = gi_2212; //6 //Barƫ��ֵ
         break;
      case 1:
         li_4 = gi_2224;//7   //����ѡ��1Week
         li_0 = gi_2228;//2//Barƫ��ֵ
         break;
      default:
         continue;
      }
      for (int li_8 = 0; li_8 < li_0; li_8++) 
      {
         l_ilow_20 = iLow(g_symbol_1980, gia_2680[li_4], li_8);//
         l_ihigh_28 = iHigh(g_symbol_1980, gia_2680[li_4], li_8);
         if (l_ilow_20 > 0.0)
            if (gda_2572[l_index_16] == 0.0 || l_ilow_20 < gda_2572[l_index_16]) gda_2572[l_index_16] = l_ilow_20; //gda_2572[l_index_16]��¼������Bar����Сֵ
         if (l_ihigh_28 > 0.0)
            if (gda_2576[l_index_16] == 0.0 || l_ihigh_28 > gda_2576[l_index_16]) gda_2576[l_index_16] = l_ihigh_28;//gda_2576[l_index_16]��¼������Bar�����ֵ
      }
   }
}
//----------------------------------------------------------------------------------
//15Min:g_ilow_2600 = l_ilow_0; //��Сֵ��g_ihigh_2608 = l_ihigh_8;//���ֵ��gd_2616 = g_ihigh_2608 - g_ilow_2600; //gd_2616�����߼۵Ĳ�ֵ��gi_2596
void myIndicator_Flat() 
{
   double l_ilow_0;
   double l_ihigh_8;
   int l_count_24;
   int l_count_28;
   int li_32;
   double l_ilow_44;
   double l_ihigh_52;
   double ld_16 = g_spread_2020 * gd_1988; //����С
   gi_2596 = FALSE;
   g_ilow_2600 = 0;
   g_ihigh_2608 = 0;
   gd_2616 = 0;
   for (int li_36 = 0; li_36 < gi_2260; li_36++) //gi_2260=8
   {
      l_ilow_0 = iLow(g_symbol_1980, gia_2680[gi_2256], li_36);//gi_2256=2 ��15MIn
      l_ihigh_8 = iHigh(g_symbol_1980, gia_2680[gi_2256], li_36);
      if (l_ilow_0 > 0.0)
         if (g_ilow_2600 == 0.0 || l_ilow_0 < g_ilow_2600) g_ilow_2600 = l_ilow_0; //��Сֵ
      if (l_ihigh_8 > 0.0)
         if (g_ihigh_2608 == 0.0 || l_ihigh_8 > g_ihigh_2608) g_ihigh_2608 = l_ihigh_8;//���ֵ
   }
   gd_2616 = g_ihigh_2608 - g_ilow_2600; //gd_2616�����߼۵Ĳ�ֵ
   if (g_ihigh_2608 > 0.0 && g_ilow_2600 > 0.0 && gd_2616 - ld_16 >= g_bid_2004 * gd_2236 / 100.0 && gd_2616 - ld_16 <= g_bid_2004 * gd_2244 / 100.0) 
   {//�����ͼ۵Ĳ�ֵ-���������*0.1/100��С������*0.4/100
      l_count_24 = 0;
      l_count_28 = 0;
      li_32 = 0;
      for (li_36 = 0; li_36 < gi_2260; li_36++)// 8
      {
         l_ilow_0 = iLow(g_symbol_1980, gia_2680[gi_2256], li_36);
         l_ihigh_8 = iHigh(g_symbol_1980, gia_2680[gi_2256], li_36);
         if (l_ilow_0 > 0.0 && l_ilow_0 < g_ilow_2600 + gd_2616 / 4.0 && li_32 >= 0) 
         {
            li_32 = -1;
            l_count_24++;//ȡ��15Min���ڸ�Bar��СֵС��������Сֵ�������߼۵Ĳ�ֵ�ķ�֮һ֮�͵�bar��
         }
         if (l_ihigh_8 > 0.0 && l_ihigh_8 > g_ihigh_2608 - gd_2616 / 4.0 && li_32 <= 0) 
         {
            li_32 = 1;
            l_count_28++;//ȡ��15Min���ڸ�Bar���ֵ�����������ֵ�������߼۵Ĳ�ֵ�ķ�֮һ֮�ͣ���bar��
         }
      }
      if (diFL_UseConditionTakeOver == 1) 
      {
         l_ilow_44 = 0;
         l_ihigh_52 = 0;
         for (li_36 = 0; li_36 < 100; li_36++) 
         {
            l_ilow_0 = iLow(g_symbol_1980, gia_2680[diFL_PeriodTakeOver], li_36);   //diFL_PeriodTakeOver==4,1Hour
            l_ihigh_8 = iHigh(g_symbol_1980, gia_2680[diFL_PeriodTakeOver], li_36);
            if (li_36 >= diFL_CountBarsTakeOver)   //diFL_CountBarsTakeOver==2
               if (l_ilow_0 < l_ilow_44 && l_ihigh_8 > l_ihigh_52) break;//��ǰ��������������Сֵ������������ķ�Χ�⣬��break
            if (l_ilow_0 > 0.0)//
               if (l_ilow_44 == 0.0 || l_ilow_0 < l_ilow_44) l_ilow_44 = l_ilow_0;//l_ilow_44��¼��Сֵ
            if (l_ihigh_8 > 0.0)
               if (l_ihigh_52 == 0.0 || l_ihigh_8 > l_ihigh_52) l_ihigh_52 = l_ihigh_8;//l_ihigh_52��¼���ֵ
            if (l_ihigh_52 - l_ilow_44 >= g_bid_2004 * gd_2244 / 100.0) return;//gd_2244 = gda_1924[ai_0];
         }
      }
      if (l_count_24 >= gi_2252 && l_count_28 >= gi_2252) gi_2596 = TRUE;//gi_2252=1, gi_2252 = gia_1928[ai_0];
   }
}
//-----------------------------------------------------------------------
//�������ǰ׺���ⲿ����OwnMagicPrefix���Ƿ�һ��
bool myIsOwnOrder(int a_magic_0 = -1) 
{
   if (a_magic_0 == -1) a_magic_0 = OrderMagicNumber();
   string l_magic_4 = a_magic_0;
   string ls_12 = OwnMagicPrefix;
   if (StringFind(l_magic_4, ls_12, 0) == 0) return (TRUE);
   return (FALSE);
}
//---------------------------------------------------------------------------
//���ݶ������ͣ�ai_0��������Ӧ��ֵ
int myGetNormalOrderType(int ai_0) 
{
   switch (ai_0) 
   {
   case 0:
      return (gi_2656);
   case 1:
      return (gi_2660);
   case 2:
      return (gi_2664);
   case 4:
      return (gi_2672);
   case 3:
      return (gi_2668);
   case 5:
      return (gi_2676);
   }
   return (-1);
}
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

int myOrderSend(string a_symbol_0, int a_cmd_8, double a_lots_12, double a_price_20, int a_slippage_28, double ad_32, double ad_40, string as_48 = "", int a_magic_56 = 0, int a_datetime_60 = 0, color a_color_64 = -1) 
{
   int l_error_76;
   double l_price_80;
   double l_price_88;
   string l_comment_96 = PrefixOrderComment;
   string ls_104 = a_magic_56;//?int a_magic_56 = 0
   if (StringLen(ls_104) >= 4) {
      l_comment_96 = StringConcatenate(l_comment_96, "T");
      ls_104 = StringSubstr(ls_104, StringLen(ls_104) - 4, 4);//ȡ����λ
      for (int li_68 = 0; li_68 < StringLen(ls_104); li_68++)
         if (StringSubstr(ls_104, li_68, 1) != "0") l_comment_96 = StringConcatenate(l_comment_96, StringSubstr(ls_104, li_68, 1));
   }
   l_comment_96 = StringConcatenate(l_comment_96, as_48);
   if (Set_TP_SL_ByModifyOrder == 1) 
   {
      l_price_88 = 0;
      l_price_80 = 0;
      l_comment_96 = StringConcatenate(l_comment_96, " {TP=", ad_40, "} {SL=", ad_32, "}");
   } 
   else {
      l_price_88 = ad_40;
      l_price_80 = ad_32;
   }
   if (gd_2524 != gd_2624 && gd_2524 != 0.0) {
      Print("OLD tick!");
      return (-1);
   }
  if (CommentOrderOperations) Print(" : ", a_symbol_0, " / ", glGetOrderTypeStr(a_cmd_8), " ", a_lots_12, " at ", a_price_20, " / tp = ", l_price_88, " sl = ", l_price_80);
   int l_ticket_72 = OrderSend(a_symbol_0, a_cmd_8, a_lots_12, a_price_20, a_slippage_28, 0, 0, l_comment_96, a_magic_56, a_datetime_60, a_color_64);
    if (l_ticket_72 > -1) {
         OrderSelect(l_ticket_72, SELECT_BY_TICKET);
         OrderModify(OrderTicket(), OrderOpenPrice(), l_price_80, l_price_88, 0, Green);
      }
   if (PlaySoundWhenOpenOrder) PlaySound(FileNameSoundOpenOrder);
   if (l_ticket_72 > 0) {
      if (OrderSelect(l_ticket_72, SELECT_BY_TICKET, MODE_TRADES)) {
         if (CommentOrderOperations) Print(" ");
         return (l_ticket_72);
      }
      if (CommentOrderOperations) {
         l_error_76 = GetLastError();
         Print(" : ", l_error_76, " (", ErrorDescription(l_error_76), ")");
      }
   }
   return (-1);
}
//--------------------------------------------------------------------------------------------------------------------------------------------------
//�޸�
bool myOrderModify(int a_ticket_0, double a_price_4, double a_price_12, double a_price_20, int a_datetime_28 = 0, color a_color_32 = -1) {
   int l_error_36;
   if (CommentOrderOperations) Print(" : ", a_ticket_0, " at ", a_price_4, " / tp = ", a_price_20, " sl = ", a_price_12);
   if (OrderModify(a_ticket_0, a_price_4, a_price_12, a_price_20, a_datetime_28, a_color_32)) {
      if (CommentOrderOperations) Print(" ");
      return (TRUE);
   }
   if (CommentOrderOperations) {
      l_error_36 = GetLastError();
      Print(" ", l_error_36, " (", ErrorDescription(l_error_36), ")");
   }
   return (FALSE);
}
//------------------------------------------------
//ɾ���ҵ���������CommentOrderOperationsѡ���Ƿ���������Ϣ
bool myOrderDelete(int a_ticket_0) 
{
   int l_error_4;
   if (CommentOrderOperations) Print(" : ", a_ticket_0);
   if (OrderDelete(a_ticket_0)) 
   {
      if (CommentOrderOperations) Print(" ");
      return (TRUE);
   }
   if (CommentOrderOperations) 
   {
      l_error_4 = GetLastError();
      Print(" : ", l_error_4, " (", ErrorDescription(l_error_4), ")");
   }
   return (FALSE);
}
//-----------------------------------------------------------------------------
//GetSymbolSettingsDay
void myGetSymbolSettingsDay() 
{
   int li_4;
   int li_8;
   string l_str_concat_12;
   string ls_20;
   string ls_28;
   double l_digits_36;
   if (TypeOfQuoteDigits == 0) //TypeOfQuoteDigits Ϊ�ⲿ������� Ĭ����0
   {
      l_str_concat_12 = "EURUSD";
      if (CustomNameForCurrencyPair != "AAABBB" && StringFind(CustomNameForCurrencyPair, "AAA") >= 0 && StringFind(CustomNameForCurrencyPair, "BBB") >= 0) 
      {//��CustomNameForCurrencyPair��ֻ����"BBBAAA"
         li_4 = StringFind(CustomNameForCurrencyPair, "AAA");
         li_8 = StringFind(CustomNameForCurrencyPair, "BBB");
         if (li_4 > 0) ls_20 = StringSubstr(CustomNameForCurrencyPair, 0, li_4);
         else ls_20 = "";
         l_str_concat_12 = StringConcatenate(ls_20, "EUR", StringSubstr(CustomNameForCurrencyPair, li_4 + 3));//ls_20("BBB")+"EUR"+��ȡ"AAA"֮����ַ���(�յ�)
         if (li_8 > 0) ls_28 = StringSubstr(l_str_concat_12, 0, li_8);
         else ls_28 = "";
         l_str_concat_12 = StringConcatenate(ls_28, "USD", StringSubstr(l_str_concat_12, li_8 + 3));//ls_28(�յ�)+"USD"+"USD"
      }
      l_digits_36 = MarketInfo(l_str_concat_12, MODE_DIGITS);////
      if (l_digits_36 == 4.0) gi_2336 = 1;
      else 
      {
         if (l_digits_36 == 5.0) gi_2336 = 2;
         else gi_2336 = 1;    //����С������ȷ���������ֵ�ֵ
      }
   } else gi_2336 = TypeOfQuoteDigits;
 //---------------------------------------------  
   gd_2580 = g_str2int_2484 % 123 + 123;//�˻����ִ���g_str2int_2484���Ѷ��庯��GetSymbolsSettingsFromStrings ���ж���
   for (int l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) 
   {
      gda_1716[l_index_0] = MarketInfo(gsa_1704[l_index_0], MODE_SWAPLONG); //���ǲ�λ���ڡ�
      gda_1720[l_index_0] = MarketInfo(gsa_1704[l_index_0], MODE_SWAPSHORT);//���ղ�λ���ڡ�
      
      if (gi_2336 == 2) 
      {
         if(gia_1748[l_index_0] < 30 && IsCurrencyPair(gsa_1704[l_index_0], CustomNameForCurrencyPair)) 
         {
            Print("  ", gsa_1704[l_index_0], " - MaxSpreadForTradeSymbol = ", 10 * gia_1748[l_index_0]);
            gia_1748[l_index_0] = 10 * gia_1748[l_index_0];  //=120
         }
         if (gia_1752[l_index_0] != 0 && gia_1752[l_index_0] < 50) //���ڵĲ�������gia_1752[l_index_0]=0
         {                                                   //gia_1752=sFixedTakeProfit���������֣�����ΪdFixedTakeProfit(0)
            Print(" ", gsa_1704[l_index_0], " - FixedTakeProfit = ", 10 * gia_1752[l_index_0]);
            gia_1752[l_index_0] = 10 * gia_1752[l_index_0];
         }
         if (gia_1756[l_index_0] != 0 && gia_1756[l_index_0] < 50) //���ڵĲ�������gia_1756[l_index_0]=0
         {                                                     //gia_1756=sFixedStopLoss���������� ,����ΪdFixedStopLoss(0)
            Print(" ", gsa_1704[l_index_0], " - FixedStopLoss = ", 10 * gia_1756[l_index_0]);
            gia_1756[l_index_0] = 10 * gia_1756[l_index_0];
         }
         if (gia_1788[l_index_0] != 0 && gia_1788[l_index_0] < 50) //gia_1788=dTrailingStop = 0;�ƶ�ֹ��
         {
            Print(" ", gsa_1704[l_index_0], " - TrailingStop = ", 10 * gia_1788[l_index_0]);
            gia_1788[l_index_0] = 10 * gia_1788[l_index_0];
         }
         if (gia_1792[l_index_0] != 0 && gia_1792[l_index_0] < 10) //gia_1792=dStepTrailingStop = 0;
         {
            Print(" ", gsa_1704[l_index_0], " - StepTrailingStop = ", 10 * gia_1792[l_index_0]);
            gia_1792[l_index_0] = 10 * gia_1792[l_index_0];
         }
      }
   }
   g_day_2324 = Day();//��������µĵ���,���һ�η��ʷ�������ʱ��
}
//-------------------------------------------------------------------------------
//����Ӧ�ַ����еĸ������ҶԵ��������ִ�������
void GetSymbolsSettingsFromStrings() 
{
   string lsa_4[];
   string ls_8;
   myGetSettingsFromString(lsa_4, sUseBuy);//sUseBuy=""ָ����ʲô��
   for(int l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) 
   {
      if (gia_1728[l_index_0] == 1)
         if (lsa_4[l_index_0] != "<def>") gia_1728[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   myGetSettingsFromString(lsa_4, sUseSell);//
   for(l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) 
   {
      if (gia_1732[l_index_0] == 1)
         if (lsa_4[l_index_0] != "<def>") gia_1732[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1724, gi_1700);
   myGetSettingsFromString(lsa_4, sUseOnlyPlusSwaps);
   for(l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) 
   {
      if (lsa_4[l_index_0] == "<def>") gia_1724[l_index_0] = dUseOnlyPlusSwaps;
      else gia_1724[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1776, gi_1700);
   myGetSettingsFromString(lsa_4, sTimeStopLoss_Minutes);
   for(l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) 
   {
      if (lsa_4[l_index_0] == "<def>") gia_1776[l_index_0] = dTimeStopLoss_Minutes;
      else gia_1776[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1752, gi_1700);
   myGetSettingsFromString(lsa_4, sFixedTakeProfit);
   for(l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) 
   {
      if (lsa_4[l_index_0] == "<def>") gia_1752[l_index_0] = dFixedTakeProfit;
      else gia_1752[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1756, gi_1700);
   myGetSettingsFromString(lsa_4, sFixedStopLoss);
   for(l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1756[l_index_0] = dFixedStopLoss;
      else gia_1756[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1760, gi_1700);
   myGetSettingsFromString(lsa_4, gs_596);
   for(l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) 
   {
      if (lsa_4[l_index_0] == "<def>") gia_1760[l_index_0] = gi_592;
      else gia_1760[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1760[l_index_0] != 0) gia_1760[l_index_0] = MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1760[l_index_0]);
   }
   ArrayResize(gia_1764, gi_1700);
   myGetSettingsFromString(lsa_4, gs_608);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1764[l_index_0] = gi_604;
      else gia_1764[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1764[l_index_0] != 0) gia_1764[l_index_0] = MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1764[l_index_0]);
   }
   ArrayResize(gia_1768, gi_1700);
   myGetSettingsFromString(lsa_4, gs_620);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1768[l_index_0] = gi_616;
      else gia_1768[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1768[l_index_0] != 0) gia_1768[l_index_0] = MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1768[l_index_0]);
   }
   ArrayResize(gia_1772, gi_1700);
   myGetSettingsFromString(lsa_4, gs_632);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1772[l_index_0] = gi_628;
      else gia_1772[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1772[l_index_0] != 0) gia_1772[l_index_0] = MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1772[l_index_0]);
   }
   ArrayResize(gia_1780, gi_1700);
   myGetSettingsFromString(lsa_4, gs_644);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1780[l_index_0] = gi_640;
      else gia_1780[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1780[l_index_0] != 0) gia_1780[l_index_0] = MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1780[l_index_0]);
   }
   ArrayResize(gia_1784, gi_1700);
   myGetSettingsFromString(lsa_4, gs_656);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1784[l_index_0] = gi_652;
      else gia_1784[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1784[l_index_0] != 0) gia_1784[l_index_0] = MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1784[l_index_0]);
   }
   ArrayResize(gia_1788, gi_1700);
   myGetSettingsFromString(lsa_4, sTrailingStop);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1788[l_index_0] = dTrailingStop;   //=0
      else gia_1788[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1788[l_index_0] != 0) gia_1788[l_index_0] = MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gia_1788[l_index_0]);
   }
 //----------------------------------------
   gd_2292 = 34.0 * LicenseKey;
 //--------------------------------------------
   ArrayResize(gia_1792, gi_1700);
   myGetSettingsFromString(lsa_4, sStepTrailingStop);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1792[l_index_0] = dStepTrailingStop;
      else gia_1792[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1792[l_index_0] < 0) gia_1792[l_index_0] = 0;
   }
   ArrayResize(gia_1796, gi_1700);
   myGetSettingsFromString(lsa_4, gs_536);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1796[l_index_0] = gi_532;
      else gia_1796[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1800, gi_1700);
   myGetSettingsFromString(lsa_4, gs_548);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1800[l_index_0] = gi_544;
      else gia_1800[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1800[l_index_0] > 100) gia_1800[l_index_0] = -1;
   }
   ArrayResize(gia_1804, gi_1700);
   myGetSettingsFromString(lsa_4, gs_560);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1804[l_index_0] = gi_556;
      else gia_1804[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1804[l_index_0] > 100) gia_1804[l_index_0] = -1;
   }
   ArrayResize(gia_1808, gi_1700);
   myGetSettingsFromString(lsa_4, gs_572);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1808[l_index_0] = gi_568;
      else gia_1808[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1808[l_index_0] > 100) gia_1808[l_index_0] = -1;
   }
   ArrayResize(gia_1812, gi_1700);
   myGetSettingsFromString(lsa_4, gs_584);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1812[l_index_0] = gi_580;
      else gia_1812[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1812[l_index_0] > 100) gia_1812[l_index_0] = -1;
   }
   ArrayResize(gia_1816, gi_1700);
   myGetSettingsFromString(lsa_4, sUseOneWayRealOrdersB);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1816[l_index_0] = dUseOneWayRealOrdersB;
      else gia_1816[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   //--------------------------------------------------------------------------------------------------------------------------------------------------
   if (StringLen(g_acc_number_2348) > 2) ls_8 = StringSubstr(g_acc_number_2348, 1, StringLen(g_acc_number_2348) - 2);//��ȡ��ǰ�˻����ֳ�ȥͷ����β���Ĳ���
   else ls_8 = g_acc_number_2348;
   g_str2int_2484 = StrToInteger(ls_8);//��¼���˻����ֵĴ���
   //-----------------------------------------------------------------------------------------------------------------------
   ArrayResize(gia_1820, gi_1700);
   myGetSettingsFromString(lsa_4, sUseOneWayRealOrdersS);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1820[l_index_0] = dUseOneWayRealOrdersS;
      else gia_1820[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1824, gi_1700);
   myGetSettingsFromString(lsa_4, sMinDistanceRealOrdersB_PR);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1824[l_index_0] = dMinDistanceRealOrdersB_PR;
      else gda_1824[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1828, gi_1700);
   myGetSettingsFromString(lsa_4, sMinDistanceRealOrdersS_PR);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1828[l_index_0] = dMinDistanceRealOrdersS_PR;
      else gda_1828[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1832, gi_1700);
   myGetSettingsFromString(lsa_4, gs_512);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1832[l_index_0] = gi_508;
      else gia_1832[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1836, gi_1700);
   myGetSettingsFromString(lsa_4, gs_524);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1836[l_index_0] = gi_520;
      else gia_1836[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1840, gi_1700);
   myGetSettingsFromString(lsa_4, sUseAcceleratorIndicator);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) 
   {
      if (lsa_4[l_index_0] == "<def>") gia_1840[l_index_0] = dUseAcceleratorIndicator;
      else gia_1840[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1844, gi_1700);
   myGetSettingsFromString(lsa_4, siAC_CountBars);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) 
   {
      if (lsa_4[l_index_0] == "<def>") gia_1844[l_index_0] = diAC_CountBars;
      else gia_1844[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1844[l_index_0] < 2) gia_1844[l_index_0] = 2;
      if (gia_1844[l_index_0] > 10) gia_1844[l_index_0] = 10;
   }
   ArrayResize(gia_1848, gi_1700);
   myGetSettingsFromString(lsa_4, siAC_CountTimeFrames);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) 
   {
      if (lsa_4[l_index_0] == "<def>") gia_1848[l_index_0] = diAC_CountTimeFrames;
      else gia_1848[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1848[l_index_0] < 1) gia_1848[l_index_0] = 1;
      if (gia_1848[l_index_0] > 5) gia_1848[l_index_0] = 5;
   }
   ArrayResize(gia_1852, gi_1700);
   myGetSettingsFromString(lsa_4, siAC_StartTimeFrame);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1852[l_index_0] = diAC_StartTimeFrame;
      else gia_1852[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1856, gi_1700);
   myGetSettingsFromString(lsa_4, sUseSpeedIndicator);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1856[l_index_0] = dUseSpeedIndicator;
      else gia_1856[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1860, gi_1700);
   myGetSettingsFromString(lsa_4, siSP_CountBars);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1860[l_index_0] = diSP_CountBars;
      else gia_1860[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1860[l_index_0] < 2) gia_1860[l_index_0] = 2;
      if (gia_1860[l_index_0] > 10) gia_1860[l_index_0] = 10;
   }
   ArrayResize(gia_1864, gi_1700);
   myGetSettingsFromString(lsa_4, siSP_CountTimeFrames);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1864[l_index_0] = diSP_CountTimeFrames;
      else gia_1864[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1864[l_index_0] < 1) gia_1864[l_index_0] = 1;
      if (gia_1864[l_index_0] > 5) gia_1864[l_index_0] = 5;
   }
   ArrayResize(gia_1868, gi_1700);
   myGetSettingsFromString(lsa_4, siSP_StartTimeFrame);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1868[l_index_0] = diSP_StartTimeFrame;
      else gia_1868[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1872, gi_1700);
   myGetSettingsFromString(lsa_4, gs_1240);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1872[l_index_0] = gi_1236;
      else gia_1872[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1876, gi_1700);
   myGetSettingsFromString(lsa_4, gs_1256);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1876[l_index_0] = gd_1248;
      else gda_1876[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1880, gi_1700);
   myGetSettingsFromString(lsa_4, gs_1268);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1880[l_index_0] = gi_1264;
      else gda_1880[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1884, gi_1700);
   myGetSettingsFromString(lsa_4, gs_1280);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1884[l_index_0] = gi_1276;
      else gda_1884[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gda_1884[l_index_0] != 0.0) gda_1884[l_index_0] = MathMax(MarketInfo(gsa_1704[l_index_0], MODE_STOPLEVEL), gda_1884[l_index_0]);
   }
   ArrayResize(gia_1888, gi_1700);
   myGetSettingsFromString(lsa_4, sCountHighLowLimits);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1888[l_index_0] = dCountHighLowLimits;
      else gia_1888[l_index_0] = StrToInteger(lsa_4[l_index_0]);
      if (gia_1888[l_index_0] > 2) gia_1888[l_index_0] = 2;
   }
   ArrayResize(gda_1892, gi_1700);
   myGetSettingsFromString(lsa_4, siHL_LimitDistance1_PR);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1892[l_index_0] = diHL_LimitDistance1_PR;
      else gda_1892[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1896, gi_1700);
   myGetSettingsFromString(lsa_4, siHL_Period1);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1896[l_index_0] = diHL_Period1;
      else gia_1896[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1900, gi_1700);
   myGetSettingsFromString(lsa_4, siHL_CountBars1);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1900[l_index_0] = diHL_CountBars1;
      else gia_1900[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1904, gi_1700);
   myGetSettingsFromString(lsa_4, siHL_LimitDistance2_PR);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1904[l_index_0] = diHL_LimitDistance2_PR;
      else gda_1904[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1908, gi_1700);
   myGetSettingsFromString(lsa_4, siHL_Period2);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1908[l_index_0] = diHL_Period2;
      else gia_1908[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1912, gi_1700);
   myGetSettingsFromString(lsa_4, siHL_CountBars2);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1912[l_index_0] = diHL_CountBars2;
      else gia_1912[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1916, gi_1700);
   myGetSettingsFromString(lsa_4, sUseFlatIndicator);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1916[l_index_0] = dUseFlatIndicator;
      else gia_1916[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1920, gi_1700);
   myGetSettingsFromString(lsa_4, siFL_MinWidthCanal_PR);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1920[l_index_0] = diFL_MinWidthCanal_PR;
      else gda_1920[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1924, gi_1700);
   myGetSettingsFromString(lsa_4, siFL_MaxWidthCanal_PR);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1924[l_index_0] = diFL_MaxWidthCanal_PR;
      else gda_1924[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1928, gi_1700);
   myGetSettingsFromString(lsa_4, siFL_MinExtremumsCount);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1928[l_index_0] = diFL_MinExtremumsCount;
      else gia_1928[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1932, gi_1700);
   myGetSettingsFromString(lsa_4, siFL_Period);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1932[l_index_0] = diFL_Period;
      else gia_1932[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1936, gi_1700);
   myGetSettingsFromString(lsa_4, siFL_CountBars);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1936[l_index_0] = diFL_CountBars;
      else gia_1936[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1940, gi_1700);
   myGetSettingsFromString(lsa_4, siFL_StopLoss_PR);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1940[l_index_0] = diFL_StopLoss_PR;//0.0
      else gda_1940[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1944, gi_1700);
   myGetSettingsFromString(lsa_4, siFL_LotSizeMultiply);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1944[l_index_0] = diFL_LotSizeMultiply;
      else gda_1944[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1744, gi_1700); //Ĭ��0.01
   myGetSettingsFromString(lsa_4, sRisk);//sRisk �ⲿ������Ʋ���
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1744[l_index_0] = dRisk; //0.01
      else gda_1744[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1748, gi_1700);   //gia_1748 ���
   myGetSettingsFromString(lsa_4, sMaxSpreadForTradeSymbol);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) 
   {
      if (lsa_4[l_index_0] == "<def>") gia_1748[l_index_0] = dMaxSpreadForTradeSymbol; //gia_1748[l_index_0] = 12
      else gia_1748[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1948, gi_1700);// 
   myGetSettingsFromString(lsa_4, sMinLotSize);//�ó���С����С��׼��������������gda_1948��
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1948[l_index_0] = dMinLotSize;//0.01
      else gda_1948[l_index_0] = StrToDouble(lsa_4[l_index_0]);
      if (gda_1948[l_index_0] != 0.0) gda_1948[l_index_0] = MathMax(MarketInfo(gsa_1704[l_index_0], MODE_MINLOT), gda_1948[l_index_0]);
      else gda_1948[l_index_0] = MarketInfo(gsa_1704[l_index_0], MODE_MINLOT);
   }
   ArrayResize(gda_1952, gi_1700);
   myGetSettingsFromString(lsa_4, sMaxLotSize);//�ó�����������׼��������������gda_1952��
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1952[l_index_0] = dMaxLotSize;
      else gda_1952[l_index_0] = StrToDouble(lsa_4[l_index_0]);
      if (gda_1952[l_index_0] != 0.0) gda_1952[l_index_0] = MathMin(MarketInfo(gsa_1704[l_index_0], MODE_MAXLOT), gda_1952[l_index_0]);
      else gda_1952[l_index_0] = MarketInfo(gsa_1704[l_index_0], MODE_MAXLOT);
   }
   ArrayResize(gda_1956, gi_1700);//gda_1956 MAX(dStepLotSize=0.01, MODE_LOTSTEP)
   myGetSettingsFromString(lsa_4, sStepLotSize);//�����Ĳ�ֵ �ⲿ�����˹�����
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1956[l_index_0] = dStepLotSize;//���û���ҵ����Ӧ��"����ֵ"����ⲿ������������=0.01
      else gda_1956[l_index_0] = StrToDouble(lsa_4[l_index_0]);
      if (gda_1956[l_index_0] != 0.0) gda_1956[l_index_0] = MathMax(MarketInfo(gsa_1704[l_index_0], MODE_LOTSTEP), gda_1956[l_index_0]);
      else gda_1956[l_index_0] = MarketInfo(gsa_1704[l_index_0], MODE_LOTSTEP);
   }
   ArrayResize(gia_1976, gi_1700);
   myGetSettingsFromString(lsa_4, sSlipPage);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1976[l_index_0] = dSlipPage;
      else gia_1976[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1960, gi_1700);
   myGetSettingsFromString(lsa_4, gs_1656);//�ȴӵڶ�������gs_1656�������������� ��ΪRef��ֵΪgi_1652
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1960[l_index_0] = gi_1652;//=1
      else gia_1960[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1736, gi_1700);
   myGetSettingsFromString(lsa_4, gs_232, ";", "<def>", gs_240);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1736[l_index_0] = 0;
      else gda_1736[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gda_1740, gi_1700);
   myGetSettingsFromString(lsa_4, gs_248, ";", "<def>", gs_256);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gda_1740[l_index_0] = 0;
      else gda_1740[l_index_0] = StrToDouble(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1964, gi_1700);
   myGetSettingsFromString(lsa_4, sMaxSymbolOrdersCount);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1964[l_index_0] = dMaxSymbolOrdersCount;
      else gia_1964[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1968, gi_1700);
   myGetSettingsFromString(lsa_4, gs_1672);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1968[l_index_0] = gi_1668;
      else gia_1968[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
   ArrayResize(gia_1972, gi_1700);
   myGetSettingsFromString(lsa_4, gs_1684);
   for (l_index_0 = 0; l_index_0 < gi_1700; l_index_0++) {
      if (lsa_4[l_index_0] == "<def>") gia_1972[l_index_0] = gi_1680;
      else gia_1972[l_index_0] = StrToInteger(lsa_4[l_index_0]);
   }
}
//----------------------------------------------------------------------------------------
//ȡ��ѡ����Ҷԣ���ǰ�ļ۸�
double glGetCurrentClosePrice() 
{
   double l_price_0;
   if (OrderSymbol() == Symbol()) 
   {
      if (OrderType() == OP_BUY) l_price_0 = Bid;
      else l_price_0 = Ask;
   } 
   else 
   {
      if (OrderType() == OP_BUY) l_price_0 = MarketInfo(OrderSymbol(), MODE_BID);
      else l_price_0 = MarketInfo(OrderSymbol(), MODE_ASK);
   }
   return (l_price_0);
}
//------------------------------------------------------------------------------------------------------------
//���ּ�ƽ�֣�ƽ�ֳɹ�����true
/*
   ����  bool ai_0 = FALSE,  �Ƿ��ӡ��������Ϣ
         double a_price_4 = -1.0, ���Ҷ�ƽ�ּ۸�aa_price_4 = -1.0ʱ,��ȡ��ǰ�г���
         double a_slippage_12 = 0.0 �����С
   ����ֵ ƽ���Ƿ�ɹ�����Ϣli_ret_52 ���ɹ�==1
*/
int glOrderClose(bool ai_0 = FALSE, double a_price_4 = -1.0, double a_slippage_12 = 0.0) 
{
   int l_error_48;
   bool li_ret_52 = FALSE;
   int l_ticket_36 = OrderTicket();
   double l_ord_lots_40 = OrderLots();
   if (a_price_4 == -1.0) a_price_4 = glGetCurrentClosePrice();//ȡ��ѡ����Ҷԣ���ǰ�ļ۸�
   for (int l_count_20 = 0; l_count_20 < 5; l_count_20++)  //Ϊ����߳ɹ�����,���ƽ5��
   {
      if (ai_0) Print(" : ", l_ticket_36, " ", l_ord_lots_40, " at ", a_price_4);
      if (OrderClose(l_ticket_36, l_ord_lots_40, a_price_4, a_slippage_12)) 
      {
         li_ret_52 = TRUE;
         if (!(ai_0)) break;
         Print(" ");
         break;
      }
      l_error_48 = GetLastError();
      if (ai_0) Print(" : ", l_error_48, " (", ErrorDescription(l_error_48), ")");
      if (l_error_48 > 4000/* NO_MQLERROR */) break;
      Sleep(1000);
      RefreshRates();
      a_price_4 = glGetCurrentClosePrice();
   }
   return (li_ret_52);
}
//------------------------------------------------------------------------------------------------------------------------------------------------
/*
  int a_cmd_0 = -1,  ����
  string a_symbol_4 = "", 
  bool ai_12 = TRUE, �Ƿ�����ж�myIsOwnOrder()
  bool ai_16 = FALSE, �Ƿ�����ж�OrderProfit() <= 0.0
  int a_magic_20 = 0, �Ƿ�����ж�OrderMagicNumber() != a_magic_20
  bool ai_24 = FALSE  �Ƿ�����ж�OrderTakeProfit() != 0.0
*/
//ƽ�ֳɹ�����True ���ɹ�����false
int glCloseAllOrders(int a_cmd_0 = -1, string a_symbol_4 = "", bool ai_12 = TRUE, bool ai_16 = FALSE, int a_magic_20 = 0, bool ai_24 = FALSE) 
{
   bool li_ret_44 = TRUE;
   int l_ord_total_40 = OrdersTotal();
   for (int l_pos_28 = l_ord_total_40 - 1; l_pos_28 >= 0; l_pos_28--) {
      if (OrderSelect(l_pos_28, SELECT_BY_POS, MODE_TRADES)) {
         if (a_cmd_0 == -1 || OrderType() == a_cmd_0 && a_symbol_4 == "" || OrderSymbol() == a_symbol_4) {
            if (ai_12)
               if (!(myIsOwnOrder())) continue;
            if (ai_16)
               if (OrderProfit() <= 0.0) continue;
            if (a_magic_20 != 0)
               if (OrderMagicNumber() != a_magic_20) continue;
            if (ai_24)
               if (OrderTakeProfit() != 0.0) continue;
            if (!glOrderClose(CommentOrderOperations)) li_ret_44 = FALSE;
         }
      } else li_ret_44 = FALSE;
   }
   return (li_ret_44);
}
//--------------------------------------------------------------------------------------------------------------------------------
//ɾ���ҵ����ɹ�����True��ʧ�ܷ���False 
/*
   ������int a_cmd_0 = -1, ������-1ʱ��Ϊ�������ͣ�
         string a_symbol_4 = "",
         double ad_12 = 0.0, ������0ʱ���ҵ��۸�С����ʱ������ִ��
         double ad_20 = 0.0, ������0ʱ���ҵ��۸�С����ʱ������ִ��
         bool ai_28 = TRUE ���Ƿ�ִ��myIsOwnOrder()�ж�
*/
bool glDeleteAllDeferOrders(int a_cmd_0 = -1, string a_symbol_4 = "", double ad_12 = 0.0, double ad_20 = 0.0, bool ai_28 = TRUE) 
{
   int l_cmd_48;
   double l_ord_open_price_52;
   bool li_ret_60 = TRUE;
   int l_ord_total_44 = OrdersTotal();
   for (int l_pos_32 = l_ord_total_44 - 1; l_pos_32 >= 0; l_pos_32--) 
   {
      if (OrderSelect(l_pos_32, SELECT_BY_POS, MODE_TRADES)) 
      {
         l_cmd_48 = OrderType();
         l_ord_open_price_52 = OrderOpenPrice();
         if (a_cmd_0 == -1 || l_cmd_48 == a_cmd_0 && a_symbol_4 == "" || OrderSymbol() == a_symbol_4) 
         {
            if (ai_28)
               if (!(myIsOwnOrder())) continue;
            if (a_cmd_0 == -1)
               if (l_cmd_48 == OP_BUY || l_cmd_48 == OP_SELL) continue;
            if (ad_12 != 0.0 && l_ord_open_price_52 < ad_12) continue;//�ҵ����ּ۲�С��ad_12���ż���
            if (ad_20 != 0.0 && l_ord_open_price_52 > ad_20) continue;//�ҵ����ּ۲�����ad_20���ż���
            if (!myOrderDelete(OrderTicket())) li_ret_60 = FALSE;
         }
      } 
      else li_ret_60 = FALSE;
   }
   return (li_ret_60);
}
//--------------------------------------------------------------------------
//�����Ҷ��Ƿ�һ�����ǵĻ�����True ����Ļ�����False---���ֲ���ȡ���Ӧ�����ַ����Ƚϳ����Լ����Ƿ�׼ȷƥ��
bool IsCurrencyPair(string as_0, string as_8 = "AAABBB") {
   if (StringLen(as_0) != StringLen(as_8)) return (FALSE);
   if (StringSubstr(as_0, 0, 1) == "#") return (FALSE);
   if (as_0 == "GOLD" || as_0 == "SILVER") return (FALSE);
   int li_16 = StringFind(as_8, "AAA");
   if (li_16 == -1) return (FALSE);
   if (li_16 != 0)
      if (StringSubstr(as_0, 0, li_16) != StringSubstr(as_8, 0, li_16)) return (FALSE);//li_16==0,���ַ����Ŀ�ʼλ��
   li_16 = StringFind(as_8, "BBB");
   if (li_16 == -1) return (FALSE);
   if (li_16 != 0)
      if (StringSubstr(as_0, li_16 + 3) != StringSubstr(as_8, li_16 + 3)) return (FALSE); //li_16ΪBBB�Ŀ�ʼλ��
   return (TRUE);
}
//-----------------------------------------------------------------------------------------
//��as_0��as_12һ�µ�ǰ���£���as_12�н�ȡǰ�棨ai_8 = 1�������һ���֣�ai_8 = 2������ȡ�ɹ�������ȡ���ַ��������򷵻ؿ��ַ���
string GetCurrencyFromSymbol(string as_0, int ai_8 = 1, string as_12 = "AAABBB") {
   int li_20;
   if (!IsCurrencyPair(as_0, as_12)) return ("");
   if (ai_8 == 1) li_20 = StringFind(as_12, "AAA");
   else {
      if (ai_8 == 2) li_20 = StringFind(as_12, "BBB"); //�˺��������������ַ�����ʼ��λ�á�
      else return ("");
   }
   if (li_20 == -1) return ("");
   return (StringSubstr(as_0, li_20, 3));  //ai_8=1ʱȡ������ǰ�벿�֣���AAA,ai_8=2ʱȡ�����Ǻ�벿�֣���BBB
}
//---------------------------------------------------------
//��ad_0����������С��λ����ad_8��ͬ
double glDoubleRound(double ad_0, double ad_8) 
{
   int li_20 = 1;
   if (ad_8 == 0.0) return (ad_0);
   while (ad_8 * li_20 < 1.0) li_20 = 10 * li_20;
   int li_16 = ad_8 * li_20;
   double ld_24 = MathFloor(ad_0 * li_20);
   if (MathAbs(ad_0 * li_20 - ld_24) > 0.5) ld_24++; //��������
   double ld_32 = ld_24 / li_16;
   if (ld_32 != MathRound(ld_32)) 
   {
      if (MathAbs(ld_32 - MathFloor(ld_32)) > 0.5) ld_32 = MathFloor(ld_32) + 1.0;
      else ld_32 = MathFloor(ld_32);
      ld_24 = ld_32 * li_16;
   }
   return (ld_24 / li_20);
}
//--------------------------------------------------------------------------------------------------?
//�����Ҷ����ͷֿ�������������asa_8[]�У���󷵻��ܸ���
int glSeparateStringInArray(string as_0, string &asa_8[], string as_12 = ";", bool ai_20 = TRUE) 
{
   int li_ret_32 = 0;
   ArrayResize(asa_8, 0);//�����СΪ0,Ŷ��������������һ��
   if(as_12 == " ") as_0 = glStringTrimAll(as_0);
   for (int li_24 = StringFind(as_0, as_12); li_24 != -1; li_24 = StringFind(as_0, as_12)) 
   {
      li_ret_32++;
      ArrayResize(asa_8, li_ret_32);
      asa_8[li_ret_32 - 1] = StringSubstr(as_0, 0, li_24);
      if (as_12 == " ") as_0 = StringTrimLeft(as_0);
      else as_0 = StringSubstr(as_0, li_24 + StringLen(as_12));
   }
   if (as_0 != "") 
   {
      li_ret_32++;
      ArrayResize(asa_8, li_ret_32);
      asa_8[li_ret_32 - 1] = as_0;
   }//���ַ��������һ�����Ҷ����ʹ�������asa_8[]�����һ����
   if (ai_20) for (int l_index_28 = 0; l_index_28 < li_ret_32; l_index_28++) 
   asa_8[l_index_28] = glStringTrimAll(asa_8[l_index_28]); 
   return (li_ret_32);
}
//------------------------------------------------------------------------------------------------------
//���ַ�������ȥ������������Ŀո񡢻��з����Ʊ��
string glStringTrimAll(string as_0) 
{
   return (StringTrimLeft(StringTrimRight(as_0)));
}
//-----------------------------------------------------------------------------------------------------
//��¼��������
string glGetOrderTypeStr(int ai_0) {
   string ls_ret_4;
   switch (ai_0) {
   case 0:
      ls_ret_4 = "BUY";
      break;
   case 1:
      ls_ret_4 = "SELL";
      break;
   case 2:
      ls_ret_4 = "BUY LIMIT";
      break;
   case 3:
      ls_ret_4 = "SELL LIMIT";
      break;
   case 4:
      ls_ret_4 = "BUY STOP";
      break;
   case 5:
      ls_ret_4 = "SELL STOP";
      break;
   default:
      ls_ret_4 = "UNKNOWN";
   }
   return (ls_ret_4);
}
//---------------------------------------------------------------------------------------
string ErrorDescription(int ai_0) {
   string ls_ret_4;
   switch (ai_0) {
   case 0:
      ls_ret_4 = " ";
      break;
      case 1:   ls_ret_4="no error";
      break;                                                  
      case 2:   ls_ret_4="common error";
      break;                                              
      case 3:   ls_ret_4="invalid trade parameters";
      break;                                  
      case 4:   ls_ret_4="trade server is busy";
      break;                                      
      case 5:   ls_ret_4="old version of the client terminal";
      break;                        
      case 6:   ls_ret_4="no connection with trade server";
      break;                           
      case 7:   ls_ret_4="not enough rights";
      break;                                         
      case 8:   ls_ret_4="too frequent requests";
      break;                                     
      case 9:   ls_ret_4="malfunctional trade operation";
      break;                             
      case 64:  ls_ret_4="account disabled";
      break;                                          
      case 65:  ls_ret_4="invalid account";
      break;                                           
      case 128: ls_ret_4="trade timeout";
      break;                                             
      case 129: ls_ret_4="invalid price";
      break;                                             
      case 130: ls_ret_4="invalid stops";
      break;                                             
      case 131: ls_ret_4="invalid trade volume";
      break;                                      
      case 132: ls_ret_4="market is closed";
      break;                                          
      case 133: ls_ret_4="trade is disabled";
      break;                                         
      case 134: ls_ret_4="not enough money";
      break;                                          
      case 135: ls_ret_4="price changed";
      break;                                             
      case 136: ls_ret_4="off quotes";
      break;                                                
      case 137: ls_ret_4="broker is busy";
      break;                                            
      case 138: ls_ret_4="requote";
      break;                                                   
      case 139: ls_ret_4="order is locked";
      break;                                           
      case 140: ls_ret_4="long positions only allowed";
      break;                               
      case 141: ls_ret_4="too many requests";
      break;                                         
      case 145: ls_ret_4="modification denied because order too close to market";
      break;     
      case 146: ls_ret_4="trade context is busy";
      break;                                     
      //---- mql4 errors
      case 4000: ls_ret_4="no error";
      break;                                                 
      case 4001: ls_ret_4="wrong function pointer";
      break;                                   
      case 4002: ls_ret_4="array index is out of range";
      break;                              
      case 4003: ls_ret_4="no memory for function call stack";
      break;                        
      case 4004: ls_ret_4="recursive stack overflow";
      break;                                 
      case 4005: ls_ret_4="not enough stack for parameter";
      break;                           
      case 4006: ls_ret_4="no memory for parameter string";
      break;                           
      case 4007: ls_ret_4="no memory for temp string";
      break;                                
      case 4008: ls_ret_4="not initialized string";
      break;                                   
      case 4009: ls_ret_4="not initialized string in array";
      break;                          
      case 4010: ls_ret_4="no memory for array";
      break;                             
      case 4011: ls_ret_4="too long string";
      break;                                          
      case 4012: ls_ret_4="remainder from zero divide";
      break;                               
      case 4013: ls_ret_4="zero divide";
      break;                                              
      case 4014: ls_ret_4="unknown command";
      break;                                          
      case 4015: ls_ret_4="wrong jump (never generated error)";
      break;                       
      case 4016: ls_ret_4="not initialized array";
      break;                                    
      case 4017: ls_ret_4="dll calls are not allowed";
      break;                                
      case 4018: ls_ret_4="cannot load library";
      break;                                      
      case 4019: ls_ret_4="cannot call function";
      break;                                     
      case 4020: ls_ret_4="expert function calls are not allowed";
      break;                    
      case 4021: ls_ret_4="not enough memory for temp string returned from function";
      break; 
      case 4022: ls_ret_4="system is busy (never generated error)";
      break;                   
      case 4050: ls_ret_4="invalid function parameters count";
      break;                        
      case 4051: ls_ret_4="invalid function parameter value";
      break;                         
      case 4052: ls_ret_4="string function internal error";
      break;                           
      case 4053: ls_ret_4="some array error";
      break;                                         
      case 4054: ls_ret_4="incorrect series array using";
      break;                             
      case 4055: ls_ret_4="custom indicator error";
      break;                                   
      case 4056: ls_ret_4="arrays are incompatible";
      break;                                  
      case 4057: ls_ret_4="global variables processing error";
      break;                        
      case 4058: ls_ret_4="global variable not found";
      break;                                
      case 4059: ls_ret_4="function is not allowed in testing mode";
      break;                  
      case 4060: ls_ret_4="function is not confirmed";
      break;                                
      case 4061: ls_ret_4="send mail error";
      break;                                          
      case 4062: ls_ret_4="string parameter expected";
      break;                                
      case 4063: ls_ret_4="integer parameter expected";
      break;                               
      case 4064: ls_ret_4="double parameter expected";
      break;                                
      case 4065: ls_ret_4="array as parameter expected";
      break;                              
      case 4066: ls_ret_4="requested history data in update state";
      break;                   
      case 4099: ls_ret_4="end of file";
      break;                                              
      case 4100: ls_ret_4="some file error";
      break;                                          
      case 4101: ls_ret_4="wrong file name";
      break;                                          
      case 4102: ls_ret_4="too many opened files";
      break;                                    
      case 4103: ls_ret_4="cannot open file";
      break;                                         
      case 4104: ls_ret_4="incompatible access to a file";
      break;                            
      case 4105: ls_ret_4="no order selected";
      break;                                        
      case 4106: ls_ret_4="unknown symbol";
      break;                                           
      case 4107: ls_ret_4="invalid price parameter for trade function";
      break;               
      case 4108: ls_ret_4="invalid ticket";
      break;                                           
      case 4109: ls_ret_4="trade is not allowed";
      break;                                     
      case 4110: ls_ret_4="longs are not allowed";
      break;                                    
      case 4111: ls_ret_4="shorts are not allowed";
      break;                                   
      case 4200: ls_ret_4="object is already exist";
      break;                                  
      case 4201: ls_ret_4="unknown object property";
      break;                                  
      case 4202: ls_ret_4="object is not exist";
      break;                                      
      case 4203: ls_ret_4="unknown object type";
      break;                                      
      case 4204: ls_ret_4="no object name";
      break;                                           
      case 4205: ls_ret_4="object coordinates error";
      break;                                 
      case 4206: ls_ret_4="no specified subwindow";
      break;  
   }
   return (ls_ret_4);
}

