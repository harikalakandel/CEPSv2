function [XDist, Ppi] = XDistEn(Sig, varargin)
% XDistEn  estimates the cross-distribution entropy between two univariate data sequences.
%
%   [XDist, Ppi] = XDistEn(Sig) 
% 
%   Returns the cross-distribution entropy estimate (``XDist``) and the
%   corresponding distribution probabilities (``Ppi``) estimated between the data 
%   sequences contained in ``Sig`` using the default parameters: 
%   embedding dimension = 2, time delay = 1, binning method = ``'Sturges'``,
%   logarithm = base 2, normalisation = w.r.t number of histogram bins
%
%   [XDist, Pi] = XDistEn(Sig, name, value, ...)
% 
%   Returns the cross-distribution entropy estimate (``XDist``) estimated beween the 
%   data sequences contained in ``Sig`` using the specified name/value pair 
%   arguments:
% 
%      * ``m``     - Embedding Dimension, a positive integer   [default: 2]
%      * ``tau``   - Time Delay, a positive integer            [default: 1]
%      * ``Bins``  - Histogram bin selection method for distance distribution,
%        an integer > 1 indicating the number of bins, or one of the following strings:
%        {``'sturges'``, ``'sqrt'``, ``'rice'``, ``'doanes'``} [default: ``'sturges'``]
%      * ``Logx``  - Logarithm base, a positive scalar         [default: 2]
%        enter 0 for natural log
%      * ``Norm``  - Normalisation of ``XDist`` value, a boolean value:
%                - [false]  no normalisation.
%                - [true]   normalises w.r.t # of histogram bins [default]
%
%   See also:
%       XSampEn, XApEn, XPermEn, XCondEn, DistEn, DistEn2D, XMSEn.
%   
%   References:
%     [1] Yuanyuan Wang and Pengjian Shang,
%           "Analysis of financial stock markets through the multiscale
%           cross-distribution entropy based on the Tsallis entropy."
%           Nonlinear Dynamics 
%           94.2 (2018): 1361-1376.

narginchk(1,11)
Sig = squeeze(Sig);
if size(Sig,1) == 2
    Sig = Sig';
end

p = inputParser;
Chk = @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x,1)==0);
Chk1 = @(x) isnumeric(x) && ismatrix(x) && (min(size(x))==2) && numel(x)>20;
Chk2 = @(x) isscalar(x) && (x >= 0);
Chk3 = {'sturges','sqrt','rice','doanes'};
Chk4 = @(x) (isnumeric(x) && isscalar(x)) ...
    || (ischar(x) && any(validatestring(lower(x),Chk3)));
addRequired(p,'Sig',Chk1);
addParameter(p,'m',2,Chk);
addParameter(p,'tau',1,Chk);
addParameter(p,'Bins','sturges',Chk4);
addParameter(p,'Logx',2,Chk2);
addParameter(p,'Norm',true,@(x) islogical(x));
parse(p,Sig,varargin{:})
m = p.Results.m; tau = p.Results.tau; Bins = p.Results.Bins; 
Logx = p.Results.Logx; Norm = p.Results.Norm;

if Logx == 0
    Logx = exp(1);
end
S1 = Sig(:,1); S2 = Sig(:,2);
Nx = length(S1) - ((m-1)*tau);
Zm1 = zeros(Nx,m);
Zm2 = zeros(Nx,m);
for n = 1:m
    Zm1(:,n) = S1((n-1)*tau + 1:Nx+(n-1)*tau);
    Zm2(:,n) = S2((n-1)*tau + 1:Nx+(n-1)*tau);
end

DistMat = zeros(Nx,Nx);
for k = 1:Nx
    DistMat(k,:) = max(abs(repmat(Zm1(k,:),Nx,1) - Zm2),[],2);
end

Ny = Nx*Nx;
DistMat = reshape(DistMat,1,Ny);
if ischar(Bins)
    switch lower(Bins)
        case 'sturges'
            Bx = ceil(log2(Ny) + 1);
        case 'rice'
            Bx = ceil(2*(Ny^(1/3)));
        case 'sqrt'
            Bx = ceil(sqrt(Ny));
        case 'doanes'
            sigma = sqrt(6*(Ny-2)/((Ny+1)*(Ny+3)));
            Bx = ceil(1+log2(Ny)+log2(1+abs(skewness(DistMat)/sigma)));
        otherwise 
            error('Please enter a valid binning method')
    end
else    
    Bx = Bins;
end
By = linspace(min(DistMat),max(DistMat),Bx+1);
Ppi = histcounts(DistMat,By)/Ny;
if round(sum(Ppi),6) ~= 1
    warning('Potential error estimating probabilities (p = %d).',sum(Ppi))
    Ppi(Ppi==0)=[];
elseif any(Ppi==0)
    fprintf('Note: %d/%d bins were empty',sum(Ppi==0),numel(Ppi));
    Ppi(Ppi==0)=[];
end
XDist = -sum(Ppi.*log(Ppi)/log(Logx));
if Norm
    XDist = XDist/(log(Bx)/log(Logx));
end
end

% 
%   Copyright 2021 Matthew W. Flood, EntropyHub
% 
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%
%        http://www.apache.org/licenses/LICENSE-2.0
%
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
%
%   For Terms of Use see https://github.com/MattWillFlood/EntropyHub

