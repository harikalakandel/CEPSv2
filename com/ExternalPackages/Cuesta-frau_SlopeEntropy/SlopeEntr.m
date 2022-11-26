function [pe, Psi_Patt, counter] = SlopeEntr(data, dim, gamma, delta)
%% SlopeEntr(data, dim, gamma, delta)
% Slope entropy - an entropy estimation method (based on
% Cuesta-Frau D. Slope Entropy: A New Time Series Complexity Estimator
% Based on Both Symbolic Patterns and Amplitude Information. Entropy.
% 2019;21(12):1167. doi:10.3390/e21121167)
% Estimates entropy based on relative change using two thresholds gamma and
% delta
% INPUT:
% data - a vector of time-series of measured data
% dim - dimension of calculation, how long subsequences should be analysed
% preset value is 6. Dimension has to be smaller than the data vector length.
% gamma - the first of the thresholding parameters if the difference between
% samples if higher than gamma a stong change is detected in the data
% (either positive or negative). Gamma has to be large than delta.
% Preset value is 0.94.
% delta - the second of the thresholding variables, express a minimal
% change in the data that is taken as an increase or decrease. Has to be
% higher than 10e-12. Preset value 0.001.
% OUTPUT:
% pe - the estimated slope entropy measurement
% Psi_Patt - individual patterns found in the data
% counter - counts of individual patterns in Psi_Patt
%
%% Implemented based on David Cuesta-Frau article by Jakub Schneider CTU and Mindpax; May-2020

if nargin < 1, error('The data time-series must be included'), end
if nargin < 2, dim = 6; end
if nargin < 3, gamma = 0.94; end
if nargin < 4, delta = 0.001; end

n_dp = length(data);

if n_dp <= dim || n_dp < 10, error('The signal is Too short'), end
%if dim > min_pe || dim < max_pe, error('The signal is Too short'), end
if delta < 1e-12, error('The delta parameter is too small choose number higher than 1e-12'), end
if delta >= gamma, error('The delta parameter has to be larger than the gamma parameter'), end

Psi_Patt = [];
counter = [];
patt = nan(1,dim-1);
%val_list = [2,1,0,-2,-1];
pe = 0;
for k = 1:n_dp-(dim-1)
    subsec = data(k:k+dim-1);
%
    lg_gamma = subsec(2:end) > (subsec(1:end-1)+gamma);
    lg_delta = subsec(2:end) > (subsec(1:end-1)+delta);
    lg_ab_delta = abs(subsec(2:end) - subsec(1:end-1)) <= delta;
    lg_n_gamma = subsec(2:end) < (subsec(1:end-1)-gamma);

%     lg_thr = [subsec(2:end) > (subsec(1:end-1)+gamma);...
%         subsec(2:end) > (subsec(1:end-1)+delta);...
%         abs(subsec(2:end) - subsec(1:end-1)) <= delta;...
%         subsec(2:end) < (subsec(1:end-1)-gamma)];
%
%     ind_unfilled = true(1,dim-1);
%     for m = 1:4
%         patt(lg_thr(m,:) & ind_unfilled) = val_list(m);
%         ind_unfilled(lg_thr(m,:) & ind_unfilled) = false;
%     end
%     patt(ind_unfilled) = val_list(5);

    for m = 1:dim-1
        if lg_gamma(m)
            patt(m) = 2;
        elseif lg_delta(m)
            patt(m) = 1;
        elseif lg_ab_delta(m)
            patt(m) = 0;
        elseif lg_n_gamma(m)
            patt(m) = -2;
        else
            patt(m) = -1;
        end
    end

    n_patt = length(counter);
    act_match = false;

    for m = 1:n_patt
        if sum(Psi_Patt(m,:) == patt) == dim-1
            counter(m) = counter(m)+1;
            act_match = true;
            break
        end
    end

    if ~act_match
        Psi_Patt = [Psi_Patt; patt];
        counter = [counter; 1];
    end
end

n_patt = length(counter);

for k = 1:n_patt
    p   =   counter(k)/n_patt;
    pe  =  pe + (-p*log2(p));
end


