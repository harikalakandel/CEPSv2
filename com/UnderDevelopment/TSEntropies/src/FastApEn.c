#include <math.h>
#include <stdio.h>
#include <stdlib.h>

/*
   TS : time series
R_res : final result (output)
R_N   : length of TS
R_dim : embedding dimension
R_lag : embedding lag/delay
R_r   : threshold/neighbourhood size
*/

void FastApEn_Cfun(double *TS, double *R_res, int *R_N, int *R_dim, int *R_lag, double *R_r)
{
  int N      = *R_N;
  int dim    = *R_dim;
  int lag    = *R_lag;
  double r   = *R_r; // threshold of vicinity

  int numOfSeq = N - (dim*lag) + 1;  // number of sequencies inside of time series TS
  int Ncl; // number of value classes
  int count  = 0;
  short *alreadyMatched = malloc(numOfSeq*sizeof(short));  // allocating space for match records
  double temp_res[2];  // temporary results
  double logji;

  for(int run = 0; run < 2; run++) {
    Ncl = 0; logji = 0;
    for(int i=0; i<numOfSeq; i++) alreadyMatched[i] = 0; // clearing match records
    for(int x=0; x<numOfSeq; x++) {
      if (alreadyMatched[x]) continue;
      count = 0;
      Ncl++;
      for(int m,y=0; y<numOfSeq; y++) {
        if (alreadyMatched[y]) continue;
        for(m=0; m<dim; m++) {
          if (fabs(TS[x+m*lag]-TS[y+m*lag]) > r) break;  // test for Maximum distance L_infinity
        }

        if (m==dim) {  // test if all dimensions distances are less than or equal to eps
          count++;
          alreadyMatched[y] = 1;
        }
      }

      logji += log(count);
    }
    temp_res[run] = (logji/Ncl) - log(Ncl);
    dim++;
    numOfSeq -= lag;
  }

  *R_res = temp_res[0] - temp_res[1];

  free(alreadyMatched);
}

