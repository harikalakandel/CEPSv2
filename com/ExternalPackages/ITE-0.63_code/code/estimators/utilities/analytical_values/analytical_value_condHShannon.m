function [condH] = analytical_value_condHShannon(distr,par)
%Analytical value (condH) of the conditional Shannon entropy for the given distribution family. See also 'quick_test_condHShannon.m'.
%
%INPUT:
%   distr  : name of the distribution.
%   par    : parameters of the distribution (structure).
%
%If distr = 'normal' : par.cov = covariance matrix, par.d1 = dimension of the y^1, par.d2 = dimension of y^2.

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

switch distr 
    case 'normal'   
        %H12:
            H12 = analytical_value_HShannon(distr,par); %joint entropy
        %H2:
            C = par.cov;
            d1 = par.d1;
            par.cov = C(d1+1:end,d1+1:end);
            H2 = analytical_value_HShannon(distr,par); %entropy of the conditioning variable
        condH = H12 - H2;
    otherwise
        error('Distribution=?');
end  

