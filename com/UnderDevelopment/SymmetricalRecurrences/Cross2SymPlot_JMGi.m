function [SP]=Cross2SymPlot_JMGi(x1,x2,type,m,epsilon,Centering,display)
% Input variables: 
% x1 - x1 
% type : 1->Translation, 2-> Reflection, 3->Inversion, 4-> Glide reflection
% m : size of the pattern (uplet)
% epsilon - factor of the criterion of similarity   r_factor*std(x1) 
% epsilon between 0.1*SD and 0.25*SD, where SD is the x1 standard deviation
% Centering : Centering=1 leads to the centering of the pattern, otherwise nothing
% Output variables: 
% SP : Symetry plot 
% Example of display: spy(SP);axis xy;
%==================Example================================
% clear,clc
%x1=[0 1 2 1 0 -1 -2 -1 0 1 2];epsilon=0.01;
%x2=[2 1 0 -1 -2 -1 0 1 2 1 0];
%x1=[1 1 -1 -1 1 1 -1 -1];epsilon=0.01;Centering=0;type='T';
%x2=[1 1 -1 -1 -1 -1 1 1];
%m=2
% 

X1=[];
N=length(x1);
    for k=1:N-m+1 
       if Centering==0;
           Y1(k,:)=x1(k:k+m-1);X2(k,:)=x2(k:k+m-1);
       else  Y1(k,:)=x1(k:k+m-1)-mean(x1(k:k+m-1));X2(k,:)=x2(k:k+m-1)-mean(x2(k:k+m-1));
       end
        switch type
            case 'T';X1(k,:)=(Y1(k,:));
            case 'R';X1(k,:)=fliplr(Y1(k,:));
            case 'I';X1(k,:)=-fliplr(Y1(k,:));
            case 'G';X1(k,:)=-(Y1(k,:));
        end
    end 
    SP=zeros(N-m+1,N-m+1);
    
    for j=1:N-m+1 
        if m==1
            aux=repmat(x2(j),N-m+1,1);
            Nrec=find(abs(X1-aux) <= epsilon);
            SP(j,Nrec)=1;
        else
            aux=repmat(X2(j,:),N-m+1,1);%
             Nrec=find(max(abs(X1-aux)')' <= epsilon);
            SP(j,Nrec)=1;
        end
    end

 if display==1; %figure;
     spy(SP);axis xy;end
 
 