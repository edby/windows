//+------------------------------------------------------------------+
//|                                                     Fractals.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
//---- input parameters

//---- buffers
double ExtUpFractalsBuffer[];
double ExtDownFractalsBuffer[];
double ExtUpBuffer[];
double ExtDownBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator buffers mapping 
   // IndicatorBuffers(4);
    SetIndexBuffer(0,ExtUpFractalsBuffer);
    SetIndexBuffer(1,ExtDownFractalsBuffer); 
  //  SetIndexBuffer(3,ExtUpBuffer);
  //  SetIndexBuffer(4,ExtDownBuffer);  
//---- drawing settings
    SetIndexStyle(0,DRAW_ARROW);
    SetIndexArrow(0,119);
    SetIndexStyle(1,DRAW_ARROW);
    SetIndexArrow(1,119);
    
//----
    SetIndexEmptyValue(0,0.0);
    SetIndexEmptyValue(1,0.0);
//---- name for DataWindow
    SetIndexLabel(0,"Fractal Up");
    SetIndexLabel(1,"Fractal Down");
    ArrayInitialize(ExtUpFractalsBuffer,0.0);
    ArrayInitialize(ExtDownFractalsBuffer,0.0);
//---- initialization done   
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    i,nCountedBars,cnt;
   bool   bFound;
   double dCurrent;
   nCountedBars=IndicatorCounted();
//---- last counted bar will be recounted    
   if(nCountedBars<=2)
      i=Bars-nCountedBars-3;
   if(nCountedBars>2)
     {
      nCountedBars--;
      i=Bars-nCountedBars-1;
     }
