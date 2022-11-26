function [swapCount] = countBubbleSwap(data)
    %% input data = [1 2 4  5 66 4...]
    % return the number of swap required to sort the data in ascending order
    %% a original bubble sort is used to count the number of swap required to sort the data in ascending order
    swapCount = 0;
    pData = data;
    for i=1:size(data,2)-1
        currSwaps=[];
        for j=i+1:size(data,2)
            if data(1,i)>data(1,j)
                tmp=data(1,i);
                data(1,i)=data(1,j);
                data(1,j)=tmp;
                swapCount = swapCount+1;
            end
            currSwaps=[currSwaps data];
        end
      %  fprintf("Step %d %0.2 d",i,currSwaps(1,1),currSwaps(1,1),currSwaps(1,1),currSwaps(1,1),currSwaps(1,1),currSwaps(1,1),currSwaps(1,1),currSwaps(1,1),)
    end
    
    
end

