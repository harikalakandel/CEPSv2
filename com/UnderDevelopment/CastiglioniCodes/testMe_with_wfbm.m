%To check your Matlab version of the code, I suggest that you run it on fractional Brownian motions with known fractal dimensions. 
%In my paper, I generated random fractals with the wfbm(H,n) Matlab function, where n is the length of the series and H the Hurst exponent, 
%which is related to FD by FD=2-H. 
clear
n=100;
result1=nan(11,1);
result2=nan(11,1);
result3=nan(11,1);
nIndex = 1;
nList = [100,1000,10000];
for nIndex=1:size(nList,2)
    n=nList(1,nIndex);
    for i=0:10
        H=i/10;
        ans1=nan(100,1);
        ans2=nan(100,1);
        ans3=nan(100,1);
        for k=1:100
            data = wfbm(H,n);

           
           
           ans1(k)=FD_C(data,n);
           ans2(k)=FD_M(data,n);    
           ans3(k)=SevickFD(data');

        end
        result1(i+1,nIndex)=mean(ans1);
        result2(i+1,nIndex)=mean(ans2);
        result3(i+1,nIndex)=mean(ans3);
    end
   
end
[[0:0.1:1]' result1 result2 result3]

figure(1)
subplot(3,1,1)
plot([1:0.1:2],result1,'*')
hold on
plot([1:0.1:2],result1)
title('FD_c')


subplot(3,1,2)
plot([1:0.1:2],result2,'*')
hold on
plot([1:0.1:2],result2)
title('FD_m')

subplot(3,1,3)
plot([1:0.1:2],result3,'*')
hold on
plot([1:0.1:2],result3)
title('FD_s')





legend('n=100','n=1000','n=10000')



