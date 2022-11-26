function output = amchirp(t,f0,f1,fm,mu)
%output = amchirp(t,f0,f1,fm,mu)
% Signal with logarithmic chirp and AM modulation.
% Input:
% t: the array of sample points
% f0: the chirp time series starts from f0 Hz
% f1: The chirp time series reaches f1 Hz at the end
% fm: the modulating frequency
% mu: modulation index
%
%Ref: [1] H. Azami and J. Escudero, “Improved Multiscale Permutation Entropy for Biomedical Signal Analysis: Interpretation and Application to Electroencephalogram Signals”,  Biomedical Signal Processing and Control , 2015.     %
%

%If you use any of these resources, please make sure that you cite reference [1].

%   Hamed Azami and Javier Escudero Rodriguez
%   hamed.azami@ed.ac.uk and javier.escudero@ed.ac.uk
%
%   23-June-15
%
f = logspace(log10(f0), log10(f1), length(t));
f = f(:);
output = cos(2*pi*f.*t);
% modulation
output = output .*(1+mu*cos(2*pi*fm*t));
% plot(t,output)
