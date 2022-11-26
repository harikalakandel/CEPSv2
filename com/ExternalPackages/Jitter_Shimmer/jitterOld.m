function [jitta,jitt,RAP,PPQ5]=jitterOld(T)
% load('jittervalores.mat')
%T=subject1;

% jitta and jitt
N=length(T);    % nº of periods
Ti=T(1:end-1);
T1=T(2:end);
MT=mean(T);         % Average periods
jitta=mae(T1-Ti),   % [s]
%jitta2=sum(abs(T1-Ti))/(N-1),
jitt=(jitta/MT)*100; % [%]

%RAP
vetor3=zeros(N-2,1);
for i=1:N-2
    md3=sum(T(i:i+2))/3;
    vetor3(i)=abs(T(i+1)-md3);
end
RAP=sum(vetor3)/(N-2)/MT*100;

%ppq5
vetor5=zeros(N-4,1);
for i=1:N-4
    md5=sum(T(i:i+4))/5;
    vetor5(i)=abs(T(i+2)-md5);
end
PPQ5=sum(vetor5)/(N-4)/MT*100;