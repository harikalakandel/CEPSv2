function [XSamp, A, B] = XSampEn(Sig, varargin)
% XSampEn  estimates the cross-sample entropy between two univariate data sequences.
%
%   [XSamp, A, B] = XSampEn(Sig) 
% 
%   Returns the cross-sample entropy estimates (``XSamp``) and the number of 
%   matched vectors (``m: B``, ``m+1: A``) for m = [0,1,2] estimated for the two 
%   univariate data sequences contained in ``Sig`` using the default parameters:
%   embedding dimension = 2, time delay = 1, 
%   radius distance threshold = 0.2*SD(``Sig``), logarithm = natural
%
%   [XSamp, A, B] = XSampEn(Sig, name, value, ...)
% 
%   Returns the cross-sample entropy estimates (``XSamp``) for dimensions 
%   [0,1, ..., ``m``] estimated between the data sequences in ``Sig`` using the 
%   specified name/value pair  arguments:
% 
%       * ``m``     - Embedding Dimension, a positive integer  [default: 2]
%       * ``tau``   - Time Delay, a positive integer         [default: 1]
%       * ``r``     - Radius Distance Threshold, a positive scalar [default: 0.2*SD(``Sig``)]
%       * ``Logx``  - Logarithm base, a positive scalar      [default: natural]
%
%   See also:
%       XFuzzEn, XApEn, SampEn, SampEn2D, XMSEn, ApEn
%   
%   References:
%     [1] Joshua S Richman and J. Randall Moorman. 
%           "Physiological time-series analysis using approximate entropy
%           and sample entropy." 
%           American Journal of Physiology-Heart and Circulatory Physiology
%           (2000)
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
A(1) = sum(sum(Counter));  B(1) = N*N;
% N*(N-1)/2; Changed as no identical pairs compared
for n = 1:N - tau 
    ix = find(Counter(n,:)==1);
    for k = 1:M(n)
        ix(ix + (k*tau) > N) = [];
        if isempty(ix)
            break
        end
        p1 = repmat(S1(n:tau:n+(k*tau))',length(ix),1);
        p2 = S2(ix+(0:tau:tau*k)')';        
        ix = ix(max(abs(p1 - p2),[],2) <= r);
        Counter(n, ix) = Counter(n,ix) + 1;
    end
end

for k = 1:m
    A(k+1) = sum(sum(Counter>k)); 
    B(k+1) = sum(sum(Counter>=k));
end
XSamp = -log(A./B)/log(Logx);
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