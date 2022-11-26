function [MSx, CI] = XMSEn(Sig, Mobj, varargin) 
% XMSEn  returns the multiscale cross-entropy between two univariate data sequences.
%
%   [MSx,CI] = XMSEn(Sig, Mobj) 
% 
%   Returns a vector of multiscale cross-entropy values (``MSx``) and the
%   complexity index (``CI``) between the data sequences contained in ``Sig`` using 
%   the parameters specified by the multiscale object (``Mobj``) over 3 temporal
%   scales with coarse-graining (default).
%    
%   [MSx,CI] = XMSEn(Sig, Mobj, name, value, ...)
% 
%   Returns a vector of multiscale cross-entropy values (``MSx``) and the
%   complexity index (``CI``) between the data sequences contained in ``Sig`` 
%   using the parameters specified by the multiscale object (``Mobj``) and the
%   following name/value pair arguments:
% 
%       * ``Scales``   - Number of temporal scales, an integer > 1   (default = 3)
%       * ``Methodx``  - Graining method, one of the following: [default = ``'coarse'``]
%         {``'coarse'``, ``'modified'``, ``'imf'``, ``'timeshift'``} 
%       * ``RadNew``   - Radius rescaling method, an integer in the range [1 4].
%         When the entropy specified by ``Mobj`` is ``XSampEn`` or ``XApEn``, 
%         ``RadNew`` rescales the radius threshold in each sub-sequence
%         at each time scale (Xt). If a radius value (``r``) is specified 
%         by ``Mobj``, this becomes the rescaling coefficient, otherwise
%         it is set to 0.2 (default). The value of ``RadNew`` specifies
%         one of the following methods:
%                   * [1]    Standard Deviation          - r*std(Xt)
%                   * [2]    Variance                    - r*var(Xt)
%                   * [3]    Mean Absolute Deviation     - r*mad(Xt)
%                   * [4]    Median Absolute Deviation   - r*mad(Xt,1)
%       * ``Plotx``    - When ``Plotx == true``, returns a plot of the entropy value at
%         each time scale (i.e. the multiscale entropy curve) [default: false]
% 
%   See also MSobject, XSampEn, XApEn, rXMSEn, cXMSEn, hXMSEn, MSEn
%   
%   References:
%     [1] Rui Yan, Zhuo Yang, and Tao Zhang,
%           "Multiscale cross entropy: a novel algorithm for analyzing two
%           time series." 
%           5th International Conference on Natural Computation. 
%           Vol. 1, pp: 411-413 IEEE, 2009.
% 
%     [2] Madalena Costa, Ary Goldberger, and C-K. Peng,
%           "Multiscale entropy analysis of complex physiologic time series."
%           Physical review letters
%           89.6 (2002): 068102.
% 
%     [3] Vadim V. Nikulin, and Tom Brismar,
%           "Comment on “Multiscale entropy analysis of complex physiologic
%           time series”." 
%           Physical review letters 
%           92.8 (2004): 089803.
% 
%     [4] Madalena Costa, Ary L. Goldberger, and C-K. Peng. 
%           "Costa, Goldberger, and Peng reply." 
%           Physical Review Letters
%           92.8 (2004): 089804.
% 
%     [5] Antoine Jamin, et al,
%           "A novel multiscale cross-entropy method applied to navigation 
%           data acquired with a bike simulator." 
%           41st annual international conference of the IEEE EMBC
%           IEEE, 2019.
% 
%     [6] Antoine Jamin and Anne Humeau-Heurtier. 
%           "(Multiscale) Cross-Entropy Methods: A Review." 
%           Entropy 
%           22.1 (2020): 45.


narginchk(2,10)
Sig = squeeze(Sig);
if size(Sig,1) == 2
    Sig = Sig';
end
p = inputParser;
Chk = {'coarse';'modified';'imf';'timeshift'};
Chk2 = @(x) isnumeric(x) && ismatrix(x) && min(size(x))==2 && numel(x)>20;
addRequired(p,'Sig',Chk2);
addRequired(p,'Mobj',@(x) isstruct(x));
addParameter(p,'Methodx','coarse',@(x) any(validatestring(string(x),Chk)));
addParameter(p,'Scales',3,@(x) isnumeric(x) && (x>0) && (length(x)==1));
addParameter(p,'RadNew',0,@(x) ismember(x,0:4) && ...
    any(validatestring(func2str(Mobj.Func),{'XSampEn';'XApEn'})));
addParameter(p,'Plotx',false,@(x) islogical(x));
parse(p,Sig, Mobj, varargin{:})
Methodx = str2func(p.Results.Methodx);
RadNew = p.Results.RadNew;
MSx = zeros(1,p.Results.Scales);
Fields = fieldnames(Mobj);
Y = struct2cell(Mobj);
C = [Fields(2:end),Y(2:end)].';

if strcmp(p.Results.Methodx,'imf')
    [Imfx,Resx] = emd(Sig(:,1),'MaxNumIMF',p.Results.Scales-1,'Display',0); 
    [Imfy,Resy] = emd(Sig(:,2),'MaxNumIMF',p.Results.Scales-1,'Display',0); 
    Sig = zeros(size(Sig,1),2,p.Results.Scales);
    Sig(:,1,:) = [Imfx Resx];
    Sig(:,2,:) = [Imfy Resy];    
    clear Imfx Resx Imfy Resy
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
        %C_Loc = length(C(1,:)) + 1;
        C_Loc = size(C,1) + 1;
        C{1,C_Loc} = 'r';
        Cx = .2;
    end
end
for T = 1:p.Results.Scales    
    fprintf(' .')
    Temp = Methodx(Sig,T);      
    if strcmpi(p.Results.Methodx,'timeshift')
        Tempx = zeros(1,T);
        for k = 1:T
            fprintf(' .')
            if RadNew
                C{2,C_Loc} = Cx*Rnew(Temp(k,:));
            end
            Tempy = Mobj.Func(Temp(k,:,:),C{:});  
            Tempx(k) = Tempy(end);
        end
        Temp2 = mean(Tempx);
        clear Tempx Tempy
    else
        if RadNew
            C{2,C_Loc} = Cx*Rnew(Temp(:));
        end
        Temp2 = Mobj.Func(Temp,C{:});
    end
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
   title(sprintf('Multiscale %s (%s-graining method)',func2str(Y{1}),...
       p.Results.Methodx),'FontSize',16,'FontWeight','bold','Color',[7 54 66]/255)
end
end

function [Y] = coarse(Z,sx)
    Ns = floor(length(Z)/sx);
    T1 = mean(reshape(Z(1:sx*Ns,1),sx,Ns),1);
    T2 = mean(reshape(Z(1:sx*Ns,2),sx,Ns),1);
    Y = [T1;T2];
end
function [Y] = modified(Z,sx)
    Y = movmean(Z,sx);
    Y = Y(ceil((sx+1)/2):end-ceil(sx/2)+1,:);
end
function [Y] = imf(Z,sx)
    Y = squeeze(sum(Z(:,:,1:sx),3));    
end
function [Y] = timeshift(Z,sx)
    Y = zeros(sx,floor(length(Z)/sx),2);
    Y(:,:,1) = reshape(Z(1:sx*floor(length(Z)/sx),1),sx,floor(length(Z)/sx));
    Y(:,:,2) = reshape(Z(1:sx*floor(length(Z)/sx),2),sx,floor(length(Z)/sx));    
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