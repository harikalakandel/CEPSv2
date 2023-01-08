function [ HRA ] = hrasymm( signal, tau )
%%
if nargin<2
    tau = 1;
end
%%
data = signal(:);
signal = data;
%%
for iter_scale = 1 : length(tau)
    scale = tau(iter_scale);
    x = multiscale(signal,scale);
    x = x-min(x)+0.00001;
    %%
    x0 = x(1:end-1);
    x1 = x(2:end);
    %%
    slope = atan(x1./x0);
    slope_r = (slope-pi/4);
    ALI = slope_r(slope_r>0);
    BLI = slope_r(slope_r<0);
    %% something woring in this code below .....   ALI and BLI maynot have same size so their abs sum or difference is not possible..
    %% check with Ashis
    %% SI = sum(ALI)/sum(abs([ALI BLI]));
    %% suggestion 
    SI = sum(ALI)/sum(abs([ALI;BLI]))

    %%
    PI = length(ALI)/(length(ALI)+length(BLI));
    %%
    L = length(x1);
    SD1I = sqrt((1/L)*(sum((x1-x0).^2)/2));
    xy = (x1-x0)/sqrt(2);
    SD1UP = sqrt(sum(xy(xy > 0).^2)/L);
    GI = SD1UP^2/SD1I^2;

    %%
    x = data-min(data);
    x(x==0) = 0.00001;
    x0 = x(1:end-1);
    x1 = x(2:end);
    slope = atan(x1./x0);
    slope_r = (slope-pi/4);
    dist = sqrt(x1.^2+x0.^2);
    S = 0.5*abs(slope_r).*dist.*dist;

    AI = sum(S(slope_r > 0))/sum(abs(S));

    %%
    HRA.PI(iter_scale) = PI*100;
    HRA.GI(iter_scale) = GI*100;
    HRA.SI(iter_scale) = SI*100;
    HRA.AI(iter_scale) = AI*100;
end
end

%% a new function multiscale is added..
%% need to verify with Ashis
%% take the average of scale elements, window size is scale and no-overlapping...
function [x] = multiscale(signal,scale)
     minLength = floor(size(signal,1)/scale);
     x=nan(minLength,1);
     for i=1:minLength
         startIndex = (i-1)*scale+1;
         endIndex = i*scale
         x(i,1)=nanmean(signal(startIndex:endIndex,1))

     end
end
