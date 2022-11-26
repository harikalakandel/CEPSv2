
data=xlsread('BA_a_25_1_EEG.csv');
currSum=data(1,1);
for i=2:size(data,1)
    currSum = currSum+data(i,1);
    data(i,1)=currSum;
end

x=data(:,2);




desiredFs =  size(data,1)/data(end,1);% 1052*10;  %?????
sampleFs = desiredFs;
figure(1)

subplot(4,1,1)
[y, Ty] = resample(x, data(:,1),desiredFs);
%[y, Ty] = resample(y,Ty,desiredFs/5);
plot(data(:,1),x,'.-',Ty,y,'-');
legend('Original','Resampled');
%ylim([-1.2 1.2])

disp([size(x) size(y)]);

newDesiredFs = 5000;


subplot(4,1,2)








[ySmoothNew, TySmoothNew] = resample(x,data(:,1),newDesiredFs);
%[ySmooth, TySmooth] = resample(ySmooth,TySmooth,desiredFs/SMOOTHING_FACTOR);
plot(data(:,1),x,'.-',TySmoothNew,ySmoothNew,'-');
legend('Original','new DFs');


subplot(4,1,3);
[ySpine, TySpine] = resample(x, data(:,1),desiredFs,'spline');
plot(data(:,1),x,'.-','color','blue');
hold on
plot(Ty,y,'.-',TySpine,ySpine,'-');
legend('Original','Resampled','Using Spine');

disp('Square Absolute Error');



info = strcat(' Resampled Error ',num2str(error),'Smoothing Resample Error ',num2str(errorSmooth))
xlabel(info)
%%smoothing




subplot(4,1,4);



% resample and plot the response
[y,ty] = resample(data(:,2),data(:,1),desiredFs,'spline',p,q,lpFilt);



plot(data(:,1),data(:,2),'.')
hold on
plot(ty,y)
hold off
xlabel('time')
ylabel('RPM')
legend('Original','Resampled (custom filter)','Location','best')


