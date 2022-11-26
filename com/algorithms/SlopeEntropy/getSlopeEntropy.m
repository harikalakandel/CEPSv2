%% converted c++ code from Cuesta-Frau into matlab code
function [ fSlopeEn ] = getSlopeEntropy( vectorTimeSeries,iEmbeddedDimension,fGamma,fDelta )

fSlopeEn=0



%% struct structBin
%% {
%% int c
%% std:vector<int> vectorSymbols;
%% };
%% std ::list<structBin> listPatternsFound

C_INDEX=1;
VECTOR_SYMOBOLS_INDEX=2;

listPatternsFound = {}; %% first item represent c, second item represent vectorSymbols


j=1;
while j<size(vectorTimeSeries,1)-iEmbeddedDimension
    i=j+1;
    vectorSlopePattern=[];
    while i<j+iEmbeddedDimension
        fSlope= vectorTimeSeries(i,1)-vectorTimeSeries(i-1,1);
        if abs(fSlope )<=fDelta                          % codition1
            %add 0 to last of the timeSeres
            vectorSlopePattern=[vectorSlopePattern;0];
        else
            if fSlope > fDelta && fSlope <=fGamma        % condition 2
                %add 1 to last of the timeSeres
                vectorSlopePattern=[vectorSlopePattern;1];
            else
                if fSlope > fGamma     % condition 3
                    %add 1 to last of the timeSeres
                    vectorSlopePattern=[vectorSlopePattern;2];
                else
                    if fSlope < -fDelta && fSlope >= -fGamma    % condition 4
                        %add 1 to last of the timeSeres
                        vectorSlopePattern=[vectorSlopePattern;-1];
                    else
                        vectorSlopePattern=[vectorSlopePattern;-2];
                    end
                end
            end
        end
        i=i+1;
    end
    bFound = false;
    for i=1:size(listPatternsFound,1)
        patternInList = listPatternsFound{i,1}
        %%check if the second item is equal to vectorSlopePattern
        if isequal(patternInList{VECTOR_SYMOBOLS_INDEX,1},vectorSlopePattern)
            listPatternsFound{i,1}{C_INDEX,1}=patternInList{C_INDEX,1}+1 %% increase first item(c) by 1
            bFound = true
            break
        end
    end
    if bFound == false
        listPatternsFound{size(listPatternsFound,1)+1,1}={1;vectorSlopePattern};
    end
       
    j = j+1;
end




for i=1:size(listPatternsFound,1)
    patternInList = listPatternsFound{i,1}
    p=patternInList{C_INDEX,1}/size(listPatternsFound,1);
    fSlopeEn=fSlopeEn -p*log2(p)
end



%SLOPEN Summary of this function goes here
%   Detailed explanation goes here


end
%x = {8.2, 8.1, 4.4, 3.6, 5.3, 5.4, 8.3, 1.9, 3.7, 8.6, 9.6, 9,6, 8.7, 6.7, 3.3, 2, 2.5, 2.7, 4.6, 9.1, 1, 3.1, 1.7, 4.1, 3.8, 6.4, 1.3, 5.7, 3.4, 2.4, 2.1, 4.2};
%iEmbeddedDimension=3
%r=2
% delta =0.001
%getSlopeEntropy(cell2mat(x)',iEmbeddedDimension,2,0.001)