function [e] = sample_subspaces_multiD_geom(num_of_samples,de)
%function [e] = sample_subspaces_multiD_geom(num_of_samples,de)
%Sampling from the 'multiD-geom' / 'multiD1-...DM-geom' dataset. 
%
%INPUT:
%	num_of_samples: number of samples to be generated.
%   de: subspace dimensions.
%OUTPUT:
%   e: e(:,t) is the t^th sample. size(e,2) = num_of_samples.
%EXAMPLE:
%   e = sample_multiD_geom(1000,[2;2;2]);%1000 samples from the 'multi2-2-2-geom' = 'multi2-geom' dataset.
%   e = sample_multiD_geom(1000,[2;3;4]);%1000 samples from the 'multi2-3-4-geom' dataset.
%
%REFERENCE:
%   Zoltan Szabo and Andras Lorincz. Real and Complex Independent Subspace Analysis by Generalized Variance. ICA Research Network International Workshop (ICARN), pp. 85-88, 2006.

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

max_num_of_comps = 4;

if length(de) > max_num_of_comps 
    error(strcat('The number of components must be <=',num2str(max_num_of_comps),'.'));
else
    e = zeros(sum(de),num_of_samples);%preallocation
    start_idx = 1;
    for k = 1 : length(de)
        switch k
            case 1
                e_temp = sample_subspaces_multiD_geom_star(de(k),num_of_samples);
            case 2
                e_temp = sample_subspaces_multiD_geom_Lshape(de(k),num_of_samples);
            case 3
                e_temp = sample_subspaces_multiD_geom_sphere_surface(de(k),num_of_samples);
            case 4
                e_temp = sample_subspaces_multiD_geom_skeleton_of_square(de(k),num_of_samples);
        end
        %store e_temp:
            e(start_idx:start_idx+de(k)-1,:) = e_temp;
            start_idx = start_idx + de(k);
    end
end
