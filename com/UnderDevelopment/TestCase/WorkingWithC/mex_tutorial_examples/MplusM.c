/*
 * ===============================================================
 * MplusM.c  Takes two matrices of doubles and returns their sum.
 * Example for illustrating how to handle N-dimensional arrays in a MEX-file. 
 * NOTE: MATLAB uses 1-based indexing, C uses 0-based indexing.
 * ===============================================================
 */

#include "mex.h"
#include "matrix.h"

void mplusm(double *m1,double *m2,int rows,int cols,double *mout) {
    int i,j,count = 0;
    
     for(i=0; i<rows; i++){
          for(j=0; j<cols; j++){
              *(mout + count) = *(m1 + count) + *(m2 + count);
                count++;
          }
     }
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  /* Declare variables. */ 
  
    double *m_in1, *m_in2, *m_out;
            int  rows, cols;
  
  /* Check for proper number of input and output arguments. */    
    if (nrhs != 2) {
        mexErrMsgTxt("Two input arguments required.");
    } 
    if (nlhs > 1) {
        mexErrMsgTxt("Too many output arguments.");
    }

  /* Check data type of input argument. */
    if (!(mxIsDouble(prhs[0]))) {
        mexErrMsgTxt("Input array must be of type double.");
    }

  /* Create a pointer to every input matrix. */
    m_in1  = mxGetPr(prhs[0]);
    m_in2  = mxGetPr(prhs[1]);
  
   /* Get the dimensions of the input matrices. */
    rows = mxGetM(prhs[0]);
     cols = mxGetN(prhs[0]);
   
  /* Set the output pointer to the output matrix. */
    plhs[0] = mxCreateDoubleMatrix(rows,cols, mxREAL);
  
  /* Create a C pointer to a copy of the output matrix. */
    m_out  = mxGetPr(plhs[0]);
  
    mplusm(m_in1,m_in2,rows,cols,m_out);
        
}