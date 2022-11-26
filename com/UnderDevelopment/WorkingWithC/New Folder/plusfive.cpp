#include "mex.h"

static void plusfive(const size_t len, const double *x, double *y)
{
    for (size_t i = 0; i < len; ++i)
        y[i] = x[i] + 5;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /*
    if (nrhs != 1 || nlhs > 1)
        mexErrMsgIdAndTxt("mex:error", "wrong number of arguments");
    if(!mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) || mxIsSparse(prhs[0]))
        mexErrMsgIdAndTxt("mex:error", "input is a dense real double array");
    */
    const int ndims = mxGetNumberOfDimensions(prhs[0]);
    printf("ndims is :%d",ndims);
    const mwSize *dims = mxGetDimensions(prhs[0]);
    const mwSize numel = mxGetNumberOfElements(prhs[0]);
    const double *input = mxGetPr(prhs[0]);

    //plhs[0] = mxCreateNumericArray(ndims, dims, mxDOUBLE_CLASS, mxREAL);    
    double *output = mxGetPr(plhs[0]);

    
    
    plusfive(numel, input, output);
}