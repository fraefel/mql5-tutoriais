//+------------------------------------------------------------------+
//|                                                EpsilonGreedy.mq5 |
//|                                      Copyright 2020,Lethan Corp. |
//|                           https://www.mql5.com/pt/users/14134597 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020,Lethan Corp."
#property link      "https://www.mql5.com/pt/users/14134597"
#property version   "1.00"

#define NUM_TRIALS 10000
#define EPS 0.1
#define NUM_BANDIT 3

#include "Libraries\CBandit.mqh"

double BANDIT_PROBABILITIES[NUM_BANDIT] = {0.2, 0.5, 0.75};
int    J;
double tempJ[NUM_BANDIT];

namespace EpsilonGreedy
{
void Experiment(void)
  {

   CBandit *bandits[NUM_BANDIT];

   for(int i=0; i<NUM_BANDIT; i++)
     {
      bandits[i] = new CBandit(BANDIT_PROBABILITIES[i]);
     }

   double rewards[NUM_TRIALS] = {.0};
   double num_times_explored  = .0;
   double num_times_exploited = .0;
   double num_optimal         = .0;

   for(int i=0; i<NUM_BANDIT; i++)
     {
      tempJ[i] = bandits[i].P();
     }

   int optimal_j  = ::ArgMax(tempJ, ArraySize(tempJ));
   Print("optimal j: ",optimal_j);

   for(int i=0; i<NUM_TRIALS; i++)
     {
      //use epsilon-greendy to select the next bandit
      if(Random::Random() < EPS)
        {
         num_times_explored +=1;
         J = Random::Randint(ArraySize(bandits));
        }
      else
        {
         num_times_exploited += 1;
         for(int j=0; j<NUM_BANDIT; j++)
           {
            tempJ[j] = bandits[j].Estimative();
           }
         J = ::ArgMax(tempJ, ArraySize(tempJ));
        }

      if(J == optimal_j)
         num_optimal += 1;

      //pull the arm for the bandit with the largest sample
      double x = bandits[J].Pull();

      //update rewards log
      rewards[i] = x;

      //update the distribution for the bandit whose arm we just pulled
      bandits[J].Update(x);

     }

   for(int i=0; i<NUM_BANDIT; i++)
     {
      Print("mean estimate: ", bandits[i].Estimative(), " bandit :", i);
     }

   double rewardsSum = .0;
   rewardsSum        = ::Sum(rewards);

   Print("total reward earned: ", rewardsSum);
   Print("overall win rate: ", rewardsSum / NUM_TRIALS);
   Print("num_times_explored: ", num_times_explored);
   Print("num_times_exploited: ", num_times_exploited);
   Print("num times selected optimal bandit: ", num_optimal);

   for(int i=0; i<NUM_BANDIT; i++)
      delete bandits[i];
  }
}
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   ::EpsilonGreedy::Experiment();
  }
//+------------------------------------------------------------------+
