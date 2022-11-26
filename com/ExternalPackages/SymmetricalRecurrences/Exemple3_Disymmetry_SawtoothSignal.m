% This algorithim shows a mean to measure the similarity degree between 2
% signals : symmatrical sawteeth with a delay and disymmetrical sawteeth with a delay. 
clear,clc;close all

N=1000;
t = 0:1/(N-1):1;f0=4;
x1 = sawtooth(2*pi*f0*t,0.5);
x2 = sawtooth(2*pi*f0*t+pi/3,0.5);

epsilon=0.01;Centering=0;display=0;m=2;
[SPt]=SymPlot_JMGi(x1,'T',m,epsilon,Centering,display);
[SPr]=SymPlot_JMGi(x1,'R',m,epsilon,Centering,display);
[SPi]=SymPlot_JMGi(x1,'I',m,epsilon,Centering,display);
[SPg]=SymPlot_JMGi(x1,'G',m,epsilon,Centering,display);

figure
subplot(6,2,1);plot(t,x1);title('Sym. Rec. Plots from a symmetric sawtooth')
subplot(6,4,5);spy(SPt);axis xy;title('T')
subplot(6,4,6);spy(SPr);axis xy;title('R')
subplot(6,4,9);spy(SPi);axis xy;title('I')
subplot(6,4,10);spy(SPg);axis xy;title('G')

epsilon=0.01;Centering=0;display=0;m=2;
[CSPt]=Cross2SymPlot_JMGi(x1,x2,'T',m,epsilon,Centering,display);
[CSPr]=Cross2SymPlot_JMGi(x1,x2,'R',m,epsilon,Centering,display);
[CSPi]=Cross2SymPlot_JMGi(x1,x2,'I',m,epsilon,Centering,display);
[CSPg]=Cross2SymPlot_JMGi(x1,x2,'G',m,epsilon,Centering,display);

subplot(6,2,2);plot(t,x1,t,x2);title('Cross Sym. Rec. Plots from symmetric sawteeth')
subplot(6,4,7);spy(CSPt);axis xy;title('T')
subplot(6,4,8);spy(CSPr);axis xy;title('R')
subplot(6,4,11);spy(CSPi);axis xy;title('I')
subplot(6,4,12);spy(CSPg);axis xy;title('G')

%%
clear,clc;

N=1000;
t = 0:1/(N-1):1;
f0=4;
x1 = sawtooth(2*pi*f0*t,0.25);
x2 = sawtooth(2*pi*f0*t+pi/3,0.5);

epsilon=0.01;Centering=0;display=0;m=2;
[SPt]=SymPlot_JMGi(x1,'T',m,epsilon,Centering,display);
[SPr]=SymPlot_JMGi(x1,'R',m,epsilon,Centering,display);
[SPi]=SymPlot_JMGi(x1,'I',m,epsilon,Centering,display);
[SPg]=SymPlot_JMGi(x1,'G',m,epsilon,Centering,display);

subplot(6,2,7);plot(t,x1);title('Sym. Rec. Plots from a disymmetric sawtooth')
subplot(6,4,17);spy(SPt);axis xy;title('T')
subplot(6,4,18);spy(SPr);axis xy;title('R')
subplot(6,4,21);spy(SPi);axis xy;title('I')
subplot(6,4,22);spy(SPg);axis xy;title('G')

epsilon=0.01;Centering=0;display=0;m=2;
[CSPt]=Cross2SymPlot_JMGi(x1,x2,'T',m,epsilon,Centering,display);
[CSPr]=Cross2SymPlot_JMGi(x1,x2,'R',m,epsilon,Centering,display);
[CSPi]=Cross2SymPlot_JMGi(x1,x2,'I',m,epsilon,Centering,display);
[CSPg]=Cross2SymPlot_JMGi(x1,x2,'G',m,epsilon,Centering,display);

subplot(6,2,8);plot(t,x1,t,x2);title('Cross Sym. Rec. Plots from disymmetric sawteeth')
subplot(6,4,19);spy(CSPt);axis xy;title('T')
subplot(6,4,20);spy(CSPr);axis xy;title('R')
subplot(6,4,23);spy(CSPi);axis xy;title('I')
subplot(6,4,24);spy(CSPg);axis xy;title('G')




