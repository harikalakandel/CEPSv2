%To check your Matlab version of the code, I suggest that you run it on fractional Brownian motions with known fractal dimensions. 
%In my paper, I generated random fractals with the wfbm(H,n) Matlab function, where n is the length of the series and H the Hurst exponent, 
%which is related to FD by FD=2-H. 
clear
n=100;
results=nan(11,3);
for i=0:10
    H=i/10;
    ans=nan(100,3);
    for k=1:100
        data = wfbm(H,n);

        ans(k,1)=FD_C(data,n);
        ans(k,2)=FD_M(data,n);    
        ans(k,3)=FM_M(data,n);
    end
    results(i+1,:)=mean(ans,1);
end
[[0:0.1:1]' results]



