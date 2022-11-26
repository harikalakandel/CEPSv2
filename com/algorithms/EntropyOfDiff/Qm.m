function [ans] = Qm(strPlus)
    %format rational

    if size(strPlus,2)==sum(strPlus)
        ans =  1/factorial((size(strPlus,2)+1));

    elseif size(strPlus,2)==-1*sum(strPlus)
         ans =  1/factorial((size(strPlus,2)+1));
    elseif strPlus(1,1)==-1
        tmpStrPlus = strPlus;
        tmpStrPlus(1,1)=1;
        ans = Qm(strPlus(1,2:end))-Qm(tmpStrPlus);

    elseif strPlus(1,end)==-1
        tmpStrPlus = strPlus;
        tmpStrPlus(1,end)=1;
        ans = Qm(strPlus(1,1:end-1))-Qm(tmpStrPlus);
    else

    indMinus = find(strPlus==-1);
    indMinus=indMinus(1,1);

    tmpStrPlus=strPlus;
    tmpStrPlus(1,indMinus)=1;
    ans = Qm(strPlus(1,1:indMinus-1)) * Qm(strPlus(1,indMinus+1:end))-Qm(tmpStrPlus);
end
