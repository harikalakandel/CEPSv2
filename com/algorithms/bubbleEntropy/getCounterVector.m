function [c_m] = getCounterVector(S_m,m)
%% get counter
mm = m*(m-1)/2;

c_m=zeros(1,mm+1);
for i=0:mm
    c_m(1,i+1) =sum(S_m==i);
end

end

