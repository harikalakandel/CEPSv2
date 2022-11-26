clear
close all
warning off
for j=1:10
data = rand(90,1);

color={'r','g','b'};
%fig1=figure(1);
%fig2=figure(2);
hold on
for i=2:4
    [Fq1, Fq2] = getAlphaUsingFMFDFA(data,i);
    disp([i Fq1 Fq2]);
    disp('..........');
%     figure(fig1)
%     plot(Fq1,'color',color{i-1})
%     hold on
%     figure(fig2)
%     plot(Fq2,'color',color{i-1})
%     hold on
end
end