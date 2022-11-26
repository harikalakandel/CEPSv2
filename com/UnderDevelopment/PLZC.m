function index  =  PLZC(data,m,lag)
ly  =  length(data);
permlist  =  perms(1:m);
c(1:length(permlist))  =  0;

OPi  =  zeros(1,ly-lag*(m-1));

for j  =  1:ly-lag*(m-1)
    [a,iv] =  sort(data(j:lag:j  +  lag*(m-1)));
    for jj  =  1:length(permlist)
        if (abs(permlist(jj,:)-iv)) ==  0
            OPi(j)  =  jj;
        end
    end
end
c  =  1;
S  =  OPi(1);
Q  =  [];
SQ  =  [];
for i  = 2:length(OPi)
    Q   =  strcat(Q,OPi(i));
    SQ  =  strcat(S,Q);
    SQv =  SQ(1:length(SQ)-1);
    if isempty(findstr(SQv,Q))
        S =  SQ;
        Q =  [];
        c =  c  +  1;
    end
end
mm  =  factorial(m);
b  =  length(OPi)*log(mm)/log(length(OPi));
index  =  c/b;
end