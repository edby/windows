//+------------------------------------------------------------------+  
//|                                                                  |  
//|              Modify int start()       there are some errors      |  
//|                                                                  | 
//+------------------------------------------------------------------+  
#include <stdlib.mqh>
  extern int 
      Magic_Number_N  = 1
  ,   Magic_Number_R  = -1
  ,   Bars_Run        = 10
  ,   Bars_Sleep      = 2
  ,   Lots            = 1
  ,   SL              = 20
  ,   SL_Fast         = 10
  ,   SL_Max          = 40
  ,   MS_Big          = 30
  ,   MS_Small        = 15
  ,   Points_Win_Fast = 40
  ,   mSecond_Sleep   = 110
  ,   Ratio_Rev       = 5
  ,   Reverse_Point_B = 10
  ,   Reverse_Point_S = 5
  ,   Seek_Period_Ind = 16
  ,   Bar_Ignore_Ind  = 3
  ,   Min_Points_Ind  = 3
  ,   Max_Points_Ind  = 10
  ;
  extern double
      Range_Ratio_Ind = 9
  ,   Slip            = 3
  ;

  int 
      Bar_Seconds
  ,   Pips_Slip
  ,   Pips_Digits
  ,   TP              = 0
  ;
  double 
      Pips_SL
  ,   Stop_Loss
  ;
  int init()
  {
    Comment(
      "Lots: ",              Lots
  ,   "\nSL: ",              SL
  ,   "\nMS_Big: ",          MS_Big
  ,   "\nMS_Small: ",        MS_Small
  ,   "\nPoints_Win_Fast: ", Points_Win_Fast
  ,   "\nmSecond_Sleep: ",   mSecond_Sleep
  ,   "\nSeek_Period_Ind: ", Seek_Period_Ind
  ,   "\nBar_Ignore_Ind: ",  Bar_Ignore_Ind
  ,   "\nMin_Points_Ind: ",  Min_Points_Ind
  ,   "\nMax_Points_Ind: ",  Max_Points_Ind
  ,   "\nRange_Ratio_Ind:",  Range_Ratio_Ind
  ,   "\nSlip: ",            Slip
 );
    
    Bar_Seconds = Period()*60;
    if( Digits%2 == 1 ) 
    {
      Pips_SL     = Point*10;
      Pips_Slip   = 10;
      Pips_Digits = 1;
    }
    else 
    {
      Pips_SL     = Point;
      Pips_Slip   = 1;
      Pips_Digits = 0;
    }
    return(0);
  }


  int deinit()
  {
    return(0);
  }

  int start()
  {
    
    // Get Sign for trading from Indicator by iCustom()
    int Signal =  iCustom(NULL,0,"Test_Ind",Seek_Period_Ind,Bar_Ignore_Ind,Min_Points_Ind,Max_Points_Ind,Range_Ratio_Ind,1,0);
    
    // not trade within "Bars_Sleep" bars after order closing whose Order run within "Bars_Run" bars 
    if ( OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY) )
      if (
         (OrderCloseTime()-OrderOpenTime())/Bar_Seconds <= Bars_Run  
//    &&  OrderProfit()                                 <  0
      && (TimeCurrent()-OrderCloseTime())/Bar_Seconds   <= Bars_Sleep
         )
      Signal = 0;
      
    // open reverse order once an order was closed within half of period on stop loss line
    int Magic_Number = Magic_Number_N;
    if( OrderSelect(OrdersHistoryTotal()-1,SELECT_BY_POS,MODE_HISTORY) )
      if( (OrderCloseTime()-OrderOpenTime())/Bar_Seconds <  MathCeil(Seek_Period_Ind/2) 
          && OrderProfit()                               <  0.0 
          && OrderMagicNumber()                          == Magic_Number
          && OrdersTotal()                               == 0
        )
      { 
        if( OrderType() == OP_BUY )     Signal = -1; 
        else if(OrderType() ==OP_SELL)  Signal = 1; 
        Magic_Number = Magic_Number_R; 
      }
      
    // Reset Stop_Loss as zero and run Set_Stop_Loss(); if no signal and Stop_Loss not be assigned, return.
    Stop_Loss = 0.0;
    Set_Stop_Loss( Signal );
    if(Signal == 0 && Stop_Loss == 0.0) return(0);
    
    // if get a trading signal and OrdersTotal() returns 0, Open order(the stop loss should be assigned by Set_Stop_Loss(),or default)
    if( OrdersTotal() == 0 )
    {
      if( Signal == 1 ) 
      {
        iWait();
        if(Stop_Loss == 0) Stop_Loss = Ask-SL*Pips_SL;
        int Order_Ticket= OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number,0,0); 
        if(Order_Ticket < 0) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
      }
      else if(Signal== -1)
      {  
        iWait();
        if(Stop_Loss == 0) Stop_Loss = Bid+SL*Pips_SL;
        Order_Ticket= OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number,0,0);
        if( Order_Ticket < 0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
      }
    }
   
    // if get a trading signal and an order has existed, stop loss should be changed when a new value assigned by Set_Stop_Loss(),and send reverse order after close current order when a reserse signal occurs.
    else if( OrderSelect(OrdersTotal()-1,SELECT_BY_POS) )
    {
      if( OrderType() == OP_BUY ) 
      {
        if(Signal == -1) // Close the current order and send reverse order 
        { iWait();
          if( OrderClose(OrderTicket(),Lots,Bid,Slip*Pips_Slip,0) )  
          {
            if(Stop_Loss == 0.0) Stop_Loss = Bid+SL*Pips_SL;
            Order_Ticket= OrderSend(Symbol(),OP_SELL,Lots,Bid,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number,0,0);
            if( Order_Ticket < 0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
          }
          else Print("OrderClose() failed: ",ErrorDescription(GetLastError()));
        }
        else if(Stop_Loss != 0.0 && Stop_Loss != OrderStopLoss() ) // Reset Stop Loss Line
          if(!OrderModify(OrderTicket(),OrderOpenPrice(),Stop_Loss,0,0,0))
              Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
      }
   
      else if( OrderType() == OP_SELL) 
      {
        if(Signal == 1) // Close the current order and send reverse order 
        { iWait();
          if( OrderClose(OrderTicket(),Lots,Ask,Slip*Pips_Slip,0) )  
          { 
            if(Stop_Loss == 0.0) Stop_Loss = Ask-SL*Pips_SL;
            Order_Ticket= OrderSend(Symbol(),OP_BUY,Lots,Ask,Slip*Pips_Slip,Stop_Loss,TP,0,Magic_Number,0,0);
            if( Order_Ticket < 0 ) Print("OrderSend() failed: ",ErrorDescription(GetLastError()));
          }
          else Print("OrderClose() failed: ",ErrorDescription(GetLastError()));
        }
        else if(Stop_Loss != 0.0 && Stop_Loss != OrderStopLoss() ) // Reset Stop Loss Line
          if(!OrderModify(OrderTicket(),OrderOpenPrice(),Stop_Loss,0,0,0))
              Print("OrderModify() failed: ",ErrorDescription(GetLastError()));
      }
    }  
    return(0);
  }
  
  void Set_Stop_Loss(int Sig)
  {  
    // if the order in a fast moving, it will never reduce profit more than "SL_Fast" Pips.                     
    int Profit_Points = NormalizeDouble( MathAbs( OrderClosePrice() - OrderOpenPrice() )/Pips_SL,0 );
    if( OrderSelect(OrdersTotal()-1,SELECT_BY_POS) )
      if( (TimeCurrent()-OrderOpenTime())/Bar_Seconds < Seek_Period_Ind && Profit_Points > Points_Win_Fast)
      {
        double SL = SL_Fast;
        if(MathAbs(Close[0]-OrderStopLoss()) > SL*Pips_SL ) 
          if(OrderType() == OP_BUY)
          {
            iWait();
            if( !OrderModify(OrderTicket(),OrderOpenPrice(),Bid-SL*Pips_SL,0,0,0) )
            Print("OrderModify() for Fast order failed: ",ErrorDescription(GetLastError()));
          }
          else if(OrderType() == OP_SELL)
          {
            iWait();
            if( !OrderModify(OrderTicket(),OrderOpenPrice(),Ask+SL*Pips_SL,0,0,0) )
            Print("OrderModify() for Fast order failed: ",ErrorDescription(GetLastError()));
          }
      }

    // get stop loss line for OrderSend() or OrderModify()
    if(Sig == 0) // no trading signal
    {
      if(OrdersTotal() == 0 ) return;
      else
      {
        if( !OrderSelect(OrdersTotal()-1,SELECT_BY_POS) )
        { Print("OrderSelect() when Sig is 0 failed: ",ErrorDescription(GetLastError())); return; }
 
        if(OrderType() == OP_BUY)
        for(int i=Seek_Period_Ind;i>0;i--)  // seeking for big reverse point      
        {
          int Bars_Shift = iLowest(NULL,0,MODE_LOW,i,0);
          if(Low[Bars_Shift] == Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_B,Bars_Shift)] )
            if( (Close[0]-Low[Bars_Shift])/Pips_SL + Ratio_Rev < SL_Max )
              { Stop_Loss = Low[Bars_Shift]-Ratio_Rev*Pips_SL; break; }
        }
               
        else if(OrderType() == OP_SELL)
        for( i=Seek_Period_Ind;i>0;i--) // seeking for big reverse point
        {
          Bars_Shift = iHighest(NULL,0,MODE_HIGH,i,0);
          if(High[Bars_Shift] == High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_B,Bars_Shift)] )
          if( (High[Bars_Shift]-Close[0])/Pips_SL + Ratio_Rev< SL_Max )
            { Stop_Loss = High[Bars_Shift]+Ratio_Rev*Pips_SL; break; }
        }
      }
    }
    
    else if(Sig == 1)    // Signal for long
    {
      for( i=Seek_Period_Ind;i>0;i--)  // seeking for big reverse point      
      {
        Bars_Shift = iLowest(NULL,0,MODE_LOW,i,0);
        if(Low[Bars_Shift] == Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_B,Bars_Shift)] )
          if( (Close[0]-Low[Bars_Shift])/Pips_SL + Ratio_Rev < SL_Max )
            { Stop_Loss = Low[Bars_Shift]-Ratio_Rev*Pips_SL; break; }
      }
      
      if (OrderSelect(OrdersTotal()-1,SELECT_BY_POS)) // an existed order will execute below codes only when its run time is within one seek_Period.
        if((TimeCurrent()-OrderOpenTime())/Bar_Seconds < Seek_Period_Ind ) 
          bool Within = true;
        else   Within = false;
          
      if(i == 0 && (OrdersTotal() == 0 || Within == true)) // seeking for small reverse Point
      for( i=3;i<Seek_Period_Ind;i++)    // seeking for small reverse point
      {
        Bars_Shift = iLowest(NULL,0,MODE_LOW,i,0);
        if( Low[Bars_Shift] == Low[iLowest(NULL,0,MODE_LOW,Reverse_Point_B,Bars_Shift)] )
          if( (Close[0]-Low[Bars_Shift])/Pips_SL < SL_Max/2 )
            { Stop_Loss = Low[Bars_Shift]-Ratio_Rev*Pips_SL; break; }
      } 
    }
     
    else if(Sig == -1) // Signal for short 
    {
      for( i=Seek_Period_Ind;i>0;i--) // seeking for big reverse point
      {
        Bars_Shift = iHighest(NULL,0,MODE_HIGH,i,0);
        if(High[Bars_Shift] == High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_B,Bars_Shift)] )
          if( (High[Bars_Shift]-Close[0])/Pips_SL + Ratio_Rev < SL_Max )
            { Stop_Loss = High[Bars_Shift]+Ratio_Rev*Pips_SL; break; }
      }
       
      if (OrderSelect(OrdersTotal()-1,SELECT_BY_POS)) // an existed order will execute below codes only when its run time is within one seek_Period.
        if((TimeCurrent()-OrderOpenTime())/Bar_Seconds < Seek_Period_Ind ) 
              Within = true;
        else  Within = false;
         
      if(i == 0 && (OrdersTotal() == 0 || Within == true)) // seeking for small reverse Point
      for( i=3;i<Seek_Period_Ind;i++)   // seeking for small reverse point
      {
        Bars_Shift = iHighest(NULL,0,MODE_HIGH,i,0);
        if( High[Bars_Shift] == High[iHighest(NULL,0,MODE_HIGH,Reverse_Point_B,Bars_Shift)] )
          if( (High[Bars_Shift]-Close[0])/Pips_SL < SL_Max/2 )
            { Stop_Loss = High[Bars_Shift]+Pips_SL; break; }
      }      
    } 
    return;
  }

  void iWait()
  {
    if(!IsTradeAllowed())
    Sleep(mSecond_Sleep);
    RefreshRates();
    return;
  }

