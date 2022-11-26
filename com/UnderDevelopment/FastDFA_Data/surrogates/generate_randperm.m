% Generate a random permutation surrogate
%
% H0: signal is IID noise
%
% set random seed using rand('seed',s)
%
% Usage: Xs = generate_randperm (X)

function Xs = generate_randperm(X)

if (nargin<1)
	X = [];
end

Xs = X(randperm(length(X)));

