function output = changingar(t,phiPlus,phiMinus)
%output = changingar(t,phiPlus,phiMinus)
%
% Autoregressive of order 1 (AR(1) for the time array t whose parameter goes from phiPlus to phiMinus linearly.
%
% THIS NEEDS INPUTS AND OUTPUTS
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

error = randn(size(t));
output = NaN*ones(size(error));

phi = linspace(phiPlus, phiMinus, length(t));

output(1) = error(1);
for k = 2:length(t)
    output(k) = error(k) + phi(k)*output(k-1);
end

output = output(:);

% figure
% plot(t,output);
% figure
% specgram(output,750,150)
