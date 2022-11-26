function [MSx, CI] = cXMSEn(Sig, Mobj, varargin)
% cXMSEn  returns the composite multiscale cross-entropy between two  univariate data sequences.
%
%   [MSx, CI] = cXMSEn(Sig, Mobj) 
% 
%   Returns a vector of composite multiscale cross-entropy values (``MSx``) 
%   between two univariate data sequences contained in ``Sig`` using the 
%   parameters specified by the multiscale object (``Mobj``) using the composite 
%   multiscale entropy method (cMSE) over 3 temporal scales.
%    
%   [MSx, CI] = cXMSEn(Sig, Mobj, name, value, ...)
% 
%   Returns a vector of composite multiscale cross-entropy values (``MSx``) 
%   between the data sequences contained in ``Sig`` using the parameters
%   specified by the multiscale object (``Mobj``) and the following name/value
%   pair arguments:
% 
%      * ``Scales``   - Number of temporal scales, an integer > 1   (default: 3)
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
%      * ``Refined``  - Refined-composite ``XMSEn`` method. When ``Refined == true``
%        and the entropy function specified by ``Mobj`` is ``XSampEn``, ``cXMSEn``
%        returns the refined-composite multiscale entropy (rcXMSEn) (default: false)
%      * ``Plotx``    - When ``Plotx == true``, returns a plot of the entropy value at 
%        each time scale (i.e. the multiscale entropy curve)    (default: false)
% 
%   See also:
%       MSobject, XMSEn, rXMSEn, hXMSEn, XSampEn, XApEn, MSEn, cMSEn, rMSEn
%   
%   References:
%     [1] Rui Yan, Zhuo Yang, and Tao Zhang,
%           "Multiscale cross entropy: a novel algorithm for analyzing two
%           time series." 
%           5th International Conference on Natural Computation. 
%           Vol. 1, pp: 411-413 IEEE, 2009.
% 
%     [2] Yi Yin, Pengjian Shang, and Guochen Feng, 
%           "Modified multiscale cross-sample entropy for complex time 
%           series."
%           Applied Mathematics and Computation 
%           289 (2016): 98-110.
% 
%     [3] Madalena Costa, Ary Goldberger, and C-K. Peng,
%           "Multiscale entropy analysis of complex physiologic time series."
%           Physical review letters
%           89.6 (2002): 068102.
% 
%     [4] Antoine Jamin, et al,
%           "A novel multiscale cross-entropy method applied to navigation 
%           data acquired with a bike simulator." 
%           41st annual international conference of the IEEE EMBC
%           IEEE, 2019.
% 
%     [5] Antoine Jamin and Anne Humeau-Heurtier. 
%           "(Multiscale) Cross-Entropy Methods: A Review." 
%           Entropy 
%           22.1 (2020): 45.
% 
%     [6] Shuen-De Wu, et al.,
%           "Time series analysis using composite multiscale entropy." 
%           Entropy 
%           15.3 (2013): 1069-1084.
% 


narginchk(2,10)
Sig = squeeze(Sig);
if size(Sig,1) == 2
    Sig = Sig';
end
p = inputParser;
Chk1 = @(x) isnumeric(x) && ismatrix(x) && (min(size(x)) ==2) && numel(x)>20;
addRequired(p,'Sig',Chk1);
addRequired(p,'Mobj',@(x) isstruct(x));
addParameter(p,'Scales',3,@(x) isnumeric(x) && (length(x)==1) && (x>1));
addParameter(p,'RadNew',0,@(x) ismember(x,0:4) && ...
    any(validatestring(func2str(Mobj.Func),{'XSampEn';'XApEn'})));
addParameter(p,'Refined',false,@(x) islogical(x) && ...
    any(validatestring(func2str(Mobj.Func),{'XSampEn'})));
addParameter(p,'Plotx',false,@(x) islogical(x));
parse(p,Sig, Mobj, varargin{:})
MSx = zeros(1,p.Results.Scales);
RadNew = p.Results.RadNew;
Fields = fieldnames(Mobj);
Y = struct2cell(Mobj);
C = [Fields(2:end),Y(2:end)].';

if RadNew
    switch RadNew
        case 1
            Rnew = @(x) std(x(:),1);
        case 2
            Rnew = @(x) var(x(:),1);
        case 3            
            Rnew = @(x) mad(x(:));
        case 4
            Rnew = @(x) mad(x(:),1);
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
        C{1,C_Loc} = 'r';
        Cx = .2;
    end
end
for T = 1:p.Results.Scales      
    Temp = modified(Sig,T); 
    N = T*floor(length(Temp)/T);
    Temp3 = zeros(1,T);
    for k = 1:T
        fprintf(' .')
        if RadNew
            C{2,C_Loc} = Cx*Rnew(Temp(k:T:N,:));
        end
        
        if p.Results.Refined          
            [~, Ma, Mb] = Mobj.Func(Temp(k:T:N,:),C{:});
            Temp2(k) = Ma(end);
            Temp3(k) = Mb(end);
        else
            Temp2 = Mobj.Func(Temp(k:T:N,:),C{:});
            Temp3(k) = Temp2(end);
        end
    end    
    
    if p.Results.Refined
        MSx(T) = -log(sum(Temp2)/sum(Temp3));
    else
        MSx(T) = mean(Temp3);
    end
    clear Temp Temp2 Temp3 Ma Mb
end
CI = sum(MSx);
fprintf(' .\n')
if any(isnan(MSx))
    fprintf('\nSome entropy values may be undefined.')
end

if p.Results.Plotx
    if p.Results.Refined
        strx = 'Refined-Composite';
    else
        strx = 'Composite';
    end
    
   figure, hold on
   plot(1:p.Results.Scales,MSx,'color',[8 63 77]/255,'LineWidth',3)   
   scatter(1:p.Results.Scales,MSx,60,[1 0 1],'filled')   
   xlabel('Scale Factor','FontSize',12,'FontWeight','bold','Color',[7 54 66]/255)
   ylabel('Entropy Value','FontSize',12,'FontWeight','bold','Color',[7 54 66]/255)
   title(sprintf('%s Multiscale %s',strx,func2str(Y{1})),...
       'FontSize',16,'FontWeight','bold','Color',[7 54 66]/255)
end
end

function [Y] = modified(Z,sx)
    Y = movmean(Z,sx);
    Y = Y(ceil((sx+1)/2):end-ceil(sx/2)+1,:);
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