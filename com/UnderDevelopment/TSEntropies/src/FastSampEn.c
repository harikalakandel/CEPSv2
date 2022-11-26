#include <math.h>
#include <stdio.h>
#include <stdlib.h>

/*
   TS : time series
R_dim : embedding dimension
R_lag : embedding lag/delay
R_r : threshold/neighbourhood size
*/
  
void FastSampEn_Cfun(double *TS, double *R_res, int *R_N, int *R_dim, int *R_lag, double *R_r)
{
  int N      = *R_N;
  int dim    = *R_dim;
  int lag    = *R_lag;
  double r   = *R_r; //Maximum and Manhattan distance
   
  int numOfSeq = N - (dim*lag) + 1;  // number of sequencies inside of time series TS
  int count;
  short *alreadyMatched = malloc(numOfSeq*sizeof(short));
  double temp_res[2];

  for(int run = 0; run < 2; run++) {
    count = 0;
    for(int i=0; i<numOfSeq; i++) alreadyMatched[i] = 0; // clearing match records
    for(int x=0; x<numOfSeq; x++) {
      if (alreadyMatched[x]) continue;
      for(int m,y=0; y<numOfSeq; y++) {
        if (alreadyMatched[y]) continue;
        for(m=0; m<dim; m++) {
          if (fabs(TS[x+m*lag]-TS[y+m*lag]) >= r) break;  // test for Maximum distance L_infinity
        }

	if (m==dim) {  // test if all dimensions distance is less than or equal to eps
          count++;
          alreadyMatched[y] = 1;
        }
      }

      count--;  // because SampEn do not count on self match
    }

    temp_res[run] = count;
    dim++;
    numOfSeq -= lag;
  }

  if(temp_res[1]!=0) *R_res = log(temp_res[0] / temp_res[1]);
  else *R_res = 666;

  free(alreadyMatched);
}

