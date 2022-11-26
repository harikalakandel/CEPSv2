function [XFuzz, Ps1, Ps2] = XFuzzEn(Sig, varargin) 
% XFuzzEn  estimates the cross-fuzzy entropy between two univariate data  sequences.
%
%   [XFuzz, Ps1, Ps2] = XFuzzEn(Sig) 
% 
%   Returns the cross-fuzzy entropy estimates (``XFuzz``) and the average fuzzy
%   distances (``m: Ps1``, ``m+1: Ps2``) for ``m`` = [1,2] estimated for the data sequences
%   contained in ``Sig``, using the default parameters: 
%   embedding dimension = 2, time delay = 1, fuzzy function (``Fx``) = ``'default'``,
%   fuzzy function paramters (``r``) = [0.2, 2], logarithm = natural
%
%   [XFuzz, Ps1, Ps2] = XFuzzEn(Sig, name, value, ...)
% 
%   Returns the cross-fuzzy entropy estimates (``XFuzz``) for dimensions = [1, ..., ``m``]
%   estimated for the data sequences in ``Sig`` using the specified name/value 
%   pair arguments:
% 
%      * ``m``     - Embedding Dimension, a positive integer   [default: 2]
%      * ``tau``   - Time Delay, a positive integer        [default: 1]
%      * ``Fx``    - Fuzzy function name, one of the following strings:
%        {``'sigmoid'``, ``'modsampen'``, ``'default'``, ``'gudermannian'``, ``'linear'``}
%      * ``r``     - Fuzzy function parameters, a 1 element scalar or a 2 element
%        vector of positive values. The ``r`` parameters for each fuzzy
%        function are defined as follows:  (default: [.2 2])
%                 sigmoid:     
%                             * r(1) = divisor of the exponential argument
%                             * r(2) = value subtracted from argument (pre-division)
%                 modsampen:    
%                             *  r(1) = divisor of the exponential argument
%                             *  r(2) = value subtracted from argument (pre-division)
%                 default:      
%                             *  r(1) = divisor of the exponential argument
%                             *  r(2) = argument exponent (pre-division)
%                 gudermannian: 
%                             *  r  = a scalar whose value is the numerator of
%                               argument to gudermannian function:
%                               GD(x) = atan(tanh(r/x)). GD(x) is 
%                               normalised to have a maximum value of 1.
%                 linear:       
%                              * r  = an integer value. When ``r == 0``, the
%                               argument of the exponential function is 
%                               normalised between [0 1]. When ``r == 1``,
%                               the minimuum value of the exponential 
%                               argument is set to 0.                          
%      * ``Logx``  - Logarithm base, a positive scalar  [default: natural]
%
%   For further information on the name/value paire arguments, see
%   the `EntropyHub guide <https://github.com/MattWillFlood/EntropyHub/blob/main/EntropyHub%20Guide.pdf>`_
%   
%   See also:
%         FuzzEn, XSampEn, XApEn, FuzzEn2D, XMSEn, MSEn
% 
%   References:
%     [1] Hong-Bo Xie, et al.,
%           "Cross-fuzzy entropy: A new method to test pattern synchrony of
%           bivariate time series." 
%           Information Sciences 
%           180.9 (2010): 1715-1724.
% 

narginchk(1,11)
Sig = squeeze(Sig);
if size(Sig,1) == 2
    Sig = Sig';
end

p = inputParser;
Chk = @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x,1)==0);
Chk1 = @(x) isnumeric(x) && ismatrix(x) && (min(size(x))==2) && numel(x)>20;
Chk2 = @(x) isscalar(x) && (x > 0);
Chk3 = {'sigmoid','modsampen','default','gudermannian','linear'};
addRequired(p,'Sig',Chk1);
addParameter(p,'m',2,Chk);
addParameter(p,'tau',1,Chk);
addParameter(p,'r',[.2, 2],@(x) isnumeric(x) && isvector(x) && (min(x) >= 0));
addParameter(p,'Fx','default',@(x) ischar(x) && any(validatestring(lower(x),Chk3)));
addParameter(p,'Logx',exp(1),Chk2);
parse(p,Sig,varargin{:})
m = p.Results.m; tau = p.Results.tau; 
r = p.Results.r; Logx = p.Results.Logx; 

if numel(r) == 2 && strcmpi(p.Results.Fx,'linear')
    r = 0;
    fprintf('Multiple values for r entered. Default value (0) used.') 
elseif numel(r) == 2 && strcmpi(p.Results.Fx,'gudermannian')
    r = r(1);
    fprintf('Multiple values for r entered. First value used.') 
end

N = size(Sig,1);
S1 = Sig(:,1); S2 = Sig(:,2);
Fun = str2func(lower(p.Results.Fx));
m = m+1;
Sx1 = zeros(N,m);
Sx2 = zeros(N,m);
for k = 1:m
    Sx1(1:N-(k-1)*tau,k) = S1(1 + (k-1)*tau:N);
    Sx2(1:N-(k-1)*tau,k) = S2(1 + (k-1)*tau:N);
end

Ps1 = zeros(1,m);
Ps2 = zeros(1,m-1);
Ps1(1) = 1; %Does this need to be changed
for k = 2:m
    N1 = N - k*tau;
    N2 = N - (k-1)*tau;
    A = Sx1(1:N2,1:k) - mean(Sx1(1:N2,1:k),2);
    B = Sx2(1:N2,1:k) - mean(Sx2(1:N2,1:k),2);
    d2 = zeros(N2);
    for p = 1:N2
        Mu2 = max(abs(A(p,:) - B),[],2);
        d2(p,:) = Fun(Mu2,r);
    end    
    Ps1(k) = mean(mean(d2(1:N1,1:N1)));
    Ps2(k-1) = mean(mean(d2));
end
XFuzz = (log(Ps1(1:end-1)) - log(Ps2))/log(Logx);
end

function [y] = sigmoid(x,r)
if numel(r) == 1
    error('When Fx = "Sigmoid", r must be a two-element vector.')
end
y = 1./(1+exp((x-r(2))/r(1)));
end
function [y] = modsampen(x,r)
if numel(r) == 1
    error('When Fx = "Modsampen", r must be a two-element vector.')
end
y = 1./(1+exp((x-r(2))/r(1)));
end
function [y] = default(x,r)
if numel(r) == 1
    error('When Fx = "Default", r must be a two-element vector.')
end
y = exp(-(x.^r(2))/r(1));
end
function [y] = gudermannian(x,r)
y = atan(tanh(r(1)./x));
y = y/max(y);
end
function [y] = linear(x,r)
if r == 0 && numel(x)>1
    y = exp(-(x - min(x))/range(x));
elseif r==0 && numel(x)==1
    y = 0;
elseif r == 1
    y = exp(-(x - min(x)));
else
    error('When Fx = "Linear", r must be 0 or 1')
%     y = -(x - max(x))/range(x);
end
end

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
