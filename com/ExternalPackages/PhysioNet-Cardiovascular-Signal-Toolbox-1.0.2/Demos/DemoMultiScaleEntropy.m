%	OVERVIEW:
%       Compute the MultiScale Entropy using RR intervals generated by
%       RRgen
%   OUTPUT:
%       HRV Metrics exported to .cvs files
%
%   DEPENDENCIES & LIBRARIES:
%       https://github.com/cliffordlab/PhysioNet-Cardiovascular-Signal-Toolbox
%   REFERENCE: 
%       Vest et al. "An Open Source Benchmarked HRV Toolbox for Cardiovascular 
%       Waveform and Interval Analysis" Physiological Measurement (In Press), 2018. 
%	REPO:       
%       https://github.com/cliffordlab/PhysioNet-Cardiovascular-Signal-Toolbox
%   ORIGINAL SOURCE AND AUTHORS:     
%       Giulia Da Poian   
%	COPYRIGHT (C) 2018 
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc; close all;

run(['..' filesep 'startup.m'])

% Remove old files generated by this demo
OldFolder = [pwd, filesep, 'OutputData', filesep, 'ResultsNSR'];
if exist(OldFolder, 'dir')
    rmdir(OldFolder, 's');
    fprintf('Old Demo Folder deleted \n');
end


% Initialize settings for demo
HRVparams = InitializeHRVparams('demo_RRgen');  
HRVparams.HRT.on = 0; % No HRT analysis for this demo
HRVparams.DFA.on = 0; % No DFA analysis for this demo

% 1. Generate Data using RRgen

rr = rrgen(HRVparams.demo.length,HRVparams.demo.pe,HRVparams.demo.pn,HRVparams.demo.seed);
t = cumsum(rr);

% 2. Preprocess RR Data - Using HRV Toolbox
% Remove noise, Remove ectopy, Don't detrend (yet)
[NN, tNN, fbeats] = RRIntervalPreprocess(rr,t,[], HRVparams);

% 3. Calculate the Multiscale Entropy

fprintf('Computing MSE...this may take a few minutes...\n')
fprintf('Parameters used to calculate SempEntropy: m=%i r=%.2f \n', HRVparams.MSE.patternLength, HRVparams.MSE.RadiusOfSimilarity);
WindIdxs = CreateWindowRRintervals(tNN, NN, HRVparams,'mse');
mse = EvalMSE(NN,tNN,[],HRVparams,WindIdxs);
fprintf('MSE completed!\n')

% 4. Plot 
fig = figure();
ax = axes('Parent',fig, 'Position',[0.15 0.15 0.7 0.7]);
plot(mse,'LineWidth',2);
xlabel('Scale Factor');
ylabel('H_{s}');
title('Multiscale Entropy')
set(ax,'FontSize',18);
grid on


% 5. Save Results
Scales = 1:HRVparams.MSE.maxCoarseGrainings;
results =  [Scales' mse];
for i=1:length(WindIdxs); W{i}=strcat('t_', num2str(WindIdxs(i)));end
col_titles = {'Scales' W{:}};

% Generates Output - Never comment out
resFilenameMSE = SaveHRVoutput('RRgenData',[],results,...
    col_titles, 'MSE', HRVparams, tNN, NN);



% 6 Compare generated output file with the reference one
        
currentFile = [HRVparams.writedata filesep resFilenameMSE '.csv'];
referenceFile = ['ReferenceOutput' filesep 'MSEDemo.csv'];
testHRV = CompareOutput(currentFile,referenceFile);

if testHRV
    fprintf('** DemoMultiScaleEntropy: TEST SUCCEEDED ** \n ')
     fprintf('A file named %s.csv \n has been saved in %s \n', ...
    resFilenameMSE, HRVparams.writedata);
else
    fprintf('** DemoMultiScaleEntropy: TEST FAILED ** \n')
end
