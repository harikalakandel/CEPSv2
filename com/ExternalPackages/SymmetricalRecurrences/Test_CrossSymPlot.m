

clear,clc;close all

%x1=[1 1 -1 -1 -1 -1 1 1];%x2=x1;
%x2=[-1 -1 1 1 1 1 -1 -1];
x1=[0 1 2 1 0 -1 -2 -1 0 1 2 1 0 -1 -2 -1 0];
x2=[2 1 0 -1 -2 -1 0 1 2 1 0  -1 -2 -1 0 1 2 ];

figure
subplot(222);plot(x1,x2)
subplot(221);plot(x1,1:length(x1));ylim([1 length(x1)])
subplot(224);plot(1:length(x2),x2);xlim([1 length(x2)])

epsilon=0.01;Centering=0;display=0;m=2;
[SPt]=SymPlot_JMGi(x1,'T',m,epsilon,Centering,display);
[SPr]=SymPlot_JMGi(x1,'R',m,epsilon,Centering,display);
[SPi]=SymPlot_JMGi(x1,'I',m,epsilon,Centering,display);
[SPg]=SymPlot_JMGi(x1,'G',m,epsilon,Centering,display);


figure
subplot(311);plot(x1,'.-');xlim([1 length(x1)])
subplot(323);spy(SPt);axis xy;
subplot(324);spy(SPr);axis xy;
subplot(325);spy(SPi);axis xy;
subplot(326);spy(SPg);axis xy;

epsilon=0.01;Centering=0;display=0;m=2;
[CSPt]=Cross2SymPlot_JMGi(x1,x2,'T',m,epsilon,Centering,display);
[CSPr]=Cross2SymPlot_JMGi(x1,x2,'R',m,epsilon,Centering,display);
[CSPi]=Cross2SymPlot_JMGi(x1,x2,'I',m,epsilon,Centering,display);
[CSPg]=Cross2SymPlot_JMGi(x1,x2,'G',m,epsilon,Centering,display);


figure
subplot(311);plot(x1,'.-');hold on;plot(x2,'.-r');;xlim([1 length(x1)])
subplot(323);spy(CSPt);axis xy;
subplot(324);spy(CSPr);axis xy;
subplot(325);spy(CSPi);axis xy;
subplot(326);spy(CSPg);axis xy;


PSSPs=PhaseSpaceSymPlot(x1,x2,'S',epsilon,epsilon);
PSSPo=PhaseSpaceSymPlot(x1,x2,'O',epsilon,epsilon);
PSSPv=PhaseSpaceSymPlot(x1,x2,'V',epsilon,epsilon);
PSSPh=PhaseSpaceSymPlot(x1,x2,'H',epsilon,epsilon);



figure
subplot(311);plot(x1,'.-');hold on;plot(x2,'.-r');;xlim([1 length(x1)])
subplot(323);spy(PSSPs);axis xy;
subplot(324);spy(PSSPo);axis xy;
subplot(325);spy(PSSPv);axis xy;
subplot(326);spy(PSSPh);axis xy;


PSSPs1=PhaseSpaceSymPlot(x1,x1,'S',epsilon,epsilon);
PSSPo1=PhaseSpaceSymPlot(x1,x1,'O',epsilon,epsilon);
PSSPh1=PhaseSpaceSymPlot(x1,x1,'H',epsilon,epsilon);
PSSPv1=PhaseSpaceSymPlot(x1,x1,'V',epsilon,epsilon);


figure
subplot(311);plot(x1);
subplot(323);spy(PSSPs1);axis xy;
subplot(324);spy(PSSPo1);axis xy;
subplot(325);spy(PSSPh1);axis xy;
subplot(326);spy(PSSPv1);axis xy;
