clear
%H=load('N_IBI_BM_b_10_5_hrv_e.txt');
H =[57    57    56    58    54    60    56    54    60    65]'
N = size(H,1);
%PI(n)5[H(n)2H(n11)]·100/H(n) for 1<=n<=N-1
PI=[H(1:end-1,1)-H(2:end,1)]*100./H(1:end-1,1);
%Tone.Tone is defined as a simple average ...
tone=(1/(N-1))*sum(PI)
%Frequencies (fi) are figured as a number oftimes that 
%PI(n) has a value in a range in whichiis an integer
startInteger = ceil(min(PI));
endInteger = ceil(max(PI)); 
f=[];
currIndex=1;
for i=startInteger:endInteger
     f=[f;sum([PI >i & PI <= (i+1)])];
     
end

%%{for test...
allInteger = [startInteger:endInteger]';
allInteger(f==0,:)=[];
%% for test }

%The calculation PI(n)=0 is omitted because it is neitheracceleration nor inhibition.]
f(f==0,:)=[];


p=f/sum(f);

disp('all')

[allInteger f p p.*log2(p)]

entropy = -sum(p.*log2(p))
 
 