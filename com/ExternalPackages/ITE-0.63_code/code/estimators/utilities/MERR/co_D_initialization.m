function [co] = co_D_initialization(kernel,kp)
%function [co] = co_D_initialization(kernel,kp)
%Initialization of the kernel estimator.
%
%INPUT:
%   kernel: name of the kernel.
%   kp: kernel parameter.
%OUTPUT:
%   co: divergence estimator object.

%Copyright (C) 2012- Zoltan Szabo ("http://www.cmap.polytechnique.fr/~zoltan.szabo/")
%
%This file is part of the ITE (Information Theoretical Estimators) toolbox.
%
%ITE is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
%the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
%
%This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License along with ITE. If not, see <http://www.gnu.org/licenses/>.

switch kernel
    case {'RBF','exponential','Cauchy'}
        co = D_initialization('MMD_Ustat',1,{'kernel',kernel,'sigma',kp});
    case 'student'
        co = D_initialization('MMD_Ustat',1,{'kernel',kernel,'d',kp}); 
    case {'Matern3p2', 'Matern5p2'}
        co = D_initialization('MMD_Ustat',1,{'kernel',kernel,'l',kp});
    case {'poly2', 'poly3','ratquadr', 'invmquadr'}        
        co = D_initialization('MMD_Ustat',1,{'kernel',kernel,'c',kp});
    otherwise 
        error('Kernel=?');
end