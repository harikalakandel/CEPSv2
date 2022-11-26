/* This function receives a row vector of integers (in double format) and returns a vector of 
 * same length made of randomly permuted integers (in uint32 format).  */

#include "mex.h"
#include "matrix.h"
#include <stdio.h>
#include <stdlib.h>

void randpermute(int **min, int **perm, int n) {
	
    int i, j, t, j1;
  
  // Initialize the matrix.
 	for(i=0; i<1; i++)
       for(j=0; j<n; j++)
            perm[i][j] = min[i][j];

// Perform random permutation
	for(i=0; i<1; i++)
         for(j=0; j<n; j++){
 	     j1 = rand()%n; // Select a number randomly in [0  n-1]. 
		 t = perm[i][j1];
         perm[i][j1] = perm[i][j];
         perm[i][j] = t;
	}
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

void FreeMatrix(void **matrix, int row_n) {
	
    int i;
	if (matrix != NULL) {
		for (i = 0; i < row_n; i++) free(matrix[i]);
		free(matrix);
	}
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
  /* Declare variables. */ 
  
         int **mout, **min;
         int  *out_ptr;
         double *in_ptr;  // because the input vector contains integers of double type.
         int  i, j, out_rows, out_cols, dim, rows, cols;
  
  /* Check for proper number of input and output arguments. */    
  if (nrhs != 1) 
    mexErrMsgTxt("One input arguments required.");
   
  if (nlhs > 1) 
    mexErrMsgTxt("Too many output arguments.");
  
   rows = (int)mxGetM(prhs[0]);
   cols = (int)mxGetN(prhs[0]); 
  out_rows = rows;
  out_cols = cols;
  
  /* Set the output pointer to the output matrix. */
  plhs[0] = mxCreateNumericMatrix(out_rows, out_cols, mxUINT32_CLASS, mxREAL);   
  
  /* Create a C pointer to the input matrix. */
  in_ptr = mxGetPr(prhs[0]);
  
  /* Create a C pointer to the output matrix. */
  out_ptr = mxGetPr(plhs[0]);

  /* create two auxiliary matrices */
   min   = (int **)CreateMatrix(rows,cols,sizeof(int)); 
   mout = (int **)CreateMatrix(out_rows,out_cols,sizeof(int));  
   
  /* New matrix initialization. 
     Indexing follows mxArray indexing rules which differs
     from C matrix indexing. See mxArray documentation. 
     m and mout matrices are indexed according to C matrix
     indexing rules. On the contrary, plhs[0] and prhs[0] are 
     pointers to mxArrays which are ordered according to matlab indexing. */
     
  for(i=0; i<rows; i++)
      for(j=0; j<cols; j++)
         min[i][j] = (int)*(in_ptr + j*rows + i);  // Explicit type casting.
   
  randpermute(min,mout, out_cols);

 /* At the output matrix, rows become columns and vice versa 
    mxArray indexing applied */
  for(i=0; i<out_rows; i++)
      for(j=0; j<out_cols; j++)   
          *(out_ptr + j*out_rows + i) = mout[i][j];   
  
   // Destroy the auxiliary matrices. 
  FreeMatrix(mout,out_rows);
  FreeMatrix(min,rows);
 
 }