function output = mixsignal(t, ampA, tA, extB, pMax, pMin)
%output = mixsignal(t, ampA, tA, extB, pMax, pMin)
%
% MIX signal (1-z)x+zy includes a periodic and a stochastic process.
%
% Input:
% t: the array of sample points
% x(k)=ampA.sin(2.pi.k/tA)
% y is a uniformly distributed variable on [-extB , extB]
% The synthetic time-series was based on a MIX process whose parameter varied between pMin and pMax linearly.
%
%Ref: [1] H. Azami and J. Escudero, “Improved Multiscale Permutation Entropy for Biomedical Signal Analysis: Interpretation and Application to Electroencephalogram Signals”,  Biomedical Signal Processing and Control , 2015.     %
%

%If you use any of these resources, please make sure that you cite reference [1].

%   Hamed Azami and Javier Escudero Rodriguez
%   hamed.azami@ed.ac.uk and javier.escudero@ed.ac.uk
%
%   23-June-15
%
rand('state',sum(100*clock));

index = 1:length(t);
index = index(:);

% periodic part
X = ampA * sin( 2*pi*index/tA );
% random part
Y = extB*2*(rand(length(t),1)-0.5);
% For two random values  function p
valoresP = linspace(pMax,pMin,length(t));
Z = zeros(size(X));
for k = 1:length(t)
    temp = rand(1);
    if temp < valoresP(k)
        Z(k) = 1;
    %else % temp > p
    %    Z(k) = 0;
    end
end
Z = Z(:);

% Creation of the MIX process
output = (1-Z).*X + Z.*Y;
