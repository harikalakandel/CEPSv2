function [bEn] = getBubbleEn(x,m,toPrint)
    %% return the bubble entropy defined by 
    %% https://ieeexplore-ieee-org.ezproxy.herts.ac.uk/stamp/stamp.jsp?tp=&arnumber=7842617
    N=size(x,2);

    mPlus1=m+1;
    mMinus1=m-1;
    


    %% get 
    %% step 1 get a series of number of count of swap requried in each Xi (x embedded m)
    S_m= getBSwapCount(x,m);
    
    %% counter vector for embedded m
    C_m=getCounterVector(S_m,m);
    %% step 2 Normalize the counter vector by N-m+1
    P_m = C_m/(N-m+1);
    %% step 3 Compute conditional Renyi entrpoy of the distribution using equation 11
    H_mSwap = -log(sum(P_m.^(2)));

    %% step 4  Repeat step1 to step 3 for m+1 elements
    %%4.1 get swap count
    S_mPlus1 = getBSwapCount(x,mPlus1);
    %%4.1a counter vector for embedded mPlus1
    C_mPlus1 = getCounterVector(S_mPlus1,mPlus1);
    %%4.2 normalize the counter vector
    P_mPlus1 = C_mPlus1/(N-mPlus1+1);
    %%4.3 compute Conditional Renyi entropy for m+1
    H_mPlus1Swap = -log(sum(P_mPlus1.^(2)));

    %%5. compute bubble entropy using equation 13
    bEn = (H_mPlus1Swap-H_mSwap)/log(mPlus1/mMinus1);


    if toPrint
        fprintf('Input:::: \n Data: \n')
        fprintf('%0.3f,',x)
        fprintf('\nembedded Dimension : %d',m)
        
        fprintf('\n\n Swap Count (S) for %d embedded \n',m)
        fprintf('%d,',S_m)
        fprintf('\n Counter Vector (C) for %d embedded \n',m)
        fprintf('%d,',C_m)       
        fprintf('\n Probabiltiy vector (P) for %d embedded \n',m)
        fprintf('%0.3f,',P_m)
        fprintf('\n Renyi entropy  of order 2 (H) for %d embedded \n',m)
        fprintf('%0.3f',H_mSwap)
        
        fprintf("\n\n Repeating the process for m=%d \n.....................\n",mPlus1)
        fprintf('\n Swap Count (S) for %d embedded \n',mPlus1)
        fprintf('%d,',S_mPlus1)
        fprintf('\n Counter Vector (C) for %d embedded \n',mPlus1)
        fprintf('%d,',C_mPlus1)        
        fprintf('\n Probabiltiy vector (P) for %d embedded \n',mPlus1)
        fprintf('%0.3f,',P_mPlus1)
        fprintf('\n Renyi entropy  of order 2 (H) for %d embedded \n',mPlus1)
        fprintf('%0.3f',H_mPlus1Swap)
        
        fprintf('\n\n Bubble Entropy %0.4f',bEn)
    end
    
end

