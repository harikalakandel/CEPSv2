% import numpy as np
% 
function [ans]=pdf(X)
% def pfd(X, D=None):
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
%         D = np.diff(X)
%         D = D.tolist()
      D = diff(X);
%     N_delta = 0  # number of sign changes in derivative of the signal
      N_delta = 0;
%     for i in range(1, len(D)):
      for i=1:size(D,1)-1
%         if D[i] * D[i - 1] < 0:
          if D(i+1) * D(i-1+1) <0
%             N_delta += 1
              N_delta = N_delta + 1;
          end
      end
%     n = len(X)
     n = size(X,1);
%     return np.log10(n) / (
%         np.log10(n) + np.log10(n / n + 0.4 * N_delta)
%     )
      ans = log10(n)/(log10(n)+log10(n/n+0.4*N_delta));
% 
% data = np.loadtxt('../../../Data/SampleData/RR_Data/ECG_BC_c_25_8_hrv.txt')
% 
% 
% ans = pfd(data)
% print(ans)
