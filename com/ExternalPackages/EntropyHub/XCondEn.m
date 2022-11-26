function [XCond, SEw, SEz] = XCondEn(Sig, varargin) 
% XCondEn  estimates the corrected cross-conditional entropy between two univariate data sequences.
%
%   [XCond, SEw, SEz] = XCondEn(Sig) 
% 
%   Returns the corrected cross-conditional entropy estimates (``XCond``) and
%   the corresponding Shannon entropies (``m: SEw``, ``m+1: SEz``) for ``m`` = [1,2] 
%   estimated for the data sequences contained in ``Sig`` using the default
%   parameters:  embedding dimension = 2, time delay = 1,
%   number of symbols = 6,  logarithm = natural
% 
%   * Note: ``XCondEn`` is direction-dependent. Therefore, the order of the
%     data sequences in ``Sig`` matters. If the first row/column of ``Sig`` is 
%     sequence 'y', and the second row/column is sequence 'u', then ``XCond`` is
%     the amount of information carried by y(i) when the pattern u(i) is found.
% 
%   [XCond, SEw, SEz] = XCondEn(Sig, name, value, ...)
% 
%   Returns the corrected cross-conditional entropy estimates (``XCond``) for
%   the data sequences contained in ``Sig`` using the specified name/value
%   pair arguments:
% 
%      * ``m``     - Embedding Dimension, an integer > 1        [default: 2]
%      * ``tau``   - Time Delay, a positive integer             [default: 1]
%      * ``c``     - Number of symbols, an integer > 1          [default: 6]
%      * ``Logx``  - Logarithm base, a positive scalar          [default: natural]
%      * ``Norm``  - Normalisation of ``XCond`` value, a boolean value:
%               *  [false]  no normalisation - [default]
%               *  [true]   normalises w.r.t cross-Shannon entropy.  
%
%   See also:
%       XFuzzEn, XSampEn, XApEn, XPermEn, CondEn, XMSEn
% 
%   References:
%     [1] Alberto Porta, et al.,
%           "Conditional entropy approach for the evaluation of the 
%           coupling strength." 
%           Biological cybernetics 
%           81.2 (1999): 119-129.

narginchk(1,11)
Sig = squeeze(Sig);
if size(Sig,1) == 2
    Sig = Sig';
end
p = inputParser;
Chk = @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x,1)==0);
Chk1 = @(x) isnumeric(x) && ismatrix(x) && (min(size(x))==2) && numel(x)>20;
Chk2 = @(x) isscalar(x) && (x > 1);
Chk3 = @(x) isscalar(x) && (x > 1) && (mod(x,1)==0);
addRequired(p,'Sig',Chk1);
addParameter(p,'m',2,Chk3);
addParameter(p,'tau',1,Chk);
addParameter(p,'c',6,Chk3);
addParameter(p,'Logx',exp(1),Chk2);
addParameter(p,'Norm',false,@(x) islogical(x));
parse(p,Sig,varargin{:})
m = p.Results.m; tau = p.Results.tau; Logx = p.Results.Logx; 
Norm = p.Results.Norm; c = p.Results.c;

N = size(Sig,1);
S1 = (Sig(:,1)-mean(Sig(:,1)))/std(Sig(:,1),1); 
S2 = (Sig(:,2)-mean(Sig(:,2)))/std(Sig(:,2),1); 
Edges = linspace(min(S1),max(S1),c+1);
Sx1 = discretize(S1,Edges);
Edges = linspace(min(S2),max(S2),c+1);
Sx2 = discretize(S2,Edges);
SEw = zeros(1,m-1);
SEz = zeros(1,m-1);
Prcm = zeros(1,m-1);
Xi = zeros(N,m);
for k = 1:m-1
    Nx = N-(k-1)*tau; 
    Xi(1:Nx,m-(k-1)) = Sx1((k-1)*tau+1:N);
    Wi = (c.^[k-1:-1:0])*Xi(1:Nx,m-k+1:m)';
    Zi = (c^k)*Sx2((k-1)*tau+1:N)' + Wi; 
    Pw = histcounts(Wi,[min(Wi)-.5:max(Wi)+.5]);
    Pz = histcounts(Zi,[min(Zi)-.5:max(Zi)+.5]);
    Prcm(k) = sum(Pz==1)/Nx;
    
    if sum(Pw)~= Nx || sum(Pz)~= Nx
        warning('Potential error estimating probabilities.')
    end
    
    Pw(Pw==0) = []; Pw = Pw/N;
    Pz(Pz==0) = []; Pz = Pz/N;
    SEw(k) = -Pw*log(Pw)'/log(Logx);
    SEz(k) = -Pz*log(Pz)'/log(Logx);
    clear Pw Pz Wi Zi
end

Temp = histcounts(Sx2,c)/N;
Temp(Temp==0) = [];
Sy = -Temp*log(Temp)'/log(Logx);
XCond = SEz - SEw + Prcm*Sy;
XCond = [Sy XCond];
if Norm
    XCond = XCond/Sy;
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
%   limitations under the License.clc
%
%   For Terms of Use see https://github.com/MattWillFlood/EntropyHub
