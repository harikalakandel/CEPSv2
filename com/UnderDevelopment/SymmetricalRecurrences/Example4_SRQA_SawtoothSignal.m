% This algorithm measure the degree of similarity between 2 time series
clear;close all;clc
epsilon=0.01;% epsilon is a tolerance require to test if 2 points are recurrent/similar in the PhaseSpaceSymPlot algorithm.
k=1;

N=1000;
t = 0:1/(N-1):1;f0=4;


x1 = sawtooth(2*pi*f0*t,0.25);


epsilon=0.01;Centering=0;display=0;m=2;
[SPt]=SymPlot_JMGi(x1,'T',m,epsilon,Centering,display);
[SPr]=SymPlot_JMGi(x1,'R',m,epsilon,Centering,display);
[SPi]=SymPlot_JMGi(x1,'I',m,epsilon,Centering,display);
[SPg]=SymPlot_JMGi(x1,'G',m,epsilon,Centering,display);


for a=0:0.01:1;
    
    x2 = sawtooth(2*pi*f0*t+pi/2,a);
    [CSPt]=Cross2SymPlot_JMGi(x1,x2,'T',m,epsilon,Centering,display);
    [CSPr]=Cross2SymPlot_JMGi(x1,x2,'R',m,epsilon,Centering,display);
    [CSPi]=Cross2SymPlot_JMGi(x1,x2,'I',m,epsilon,Centering,display);
    [CSPg]=Cross2SymPlot_JMGi(x1,x2,'G',m,epsilon,Centering,display);

    % Calculation of the 4 kinds of Symmetrical RQA (T: Translation, R: Reflection, I: Inversion, G: Glide reflection ) as
    % suggested in J.-M. Girault, "Recurrence and symmetry of time series: Application to transition detection" Chaos, Solitons and Fractals 77(2015)11–28, http://dx.doi.org/10.1016/j.chaos.2015.04.010
    % RQA are calculated with the algorithm proposed by Marwan, N., Romano, M. C., Thiel, M., Kurths, J. (2007). Recurrence plots for the analysis of complex systems,Physics Reports, 438, 237-329. 
    % Marwan, N., Donges, J. F., Zou, Y., Donner, R. V., Kurths, J. (2009). Complex network approach for recurrence analysis of time series. Physics Letters A, 373, 4246-4254
    RQAT =rqa_marwan(CSPt);
    RQAR = rqa_marwan(CSPr);
    RQAI =rqa_marwan(CSPi);
    RQAG = rqa_marwan(CSPg);
    % Extraction of each feature
    RRt(k)=RQAT.RR;DETt(k)=RQAT.DET;Lmoyt(k)=RQAT.Lmoy;Lmaxt(k)=RQAT.Lmax;ENTRt(k)=RQAT.ENTR;LAMt(k)=RQAT.LAM;TTt(k)=RQAT.TT;
    Vmaxt(k)=RQAT.Vmax;RTmaxt(k)=RQAT.RTmax;T2t(k)=RQAT.T2;RTEt(k)=RQAT.RTE;Clustt(k)=RQAT.Clust;Transt(k)=RQAT.Trans;

    RRr(k)=RQAR.RR;DETr(k)=RQAR.DET;Lmoyr(k)=RQAR.Lmoy;Lmaxr(k)=RQAR.Lmax;ENTRr(k)=RQAR.ENTR;LAMr(k)=RQAR.LAM;TTr(k)=RQAR.TT;
    Vmaxr(k)=RQAR.Vmax;RTmaxr(k)=RQAR.RTmax;T2r(k)=RQAR.T2;RTEr(k)=RQAR.RTE;Clustr(k)=RQAR.Clust;Transr(k)=RQAR.Trans;

    RRi(k)=RQAI.RR;DETi(k)=RQAI.DET;Lmoyi(k)=RQAI.Lmoy;Lmaxi(k)=RQAI.Lmax;ENTRi(k)=RQAI.ENTR;LAMi(k)=RQAI.LAM;TTi(k)=RQAI.TT;
    Vmaxi(k)=RQAI.Vmax;RTmaxi(k)=RQAI.RTmax;T2i(k)=RQAI.T2;RTEi(k)=RQAI.RTE;Clusti(k)=RQAI.Clust;Transi(k)=RQAI.Trans;

    RRg(k)=RQAG.RR;DETg(k)=RQAG.DET;Lmoyg(k)=RQAG.Lmoy;Lmaxg(k)=RQAG.Lmax;ENTRg(k)=RQAG.ENTR;LAMg(k)=RQAG.LAM;TTg(k)=RQAG.TT;
    Vmaxg(k)=RQAG.Vmax;RTmaxg(k)=RQAG.RTmax;T2g(k)=RQAG.T2;RTEg(k)=RQAG.RTE;Clustg(k)=RQAG.Clust;Transg(k)=RQAG.Trans;

k=k+1
clear x2
end

save Test_Sawtooth

% Display each feature versus the control parameter a. Strong variations appear when a=0.847
a=0:0.01:1;
subplot(341);plot(a,RRt,a,RRr,a,RRi,a,RRg);title('RR');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
subplot(342);plot(a,DETt,a,DETr,a,DETi,a,DETg);title('DET');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
subplot(343);plot(a,Lmoyt,a,Lmoyr,a,Lmoyi,a,Lmoyg);title('Lmoy');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
subplot(344);plot(a,Lmaxt,a,Lmaxr,a,Lmaxi,a,Lmaxg);title('Lmax');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
subplot(345);plot(a,ENTRt,a,ENTRr,a,ENTRi,a,ENTRg);title('ENTR');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
subplot(346);plot(a,LAMt,a,LAMr,a,LAMi,a,LAMg);title('LAM');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
subplot(347);plot(a,TTt,a,TTr,a,TTi,a,TTg);title('TT');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
subplot(348);plot(a,Vmaxt,a,Vmaxr,a,Vmaxi,a,Vmaxg);title('Vmax');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
subplot(349);plot(a,RTmaxt,a,RTmaxr,a,RTmaxi,a,RTmaxg);title('RT');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
subplot(3,4,10);plot(a,T2t,a,T2r,a,T2i,a,T2g);title('T2');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
subplot(3,4,11);plot(a,RTEt,a,RTEr,a,RTEi,a,RTEg);title('RTE');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
subplot(3,4,12);plot(a,Clustt,a,Clustr,a,Clusti,a,Clustg);title('Clust');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
figure;plot(a,(Transt),a,(Transr),a,(Transi),a,(Transg));title('Trans');hold on;xline(0.5);xline(0.25);xline(0.75);legend('T','R','I','G');xlim([0 1] )
