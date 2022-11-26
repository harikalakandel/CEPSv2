function output = quasipernoise(t,fm,f1,f2)
%output = quasipernoise(t,fm,f1,f2)
% Amplitude-modulated quasi-periodic signal with additive WGN of diverse power
% Input:
% t: the array of sample points
% fm: the modulating frequency
% The signal was generated as an amplitude-modulated sum of two sine waves with frequencies at f1=0.5 Hz and f2=1 Hz.
% The first 20 s of this sequence does not have any noise. After that, WGN was added to the signal, with the noise power increasing every 10 s.
%
%Ref: [1] H. Azami and J. Escudero, “Improved Multiscale Permutation Entropy for Biomedical Signal Analysis: Interpretation and Application to Electroencephalogram Signals”,  Biomedical Signal Processing and Control , 2015.     %
%

%If you use any of these resources, please make sure that you cite reference [1].

%   Hamed Azami and Javier Escudero Rodriguez
%   hamed.azami@ed.ac.uk and javier.escudero@ed.ac.uk
%
%   23-June-15
%

% We changed the seed generator random signals
randn('state',sum(100*clock))

% Creating 10 segments
N = length(t)/10;

% modulating signal
xm = 0.1*cos(2*pi*fm.*t);

% Signal without external noise
x31 = [1+xm].*cos(2*pi*f1.*t)+0.7*cos(2*pi*f2.*t+pi/2);
output = x31(:);

% We are adding noise
output(2*N+1:3*N) = output(2*N+1:3*N) + 0.1*randn(N,1);
output(3*N+1:4*N) = output(3*N+1:4*N) + 0.2*randn(N,1);
output(4*N+1:5*N) = output(4*N+1:5*N) + 0.3*randn(N,1);
output(5*N+1:6*N) = output(5*N+1:6*N) + 0.4*randn(N,1);
output(6*N+1:7*N) = output(6*N+1:7*N) + 0.5*randn(N,1);
output(7*N+1:8*N) = output(7*N+1:8*N) + 0.6*randn(N,1);
output(8*N+1:9*N) = output(8*N+1:9*N) + 0.7*randn(N,1);
output(9*N+1:10*N) = output(9*N+1:10*N) + 0.8*randn(N,1);
