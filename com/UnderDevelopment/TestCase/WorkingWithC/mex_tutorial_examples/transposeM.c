/*
 * =============================================================
 * transposem.c 
 * Example for illustrating how to handle 2-dimensional arrays in 
 * a MEX-file.
 * Takes an 2-dimensional array of doubles and returns the transposed 
 * matrix. 
 * =============================================================
 */

#include "mex.h"
#include "matrix.h"
#include <stdio.h>
#include <stdlib.h>

void transposem(double **m,int rows,int cols,double **mout)
{
    int i,j;
    for(i=0; i<rows; i++)
         for(j=0; j<cols; j++)
              mout[j][i] = m[i][j];
}

char **CreateMatrix(int row_n, int col_n, int element_size) {
	
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



void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
  /* Declare variables. */ 
  
  double **min, **mout;
  double *in_ptr, *out_ptr;
  int rows, cols, i, j;
  
  /* Check for proper number of input and output arguments. */    
  if (nrhs != 1) {
    mexErrMsgTxt("One input argument required.");
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
   cols = mxGetN(prhs[0]);

  /* Set the output pointer to the output matrix. */
  plhs[0] = mxCreateDoubleMatrix(cols,rows, mxREAL);
  
  /* Create a C pointer to the output matrix. */
  out_ptr = mxGetPr(plhs[0]);

  /* create two auxiliary matrices */
  min    = (double **)CreateMatrix(rows,cols,sizeof(double));
  mout = (double **)CreateMatrix(cols,rows,sizeof(double));  
  
  /* New matrix initialization. 
     Indexing follows mxArray indexing rules which differs
     from C matrix indexing. See mxArray documentation. 
     m and mout matrices are indexed according to C matrix
     indexing rules. On the contrary, plhs[0] and prhs[0] are 
     pointers to mxArrays which are ordered according to matlab indexing. */
     
  for(i=0; i<rows; i++)
      for(j=0; j<cols; j++)
          min[i][j] = *(in_ptr + j*rows + i);
     
  transposem(min,rows,cols,mout);

 /* At the output matrix, rows become columns and vice versa 
    mxArray indexing applied */
    
  for(i=0; i<cols; i++)
       for(j=0; j<rows; j++)   
            *(out_ptr + j*cols + i) = mout[i][j];    
  
  // Destroy the auxiliary matrices. 
  FreeMatrix(min,rows);
  FreeMatrix(mout,cols);

 }
  