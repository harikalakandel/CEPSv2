/*
 * ==================================================================
 * combineColumns.c 
 * Example for illustrating how to handle 2-dimensional arrays in a MEX-file.
 * Takes a 2-dimensional array of doubles and returns a matrix which has as rows 
 *  all the possble combinations of the elements of the input matrix taken columnwise.
 * ===================================================================
 */

#include "mex.h" 
#include "matrix.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void comb(double **m_in,long int rows,int cols,double **m_out)
{
	int i,j,m,l;

	for (i=0;i<rows;i++) { 
		if (i<rows-1) {

			j=0;

			for(m=0; m<=pow(cols,rows)-pow(cols,rows-i-1); m+=pow(cols,rows-i-1)) {
				if (j<cols){
					for(l=0; l<pow(cols,rows-i-1);l++)			
						 m_out[m+l][i] = m_in[i][j];
				}
				else {

  			       j=0;
					for(l=0;l<pow(cols,rows-i-1);l++)			
						 m_out[m+l][i] = m_in[i][j];
					}
				++j;
			}
		}

	else if (i == rows-1) {

		for(m=0; m<=pow(cols,rows)-cols; m+=cols) {
			j=0;
			for(l=0;l<cols;l++) {
				m_out[m+l][i] = m_in[i][j];
				++j;
			}
     	 }
	  } 
   }
}

char **CreateMatrix(int row_n, int col_n, int element_size)
{
	char **matrix;
	int i;

	if (row_n == 0 && col_n == 0)
		return(NULL);

	matrix = (char **)calloc(row_n, sizeof(char *));
	if (matrix == NULL)
		printf("Error in CreateMatrix!\n");
	for (i = 0; i < row_n; i++) { 
		matrix[i] = (char *)calloc(col_n, element_size);
		if (matrix[i] == NULL)
			printf("Error in CreateMatrix!\n");
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



void mexFunction(int nlhs, mxArray *plhs[],  int nrhs, const mxArray *prhs[]){
  
  /* Declare variables. */ 
  double **min, **mout;
  double *in_ptr, *out_ptr;
         int  cols, out_cols, i, j;
         int  out_rows, rows;
  
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

  out_rows = pow(cols,rows);
  out_cols = rows;
  
  /* Set the output pointer to the output matrix. */
  plhs[0] = mxCreateDoubleMatrix(out_rows,out_cols,mxREAL);
  
  /* Create a C pointer to the output matrix. */
  out_ptr = mxGetPr(plhs[0]);

  // Create auxiliary I/O matrices.
   min  = (double **)CreateMatrix(rows,cols,sizeof(double));
  mout = (double **)CreateMatrix(out_rows,out_cols,sizeof(double));  
  
  /* new matrix initialization */
  /* indexing follows mxArray indexing rules which differs
     from C matrix indexing. see mxArray documentation */
  /* m and mout matrices are indexed according to C matrix
    indexing rules */
     
  for(i=0; i<rows; i++)
       for(j=0; j<cols; j++)
            min[i][j] = *(in_ptr + j*rows + i);
     
  comb(min,rows,cols,mout);

 /* At the output matrix, mxArray indexing applied */
 for(i=0; i<out_rows; i++)
      for(j=0; j<out_cols; j++)   
          *(out_ptr + j*out_rows + i) = mout[i][j];    
  
// Free memory assigned to auxiliary matrices. 
  FreeMatrix(mout,out_rows);
  FreeMatrix(min,rows);
    
}
  