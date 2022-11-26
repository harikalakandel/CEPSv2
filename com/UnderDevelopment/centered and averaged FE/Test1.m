% This script gives outcomes shown in Figure 2 from the following paper
% Girault J.-M., Humeau-Heurtier A., "Centered and Averaged Fuzzy Entropy to Improve Fuzzy Entropy Precision", Entropy 2018, 20(4), 287.
% https://www.mdpi.com/1099-4300/20/4/287   
% - Author:       Jean-Marc Girault
% - Date:         07/07/2017 

clear;clc;close all;
data_fig2=[1 2 4 2 -1 -2 2 1 -1 0 -1 4 -2 -1 1 2 -4 -3 2 1 -1 -2 1 -2 -1 1 4 0];
L=length(data_fig2);
[~,NsymT]=FuzzySampEnt_TRIG(data_fig2,'T',2,0.1,1000,0);
[~,NsymR]=FuzzySampEnt_TRIG(data_fig2,'R',2,0.1,1000,0);
[~,NsymI]=FuzzySampEnt_TRIG(data_fig2,'I',2,0.1,1000,0);
[~,NsymG]=FuzzySampEnt_TRIG(data_fig2,'G',2,0.1,1000,0);
[NsymT NsymR NsymI NsymG]
Nsym=(NsymT+NsymR+NsymI+NsymG)


[~,NsymTc]=FuzzySampEnt_TRIG(data_fig2,'T',2,0.1,1000,1);
[~,NsymRc]=FuzzySampEnt_TRIG(data_fig2,'R',2,0.1,1000,1);
[~,NsymIc]=FuzzySampEnt_TRIG(data_fig2,'I',2,0.1,1000,1);
[~,NsymGc]=FuzzySampEnt_TRIG(data_fig2,'G',2,0.1,1000,1);
[NsymTc NsymRc NsymIc NsymGc]
Nsym=(NsymTc+NsymRc+NsymIc+NsymGc)

[~,NsymTf]=FuzzySampEnt_TRIG(data_fig2,'T',2,0.1,2,0);
[~,NsymRf]=FuzzySampEnt_TRIG(data_fig2,'R',2,0.1,2,0);
[~,NsymIf]=FuzzySampEnt_TRIG(data_fig2,'I',2,0.1,2,0);
[~,NsymGf]=FuzzySampEnt_TRIG(data_fig2,'G',2,0.1,2,0);
[NsymTf NsymRf NsymIf NsymGf]
Nsym=(NsymTf+NsymRf+NsymIf+NsymGf)


[~,NsymTfc]=FuzzySampEnt_TRIG(data_fig2,'T',2,0.1,2,1);
[~,NsymRfc]=FuzzySampEnt_TRIG(data_fig2,'R',2,0.1,2,1);
[~,NsymIfc]=FuzzySampEnt_TRIG(data_fig2,'I',2,0.1,2,1);
[~,NsymGfc]=FuzzySampEnt_TRIG(data_fig2,'G',2,0.1,2,1);
[NsymTfc NsymRfc NsymIfc NsymGfc]
Nsym=(NsymTfc+NsymRfc+NsymIfc+NsymGfc)
