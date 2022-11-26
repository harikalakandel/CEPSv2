%function [] = quick_test_HRenyi()
%Quick test for Renyi entropy estimators: analytical expression vs estimated value as a function of the sample number. In the test, normal/uniform variables are considered. See also 'analytical_value_HRenyi.m'.

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

%clear start:
    clear all; close all;
    genpath('E:\WorkSpace\Matlab\Projects\pipeline\com\ExternalPackages\ITE-0.63_code');
    addpath('E:\WorkSpace\Matlab\Projects\pipeline\com\ExternalPackages\ITE-0.63_code\code\estimators\quick_tests\tests_analytical_vs_estimation')
    addpath('E:\WorkSpace\Matlab\Projects\pipeline\com\ExternalPackages\ITE-0.63_code\code\estimators')
    addpath('E:\WorkSpace\Matlab\Projects\pipeline\com\ExternalPackages\ITE-0.63_code\code\shared')
    addpath('E:\WorkSpace\Matlab\Projects\pipeline\com\ExternalPackages\ITE-0.63_code\code\estimators\utilities')
    addpath('E:\WorkSpace\Matlab\Projects\pipeline\com\ExternalPackages\ITE-0.63_code\code\estimators\utilities\analytical_values')
    addpath('E:\WorkSpace\Matlab\Projects\pipeline\com\ExternalPackages\ITE-0.63_code\code\shared\embedded\ann_wrapperM')

%parameters:
    distr = 'normal'; %possibilities: 'uniform', 'normal' 
    d = 1; %dimension of the distribution
    alpha_H = 0.99; %parameter of the Renyi entropy
    num_of_samples_v = [1000:1000:30*1000]; %sample numbers used for estimation
    %estimator, base:
        cost_name = 'Renyi_kNN_k';       %d>=1
        %cost_name = 'Renyi_kNN_1tok';   %d>=1; do not forget to estimate the additive constant (for details see '' and the documentation)
        %cost_name = 'Renyi_kNN_S';      %d>=1; do not forget to estimate the additive constant...
        %cost_name = 'Renyi_weightedkNN';%d>=1
        %cost_name = 'Renyi_MST';        %d>=1; do not forget to estimate the additive constant...; computationally intensive 
        %cost_name = 'Renyi_spacing_V';  % d=1
        %cost_name = 'Renyi_spacing_E';  % d=1      
        %cost_name = 'qRenyi_CDSS';      % d=1, alpha_H=2
        %cost_name = 'Renyi_expF';       %d>=1; distr = 'normal'
        
%initialization:
    num_of_samples_max = num_of_samples_v(end);
    L = length(num_of_samples_v);
    %initialize cost object, set the alpha parameter:
        co = H_initialization(cost_name,1,{'alpha',alpha_H}); %{'alpha',alpha_H}: set the 'alpha' field
    H_hat_v = zeros(L,1); %vector of estimated entropies

%distr, d -> samples (Y), analytical value (H):
    switch distr
        case 'uniform'
            %U[a,b]:
                a = -rand(d,1); b = rand(d,1); %guaranteed that a<=b (coordinate-wise)
                %a = zeros(d,1); b = ones(d,1); %U[0,1]
            %(random) linear transformation applied to the data:
                A = rand(d);
                %A = eye(d);%do not transform the data
            %generate samples:
                Y =  A * (rand(d,num_of_samples_max) .* repmat(b-a,1,num_of_samples_max) + repmat(a,1,num_of_samples_max));
            par.a = a; par.b = b; par.A = A;
        case 'normal'
            %mean:
                m = rand(d,1);
            %random linear transformation applied to N(0,I):
                A = rand(d); 
                %A = eye(d); %do not transform the data
            %covariance matrix:
                C = A * A.';
            %generate samples:
                Y = A * randn(d,num_of_samples_max) + repmat(m,1,num_of_samples_max); %AxN(0,I)+m
            par.cov = C;
        otherwise
            error('Distribution=?');                 
    end
    %analytical value:
        H = analytical_value_HRenyi(distr,alpha_H,par);
                
%estimation:
    Tk = 0;%index of the sample number examined   
    for num_of_samples = num_of_samples_v
        Tk = Tk + 1;
        H_hat_v(Tk) = H_estimation(Y(:,1:num_of_samples),co);
        disp(strcat('Tk=',num2str(Tk),'/',num2str(L)));
    end
    
%plot:
    plot(num_of_samples_v,H_hat_v,'r',num_of_samples_v,H*ones(L,1),'g');
    legend({'estimation','analytical value'});
    xlabel('Number of samples');
    ylabel('Renyi entropy'); 
