clear;close all;clc
epsilon=0.01;% epsilon is a tolerance require to test if 2 points are recurrent/similar in the PhaseSpaceSymPlot algorithm.
k=1;




%x1 = sawtooth(2*pi*f0*t,0.25);

x1 = load("ECG_BT_a_0_1_hrv.txt")




epsilon=0.01;Centering=0;display=1;m=2;
[SPt]=SymPlot_JMGi(x1,'G',m,epsilon,Centering,display);

RQA_t1 = rqa_marwan(SPt)


% 
% 
% clear;clc;close all;
% z=[-1 1 -1 1 -1 -1  1 1];
% %z=rand(1,100);
% % With m=1, we notice the presence of false recurrences
% m=1;
% [SPt1]=SymPlot_JMGi(z,'T',m,norm(z)/20,0,0);
% [SPr1]=SymPlot_JMGi(z,'R',m,norm(z)/20,0,0);
% [SPi1]=SymPlot_JMGi(z,'I',m,norm(z)/20,0,0);
% [SPg1]=SymPlot_JMGi(z,'G',m,norm(z)/20,0,0);
% 
% RQA_t1 = rqa_marwan(SPt1)



