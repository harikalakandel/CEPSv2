clear
close all
dataA = load('Signal_A.txt');

y=nan(20,1);
m=4;
for t=1:20
    y(t)=perm_min_entropy(dataA,m,t);
end

figure(10)
plot(y)
y