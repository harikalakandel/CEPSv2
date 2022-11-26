% Generate surrogate data using AAFT method (amplitude adjusted Fourier transform)
% H0: signal is a realisation of a linear Gaussian stochastic process, followed
%	by a static nonlinearity (observation function)
% set random seed using randn('seed',s)
%
% Usage: Xs = generate_AAFT (X);

function Xs = generate_AAFT (X);

if (nargin<1)
	X = [];
end

[s1 s2] = size(X);


% Standardise time series
T1 = (X-mean(X))./std(X);

% Match signal distribution to Gaussian
[Xsorted IND1] = sort(X);
G = sort(randn(s1,s2));
T1s = T1;
T1s(IND1) = G;

% Phase randomise
T2 = real(ifft(abs(fft(T1s)).*exp(sqrt(-1).*angle(fft(randn(s1,s2))))));

% Restore original signal distribution
[DUM IND2] = sort(T2);
Xs = X;
Xs(IND2) = Xsorted;



