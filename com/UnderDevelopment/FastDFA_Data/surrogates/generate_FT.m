% Generate surrogate data using FT method (phase randomisation)
% set random seed using randn('seed',s)
% H0: signal is a realisation of a linear Gaussian stochastic process
%	(which is grossly overfit by an N/2 parameter model)
%
% Usage: Xs = generate_FT (X);

function Xs = generate_FT (X);

if (nargin<1)
	X = [];
end

m1 = mean(X);
X = X-m1;
Xs = real(ifft(abs(fft(X)).*exp(sqrt(-1).*angle(fft(randn(size(X)))))));
Xs = Xs+m1;

