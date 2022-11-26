data1=load('Bio_BR_b_10_1_RRi.txt')
data2=load('Bio_CZ_c_80_1.txt')

%data1=(data1-mean(data1))./(max(data1)-min(data1));
%data2=(data2-mean(data2))./(max(data2)-min(data2));


 [Shim,ShdB,apq3,apq5]=Shimmer(data1);

  [Shim1,ShdB1,apq31,apq51]=Shimmer(data2);

disp('Shim,ShdB,apq3,apq5')
[Shim,ShdB,apq3,apq5;Shim1,ShdB1,apq31,apq51]

%%  Results

% Shim,ShdB,apq3,apq5
% 
% ans =
% 
%     4.6903    0.4095    1.4506    3.0142
%     4.1471    0.3613    1.7983    3.0692


%%%