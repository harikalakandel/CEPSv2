function [H] = HShannon_vME_estimation(Y,co)
%function [H] = HShannon_vME_estimation(Y,co)
%Estimates the Shannon differential entropy (H) of Y using von Mises expansion.
%
%We use the naming convention 'H<name>_estimation' to ease embedding new entropy estimation methods.
%
%INPUT:
%   Y: Y(:,t) is the t^th sample.
%  co: entropy estimator object.
%
%REFERENCE: 
%   Kirthevasan Kandasamy, Akshay Krishnamurthy, Barnabas Poczos, Larry Wasserman, and James Robins. Nonparametric von Mises estimators for entropies, divergences and mutual informations. In Advances in Neural Information Processing Systems (NIPS), pages 397-405, 2015.

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

%co.mult:OK. The information theoretical quantity of interest can be (and is!) estimated exactly [co.mult=1]; the computational complexity of the estimation is essentially the same as that of the 'up to multiplicative constant' case [co.mult=0]. In other words, the estimation is carried out 'exactly' (instead of up to 'proportionality').

%H estimation:
    H = shannonEntropy(Y.',[],[]);
