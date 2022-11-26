function [SP]=SymPlot_JMGi2D(x1,x2,type,m,r_factor1,r_factor2,Centering,display)
% Input variables: 
% signal - signal 
% type : 1->Translation, 2-> Reflection, 3->Inversion, 4-> Glide reflection
% m : size of the pattern (uplet)
% r_factor - factor of the criterion of similarity   r_factor*std(signal) 
%r_factor between 0.1*SD and 0.25*SD, where SD is the signal standard deviation
% Centering : Centering=1 leads to the centering of the pattern, otherwise nothing
% Output variables: 
% SP : Symetry plot 
% Example of display: spy(SP);axis xy;
%==================Example================================
% clear,clc
% r_factor1=0.1;
% x1=[0 1 2 3 2 1 0 1 2 3 2 1 0 1 2 3 2 1];
%m=2
% 

X=[];
N=length(signal);
    for k=1:N-m+1 
        %X(j,:)=signal(j:j+m-1); 
       if Centering==0; Y(k,:)=signal(k:k+m-1);else  Y(k,:)=signal(k:k+m-1)-mean(signal(k:k+m-1));end
        switch type
            case 'T';X(k,:)=(Y(k,:));
            case 'R';X(k,:)=fliplr(Y(k,:));
            case 'I';X(k,:)=-fliplr(Y(k,:));
            case 'G';X(k,:)=-(Y(k,:));
        end
        %X(k,:)=Y(k,:);
    end 
    SP=zeros(N-m+1,N-m+1);SPwsr=zeros(N-m+1,N-m+1);
    
    for j=1:N-m+1 
        %aux=repmat(X(j,:),N-m+1,1);
        if m==1
             aux=repmat(signal(j),N-m+1,1);
            %M(j,:)=(abs(signal'-aux));
            %M(j,:)=(abs(X-aux)); 
            Nrec=find(abs(X-aux) <= r_factor);
            SP(j,Nrec)=1;
           % Ind=find(Nrec~=j);% find self recurrence
           % Nc=Nrec(Ind);
           % SPwsr(j,Nc)=1; % Symmetry plot without self-recurrence
        else
            aux=repmat(Y(j,:),N-m+1,1);%
            %M(j,:)=max(abs(X-aux)'); 
             Nrec=find(max(abs(X-aux)')' <= r_factor);
          %  Ind=find(Nrec~=j); % find self recurrence
            %% Symmetry plot without self-recurrenceM=N-(m-1)
            %Nc=Nrec(Ind);
           % SPwsr(j,Nc)=1; % Symmetry plot without self-recurrence
            SP(j,Nrec)=1;
        end
      %  SPwsr=SP;
 
       % C(j)=length(Nc)/(N-m+1);
    end
    %if type=='T'; SPwsr=SP-eye(N-m+1);end %Symmetry plot without self-recurrence
    %SP_WSR=SPwsr;
    %RR=mean(mean(SPwsr));
    % SPwsr:Symmetry plot without self-recurrence
%M=N-(m-1);
% if type=='T';RRc=((RR*M-1)+2)/(M+1);end
% if type=='R';RRc=((RR*M-1)+2)/(M+1);end
% if type=='I';RRc=RR*M/(M+1);end
% if type=='G';RRc=RR*M/(M+1);end
 % RRc: RR corrected in order to count only the diagonal and the values below the diagonal

 if display==1; %figure;
     spy(SP);axis xy;end
 
 