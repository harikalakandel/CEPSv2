%% testing with the example in paper from Cuesta-Frau 2020 .....
%generate random data points 
x=[-0.45, 1.9, 0.87, -0.91, 2.3, 1.1, 0.75, 1.3, -1.6, 0.47, -0.15, 0.65, 0.55, -1.1, 0.3];
%% embeded dimension
m=3;
%% get the bubble Entropy
printInfo = true %% for test case
getBubbleEn(x,m,printInfo)