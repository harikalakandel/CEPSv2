
%data=xlsread('BA_a_25_1_EEG.xlsx');

data = load('RBA_B001_65_EDA_5.txt')

close all

y = detrend(data,2);
subplot(3,1,1)
plot(data,'color','blue')
subplot(3,1,2)
plot(y,'color','green')

subplot(3,1,3)

y1 = detrend(data,1,4000)

plot(y1,'color','red')