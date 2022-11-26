% def pfd(X, D=None):
function [ans]=PetrosianFD(X,D)
%     """Compute Petrosian Fractal Dimension of a time series from either two
%     cases below:
%         1. X, the time series of type list (default)
%         2. D, the first order differential sequence of X (if D is provided,
%            recommended to speed up)
%     In case 1, D is computed using Numpy's difference function.
%     To speed up, it is recommended to compute D before calling this function
%     because D may also be used by other functions whereas computing it here
%     again will slow down.
%     """
%     if D is None:
      if nargin==2
%         D = numpy.diff(X)
            D = diff(X);
%         D = D.tolist()
      end
        
%     N_delta = 0  # number of sign changes in derivative of the signal
      N_delta = 0
      for i =2:size(D,1)
%     for i in range(1, len(D)):
          if D(i) *(D(i-1)<0
%         if D[i] * D[i - 1] < 0:
%             N_delta += 1
            N_delta =  N_delta + 1;
          end
      end
%     n = len(X)
      n = size(X,1)
%     return numpy.log10(n) / (
      ans = log10(n)/(log10(n)+log10(n/(n+0.4*N_delta)))
%         numpy.log10(n) + numpy.log10(n / n + 0.4 * N_delta)
%     )
    
%
end
