% Generate a surrogate with a certain (instantaneous) correlation 
% to one signal (S) and with the signal distribution of another (Xo)
% set random seed using rand('seed',s)
%
% Usage: [Xs err] = generate_corr_pair (S, Xo, des_corr);
%	S	'Reference' Signal
%	Xo	Signal with desired amplitude distribution
%	err	residual discrepancy on correlation

function [Xs,err,E] = generate_iAAC (S, Xo, des_corr);

if (nargin<2)
	error ('Please provide two signals');
end
if (nargin<3)
	des_corr = mean(Xo./norm(Xo).*S./norm(S));
end
if (abs(des_corr)>1)
	error ('Desired correlation should be between -1 and 1');
end

[s1 s2] = size(Xo);

pp = length(Xo);
ep = 100;

% Normalise
normx = sqrt(sum(Xo.^2));
Xo = Xo(:)./normx;
S = S(:)./repmat(sqrt(sum(S.^2)),pp,1);

% Desired Correlation
Co = des_corr;

% Initial Conditions
Xs = Xo(randperm(pp));
Xsort = sort(Xo);

% Preamble
D = Co-S'*Xs;
err = sum(D(:).^2);
err_prev = err+1;
e = 1;
mu = 1/sum(S(:).^2);	% Normalised Algorithm

% Here Goes
E = zeros(ep,1);
while ((e<ep) & (err_prev-err>1e-10))

	% Perform FPI Update
	Xs = Xs + mu.*S*D;
	Xs2 = Xs;

	% Match Amplitude Distribution
	[DUM INDs] = sort(Xs);
	Xs(INDs) = Xsort;

	% Compute Discrepancy
	D = Co-S'*Xs;
	err_prev = err;
	err = sum((D(:).^2));

	E(e) = err;
	e = e+1;

end

% Restore Norm
Xs = zeros(s1,s2);
Xs(:) = Xs2(:).*(normx/norm(Xs2));