//----Up and Down Fractals
   while(i>=2)
     {
      //----Fractals up
      bFound=false;
      dCurrent=High[i];
      cnt = 1;
      double LastUpFractals = 0;
      if(nCountedBars > 0)
      {
         while(ExtUpFractalsBuffer[i+cnt]==0)
         {
            cnt += 1;
         }
         if(ExtUpFractalsBuffer[i+cnt] != 0)
         {
            LastUpFractals = ExtUpFractalsBuffer[i+cnt];
            Print("Ç°¸ß"+LastUpFractals);
         }
      }
      if(dCurrent>High[i+1] && dCurrent>High[i+2] && dCurrent>High[i-1] && dCurrent>High[i-2])
      {
         
         if((LastUpFractals-dCurrent)>20*Point || (dCurrent-LastUpFractals)>5*Point)
         {
            bFound=true;
            ExtUpFractalsBuffer[i]=dCurrent;           
         }     
       //  ExtUpBuffer[i]=dCurrent;  
      }
      //----6 bars Fractal
      if(!bFound && (Bars-i-1)>=3)
      {
         if(dCurrent==High[i+1] && dCurrent>High[i+2] && dCurrent>High[i+3] &&
            dCurrent>High[i-1] && dCurrent>High[i-2])
         {
            if((LastUpFractals-dCurrent)>20*Point || (dCurrent-LastUpFractals)>5*Point)
            {
               bFound=true;
               ExtUpFractalsBuffer[i]=dCurrent;
            }     
           // ExtUpBuffer[i]=dCurrent;
         }        
      }         
      //----7 bars Fractal
      if(!bFound && (Bars-i-1)>=4)
      {   
         if(dCurrent>=High[i+1] && dCurrent==High[i+2] && dCurrent>High[i+3] && dCurrent>High[i+4] &&
            dCurrent>High[i-1] && dCurrent>High[i-2])
         {
            if((LastUpFractals-dCurrent)>20*Point || (dCurrent-LastUpFractals)>5*Point)
            {
               bFound=true;
               ExtUpFractalsBuffer[i]=dCurrent;
            }     
          //  ExtUpBuffer[i]=dCurrent; 
         }
      }  
      //----8 bars Fractal                          
      if(!bFound && (Bars-i-1)>=5)
      {   
         if(dCurrent>=High[i+1] && dCurrent==High[i+2] && dCurrent==High[i+3] && dCurrent>High[i+4] && dCurrent>High[i+5] && 
            dCurrent>High[i-1] && dCurrent>High[i-2])
         {
            if((LastUpFractals-dCurrent)>20*Point || (dCurrent-LastUpFractals)>5*Point)
            {
               bFound=true;
               ExtUpFractalsBuffer[i]=dCurrent;
            }     
          //  ExtUpBuffer[i]=dCurrent;  
         }       
       } 
      //----9 bars Fractal                                        
      if(!bFound && (Bars-i-1)>=6)
      {   
         if(dCurrent>=High[i+1] && dCurrent==High[i+2] && dCurrent>=High[i+3] && dCurrent==High[i+4] && dCurrent>High[i+5] && 
            dCurrent>High[i+6] && dCurrent>High[i-1] && dCurrent>High[i-2])
         {
            if((LastUpFractals-dCurrent)>20*Point || (dCurrent-LastUpFractals)>5*Point)
            {
               bFound=true;
               ExtUpFractalsBuffer[i]=dCurrent;
            }     
         //   ExtUpBuffer[i]=dCurrent; 
         }         
      }                                    
      //----Fractals down
      bFound=false;
      dCurrent=Low[i];
      double LastDownFractals = 0;
      cnt = 1;
      if(nCountedBars > 0)
      {
         while(ExtUpFractalsBuffer[i+cnt]==0)
         {
            cnt += 1;
         }
         if(ExtDownFractalsBuffer[i+cnt] != 0)
         {
            LastDownFractals = ExtDownFractalsBuffer[i+cnt];
            Print("Ç°µÍ"+LastDownFractals);
         }
      }
     
      if(dCurrent<Low[i+1] && dCurrent<Low[i+2] && dCurrent<Low[i-1] && dCurrent<Low[i-2])
      {
         if((dCurrent-LastDownFractals)>20*Point ||(LastDownFractals-dCurrent)>5*Point)
         {
            bFound=true;
            ExtDownFractalsBuffer[i]=dCurrent;
         }
      }
      //----6 bars Fractal
      if(!bFound && (Bars-i-1)>=3)
      {
         if(dCurrent==Low[i+1] && dCurrent<Low[i+2] && dCurrent<Low[i+3] &&
            dCurrent<Low[i-1] && dCurrent<Low[i-2])
         {
            if((dCurrent-LastDownFractals)>20*Point ||(LastDownFractals-dCurrent)>5*Point)
            {
               bFound=true;
               ExtDownFractalsBuffer[i]=dCurrent;
            }
         }                      
      }         
      //----7 bars Fractal
      if(!bFound && (Bars-i-1)>=4)
        {   
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent<Low[i+3] && dCurrent<Low[i+4] &&
            dCurrent<Low[i-1] && dCurrent<Low[i-2])
           {
               if((dCurrent-LastDownFractals)>20*Point ||(LastDownFractals-dCurrent)>5*Point)
               {
                  bFound=true;
                  ExtDownFractalsBuffer[i]=dCurrent;
               }
           }                      
        }  
      //----8 bars Fractal                          
      if(!bFound && (Bars-i-1)>=5)
        {   
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent==Low[i+3] && dCurrent<Low[i+4] && dCurrent<Low[i+5] && 
            dCurrent<Low[i-1] && dCurrent<Low[i-2])
         {
            if((dCurrent-LastDownFractals)>20*Point ||(LastDownFractals-dCurrent)>5*Point)
            {
               bFound=true;
               ExtDownFractalsBuffer[i]=dCurrent;
            }
         }                      
        } 
      //----9 bars Fractal                                        
      if(!bFound && (Bars-i-1)>=6)
      {   
         if(dCurrent<=Low[i+1] && dCurrent==Low[i+2] && dCurrent<=Low[i+3] && dCurrent==Low[i+4] && dCurrent<Low[i+5] && 
            dCurrent<Low[i+6] && dCurrent<Low[i-1] && dCurrent<Low[i-2])
         {
            if((dCurrent-LastDownFractals)>20*Point ||(LastDownFractals-dCurrent)>5*Point)
            {
               bFound=true;
               ExtDownFractalsBuffer[i]=dCurrent;
            }
         }                      
      }                                    
      i--;
    }
//----
   return(0);
  }
//+------------------------------------------------------------------+