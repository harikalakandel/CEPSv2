function [A] = ASpearman3_estimation(Y,ds,co)
%function [A] = ASpearman3_estimation(Y,ds,co)
%Estimates the second multivariate extension of Spearman's rho using empirical copulas.
%
%We use the naming convention 'A<name>_estimation' to ease embedding new association measure estimator methods.
%
%INPUT:
%   Y: Y(:,t) is the t^th sample.
%  ds: subspace dimensions. ds(m) = dimension of the m^th subspace, m=1,...,M (M=length(ds)).
%  co: association measure estimator object.
%
%REFERENCE:
%   Friedrich Shmid, Rafael Schmidt, Thomas Blumentritt, Sandra Gaiser, and Martin Ruppert. Copula Theory and Its Applications, Chapter Copula based Measures of Multivariate Association. Lecture Notes in Statistics. Springer, 2010.
%   Roger B. Nelsen. An Introduction to Copulas (Springer Series in Statistics). Springer, 2006.
%   Roger B. Nelsen. Distributions with Given Marginals and Statistical Modelling, chapter Concordance and copulas: A survey, pages 169-178. Kluwer Academic Publishers, Dordrecht, 2002.
%   C. Spearman. The proof and measurement of association between two things. The American Journal of Psychology, 15:72-101, 1904.

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

%verification:
    if sum(ds) ~= size(Y,1);
        error('The subspace dimensions are not compatible with Y.');
    end
    if ~one_dimensional_problem(ds)
        error('The subspaces must be one-dimensional for this estimator.');
    end
    
[d,num_of_samples] = size(Y); %dimension, number of samples
U = copula_transformation(Y);

h = (d+1) / (2^d - (d+1)); %h_rho(d)

A1 = h * (2^d * mean(prod(1-U)) -1);
A2 = h * (2^d * mean(prod(U)) -1);
A = (A1+A2)/2;


