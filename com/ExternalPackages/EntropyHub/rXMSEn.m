function [MSx, CI] = rXMSEn(Sig, Mobj, varargin) 
% rXMSEn  returns the refined multiscale cross-entropy between two  univariate data sequences.
%
%   [MSx,CI] = rXMSEn(Sig, Mobj) 
% 
%   Returns a vector of refined multiscale cross-entropy values (``MSx``) and
%   the complexity index (``CI``) between the data sequences contained in
%   ``Sig`` using the parameters specified by the multiscale object (``Mobj``) and the
%   following default parameters:   Scales = 3, Butterworth LPF Order = 6,
%   Butterworth LPF cutoff frequency at scale (T): Fc = 0.5/T. 
%   If the entropy function specified by ``Mobj`` is ``XSampEn`` or ``XApEn``, ``rMSEn`` 
%   updates the threshold radius of the data sequences (Xt) at each scale
%   to 0.2*std(Xt) when no ``r`` value is provided by ``Mobj``, or ``r``*std(Xt) if 
%   ``r`` is specified.
%    
%   [MSx,CI] = rXMSEn(Sig, Mobj, name, value, ...)
% 
%   Returns a vector of refined multiscale cross-entropy values (``MSx``) and 
%   the complexity index (``CI``) between the data sequences contained in
%   ``Sig`` using the parameters specified by the multiscale object (``Mobj``) and the
%   following name/value pair arguments:
% 
%      * ``Scales``   - Number of temporal scales, an integer > 1 (default: 3)
%      * ``F_Order``  - Butterworth low-pass filter order, a positive integer (default: 6)
%      * ``F_Num``    - Numerator of Butterworth low-pass filter cutoff frequency,
%        a scalar value in range [0 < ``F_Num`` < 1]. The cutoff frequency
%        at each scale (T) becomes: Fc = ``F_Num``/T.  (default = 0.5)
%      * ``RadNew``   - Radius rescaling method, an integer in the range [1 4].
%        When the entropy specified by ``Mobj`` is ``XSampEn`` or ``XApEn``, 
%        ``RadNew`` rescales the radius threshold in each sub-sequence
%        at each time scale (Xt). If a radius value (``r``) is specified 
%        by ``Mobj``, this becomes the rescaling coefficient, otherwise
%        it is set to 0.2 (default). The value of ``RadNew`` specifies
%        one of the following methods:
%                   * [1]    Standard Deviation          - r*std(Xt)
%                   * [2]    Variance                    - r*var(Xt)
%                   * [3]    Mean Absolute Deviation     - r*mad(Xt)
%                   * [4]    Median Absolute Deviation   - r*mad(Xt,1)
%      * ``Plotx``    - When ``Plotx == true``, returns a plot of the entropy value at 
%        each time scale (i.e. the multiscale entropy curve)    (default: false)
% 
%   See also:
%       MSobject, XMSEn, cXMSEn, hXMSEn, XSampEn, XApEn, MSEn, rMSEn
% 
%   References:
%     [1]   Matthew W. Flood,
%           "rXMSEn - EntropyHub Project"
%           2021, https://github.com/MattWillFlood/EntropyHub
% 
%     [2]   Rui Yan, Zhuo Yang, and Tao Zhang,
%           "Multiscale cross entropy: a novel algorithm for analyzing two
%           time series." 
%           5th International Conference on Natural Computation. 
%           Vol. 1, pp: 411-413 IEEE, 2009.
% 
%     [3] José Fernando Valencia, et al.,
%           "Refined multiscale entropy: Application to 24-h holter 
%           recordings of heart period variability in healthy and aortic 
%           stenosis subjects." 
%           IEEE Transactions on Biomedical Engineering 
%           56.9 (2009): 2202-2213.
% 
%     [4] Puneeta Marwaha and Ramesh Kumar Sunkaria,
%           "Optimal selection of threshold value ‘r’for refined multiscale
%           entropy." 
%           Cardiovascular engineering and technology 
%           6.4 (2015): 557-576.
% 
%     [5] Yi Yin, Pengjian Shang, and Guochen Feng, 
%           "Modified multiscale cross-sample entropy for complex time 
%           series."
%           Applied Mathematics and Computation 
%           289 (2016): 98-110.
% 
%     [6] Antoine Jamin, et al,
%           "A novel multiscale cross-entropy method applied to navigation 
%           data acquired with a bike simulator." 
%           41st annual international conference of the IEEE EMBC
%           IEEE, 2019.
% 
%     [7] Antoine Jamin and Anne Humeau-Heurtier. 
%           "(Multiscale) Cross-Entropy Methods: A Review." 
%           Entropy 
%           22.1 (2020): 45.
% 


