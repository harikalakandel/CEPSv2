% Generate stationary bootstrap of a time series
% H0: signal is stationary
% set random seed using rand('seed',s)
%
% Usage: Xs = generate_stat_boot (X, p);
%	default p=.05

function Xs = generate_stat_boot (X, p)

if (nargin<2)
	p = .05;
end

Xs = X;
pp = length(X);

ind1 = floor(rand*(pp-1)+1);
R = rand(pp,1);
M = R<=p;

Xs(1) = X(ind1);
for p=2:pp
	ind1 = ~M(p)*(ind1+1) + M(p)*floor(rand*(pp-1)+1);
	if (ind1>pp)
		ind1 = rem(ind1,pp);
	end
	Xs(p) = X(ind1);
end



