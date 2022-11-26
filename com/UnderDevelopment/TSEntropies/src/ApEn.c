#include <math.h>
#include <stdio.h>

/*
  TS  : time series
R_RPy : index of the row
R_max : maximum size of the recurrence plot
R_dim : embedding dimension
R_lag : embedding lag/delay
R_r   : threshold/neighbourhood size
*/
  
  void ApEn_Cfun(double *TS, double *R_res, int *R_rmax, int *R_dim, int *R_lag, double *R_r)
{
  #define TILE (8 /* doubles per vector */ * 5)
  
  int rmax   = *R_rmax;
  int dim    = *R_dim;
  int lag    = *R_lag;
  double r   = *R_r; //Maximum and Manhattan distance
   
  int count  = 0; // number of points in vertical
  
  for(int run = 0; run < 2; run++)
  {
    double phi = 0;
    for(int RPx = 0; RPx < (rmax); RPx++)
    {    
      int ub = rmax / TILE;
      count = 0;
      for(int t = 0; t < ub; ++t)
      {
        int const_idx = t * TILE;
        double temp[TILE] = {0};
        for(int m = 0; m < dim; m++)
        {
          int ind = m * lag + RPx;
          double a = TS[ind];
          for(int RPy = 0; RPy < TILE; RPy++)
          {
            double b = TS[RPy + const_idx + m * lag];
            if(temp[RPy] < fabs(a - b)){temp[RPy] = fabs(a - b);} // Maximum distance L_infinity
          }
        }
        
        for(int ti = 0; ti < TILE; ++ti) {
          if(temp[ti] < r)
          {
            count++;
          }
        }
      }
      
      { /* Remainder handling of elements < TILE */
          double temp[TILE] = {0};
        int rest = rmax % TILE;
        int const_idx = ub * TILE;
        for(int m = 0; m < dim; ++m)
        {
          int ind = m * lag + RPx;
          double a = TS[ind];
          for(int RPy = 0; RPy < rest; RPy++)
          {
            double b = TS[RPy + const_idx + m * lag];
            if(temp[RPy] < fabs(a - b)){temp[RPy] = fabs(a - b);} // Maximum distance L_infinity
          }
        }
        
        for(int ti = 0; ti < rest; ++ti) {
          if(temp[ti] < r)
          {
            count++;
          }
        }
        
      }
    double  temp = (double)count/rmax;
    phi += log(temp)/rmax;
    }
    R_res[run] = phi;
    dim++;
    rmax -= lag;
  }
}

