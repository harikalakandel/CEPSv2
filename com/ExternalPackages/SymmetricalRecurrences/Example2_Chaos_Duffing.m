%% From the following reference "A. BenTal Physica D 171 (2002) 236-248", it is possible to show the interest of calculating indicators/features 
%% derived from the Symmetrical Recurrence Quantification Analysis proposed in J.-M. Girault, 
%"Recurrence and symmetry of time series: Application to transition detection" Chaos, Solitons and Fractals 77(2015)11–28 .
% The system under study is the Duffing system allowing the generation of new symmetries. 
% The regime change appears at a=0.847, i.e passing from a system generating 1 scroll to a system with 2 scrolls:
%  --        --  --
% |  |  ==> |  ||  |
%  --        --  --
% Written by J.-M. Girault, jean-marc.girault@eseo.fr
clear;close all;clc
epsilon=0.01;% epsilon is a tolerance require to test if 2 points are recurrent/similar in the PhaseSpaceSymPlot algorithm.
k=1;
% Global variable required for the Duffing system
global mu c beta a omega
mu=10;c=100;beta=1;omega=3.5;M=20;
% Here, the control parameter is a ranging from 0.840 to 0.856

for a=0.840:0.001:0.856;
    % Generation of signal from the Duffing system
    [t,Out]=ode45(@duffing,0:2*pi/omega/M:200*2*pi/omega,[0 0]);
    % Display the 2D phase space of the Duffing system
    figure(1);subplot(221);plot(Out(:,1));subplot(223);plot(Out(:,2))
    subplot(122);plot(Out(:,1),Out(:,2));pause(0.1)
    % Calculation of the 4 symmetry Plots from the 2D phase space
    RPpsS=PhaseSpaceSymPlot(Out(:,1)',Out(:,2)','S',epsilon,epsilon);
    RPpsO=PhaseSpaceSymPlot(Out(:,1)',Out(:,2)','O',epsilon,epsilon);
    RPpsV=PhaseSpaceSymPlot(Out(:,1)',Out(:,2)','V',epsilon,epsilon);
    RPpsH=PhaseSpaceSymPlot(Out(:,1)',Out(:,2)','H',epsilon,epsilon);
    % Display the 4 symmetry Plots
    figure(2);subplot(311);plot(Out(:,1),Out(:,2));
    subplot(323);spy(RPpsS);axis xy;
    subplot(324);spy(RPpsO);axis xy;
    subplot(325);spy(RPpsV);axis xy;
    subplot(326);spy(RPpsH);axis xy;pause(0.1);
    % Calculation of the 4 kinds of Symmetrical RQA (S: simple, O: Opposite, V: Vertical, H: Horizontal) as
    % suggested in J.-M. Girault, "Recurrence and symmetry of time series: Application to transition detection" Chaos, Solitons and Fractals 77(2015)11–28, http://dx.doi.org/10.1016/j.chaos.2015.04.010
    % RQA are calculated with the algorithm proposed by Marwan, N., Romano, M. C., Thiel, M., Kurths, J. (2007). Recurrence plots for the analysis of complex systems,Physics Reports, 438, 237-329. 
    % Marwan, N., Donges, J. F., Zou, Y., Donner, R. V., Kurths, J. (2009). Complex network approach for recurrence analysis of time series. Physics Letters A, 373, 4246-4254
    RQAS =rqa_marwan(RPpsS);
    RQAO = rqa_marwan(RPpsO);
    RQAV =rqa_marwan(RPpsV);
    RQAH = rqa_marwan(RPpsH);
    % Extraction of each feature
    RRs(k)=RQAS.RR;DETs(k)=RQAS.DET;Lmoys(k)=RQAS.Lmoy;Lmaxs(k)=RQAS.Lmax;ENTRs(k)=RQAS.ENTR;LAMs(k)=RQAS.LAM;TTs(k)=RQAS.TT;
    Vmaxs(k)=RQAS.Vmax;RTmaxs(k)=RQAS.RTmax;T2s(k)=RQAS.T2;RTEs(k)=RQAS.RTE;Clusts(k)=RQAS.Clust;Transs(k)=RQAS.Trans;

    RRo(k)=RQAO.RR;DETo(k)=RQAO.DET;Lmoyo(k)=RQAO.Lmoy;Lmaxo(k)=RQAO.Lmax;ENTRo(k)=RQAO.ENTR;LAMo(k)=RQAO.LAM;TTo(k)=RQAO.TT;
    Vmaxo(k)=RQAO.Vmax;RTmaxo(k)=RQAO.RTmax;T2o(k)=RQAO.T2;RTEo(k)=RQAO.RTE;Clusto(k)=RQAO.Clust;Transo(k)=RQAO.Trans;

    RRv(k)=RQAV.RR;DETv(k)=RQAV.DET;Lmoyv(k)=RQAV.Lmoy;Lmaxv(k)=RQAV.Lmax;ENTRv(k)=RQAV.ENTR;LAMv(k)=RQAV.LAM;TTv(k)=RQAV.TT;
    Vmaxv(k)=RQAV.Vmax;RTmaxv(k)=RQAV.RTmax;T2v(k)=RQAV.T2;RTEv(k)=RQAV.RTE;Clustv(k)=RQAV.Clust;Transv(k)=RQAV.Trans;

    RRh(k)=RQAH.RR;DETh(k)=RQAH.DET;Lmoyh(k)=RQAH.Lmoy;Lmaxh(k)=RQAH.Lmax;ENTRh(k)=RQAH.ENTR;LAMh(k)=RQAH.LAM;TTh(k)=RQAH.TT;
    Vmaxh(k)=RQAH.Vmax;RTmaxh(k)=RQAH.RTmax;T2h(k)=RQAH.T2;RTEh(k)=RQAH.RTE;Clusth(k)=RQAH.Clust;Transh(k)=RQAH.Trans;

