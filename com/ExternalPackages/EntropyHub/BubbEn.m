function [Bubb, H] = BubbEn(Sig, varargin)
% BubbEn  estimates the bubble entropy of a univariate data sequence.
%
%   [Bubb, H] = BubbEn(Sig)
% 
%   Returns the bubble entropy (``Bubb``) and the conditional Renyi entropy (``H``)
%   estimates from the data sequence (``Sig``) using the default parameters:
%   embedding dimension = 2, time delay = 1, logarithm = natural
%
%   [Bubb, H] = BubbEn(Sig, name, value, ...)
% 
%   Returns the bubble entropy (``Bubb``) estimated from the data sequence (``Sig``)
%   using the specified name/value pair arguments:
% 
%       * ``m``     - Embedding Dimension, an integer > 1.  
%         ``BubbEn`` returns estimates for each dimension [2, ..., ``m``]
% 
%       * ``tau``   - Time Delay, a positive integer
%       * ``Logx``  - Logarithm base, a positive scalar
%
%   See also:
%       PhasEn, MSEn
%
%   References:
%     [1] George Manis, M.D. Aktaruzzaman and Roberto Sassi,
%           "Bubble entropy: An entropy almost free of parameters."
%           IEEE Transactions on Biomedical Engineering
%           64.11 (2017): 2711-2718.
%


narginchk(1,7)
Sig = squeeze(Sig);

p = inputParser;
Chk = @(x) isnumeric(x) && isscalar(x) && (x > 0) && (mod(x,1)==0);
Chk2 = @(x) isnumeric(x) && isscalar(x) && (x > 1) && (mod(x,1)==0);
addRequired(p,'Sig',@(x) isnumeric(x) && isvector(x) && (length(x) > 10));
addParameter(p,'m',2,Chk2);
addParameter(p,'tau',1,Chk);
addParameter(p,'Logx',exp(1),@(x) isnumeric(x) && (x > 0));
parse(p,Sig,varargin{:})
m = p.Results.m; tau = p.Results.tau;  Logx = p.Results.Logx;

N = length(Sig);
Sx = zeros(N,m+1);
H = zeros(1,m+1);
Sx(:,1) = Sig;
for k = 2:m+1
    Sx(1:N-(k-1)*tau,k) = Sig(1+(k-1)*tau:N);
    [Swapx] = BubbSort(Sx(1:N-(k-1)*tau,1:k));
    [~,~,Locs] = unique(Swapx);
    p = accumarray(Locs,1)/(N-(k-1)*tau);
    H(k) = -log(sum(p.^2))/log(Logx);
    
    if round(sum(p)) ~= 1
        warning('Potential error in detected swap number')
    end
    clear Swapx p Locs
end

Bubb = diff(H)./(log((2:m+1)./(0:m-1))/log(Logx));
Bubb(1) = [];

end

function [swaps, bsorted] = BubbSort(Data)

[x,N2] = size(Data);
swaps = zeros(1,x);
for y = 1:x
    t = 1;
    while t <= N2-1
        for kk = 1:N2-t
            if Data(y,kk) > Data(y,kk+1)
                temp = Data(y,kk);
                Data(y,kk) = Data(y,kk+1);
                Data(y,kk+1) = temp;
                swaps(y) = swaps(y) + 1;
            end
        end
        t = t + 1;
    end
end
bsorted = Data;
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