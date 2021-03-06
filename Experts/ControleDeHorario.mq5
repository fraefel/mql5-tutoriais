//+------------------------------------------------------------------+
//|                                            ControleDeHorario.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include "..\Include\TimeTrade.mqh"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
sinput string InpStartTime           = "09:02";
sinput string InpEndTime             = "16:06";
sinput string InpClosingTime         = "17:32";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTimeTrade *timeTrade;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(timeTrade == NULL)
      timeTrade = new CTimeTrade();


   timeTrade.SetTime(InpStartTime, InpEndTime, InpClosingTime);
   timeTrade.TimeAdjustment();

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   if(timeTrade != NULL)
     {
      delete timeTrade;
      timeTrade = NULL;
     }

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(timeTrade.CheckTimeEndTrade())
     {
      Print("Horário de encerramento de ordens");
      return;
     }

   if(!timeTrade.CheckTimeTrade())
     {
      Print("Horário de parar de abir ordens");
      return;
     }

// ... your code
  }
//+------------------------------------------------------------------+
