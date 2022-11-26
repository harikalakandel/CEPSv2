function Out_IMPE = impe(X,m,t,Scale)
%Out_IMPE = impe(X,m,t,Scale)
% Calculate the Improved Multiscale Permutation Entropy (IMPE)
% Input:    X: time series;
%           m: order of permuation entropy
%           t: delay time of permuation entropy,
%           Scale: the scale factor
% Output:
%           Out_IMPE: multiscale permuation entropy
%Ref: [1] H. Azami and J. Escudero, “Improved Multiscale Permutation Entropy for Biomedical Signal Analysis: Interpretation and Application to Electroencephalogram Signals”,  Biomedical Signal Processing and Control , 2015.     %
%
  

%If you use any of these resources, please make sure that you cite reference [1].

%   Hamed Azami and Javier Escudero Rodriguez
%   hamed.azami@ed.ac.uk and javier.escudero@ed.ac.uk
%
%   23-June-15
%
Out_IMPE=NaN*ones(1,Scale);

% Result for scale 1 is based on the original signal
Out_IMPE(1)=pe(X,m,t);

for i=2:Scale
    Temp_PE=NaN*ones(1,i);
    
    for ii=1:i
        Xs = Multi(X(ii:end),i);
        Temp_PE(ii) = pe(Xs,m,t);  % pe computes Permutation Entropy
    end
    
    Out_IMPE(i)=mean(Temp_PE);
end


function M_Data = Multi(Data,S)
% Generate the consecutive coarse-grained time series
% Input:    Data: time series;
%           S: the scale factor
% Output:
%           M_Data: the coarse-grained time series at the scale factor S

L = length(Data);
J = fix(L/S);
M_Data = NaN*ones(1,J);

for i=1:J
    M_Data(i) = mean(Data((i-1)*S+1:i*S));
end
