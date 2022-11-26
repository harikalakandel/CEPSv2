% Simluated annealing approach for generating surrogate data (time series)
% Implementation is way from optimal
% Example implementation using max discrepancy of periodic autocorrelation function
%
% Important difference to TISEAN implementation: the algorithm terminates when
% energy has converged, irrespective of the accuracy
%
% Set random seed using rand('seed',s)
%
% Usage: [Xs,T0] = generate_anneal (X, n_it, alpha, T0, ep, n_succ)
%	n_it	Maximal number of iterations per temperature
%	alpha	Cooling factor
%	T0	Initial temperature (set to [] for automatic procedure)
%	ep	Maximal number of cooling iterations
%	n_succ	Minimal number of successive successful iterations
%			before next cooling step

function [Xs,T0] = anneal (X, n_it, alpha, T0, ep, n_succ)

if (nargin<1)
	X = read_ar ('/home/temu/data/laser_chaos.dat');
end
if (nargin<2)
	n_it = 500;	% Maximal number of iterations per temperature
end
if (nargin<3)
	alpha = .9;	% Cooling factor
end
if (nargin<4)
	T0 = [];	% Initial temperature
end
if (nargin<5)
	ep = 1000;	% Maximal number of cooling iterations
end
if (nargin<6)
	n_succ = 25;	% Minimal number of successive successful iterations
			% before next cooling step
end

pp = length(X);
Xs = X(randperm(pp));

s_min = n_it/20;


		%%%%%%%%%%%%%%%%%%%%%%%%%
		% Initial Configuration %
		%%%%%%%%%%%%%%%%%%%%%%%%%
Y = fft(X);
C = real(ifft(Y.*conj(Y)));
Ys = fft(Xs);
Cs = real(ifft(Ys.*conj(Ys)));


		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% Determine Initial Temperature %
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (isempty(T0))
	T0 = .001;
	s1 = 0;		% Number of successive successful iterations
	s2 = 0;		% Number of successful iterations
	en_prev = eval_crit (C,Cs);

	T0 = T0/10;
	XXs = Xs;
	while (s2<n_it*2/3)
	  s2 = 0;
	  T0 = T0*10;
	  Xs = XXs;
	  n = 1;
	  while (s1<n_succ) & (n<n_it)
		% Randomly swap two samples
		INDr = floor(rand(2,1)*(pp-1)+1);
		Xs(INDr) = Xs(INDr(2:-1:1));

		% Evaluate energy
		Ys = fft(Xs);
		Cs = real(ifft(Ys.*conj(Ys)));
		en = eval_crit (C, Cs);
		d = en_prev-en;

		% Metropolis Step
		if (d<=0)
			s1 = 0;

			r = rand;
			if (r>exp(-abs(d)/T0))
				Xs(INDr) = Xs(INDr(2:-1:1));
			else
				en_prev = en;
				s2 = s2+1;
			end
		else
			s1 = s1+1;
			s2 = s2+1;
		end
		en_prev = en;
		n = n+1;

	  end
	  if (isinf(T0))
		fprintf ('Unable to determine initial temperature\n');
		T0 = input ('  -> set manually: ');
		break;
	  end
	end
end

en_prev = eval_crit (C, Cs);
T = T0;
stop_count = 0;
e = 1;

while ((e<ep) & (stop_count<5))

	% Cool temperature
	T = T*alpha;

	s1 = 0;
	s2 = 0;
	n = 0;
	while (s1<n_succ) & (n<n_it)	% Stop criterion for one temperature

		% Randomly swap two samples
		INDr = floor(rand(2,1)*(pp-1)+1);
		Xs(INDr) = Xs(INDr(2:-1:1));

		% Evaluate energy
		Ys = fft(Xs);
		Cs = real(ifft(Ys.*conj(Ys)));
		en = eval_crit (C, Cs);
		d = en_prev-en;

		% Metropolis Step
		if (d<=0)
			s1 = 0;
			r = rand;
			if (r>exp(-abs(d)/T))
				Xs(INDr) = Xs(INDr(2:-1:1));
			else
				en_prev = en;
			end
		else
			en_prev = en;
			s1 = s1+1;
			s2 = s2+1;
		end
		n = n+1;
	end

	if 0	% The Art Corner
		E(e) = en;
		subplot (2,1,1)
		plot (E(1:e));drawnow
		subplot (2,1,2)
		S(e) = s2;
		plot (S),drawnow
	end

	if (s2<=s_min)		% Final stop criterion
		stop_count = stop_count+1;
	else
		stop_count = 0;
	end

	e = e+1;

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Example of energy function (Note that it works on C and Cs, and NOT
% on X and Xs)
% If you compute the energy from X and Xs, change the body of the main
% function accordingly

function c = eval_crit (C, Cs);

c = max(abs(C-Cs));



