function output = constantchirp(t,f0,f1)
%output = constantchirp(t,f0,f1)
% Chirp signal with contant amplitude using the MATLAB library.
% Input:
% t: the array of sample points
% f0: the chirp starts from f0 Hz
% f1: The chirp reaches f1 Hz at the end
%Ref: [1] H. Azami and J. Escudero, “Improved Multiscale Permutation Entropy for Biomedical Signal Analysis: Interpretation and Application to Electroencephalogram Signals”,  Biomedical Signal Processing and Control , 2015.     %
%
%

%If you use any of these resources, please make sure that you cite reference [1].

%   Hamed Azami and Javier Escudero Rodriguez
%   hamed.azami@ed.ac.uk and javier.escudero@ed.ac.uk
%
%   23-June-15
%

output = chirp(t,f0,t(end),f1,'logarithmic',360*rand(1)); % random initial phase
output = output(:);
