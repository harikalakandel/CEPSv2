function [XK2, Ci] = XK2En(Sig, varargin) 
% XK2En  estimates the cross-Kolmogorov (K2) entropy between two univariate data sequences.
%
%   [XK2, Ci] = XK2En(Sig)
% 
%   Returns the cross-Kolmogorov entropy estimates (``XK2``) and the correlation
%   integrals (``Ci``) for ``m`` = [1,2] estimated between the data sequences 
%   contained in ``Sig`` using the default parameters: 
%   embedding dimension = 2, time delay = 1, 
%   distance threshold (``r``) = 0.2*SD(``Sig``), logarithm = natural
%
%   [XK2, Ci] = XK2En(Sig, name, value, ...)
% 
%   Returns the cross-Kolmogorov entropy estimates (``XK2``) estimated between
%   the data sequences contained in ``Sig`` using the specified name/value
%   pair arguments:
% 
%       * ``m``     - Embedding Dimension, a positive integer [default: 2]
%       * ``tau``   - Time Delay, a positive integer         [default: 1]
%       * ``r``     - Radius Distance Threshold, a positive scalar [default: 0.2*SD(``Sig``)]
%       * ``Logx``  - Logarithm base, a positive scalar      [default: natural]
%
%   See also:
%      XSampEn, XFuzzEn, XApEn, K2En, XMSEn, XDistEn.
% 
%   References:
%     [1]   Matthew W. Flood,
%               "XK2En - EntropyHub Project"
%               (2021) https://github.com/MattWillFlood/EntropyHub
% 


narginchk(1,9)
Sig = squeeze(Sig);
if size(Sig,1) == 2
    Sig = Sig';
end

p = inputParser;
Chk = @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x,1)==0);
Chk1 = @(x) isnumeric(x) && ismatrix(x) && (min(size(x))==2) && numel(x)>20;
Chk2 = @(x) isscalar(x) && (x > 0);
addRequired(p,'Sig',Chk1);
addParameter(p,'m',2,Chk);
addParameter(p,'tau',1,Chk);
addParameter(p,'r',.2*std(Sig(:),1),Chk2);
addParameter(p,'Logx',exp(1),Chk2);
parse(p,Sig,varargin{:})
m = p.Results.m; tau = p.Results.tau; 
r = p.Results.r; Logx = p.Results.Logx; 

N   = length(Sig);
m   = m+1;
Zm1 = zeros(N,m);
Zm2 = zeros(N,m); 
Ci = zeros(1,m);
for n = 1:m
    N2 = N-(n-1)*tau;
    Zm1(1:N2,n) = Sig((n-1)*tau + 1:N,1);   
    Zm2(1:N2,n) = Sig((n-1)*tau + 1:N,2);   
    Norm = zeros(N2);    
    for k = 1:N2
        Temp = repmat(Zm1(k,1:n),N2,1) - Zm2(1:N2,1:n);
        Norm(k,:) = sqrt(sum(Temp.*Temp,2)); 
    end
    Ci(n) = mean(Norm(:) < r);     
end
 
XK2 = (log(Ci(1:m-1)./Ci(2:m))/log(Logx))/tau;
XK2(isinf(XK2)) = NaN;
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