function [FN] = FN_Gram_matrix_k(dataset,cost_name,kernel,kp,base_kp)
%function [FN] = FN_Gram_matrix_k(dataset,cost_name,kernel,kp,base_kp)
%Creates filename for the computed Gram matrix in case of linear K (kernel on the mean embeddings).

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

logkp = strcat('log',num2str(base_kp)); %example: 'log10'
kp_str = num2str(feval(logkp,kp)); 

FN = strcat('dataset',dataset,'_Gram','_cost', cost_name,'_k',kernel,'_log',num2str(base_kp),'kp',kp_str,'.mat');