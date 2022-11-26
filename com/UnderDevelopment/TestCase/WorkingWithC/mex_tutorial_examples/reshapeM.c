/*
 * =================================================================
 * reshapeM.c 
 * Takes a 2-dimensional array of doubles and returns the reshaped 
 * matrix. Function input arguments agree with MatLab's built-in reshape.m function. 
 * ==================================================================
 */

#include "mex.h"
#include "matrix.h"
#include <stdio.h>
#include <stdlib.h>

void resh(double **m,int rows,int cols,double **mout,int out_rows,int out_cols) {
    
    int i,j,k;
    double *single_row;
    
  	single_row = (double *)calloc(rows*cols, sizeof(double));
    
  	for(j=0; j<cols; j++){  
         for(i=0; i<rows; i++){
            k = j*rows + i; 
            single_row[k] = m[i][j];
          }
       }
     
      for(j=0; j<out_cols; j++){  
         for(i=0; i<out_rows; i++){
            k = j*out_rows + i; 
            mout[i][j] = single_row[k];
          }
      }
    free(single_row);
}


char **CreateMatrix(int row_n, int col_n, int element_size)
{
	char **matrix;
	int i;

	if (row_n == 0 && col_n == 0)
		return(NULL);

	matrix = (char **)calloc(row_n, sizeof(char *));
	if (matrix == NULL)
		printf("Error in fisCreateMatrix!\n");
	for (i = 0; i < row_n; i++) { 
		matrix[i] = (char *)calloc(col_n, element_size);
		if (matrix[i] == NULL)
			printf("Error in fisCreateMatrix!\n");
	}
	return(matrix);
}

// Frees memory reserved for 2d-Matrix of selected type.
void FreeMatrix(void **matrix, int row_n) {
	
    int i;
	if (matrix != NULL) {
		for (i = 0; i < row_n; i++) free(matrix[i]);
		free(matrix);
	}
}



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  /* Declare variables. */ 
  
  double **min, **mout;
  double *in_ptr, *out_ptr;
  int rows, cols, i, j, *pint1, *pint2, out_rows, out_cols;
  
  /* Check for proper number of input and output arguments. */    
  if (nrhs != 3) {
    mexErrMsgTxt("Three input arguments required.");
  } 
  if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments.");
  }

  /* Check data type of input argument. */
  if (!(mxIsDouble(prhs[0]))) {
    mexErrMsgTxt("Input array must be of type double.");
  }
       
  in_ptr = mxGetPr(prhs[0]);
  
  rows = mxGetM(prhs[0]);
  cols  = mxGetN(prhs[0]);
  out_rows = (int)mxGetScalar(prhs[1]);
  out_cols  = (int)mxGetScalar(prhs[2]);
 
  /* Set the output pointer to the output matrix. */
    plhs[0] = mxCreateDoubleMatrix(out_rows,out_cols,mxREAL);
   
    /* Create a C pointer to the output matrix. */
    out_ptr = mxGetPr(plhs[0]);

  /* create two auxiliary matrices */
      min   = (double **)CreateMatrix(rows,cols,sizeof(double));
      mout = (double **)CreateMatrix(out_rows,out_cols,sizeof(double));  
      
  /* New matrix initialization. 
     Indexing follows mxArray indexing rules which differs
     from C matrix indexing. See mxArray documentation. 
     m and mout matrices are indexed according to C matrix
     indexing rules. On the contrary, plhs[0] and prhs[0] are 
     pointers to mxArrays which are ordered according to matlab indexing. */
     
  for(i=0; i<rows; i++)
      for(j=0; j<cols; j++)
          min[i][j] = *(in_ptr + j*rows + i);
  
      resh(min,rows,cols,mout,out_rows,out_cols);
 
  /* At the output matrix, rows become columns and vice versa 
    mxArray indexing applied */
    
  for(i=0; i<out_rows; i++)
      for(j=0; j<out_cols; j++)   
          *(out_ptr + j*out_rows + i) = mout[i][j];    
      
  // Destroy the auxiliary matrices. 
  FreeMatrix(min,rows);
  FreeMatrix(mout,out_rows);
 
 }
  