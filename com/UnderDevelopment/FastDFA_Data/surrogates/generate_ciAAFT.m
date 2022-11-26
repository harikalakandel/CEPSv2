% Generate surrogate data with matching amplitude spectrum and
% modulus distribution for complex-valued data
% set random seed using rand('seed',s)
%
% H0: signal is a realisation of a linear Gaussian stochastic (complex-valued)
%	process, followed %	by a static nonlinearity (observation function),
%	which operates on the moduli of the complex-valued samples
%
% Usage: [Xs X] = generate_surrogate_complex (X, specflag, split_flag);
%	specflag	exact amplitude spectrum (1, default), otherise amp distr
%	splitflag	=1	real and imaginary components are matched separately
%			=0	modulus distribution is matched

function [Xs,X,E] = generate_cIAAFT (X, specflag, splitflag);

if (nargin<2)
	specflag = 1;
end
if (nargin<3)
	splitflag = 0;
end

max_it = 500;

pp = length(X);

Yamp = abs(fft(X));		% Desired amplitude spectrum
Xsorted = sort(abs(X));		% Desired modulus distribution
Xsr = sort(real(X));		% Desired `real' distribution
Xsi = sort(imag(X));		% Desired `imaginary' distribution

% Intial Conditions
rn = X(randperm(pp));
T1 = zeros(pp,1);
T2 = zeros(pp,1);
prev_err = 0;
c = 1;
prev_err = 1e10;
err = prev_err - 1;

E = zeros (max_it,1);
while (prev_err-err>1e-5) & (c<max_it)

	% Match Amplitude Spectrum
	Yrn = fft(rn);
	Yang = angle(Yrn);
	sn = ifft(Yamp.*(cos(Yang)+sqrt(-1).*sin(Yang)));

	% Match Amplitude Distribution
	[snsr INDr] = sort(real(sn));
	[snsi INDi] = sort(imag(sn));
	T1(INDr) = Xsr;
	T2(INDi) = Xsi;
	rn = T1+sqrt(-1).*T2;
	if (~splitflag)
		[sns INDs] = sort(rn);
		AUX1 = abs(sns);
		rn(INDs) = rn(INDs).*(abs(Xsorted)./(AUX1+(AUX1==0)));
	end

	prev_err = err;
	A2 = abs(Yrn);
	err = mean(abs(A2-Yamp));
	E(c) = err;
	c = c+1;

end
E = E(1:c-1);
if (specflag==1)
	Xs = sn;        % Exact Amplitude Spectrum
else
	Xs = rn;        % Exact Modulus Distribution
end


