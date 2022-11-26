% Symmetry plot calculated for a binary sequence with m ranging from 1 to 2
% z: binary sequence ogf length L
% Isometry: 'T','R', 'I', 'G';
% m: Size of the pattern analyzed
% M: maximal value of m, M<=L
% Tolerance: norm(z)/20
% Centering: 0 no centering
% Display: 0 no display

clear;clc;close all;
z=[-1 1 -1 1 -1 -1  1 1];
%z=rand(1,100);
% With m=1, we notice the presence of false recurrences
m=1;
[SPt1]=SymPlot_JMGi(z,'T',m,norm(z)/20,0,0);
[SPr1]=SymPlot_JMGi(z,'R',m,norm(z)/20,0,0);
[SPi1]=SymPlot_JMGi(z,'I',m,norm(z)/20,0,0);
[SPg1]=SymPlot_JMGi(z,'G',m,norm(z)/20,0,0);

RQA_t1 = rqa_marwan(SPt1)
RQA_r1 = rqa_marwan(imrotate(SPr1,90))
RQA_i1 = rqa_marwan(imrotate(SPi1,90))
RQA_g1 = rqa_marwan(SPg1)


% With m=2, false recurrences are removed.
m=2;

[SPt2]=SymPlot_JMGi(z,'T',m,norm(z)/20,0,0);
[SPr2]=SymPlot_JMGi(z,'R',m,norm(z)/20,0,0);
[SPi2]=SymPlot_JMGi(z,'I',m,norm(z)/20,0,0);
[SPg2]=SymPlot_JMGi(z,'G',m,norm(z)/20,0,0);

RQA_t2 = rqa_marwan(SPt2)
RQA_r2 = rqa_marwan(imrotate(SPr2,90))
RQA_i2 = rqa_marwan(imrotate(SPi2,90))
RQA_g2 = rqa_marwan(SPg2)

figure
subplot(311);stem(z,'ro-'); xlabel('time');ylabel('amplitude');xlim([1 8]);grid
title('Symmetry Recurrence Plot with a binary sequence')
subplot(345);spy(SPt1);axis xy;title('T, m=1');xlabel('time');ylabel('time')
subplot(346);spy(SPr1);axis xy;title('R, m=1');xlabel('time');ylabel('time')
subplot(347);spy(SPt2,'k');axis xy;title('T, m=2');xlabel('time');ylabel('time')
subplot(348);spy(SPr2,'k');axis xy;title('R, m=2');xlabel('time');ylabel('time')
subplot(349);spy(SPi1);axis xy;title('I, m=1');xlabel('time');ylabel('time')
subplot(3,4,10);spy(SPg1);axis xy;title('G, m=1');xlabel('time');ylabel('time')
subplot(3,4,11);spy(SPi2,'k');axis xy;title('I, m=2');xlabel('time');ylabel('time')
subplot(3,4,12);spy(SPg2,'k');axis xy;title('G, m=2');xlabel('time');ylabel('time')