k=k+1
clear t Out
end

save Test_Duffing_System

% Display each feature versus the control parameter a. Strong variations appear when a=0.847
a=0.840:0.001:0.856;
subplot(341);plot(a,RRs,a,RRo,a,RRv,a,RRh);title('RR');hold on;xline(0.847);legend('S','O','V','H');xlim([0.840 0.856] )
subplot(342);plot(a,DETs,a,10*DETo,a,10*DETv,a,DETh);title('DET');hold on;xline(0.847);legend('S','10 x O','10 x V','H');xlim([0.840 0.856] )
subplot(343);plot(a,Lmoys,a,Lmoyo,a,Lmoyv,a,Lmoyh);title('Lmoy');hold on;xline(0.847);legend('S','O','V','H');xlim([0.840 0.856] )
subplot(344);plot(a,Lmaxs,a,20*Lmaxo,a,20*Lmaxv,a,Lmaxh);title('Lmax');hold on;xline(0.847);legend('S','20 x O','20 x V','H');xlim([0.840 0.856] )
subplot(345);plot(a,ENTRs,a,10*ENTRo,a,10*ENTRv,a,ENTRh);title('ENTR');hold on;xline(0.847);legend('S','10 x O','10 x V','H');xlim([0.840 0.856] )
subplot(346);plot(a,LAMs,a,LAMo,a,LAMv,a,LAMh);title('LAM');hold on;xline(0.847);legend('S','O','V','H');xlim([0.840 0.856] )
subplot(347);plot(a,TTs,a,TTo,a,TTv,a,TTh);title('TT');hold on;xline(0.847);legend('S','O','V','H');xlim([0.840 0.856] )
subplot(348);plot(a,Vmaxs,a,Vmaxo,a,Vmaxv,a,Vmaxh);title('Vmax');hold on;xline(0.847);legend('S','O','V','H');xlim([0.840 0.856] )
subplot(349);plot(a,RTmaxs,a,RTmaxo,a,RTmaxv,a,RTmaxh);title('RT');hold on;xline(0.847);legend('S','O','V','H');xlim([0.840 0.856] )
subplot(3,4,10);plot(a,T2s,a,T2o,a,T2v,a,T2h);title('T2');hold on;xline(0.847);legend('S','O','V','H');xlim([0.840 0.856] )
subplot(3,4,11);plot(a,RTEs,a,RTEo,a,RTEv,a,RTEh);title('RTE');hold on;xline(0.847);legend('S','O','V','H');xlim([0.840 0.856] )
subplot(3,4,12);plot(a,Clusts,a,Clusto,a,Clustv,a,Clusth);title('Clust');hold on;xline(0.847);legend('S','O','V','H');xlim([0.840 0.856] )
figure;plot(a,(Transs),a,10*(Transo),a,2*(Transv),a,20*(Transh));title('Trans');hold on;xline(0.847);legend('S','10 x O','2 x V','20 x H');xlim([0.840 0.856] )
