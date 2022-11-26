function [result] = getNonLinearityGCM(data)
%% code from Bernaola-Galván’s MATLAB 
% % %reads 1 column file with RR data
% %  
% % fileID=fopen('test.dat');
% %  
% % c=textscan(fileID,'%f');
% % fclose(fileID);
% %  
%calculates the series of increments
dat=diff(data);
fprintf('series of Increments') ;
disp(dat')
ndata=numel(dat);

% adds a small incremental noise to avoid
% repeated values (due to the sampling of RR)
noise(:,1)=(1:ndata)*1e-12;
dat=dat+noise;
fprintf('Data with noise')
disp(dat')
 
% Obtains a gaussian series with the same ordering
[dat,ind] = sort(dat);
dat(ind)=icdf('Normal',([1:ndata]-0.5d0)/ndata,0,1);
fprintf('gaussian series with the same ordering')
disp(dat')

%% ????? not sure why Lmax is 20
Lmax=20;
%% ?? not sure why Nexper is 10000
Nexper=10000;
 
%fprintf(1,'# of data: %d\n',ndata)
 
% Computes the distance for the signal
dist0=DeltaC(dat,Lmax);

fprintf('Distance for the signal...')
disp(dist0');
 
% Generates Nexper # of linear surrogates
% and computes DeltaC for each one
% to obtain p-value
pval(1:Lmax)=0;
med=0*dist0;
for i=1:Nexper
    
%      fprintf('Loop %d',i)
%      fprintf('Calculating lindat using function shuffle_ph')
     lindat=shuffle_ph(dat);
     dist=DeltaC(lindat,Lmax);
%      fprintf('Delta C with inputs:::')
%      fprintf('Lindata :')
     %disp(lindat)
     
     med=med+dist;
     %fprintf(1,'%d\t%f\t%f\n',i,dist(1),dist0(1))
 
     % Increases pvalue every time the value of dist
     % is larger in the surrogate
     for j=1:Lmax
         if dist(j)>dist0(j)
             pval(j)=pval(j)+1;
         end
     end
end
 
%divide by Nexper to obtain probability (p-value)
pval=pval/Nexper;

fprintf('Probabiltiy p-value')
disp(pval)
 
 
med=med/Nexper;

fprintf('Med value....')
disp(med')
 
result(:,1)=dist0;
result(:,2)=pval;
result(:,3)=med;
 
 
end


 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
function delta = DeltaC(x,Lmax)
   c=xcov(x,Lmax,'coeff');
   cm=xcov(abs(x),Lmax,'coeff');
   %we only get lags form 1..Lmax (discard negative and zero lags)
   i=Lmax+2;
   j=2*Lmax+1;
   delta=(cm(i:j)-cmod_teor(c(i:j))).^2;
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
function ct = cmod_teor(c)
   ct=(c+2*(sqrt(1-c.^2)-c.*acos(c))/pi-2/pi)/(1-2/pi);
   
end
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
function xlin = shuffle_ph(x)
   %fprintf('Calculating shuffle_ph of x')
   %randomizes Fourier phases
   n=numel(x);
   m=floor(n/2);
   xft=fft(x);
%    fprintf('fft of x is ')
%    disp(xft)
%    fprintf('Absolute of fft is ')
   %%% ????? 
   %%  get imaginary in fft(x) 
   %%  to remove imaginary part we take only absolute of fft(x)
   %%% ?????
   xft = abs(xft);
%    fprintf('Absolute of fft is ')
%    disp(xft)
   ph=angle(xft);
   S=abs(xft);
   linph=ph; %position 1 is not modified
   if mod(n,2) == 0
       linph(2:m)=random('Uniform',-pi,pi,m-1,1);  %ph(2:m);
       linph(m+1)=ph(m+1); %not needed
       linph(n:-1:m+2)=-linph(2:m);
   else
       linph(2:m+1)=random('Uniform',-pi,pi,m,1); %ph(2:m+1);
       linph(n:-1:m+2)=-linph(2:m+1);
   end
   xlin=ifft(S.*(cos(linph)+1i*sin(linph)));
end

