%Definition of the parameters
%total iterations
timetot=10^6;
%quantile for Peak over threshold
quanti=0.99;
%we compute the correlation dimension over several trajectories
for traj=1:100
    %initialization of variables
    x1=ones(1,timetot);
    x2=ones(1,timetot);
    %We need a pair of trajectories x1 x2. Set the initial condition as random:
    x1(1)=rand;
    x2(1)=rand;
    %This for loop produces the trajectories
    for t=2:timetot
        x1(t)=mod(3*x1(t-1),1);
        x2(t)=mod(3*x2(t-1),1);
    end
    %Apply the logarithm to the distances
    logdista=-log(abs(x1(1000:end)-x2(1000:end)));
    %Estimates with D2 with the block maxima
    blength=1000;
    logextr=blockmaxima(logdista,blength);
    [tpar tpari]=gevfit(logextr);
    d2_GEV(traj)=1/tpar(2);
    %Estimates for D2 (Correlation dimension)
    theta2(traj)=extremal_Sueveges(logdista,quanti);
    
end











