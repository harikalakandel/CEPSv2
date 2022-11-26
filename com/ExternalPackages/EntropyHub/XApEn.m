function [XAp, Phi] = XApEn(Sig, varargin)
% XApEn  estimates the cross-approximate entropy between two univariate  data sequences.
%
%   [XAp, Phi] = XApEn(Sig)
% 
%   Returns the cross-approximate entropy estimates (``XAp``) and the log-average
%   number of matched vectors (``Phi``) for ``m`` = [0,1,2], estimated for the data
%   sequences contained in ``Sig`` using the default parameters:
%   embedding dimension = 2, time delay = 1, 
%   radius distance threshold = 0.2*SD(``Sig``),  logarithm = natural
%   
%   * NOTE: ``XApEn`` is direction-dependent. Thus, the first row/column of
%     ``Sig`` is used as the template data sequence, and the second row/column 
%     is the matching sequence.
%
%   [XAp, Phi] = XApEn(Sig, name, value, ...)
% 
%   Returns the cross-approximate entropy estimates (``XAp``) between the data
%   sequences contained in ``Sig`` using the specified name/value pair arguments:
% 
%      * ``m``     - Embedding Dimension, a positive integer   [default: 2]
%      * ``tau``   - Time Delay, a positive integer        [default: 1]
%      * ``r``     - Radius Distance Threshold, a positive scalar [default: 0.2*SD(``Sig``)]
%      * ``Logx``  - Logarithm base, a positive scalar     [default: natural]
%
%   See also:
%       XSampEn, XFuzzEn, XMSEn, ApEn, SampEn, MSEn
%   
%   References:
%     [1] Steven Pincus and Burton H. Singer,
%           "Randomness and degrees of irregularity." 
%           Proceedings of the National Academy of Sciences 
%           93.5 (1996): 2083-2088.
% 
%     [2] Steven Pincus,
%           "Assessing serial irregularity and its implications for health."
%           Annals of the New York Academy of Sciences 
%           954.1 (2001): 245-267.
% 


narginchk(1,9)
Sig = squeeze(Sig);
if size(Sig,1) == 2
    Sig = Sig';
end
p = inputParser;
Chk = @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x,1)==0);
Chk2 = @(x) isscalar(x) && (x > 0);
Chk1 = @(x) isnumeric(x) && ismatrix(x) && (min(size(x))==2) && numel(x)>20;
addRequired(p,'Sig',Chk1);
addParameter(p,'m',2,Chk);
addParameter(p,'tau',1,Chk);
addParameter(p,'r',.2*std(Sig(:),1),Chk2);
addParameter(p,'Logx',exp(1),Chk2);
parse(p,Sig,varargin{:})
m = p.Results.m; tau = p.Results.tau;
r = p.Results.r; Logx = p.Results.Logx;

N = size(Sig,1);
S1 = Sig(:,1); S2 = Sig(:,2);
Counter = 1*(abs(S1 - S2') <= r);
M = [m*ones(1,N-(m*tau)) repelem((m-1):-1:1,tau)];
XAp = zeros(1,m); Phi = XAp;
for n = 1:N-tau
    ix = find(Counter(n,:)==1);
    for k = 1:M(n)
        ix(ix + (k*tau) > N) = [];
        if isempty(ix)
            break
        end
        p1 = repmat(S1(n:tau:n+k*tau)',length(ix),1);
        p2 = S2(ix+(0:tau:k*tau)')';
        ix = ix(max(abs(p1 - p2),[],2) <= r);
        Counter(n, ix) = Counter(n, ix) + 1;
    end
end

Phi(1) = (log(N)/log(Logx))/N;
% Phi(2) = mean(log(sum(Counter>0)/N)/log(Logx));
Temp = sum(Counter>0)/N; Temp(Temp==0) = [];
Phi(2) = mean(log(Temp)/log(Logx));
XAp(1) = Phi(1) - Phi(2);
for k = 0:m-1
    ai = sum(Counter>k+1)/(N-(k+1)*tau);
    bi = sum(Counter>k)/(N-(k*tau));
    ai(ai==0) = [];
    bi(bi==0) = [];
    Phi(k+3) = sum(log(ai)/log(Logx))/(N-(k+1)*tau);
    XAp(k+2)= sum(log(bi)/log(Logx))/(N-(k*tau))- Phi(k+3);
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