 x1 = randi([0 5],1,500); dim=3; tau=1; cluster=3; T=0.5; 
%FRP=frp(x1,dim,tau,cluster,T);

set(0,'DefaultFigureVisible','off');
E = fuzzyEntropy_frp(x1,dim,tau,cluster)
set(0,'DefaultFigureVisible','on');
%x2 = randi([0 255],1,500);
%FRP=frp(x2);