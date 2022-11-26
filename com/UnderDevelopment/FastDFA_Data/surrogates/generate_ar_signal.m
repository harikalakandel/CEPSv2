% Generate signal generated from AR process
% The first umpteen samples have been left out
%
% Usage: X = generate_ar_signal (A, pp, nn)

function X = generate_ar_signal (A, pp, nn)

if (nargin<1)
	A = [.5 -.1];
end
if (nargin<2)
	pp = 1000;
end
if (nargin<3)
	nn = 1;
end

A = A(:)';
dim = length(A);

X = randn(pp+dim,nn);
IND1 = 1:dim;
for p=(dim+1):(pp+dim)
	X(p,:) = X(p,:) + A*X(p-IND1,:);
end
X = X((dim+1):end,:);

