function [entropies,Tones] = getMultiLagToneEntropy_Karm(RR,LagM)
%RR=load('N_IBI_BM_b_10_5_hrv_e.txt');
%H =[57    57    56    58    54    60    56    54    60    65]'
N = size(RR,1);
entropies=[];
Tones=[];
for Lag=1:LagM
  
    %PI(n)5[H(n)2H(n11)]·100/H(n) for 1<=n<=N-1
    PI=[RR(1:end-Lag,1)-RR(Lag+1:end,1)]*100./RR(1:end-Lag,1);
    %Tone.Tone is defined as a simple average ...
    tone=(1/(N-Lag))*sum(PI)
    Tones = [Tones tone];
    %Frequencies (fi) are figured as a number oftimes that 
    %PI(n) has a value in a range in whichiis an integer
    startInteger = floor(min(PI));
    endInteger = ceil(max(PI)); 
    p=[];
%     currIndex=1;
%     for i=startInteger:endInteger
%          p=[p;sum([PI >i & PI <= (i+1)])];
% 
%     end

    currIndex=1;

    for i=startInteger:endInteger
        if currIndex==1
            p=[p;sum([PI >=i & PI <= (i+1)])];
            currIndex=currIndex+1;
        else
            p=[p;sum([PI >i & PI <= (i+1)])];
        end

    end

    %%{for test...
    allInteger = [startInteger:endInteger]';
    allInteger(p==0,:)=[];
    %% for test }

    %The calculation PI(n)=0 is omitted because it is neitheracceleration nor inhibition.]
    p(p==0,:)=[];


    pp=p/sum(p);

    %[allInteger f p p.*log2(p)]

    entropies = [entropies -sum(pp.*log2(pp))];
end
 
 
end

