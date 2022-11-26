function output = appendednoise(t)
%output = appendednoise(t)
%
% Coloured Gaussian noise that is appended one after the other, whith different bandwidth.
% A synthetic signal consisted of a 100-s time series composed of the five segments of colored noise with increasing bandwidth is employed.
% The frequency spectra of the colored noises are all centered at fs/4 and their bandwidth increases from fs/15 to fs/3 in five equal steps.
%
% Input:
% t: the array of sample points
%
%Ref: [1] H. Azami and J. Escudero, “Improved Multiscale Permutation Entropy for Biomedical Signal Analysis: Interpretation and Application to Electroencephalogram Signals”,  Biomedical Signal Processing and Control , 2015.     %
%
% 
%If you use any of these resources, please make sure that you cite reference [1].


%   Hamed Azami and Javier Escudero Rodriguez
%   hamed.azami@ed.ac.uk and javier.escudero@ed.ac.uk
%
%   23-June-15
%

% We changed the seed generator random signals
rand('state',sum(100*clock));

% Dividing the time series to 5 segments
N = length(t)/5;

raw = randn(N+1000,5);

temp = load('numerators_order20.mat');

% Filtering
filtered(:,1) = filter(temp.Num_045_055(:),1,raw(:,1));
filtered(:,2) = filter(temp.Num_040_060(:),1,raw(:,2));
filtered(:,3) = filter(temp.Num_035_065(:),1,raw(:,3));
filtered(:,4) = filter(temp.Num_030_070(:),1,raw(:,4));
filtered(:,5) = filter(temp.Num_025_075(:),1,raw(:,5));

filtered = filtered(501:500+N,:);
filtered(:,1) = filtered(:,1)/max(abs(filtered(:,1)));
filtered(:,2) = filtered(:,2)/max(abs(filtered(:,2)));
filtered(:,3) = filtered(:,3)/max(abs(filtered(:,3)));
filtered(:,4) = filtered(:,4)/max(abs(filtered(:,4)));
filtered(:,5) = filtered(:,5)/max(abs(filtered(:,5)));
output = filtered(:);

% figure
% plot(t,output);
% figure
% specgram(output,250,150)
