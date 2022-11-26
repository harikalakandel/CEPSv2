x = sort(unique(randi(50,1,10)));
y = randi(10,1,length(x));
xi = linspace(0,max(x),15);
yi = interp1(x,y,xi,'linear');
figure(1)
subplot(2,1,1)
plot(x,y,'-*b')
hold on
plot(xi,yi,'pr')
hold off
grid
legend('Original','Interpolated')


return
Vq = interpn(y,2) 
for i=2:size(x,2)
    start = x(i-1);
    endTime = x(i);

end

xi = linspace(0,max(x),15/2);
yi = interp1(x,y,xi,'liner');
subplot(2,1,2)
plot(x,y,'-','color','blue')
hold on
plot(xi,yi,'-','color','red')
hold off
grid
legend('Original','Interpolated')