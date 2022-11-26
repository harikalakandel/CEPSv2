%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Blue Noise Generation with MATLAB Implementation   %
%                                                      %
% Author: M.Sc. Eng. Hristo Zhivomirov       07/31/13  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = bluenoise(N)

% function: y = bluenoise(N) 
% N - number of samples to be returned in a row vector
% y - a row vector of blue noise samples

% The function generates a sequence of blue noise samples. 
% In terms of power at a constant bandwidth, blue noise increase in at 3 dB/oct, i.e. 10 dB/dec. 

% difine the length of the vector and
% ensure that the M is even, this will simplify the processing
if rem(N, 2)
    M = N+1;
else
    M = N;
end

% generate white noise 
x = randn(1, M);

% FFT
X = fft(x);

% prepare a vector with frequency indexes 
NumUniquePts = M/2 + 1;     % number of the unique fft points
n = 1:NumUniquePts;         % vector with frequency indexes 

% manipulate the left half of the spectrum so the PSD
% is proportional to the frequency by a factor of 1/f, 
% i.e. the amplitudes are proportional to 1/sqrt(f)
X = X(1:NumUniquePts);  
X = X.*sqrt(n);

% prepare the right half of the spectrum - a conjugate copy of the left one,
% except the DC component and the Nyquist component - they are unique
% and reconstruct the whole spectrum
X = [X conj(X(end-1:-1:2))];

% IFFT
y = real(ifft(X));

% ensure that the length of y is N
y = y(1, 1:N);

% ensure unity standard deviation and zero mean value
y = y - mean(y);
y = y/std(y, 1);

end
