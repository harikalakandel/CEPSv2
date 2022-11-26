function [XSpec, BandEn] = XSpecEn(Sig, varargin)
% XSpecEn  estimates the cross-spectral entropy between two univariate  data sequences.
%
%   [XSpec, BandEn] = XSpecEn(Sig) 
% 
%   Returns the cross-spectral entropy estimate (``XSpec``) of the full cross-
%   spectrum and the within-band entropy (``BandEn``) estimated between the data 
%   sequences contained in ``Sig`` using the default  parameters: 
%   N-point FFT = length of ``Sig``, normalised band edge frequencies = [0 1],
%   logarithm = natural, normalisation = w.r.t # of spectrum/band frequency 
%   values.
%
%   [XSpec, BandEn] = XSpecEn(Sig, name, value, ...)
% 
%   Returns the cross-spectral entropy (``XSpec``) and the within-band entropy 
%   (``BandEn``) estimate between the data sequences contained in ``Sig`` using the
%   following specified name/value pair arguments:
% 
%       * ``N``     - Resolution of spectrum (N-point FFT), an integer > 1
%       * ``Freqs`` - Normalised band edge frequencies, a scalar in range [0 1]
%         where 1 corresponds to the Nyquist frequency (Fs/2).
%         *Note: When no band frequencies are entered, ``BandEn == SpecEn``
%       * ``Logx``  - Logarithm base, a positive scalar     [default: natural]
%       * ``Norm``  - Normalisation of ``XSpec`` value, a boolean:
%              *   [false]  no normalisation.
%              *   [true]   normalises w.r.t # of frequency values within the 
%                  spectrum/band   [default]
%
%   See also:
%         SpecEn, fft, XDistEn, periodogram, XSampEn, XApEn
%  
%   References:
%     [1]   Matthew W. Flood,
%               "XSpecEn - EntropyHub Project"
%               (2021) https://github.com/MattWillFlood/EntropyHub
% 


narginchk(1,9)
Sig = squeeze(Sig);
if size(Sig,2) == 2
    Sig = Sig';
end
p = inputParser;
Chk = @(x) isnumeric(x) && isscalar(x) && (x > 1) && (mod(x,1)==0);
Chk1 = @(x) isnumeric(x) && ismatrix(x) && (min(size(x))==2) && numel(x)>20;
Chk2 = @(x) isvector(x) && (min(x) >= 0) && (max(x) <= 1) && (length(x)==2);
addRequired(p,'Sig',Chk1);
addParameter(p,'N',2*length(Sig) + 1,Chk);
addParameter(p,'Freqs',[0 1],Chk2);
addParameter(p,'Logx',exp(1),@(x) isscalar(x) && (x >= 0));
addParameter(p,'Norm',true,@(x) islogical(x));
parse(p,Sig,varargin{:})
N = p.Results.N; Freqs = p.Results.Freqs; 
Logx = p.Results.Logx; Norm = p.Results.Norm;

if Logx == 0
    Logx = exp(1);
end
S1 = Sig(1,:); S2 = Sig(2,:);
if N == 0 || isempty(N)
    N = length(S1);
end
Fx = ceil(N/2);
Freqs = round(Freqs*Fx);
Freqs(Freqs==0) = 1;

if length(Freqs) < 2
    error('Freqs must contain at least two values.')
elseif Freqs(1) > Freqs(2)
    error('Lower band frequency must come first.')
elseif diff(Freqs) < 1
    error('Spectrum resoution too low to determine bandwidth.') 
elseif min(Freqs)<0 || max(Freqs)> Fx
    error('Freqs must be normalized w.r.t sampling frequency [0 1].')    
end

Pt = abs(fft(conv(S1,S2),N));
Pxx = Pt(1:Fx)/sum(Pt(1:Fx));
XSpec = -(Pxx*log(Pxx)')/log(Logx);
Pband = (Pxx(Freqs(1):Freqs(2)))/sum(Pxx(Freqs(1):Freqs(2)));
BandEn = -(Pband*log(Pband)')/log(Logx);

if Norm
    XSpec = XSpec/(log(Fx)/log(Logx));
    BandEn = BandEn/(log(diff(Freqs)+1)/log(Logx));
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