/*********************************************************************
 * Demo.cpp
 *
 * This file shows the basics of setting up a mex file to work with
 * Matlab.  This example shows how to use 2D matricies.  This may
 * 
 * Keep in mind:
 * <> Use 0-based indexing as always in C or C++
 * <> Indexing is column-based as in Matlab (not row-based as in C)
 * <> Use linear indexing.  [x*dimy+y] instead of [x][y]
 *
 * For more information, see my site: www.shawnlankton.com
 * by: Shawn Lankton
 *
 ********************************************************************/
addpath('C:\MinGW\bin')
#include <matrix.h>
#include <mex.h>   
#include <vector>
#include <cstring>
using namespace std;

/* Definitions to keep compatibility with earlier versions of ML */
#ifndef MWSIZE_MAX
typedef int mwSize;
typedef int mwIndex;
typedef int mwSignedIndex;

#if (defined(_LP64) || defined(_WIN64)) && !defined(MX_COMPAT_32)
/* Currently 2^48 based on hardware limitations */
# define MWSIZE_MAX    281474976710655UL
# define MWINDEX_MAX   281474976710655UL
# define MWSINDEX_MAX  281474976710655L
# define MWSINDEX_MIN -281474976710655L
#else
# define MWSIZE_MAX    2147483647UL
# define MWINDEX_MAX   2147483647UL
# define MWSINDEX_MAX  2147483647L
# define MWSINDEX_MIN -2147483647L
#endif
#define MWSIZE_MIN    0UL
#define MWINDEX_MIN   0UL
#endif


// Convert a C++ matrix to an mxArray as the TRANSPOSE
mxArray *vv2mx(vector<vector<double>> mat)
{
    size_t rows = mat.size();
    size_t cols = mat[0].size();
    mxArray *T = mxCreateDoubleMatrix(cols, rows, mxREAL);
    double *in_buf = (double *) mxGetData(T);
    for (int i = 0; i<rows; i++) {
        memcpy( in_buf + i * cols, &mat[i][0], cols *sizeof(double) );
    }
    return T;
}
// Convert an mxArray to a C++ matrix as the TRANSPOSE
vector<vector<double>> mx2vv(const mxArray *T) {
    size_t rows = mxGetN(T);
    size_t cols = mxGetM(T);
    double *in_buf = (double *) mxGetData(T);
    vector<vector<double>> mat(rows, vector<double>(cols));
    for (int i = 0; i<rows; i++) {
        memcpy( &mat[i][0], in_buf + i * cols, cols *sizeof(double) );
    }
    return mat;
}

// // Convert an mxArray to a C++ matrix as the TRANSPOSE
// vector<double> mx2v(const mxArray *T) {
//     size_t rows = mxGetN(T);
//     size_t cols = 1;
//     double *in_buf = (double *) mxGetData(T);
//     vector<double> mat(rows, vector<double>(cols));
//    
//     memcpy( &mat, 1,rows *sizeof(double) );
//     return mat;
// }



// Display a C++ matrix
void vvdisp(vector<vector<double>> mat)
{
    size_t rows = mat.size();
    size_t cols = mat[0].size();
    for (int i = 0; i<rows; i++) {
        for( int j=0; j<cols; j++ ) {
            mexPrintf("%f ",mat[i][j]);
        }
        mexPrintf("\n");
    }
    return;
}

// // Display a C++ matrix
// void vdisp(vector<double> mat)
// {
//     size_t rows = mat.size();
//     size_t cols = 1;
//     for (int i = 0; i<rows; i++) {
//        
//             mexPrintf("%f ",mat[i]);
//        
//         mexPrintf("\n");
//     }
//     return;
// }


// Display an mxArray
void mxdisp(const mxArray *T)
{
    size_t rows = mxGetM(T);
    size_t cols = mxGetN(T);
    double *in_buf = (double *) mxGetData(T);
    for (int i = 0; i<rows; i++) {
        for( int j=0; j<cols; j++ ) {
            mexPrintf("%f ",*(in_buf + i + j*rows));
        }
        mexPrintf("\n");
    }
    return;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    
    

//declare variables
    mxArray *a_in_m, *b_in_m, *c_out_m, *d_out_m;
    const mwSize *dims;
    double *a, *b, *c, *d;
    int dimx, dimy, numdims;
   
    
    int choice = (int) *mxGetPr(prhs[0]);
    mexPrintf("%i\n", choice);
   
     mexPrintf("\nInput matrix:\n");
     mxdisp(prhs[1]);
     
      mexPrintf("\nInput matrix as vv:\n");
      vector<vector<double>> data = mx2vv(prhs[1]);
     // vvdisp(data);
      int rowN = data[0].size();
       mexPrintf("Size %i\n", rowN);
       
//     if (choice==1)
//     {
//          mexPrintf("Inside choice...%s",rowN);
//         
//         for(int i=0;i<rowN;i++)
//         {
//             mexPrintf("Current Value %i  New Value %i\n", data[0][i],data[0][i]*2.0);
//             data[0][i]=data[0][i]*2.0;
//         }
//     }
              
    /*

//associate inputs
    a_in_m = mxDuplicateArray(prhs[0]);
    b_in_m = mxDuplicateArray(prhs[1]);

//figure out dimensions
    dims = mxGetDimensions(prhs[0]);
    numdims = mxGetNumberOfDimensions(prhs[0]);
    dimy = (int)dims[0]; dimx = (int)dims[1];
*/
//associate outputs
    c_out_m =  mxCreateDoubleMatrix(dimy,dimx,mxREAL);
    //d_out_m =  mxCreateDoubleMatrix(dimy,dimx,mxREAL);
    plhs[0] = vv2mx(data);//mxCreateDoubleMatrix(dimy,dimx,mxREAL);
    //plhs[1] = mxCreateDoubleMatrix(dimy,dimx,mxREAL);
    /*
//associate pointers
    a = mxGetPr(a_in_m);
    b = mxGetPr(b_in_m);
    c = mxGetPr(c_out_m);
    d = mxGetPr(d_out_m);
*/
// //do something
//     for(i=0;i<dimx;i++)
//     {
//         for(j=0;j<dimy;j++)
//         {
//             mexPrintf("element[%d][%d] = %f\n",j,i,a[i*dimy+j]);
//             c[i*dimy+j] = a[i*dimy+j]+5; //adds 5 to every element in a
//             d[i*dimy+j] = b[i*dimy+j]*b[i*dimy+j]; //squares b
//         }
//     }

    return;
}




