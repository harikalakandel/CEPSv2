%data=load('N_IBI_BM_b_10_5_hrv_e.txt');
clear
data =[57    57    56    58    54    60    56    54    60    65]'



scale=2;
Lag=1;

NN = floor(size(data,1)/scale);

RR = [];

for i=1:NN
    startIndex = (i-1)*scale+1;
    endIndex = i*scale;
    RR=[RR ;mean(data(startIndex:endIndex,1))];
end





N = size(RR,1);


%PI(n)5[H(n)2H(n11)]·100/H(n) for 1<=n<=N-1
PI=[RR(1:end-Lag,1)-RR(Lag+1:end,1)]*100./RR(1:end-Lag,1);
%Tone.Tone is defined as a simple average ...
tone=(1/(N-Lag))*sum(PI)
%Frequencies (fi) are figured as a number oftimes that 
%PI(n) has a value in a range in whichiis an integer
startInteger = ceil(min(PI));
endInteger = ceil(max(PI)); 
p=[];
currIndex=1;
for i=startInteger:endInteger
     p=[p;sum([PI >i & PI <= (i+1)])];
     
end

%%{for test...
allInteger = [startInteger:endInteger]';
allInteger(p==0,:)=[];
%% for test }

%The calculation PI(n)=0 is omitted because it is neitheracceleration nor inhibition.]
p(p==0,:)=[];


pp=p./sum(p);
disp(['p           log2(p)'])
[ pp pp.*log2(pp)]

entropy = -sum(pp.*log2(pp))
 
 