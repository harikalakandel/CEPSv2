function [FuzSampEn_trig,Nm]=FuzzySampEnt_TRIG(data,type,m,r,p,Centering)
%% Inputs: 
% data: data to be analyzed. Example: data=wfbm(0.5,1000);
% type: kind of isometry ('T': Translation, 'R': vertical Reflexion:, 'I': Inversion, 'G': Glide reflexion. 
% m: size of the pattern (m-motif). m must be >1.
% r: amplitude of the tolerance.
% p: power of the membership function. p=2 for gaussian function, p>1000 for rectangular function (classical case).
% Centering: Centering=1 for centered patterns and Centering=0 for non centered pattern (classical case)
% Output: Fuzzy sample entropy and number of similar m-pattern for a certain type of symmetry.
% Example:
% data=wfbm(0.5,1000);type='T';m=2;r=std(data)/10;p=1000; Centering=0;
% [FSE_T,N_T]=FuzzySampEnt_TRIG(data,type,m,r,p,Centering);
% Girault J.-M., Humeau-Heurtier A., "Centered and Averaged Fuzzy Entropy to Improve Fuzzy Entropy Precision", Entropy 2018, 20(4), 287.
% https://www.mdpi.com/1099-4300/20/4/287   
% - Author:       Jean-Marc Girault
% - Date:         07/07/2017 
if m>1
z=data(:);N=length(z);Nsfuz = zeros(m,N-m); n=0;
for k=m:m+1;
    Y=zeros(N-m,k);X=zeros(N-m,k); 
    for j=1:N-k+n    
       if Centering==0; Y(j,:)=z(j:j+k-1);
       else  Y(j,:)=z(j:j+k-1)-mean(z(j:j+k-1));
       end
    end
      switch type
        case 'T';X=Y;
        case 'R';X=fliplr(Y);
        case 'I';X=-fliplr(Y);
        case 'G';X=-Y;
    end   
    for j=1:N-k+n
        aux=repmat(Y(j,:),N-k+n,1);dist=max(abs(X-aux)');
        MSf=exp(-(dist/(r)).^p);[a,Pos]=find(MSf==1);%membership function
        Nsfuz(n+1,j)=sum(MSf)-length(find(Pos==j));
    end
    clear X Y
    n=n+1;
end
Nm=mean(Nsfuz(1,:))*(N-m);
 %% Calculation of the sample Entropy 
 FuzSampEn_trig=log(sum(Nsfuz(1,:))/sum(Nsfuz(2,:)));
else
    disp('m must be >1');FuzSampEn_trig=NaN;Nm=NaN;
end