narginchk(2,12)
Sig = squeeze(Sig);
if size(Sig,1) == 2
    Sig = Sig';
end
p = inputParser;
Chk1 = @(x) isnumeric(x) && ismatrix(x) && (min(size(x)) ==2) && numel(x)>20;
addRequired(p,'Sig',Chk1);
addRequired(p,'Mobj',@(x) isstruct(x));
addParameter(p,'Scales',3,@(x) isnumeric(x) && (length(x)==1) && (x>1));
addParameter(p,'F_Order',6,@(x) isnumeric(x) && (length(x)==1) && (mod(x,1)==0));
addParameter(p,'F_Num',0.5,@(x) isnumeric(x) && (length(x)==1) && (0<x) && (x<1));
addParameter(p,'Plotx',false,@(x) islogical(x));
addParameter(p,'RadNew',0,@(x) ismember(x,0:4) && ...
    any(validatestring(func2str(Mobj.Func),{'XSampEn';'XApEn'})));
parse(p,Sig, Mobj, varargin{:})
MSx = zeros(1,p.Results.Scales);
RadNew = p.Results.RadNew;
Fields = fieldnames(Mobj);
Y = struct2cell(Mobj);
C = [Fields(2:end),Y(2:end)].';

if any(strcmp(func2str(Mobj.Func),{'XSampEn';'XApEn'})) && ~RadNew
    RadNew = 1;
end
if RadNew
    switch RadNew
        case 1
            Rnew = @(x) std(x,1);
        case 2
            Rnew = @(x) var(x,1);
        case 3            
            Rnew = @(x) mad(x);
        case 4
            Rnew = @(x) mad(x,1);
    end
    
    try
        C_Loc = find(strcmp(C(1,:),'r'));
        Cx = C{2,C_Loc};
    catch
        Cy = {'Standard Deviation';'Variance';...
            'Mean Abs Deviation';'Median Abs Deviation'};
        warning(['No radius value provided.\n' ...
            'Default set to 0.2*(%s) of each new time-series.'],Cy{RadNew})
         C_Loc = size(C,1) + 1;
%         C_Loc = length(C(1,:)) + 1;
        C{1,C_Loc} = 'r';
        Cx = .2;
    end
end
for T = 1:p.Results.Scales  
    fprintf(' .')
    Temp = refined(Sig,T,p.Results.F_Order,p.Results.F_Num);    
    if RadNew
        C{2,C_Loc} = Cx*Rnew(Temp(:));        
    end
    Temp2 = Mobj.Func(Temp,C{:});
    MSx(T) = Temp2(end);   
    clear Temp Temp2    
end
CI = sum(MSx);
fprintf(' .\n')
if any(isnan(MSx))
    fprintf('\nSome entropy values may be undefined.')
end

if p.Results.Plotx
   figure, hold on
   plot(1:p.Results.Scales,MSx,'color',[8 63 77]/255,'LineWidth',3)   
   scatter(1:p.Results.Scales,MSx,60,[1 0 1],'filled')   
   xlabel('Scale Factor','FontSize',12,'FontWeight','bold','Color',[7 54 66]/255)
   ylabel('Entropy Value','FontSize',12,'FontWeight','bold','Color',[7 54 66]/255)
   title(sprintf('Refined Multiscale %s ',func2str(Y{1})),...
       'FontSize',16,'FontWeight','bold','Color',[7 54 66]/255)
end
end

function [Y] = refined(Z,sx,P1,P2)
    [bb, aa] = butter(P1, P2/sx);
    Yt = filtfilt(bb, aa, Z);
    Y = Yt(1:sx:end,:);
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