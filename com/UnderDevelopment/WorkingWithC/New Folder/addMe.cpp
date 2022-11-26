#include "mex.h"


double* addMe(int x,int y)
{
    return {x+y,2*x,2*y}  ;
}

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {
   
    double a,b;
    double *sum;

    if (nrhs!=2)
    {
        mexErrMsgIdAndTxt("bitmaker:my_sum","Two inputs required.");
    }
    
    a=mxGetScalar(prhs[0]);
    b=mxGetScalar(prhs[1]);
    plhs[0] = mxCreateDoubleMatrix(1, 3, mxREAL);
    outputMat = mxGetDoubles(plhs[0]);
    outputMat=addMe(a,b);
  
}

