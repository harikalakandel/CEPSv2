%data=xlsread('BA_a_25_1_EEG.xlsx');
% dataOrg = data;
% currSum=data(1,1);
% for i=2:size(data,1)
%     currSum = currSum+data(i,1);
%     data(i,1)=currSum;
% end

figure(1)
subplot(2,1,1)
plot(data(:,1),data(:,2));

interval = data(end,1)/size(data,1);
equTime = [interval:interval:size(data(end,1))]'


%x = sort(unique(randi(50,1,10)));
x=data(:,1)
%y = randi(10,1,length(x));
y = data(:,2)
%xi = linspace(0,max(x),15);
xi=equTime;
yi = interp1(x,y,xi,'linear');
subplot(2,1,2)
plot(x,y,'-*b')
hold on
plot(xi,yi,'pr')
hold off
grid
legend('Original','Interpolated')