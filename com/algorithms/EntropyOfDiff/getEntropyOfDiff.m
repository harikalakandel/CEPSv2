%%implementation of Entropy of Difference from Pasquale Nardone, November 5, 2014
%%inputs
%% data     -> time series data of size N by 1
%% m        -> embedding dimension
%%shiftN    -> shift
%% Output
%% EDm      -> Entropy of Difference

function [EDm,EDmRand] = getEntropyOfDiff(data,m,shiftN)
 
    %% increase m, size of signalTuple  by 1 to get signTuples of size m
    m=m+1;
   
    
    
    %% get dataTuples for the dataset
    dataTuples = []; 
  
    i=1;
    j=i+(m-1)*1;
    index=1;
    while j<=size(data,1)
        
        dataTuples = [dataTuples;data(i:1:j,1)'];
       
        i=i+shiftN;
        j=i+(m-1)*1;
        index=index+1;
    end
    
    
  
    pN=size(dataTuples,1);    
 

    %% get sign of increment or decrement with corresponding element within the tuple
    %% size of sign Tuple is m-1
    signTuples = nan(pN,m-1);
    for i=1:m-1
        %% sign is +ve (here 1) if (i+1)th element is greater than ith element with the tuple
        signTuples(:,i)=dataTuples(:,i+1)>dataTuples(:,i);
        %%added
        signTuples(signTuples(:,i)==0,i)=-1;
    end

    
    
    
    


    %% permutation of +ve (1) and -ve (0) of size m-1  [size of sign tuple]
    allPremSigns = round(npermutek([-1 1],m-1));
   
    
    
    %% add two more comumns, first for counting number of occurance or particular, second for its probability
    %allPremSigns = [allPremSigns nan(size(allPremSigns,1),2)];

   allPremSignStat= nan(size(allPremSigns,1),2);
    %% from 1 - m-1 contain the string of -ve and +ve (here 0 and 1)
    COUNT_INDEX=1;
    PROB_INDEX=2;
    
    %%get count
    for i=1:size(allPremSigns,1)
        allPremSignStat(i,COUNT_INDEX)=sum(sum(abs(repmat(allPremSigns(i,1:m-1),pN,1)-signTuples),2)==0);
    end
    
  
    %% get probability 
    allPremSignStat(:,PROB_INDEX)=allPremSignStat(:,COUNT_INDEX)./sum(allPremSignStat(:,COUNT_INDEX));
    
    
  
    %%remove the combination for which there is no occurance
    allPremSigns(allPremSignStat(:,COUNT_INDEX)==0,:)=[];
    allPremSignStat(allPremSignStat(:,COUNT_INDEX)==0,:)=[];
   
    

    
    %% get entropy of difference of order m
    EDm =-1* sum(allPremSignStat(:,PROB_INDEX).*log2(allPremSignStat(:,PROB_INDEX)));
  
    
     EDmRand=0.0;
     
     for i=1:size(allPremSigns,1)
        EDmRand = EDmRand+ allPremSignStat(i,PROB_INDEX)*log2(allPremSignStat(i,PROB_INDEX)/Qm(allPremSigns(i,:)));
     end
   
    
    

end
%%%test Case...
% %x=ceil(rand(100000,1)*100);
% data = [   85    16    91    92    83    70    58    10    98    56    71    28    14    93    43    75    17    44    36    79    94    48    22    40    27];
% x=data';
% allResults=nan(5,5);
% 
% %%getEntropyOfDiff(x,2,1)
% 
% fprintf('\n Shift\t \t\t m=2 \t\t m=3 \t\t m=4 \t\t m=5 \t\t m=6')
% for shift=1:5
%     fprintf('\n %f\t\t',shift)
%     for m =2:6
%         
%         ans1 = getEntropyOfDiff(x,m,shift);
%         fprintf('%f\t',ans1)
%     end
% end


%% Test Example 1


%%Given
%data = [   85    16    91    92    83    70    58    10    98    56    71    28    14    93    43    75    17    44    36    79    94    48    22    40    27];
%m = 4
%% Process
%pN -> number of tuples of size m -> 6
%%dataTuples
%     85    16    91    92    83
%     16    91    92    83    70
%     91    92    83    70    58
%     92    83    70    58    10
%     83    70    58    10    98
%     70    58    10    98    56
%     58    10    98    56    71
%     10    98    56    71    28
%     98    56    71    28    14
%     56    71    28    14    93
%     71    28    14    93    43
%     28    14    93    43    75
%     14    93    43    75    17
%     93    43    75    17    44
%     43    75    17    44    36
%     75    17    44    36    79
%     17    44    36    79    94
%     44    36    79    94    48
%     36    79    94    48    22
%     79    94    48    22    40
%     94    48    22    40    27


%% sign tuples [0 for -ve , 1 for +ve]
%      0     1     1     0
%      1     1     0     0
%      1     0     0     0
%      0     0     0     0
%      0     0     0     1
%      0     0     1     0
%      0     1     0     1
%      1     0     1     0
%      0     1     0     0
%      1     0     0     1
%      0     0     1     0
%      0     1     0     1
%      1     0     1     0
%      0     1     0     1
%      1     0     1     0
%      0     1     0     1
%      1     0     1     1
%      0     1     1     0
%      1     1     0     0
%      1     0     0     1
%      0     0     1     0

%% all possible tupples are 
%      0     0     0     0
%      0     0     0     1
%      0     0     1     0
%      0     0     1     1
%      0     1     0     0
%      0     1     0     1
%      0     1     1     0
%      0     1     1     1
%      1     0     0     0
%      1     0     0     1
%      1     0     1     0
%      1     0     1     1
%      1     1     0     0
%      1     1     0     1
%      1     1     1     0
%      1     1     1     1


%% count of occurance of tuples & its probability
% count occurance   ## probability [p_m(s)]
%-------------------------------------------------------------  
%     1.0000        0.0476
%     1.0000        0.0476
%     3.0000        0.1429
%          0         0
%     1.0000        0.0476
%     4.0000        0.1905
%     2.0000        0.0952
%          0         0
%     1.0000        0.0476
%     2.0000        0.0952
%     3.0000        0.1429
%     1.0000        0.0476
%     2.0000        0.0952
%          0         0
%          0         0
%          0         0



    


%% Calculate permutation entropy
%%EDm = -1* sum_s(p_m(s)*log(p_m(s))
%% EDm = 3.2728



%%Example 2 
%%Test cases M (2-6)  Shift (1-5)....

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Shift	 		 m=2 		 m=3 		 m=4 		 m=5 		 m=6
%  1.000000		1.844882	2.685816	3.272804	3.684184	4.037401	
%  2.000000		1.825011	2.663533	3.095795	3.121928	3.321928	
%  3.000000		1.750000	2.405639	2.521641	2.807355	2.807355	
%  4.000000		1.584963	2.251629	2.584963	2.321928	2.321928	
%  5.000000		0.970951	1.370951	1.370951	1.500000	1.500000	


