function [Shim,ShdB,apq3,apq5]=Shimmer(A)

% load('shimmervalores.mat');
% A=subject1sh;

N=length(A);    % Length A
MA=mean(A);     % Mean Amplitude
Shim=sum(abs(A(2:end)-A(1:end-1)))/(N-1)/MA*100;
ShdB=sum(abs(20*log10(A(2:end)./A(1:end-1))))/(N-1);

%apq3
vetor3=zeros(N-2,1);
for i=1:N-2
    md3=sum(A(i:i+2))/3;
    vetor3(i)=abs(A(i+1)-md3);
end
apq3=sum(vetor3)/(N-2)/MA*100;
%apq5
vetor5=zeros(N-4,1);
for i=1:N-4
    md5=sum(A(i:i+4))/5;
    vetor5(i)=abs(A(i+2)-md5);
end
apq5=sum(vetor5)/(N-4)/MA*100;

end




