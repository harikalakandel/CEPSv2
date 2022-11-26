function [PE] = edgePE(signal,m,t,r)
    %  Calculate the edge permutation entropy
    %  Input:   signal: time series;
    %           m: order of permuation entropy;
    %           t: time delay of permuation entropy;
    %           r: sensitivity parameter. Recommended that r is set to [0,4]
    %  Output:  
    %           PE: edge permuation entropy value.
    %  Reference: Huo, Zhiqiang, Yu Zhang, Lei Shu, and Xiaowen Liao. 
    %  "Edge permutation entropy: An improved entropy measure for time-series analysis." 
    %  In IECON 2019-45th Annual Conference of the IEEE Industrial Electronics Society, vol. 1, pp. 5998-6003. IEEE, 2019.
    
    len_signal = length(signal);
    permlist = perms(1:m);
    c(1:length(permlist))=0;

     for j=1:len_signal-t*(m-1)
         reSignal = signal(j:t:j+t*(m-1));
         [a,iv]=sort(reSignal);  % reconsructed space

         edgeDist = zeros(1,m-1);
         for k = 1:m-1
             edgeDist(1,k) = sqrt((reSignal(k)-reSignal(k+1)).^2+1) ;
         end

         averEdgeDist = (sum(edgeDist))/(m-1);

         for jj=1:length(permlist)
             if (abs(permlist(jj,:)-iv))==0
                 c(jj) = c(jj) + (averEdgeDist).^r ;
             end
         end
     end

    c=c(find(c~=0));
    p = c/sum(c);
    PE = -sum(p .* log2(p));  %/factorial(m);  

end