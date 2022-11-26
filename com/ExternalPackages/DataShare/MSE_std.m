function Out_MSE=MSE_std(x,m,r, tau,Scale )
%
%  This function calculates the multiscale sample entropy (MSE) whose coarse-graining uses standard deviation (MSE_std)
%
%
% Inputs:
%
% x: univariate signal - a vector of size 1 x N (the number of sample points)
% m: embedding dimension
% r: threshold (it is usually equal to 0.15 of the standard deviation of a signal - because we normalize signals to have a standard deviation of 1, here, r is usually equal to 0.15)
% tau: time lag (it is usually equal to 1)
% Scale: the number of scale factors
%
%
% Outputs:
%
% Out_MSE: a vector showing the MSE_std of x
%
% Ref:
% [1] H. Azami and J. Escudero, "Refined Multiscale Fuzzy Entropy based on Standard Deviation for Biomedical Signal Analysis", Medical & Biological Engineering &
% Computing, 2016.
%
% If you use the code, please make sure that you cite reference [1].
%
% Hamed Azami and Javier Escudero Rodriguez
% hamed.azami@ed.ac.uk and javier.escudero@ed.ac.uk
%
%  7-September-16
%%

% Signal is centered and normalised to standard deviation 1
x = x-mean(x);
x = x./std(x);

Out_MSE=NaN*ones(1,Scale);

for N_S=2:Scale
    xs=Multi_std(x,N_S);
    Out_MSE(N_S)=SampEn(xs,m,r,tau);
end

end

function M_Data = Multi_std(Data,S)

%  the coarse-graining process based on standard deviation

%  Input:   Data: time series;
%           S: the scale factor

% Output:
%           M_Data: the new coarse-grained time series at the scale factor S
L = length(Data);

y=reshape(Data(1:floor(L/S)*S),S,[]);

M_Data=std(y);

end