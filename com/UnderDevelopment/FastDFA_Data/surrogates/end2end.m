% Endpoint matching procedure to alleviate bias in FT-based surrogates
%
% Usage: X2 = end2end(X)

function X2 = end2end(X)

if (nargin<1)
	X = [];
end
if (min(size(X))>1)
	error ('Not implemented for multivariate time series');
end

if (length(X)<50)
	X2 = X;
	warning ('Time series is too short for endpoint matching');
	return
end
pp = length(X);

if (abs(X(1)-X(end))>1e-3)
	l = floor(pp/25)+1;
	T1 = X(1:l);
	T2 = X(pp-l+1:pp);
	D_2 = (repmat(T1(:),1,l)-repmat(T2(:)',l,1)).^2;
	[v ind1 ind2] = minmin(D_2);
	if (v>1e-1)
		warning ('Unable to make ends meet');
		X2 = X;
	else
		X2 = X(ind1:pp-l+ind2);
	end
end

