ex C======================================================================
C     timestwo.f
C     Computational function that takes a scalar and doubles it.
C     This is a MEX file for MATLAB.
C======================================================================
#include "fintrf.h"
subroutine timestwo(y_output, x_input)
      real*8 x_input, y_output

      y_output = 2.0 * x_input
      return
end

C     Gateway routine
      subroutine mexFunction(nlhs, plhs, nrhs, prhs)

C     Declarations

C     Statements

      return
      end

implicit none


C     mexFunction arguments:
      mwPointer plhs(*), prhs(*)
      integer nlhs, nrhs


C     Function declarations:
      mwPointer mxGetDoubles
      mwPointer mxCreateDoubleMatrix
      integer mxIsNumeric
      mwPointer mxGetM, mxGetN


C     Pointers to input/output mxArrays:
      mwPointer x_ptr, y_ptr

C     Array information:
      mwPointer mrows, ncols
      mwSize size

C     Check for proper number of arguments. 
      if(nrhs .ne. 1) then
         call mexErrMsgIdAndTxt ('MATLAB:timestwo:nInput',
     +                           'One input required.')
      elseif(nlhs .gt. 1) then
         call mexErrMsgIdAndTxt ('MATLAB:timestwo:nOutput',
     +                           'Too many output arguments.')
      endif


C     Check that the input is a number.
      if(mxIsNumeric(prhs(1)) .eq. 0) then
         call mexErrMsgIdAndTxt ('MATLAB:timestwo:NonNumeric',
     +                           'Input must be a number.')
      endif

C     Computational routine

      subroutine timestwo(y_output, x_input)
      real*8 x_input, y_output

      y_output = 2.0 * x_input
      return
      end



