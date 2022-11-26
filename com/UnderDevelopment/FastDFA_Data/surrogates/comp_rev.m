% Asymmetry due to time reversal, as described in Schreiber and Schmitz (1997).
%
% Usage: r = temu_rev (X, tau);

function r = temu_rev (Xo, tau)

if (nargin<2)
	tau = 1;
end

pp = length(Xo);
r = mean((Xo(tau+1:pp)-Xo(1:pp-tau)).^3);

