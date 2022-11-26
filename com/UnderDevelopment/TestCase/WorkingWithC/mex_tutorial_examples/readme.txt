This submission includes several C-MEX programming examples.
It's purpose is to serve as a C-MEX programming tutorial.
Here are the contents of the folder:

1) combineColumns.c 

Call: >> B = combineColumns(A);

This is a C-MEX function that takes as an input an M-by-N matrix of doubles.
It outputs an N^M-by-M matrix which has as rows all the possible combinations
of the elements of input matrix A taken columnwise.

2) MplusM.c

Call: >> C = MplusM(A,B);

This C-MEX function takes as inputs two matrices of doubles
and returns their sum.

3) productM.c

Call: >> B = productM(A,1);   for column-wise product of elements.  
   or >> B = productM(A,2);   for row-wise product of elements.

Thic C-MEX functions takes as input a matrix of doubles
and returns a row vector containing the product of  all elements
columnwise or the a column vector that contains the product
of its elements rowwise.

4) randpermVector1.c, randpermVector2.c, randpermVector3.c

These are three flavors of a similar function that outputs a vector of 
randomly permuted elements.

Call: >> B = randpermVector1(A);
This version of randpermVector, receives as input a row vector of doubles A and outputs a randomly permuted version of it (B).

Call: >> B = randpermVector2(A);
This version of randpermVector, receives as input a row vector of integers (holding memory of double type) and returns a vector of same length made of randomly permuted integers (of uint32 type).

Call: >> B = randpermVector3(n);
This version of randpermVector, receives an integer number n and returns a
row vector of length n, made of randomly permuted uint32 integer numbers
from 1 to n.

5) reshapeM.c

Call: >> B = reshapeM(A,m,n);

This function takes a 2-dimensional array of doubles and returns the reshaped 
matrix with m rows and n columns. Function's input arguments agree with MatLab's
built-in reshape.m function.
i.e. m is the desired number of rows of output matrix B  and
     n is the desired number of columns of output matrix B. 

6) sumM.c

Call: >> B = sumM(A,1);   for column-wise sum of elements.  
   or >> B = sumM(A,2);   for row-wise sum of elements.

Thic C-MEX functions takes as input a matrix of doubles
and returns a row vector containing the sum of  all elements
columnwise or the a column vector that contains the sum
of its elements rowwise.

7) transposeM.c

Call: >> B = transposeM(A);

This C-MEX function accepts as input a double matrix A and, very surprisingly,
returns its transpose.


ALL FUNCTIONS IMITATE THEIR MATLAB BUILT-IN COUNTERPARTS !!!
