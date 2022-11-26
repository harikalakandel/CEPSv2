#include "mex.h"


#include <cstdlib>
#include <cstring>
#include <iostream>
#include <fstream>
#define _USE_MATH_DEFINES
#include <math.h>
#include <float.h>
#include <algorithm>    // std::sort
#include <vector>  
using namespace std;
#include "Analyse.h"
/*
nlhs
    Number of expected output mxArrays
plhs
    Array of pointers to the expected output mxArrays
nrhs
    Number of input mxArrays
prhs
    Array of pointers to the input mxArrays. Do not modify any prhs values in your MEX-file. Changing the data in these read-only mxArrays can produce undesired side effects.
*/
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double a, b;
    double *sum;
    
    if(nrhs != 2)
    {
        mexErrMsgIdAndTxt("bitmarker:my_sum", "Two inputs required.");
    }
    
    if(!mxIsDouble(prhs[0]) || mxGetNumberOfElements(prhs[0]) != 1)
    {
        mexErrMsgIdAndTxt("bitmarker:my_sum", "First argument must be number.");
    }
    
    if(!mxIsDouble(prhs[1]) || mxGetNumberOfElements(prhs[1]) != 1)
    {
        mexErrMsgIdAndTxt("bitmarker:my_sum", "Second argument must be number.");
    }
    
      
    //sum = mxGetPr(plhs[0]);
    //printf("...........a: %f,\n", sum);
    //sum = mySum(a,b);
}