%%getCCM(vecData,lag)
%void Analyse::CCM(char* command)
%%Parameter
vecData = [28    68    66    17    12    50    96    35    59    23    76    26    51    70    90    96    55    14    15    26    85 25    26    82    25    93]';



 
 
%% change1 parameterize this
   %% int lag = 1;

    %%// set default values
    dataStrt = 1;
    dataWind = size(vecData,1);         %% => 26
    dataSkip = 1;
    dataReps = 1;
    M_PI = 22/7;
    
    %%matlab have mean function so 
    meanVal=mean(vecData,1);            %% => 50.3462
    
    
%     // get parameters
%     char* pch = strtok(command, " \t"); // first token will be "window"
%     pch = strtok(NULL, " \t");
%     if (pch != NULL)
%     {
%         lag = atoi(pch);
%     }
%     if (lag < 1)
%     {
%         lag = 1;
%     }
%     

%%paramter
lag=3;

    %long maxlength = dataWind + ((dataReps - 1) * dataSkip) - 3 - lag;
    %long maxlimit = dataStrt + maxlength;
    maxlength = dataWind + ((dataReps - 1) * dataSkip) - 3 - lag;   %% => maxlength = 20
    maxlimit = dataStrt + maxlength;                                %% => maxlimit = 21  
    
    
    %     variance = 0.0;
%     for (long index=dataStrt; index<maxlimit; index++)
%     {
%         variance += pow(mean - vecData[index], 2.0);
%     }
%     //cout << variance << endl;
%     variance /= (maxlength - 1);
    
    varianceVal = var(vecData);                                 %% =>varianceVal = 846.3954
    
%     %%%???????????????
%     
%     %%concept is code is different
%      variance = 0.0;
%      for index=dataStrt: maxlimit-1
%          variance = variance + (meanVal - vecData(index))^2
%      end
%      
% 
%      varianceVal =variance / (maxlength - 1);
     
     %% ?????????????
     
     
    
    %% calculate SD1 and SD2 of the Poincare plot using the stdev method
    %% double varidiff = 0.0;   // variance of successive difference of RR intervals
    %% double meandiff = 0.0;
    %% double varisum = 0.0;
    
    %% calculate SD1 and SD2 of the Poincare plot using the stdev method
    varidiff = 0.0;   
    meandiff = 0.0;
    varisum = 0.0;
    %for (long index=dataStrt; index<maxlimit; index++)
    
    %%for test only
    allDiff=[];
    allMeanDiff = [];
    allVariDiff = [];
    allVariSum = [];
    %%for test only end
    
    for index=dataStrt: maxlimit-1
        diff = vecData(index+lag,1) - vecData(index,1)
        
        meandiff = meandiff+ diff;
        varidiff = varidiff + diff.^2;      
        %%varisum += pow(vecData[index+lag] + vecData[index] - mean - mean, 2.0);
        varisum = varisum + (vecData(index+lag,1) + vecData(index,1) - meanVal - meanVal)^2
        
        %% for test only
        allDiff = [allDiff diff];
        allMeanDiff = [allMeanDiff meandiff];
        allVariDiff = [allVariDiff varidiff];        
        allVariSum = [allVariSum varisum];
        %% for test only
    end
    %% =>  allDiff              [-11      -56     -16     79      23      9       -73          41      -33      28     -6         64      45     -15     -76     -81     -29       71       10      0]
    %% => allMeanDiff           [-11      -67     -83     -4      19      28      -45         -4       -37      -9     -15        49      94      79      3      -78     -107     -36      -26     -26]
    %% => allVariDiff           [121      3257    3513    9754    10283   10364    15693      17374     18463   19247   19283     23379   25404   25629   31405   37966   38807    43848    43948   43948]
    %% => allVariSum   1.0e+04 *[0.3102   0.3530  0.3764  0.3916  0.6798  0.6867    0.7203    0.7309    0.7555  0.8268  1.0320    1.0555  1.2699  1.3290  1.3301  1.3407  1.3795   1.3798   1.7481  1.9852]

    meandiff = meandiff/maxlength;                     %% => meandiff =  -1.3000
    varidiff = varidiff/(maxlength - 1);               %% => varidiff =   2.3131e+03
    varisum = varisum/ (maxlength - 1);                %% => varisum  =   1.0449e+03
    
    % double SD1a = sqrt(0.5 * varidiff);
    SD1a = (0.5 * varidiff)^(0.5);                      %% => SD1a = 34.0077
    % double SD2a = sqrt(2 * variance - 0.5 * varidiff);
    SD2a = (2 * varianceVal - 0.5 * varidiff)^(0.5);    %% => SD2a = 23.1574
    
    % double SD2x = sqrt(0.5 * varisum);
    SD2x = (0.5 * varisum)^(0.5);                       %% => SD2x = 22.8567
    
    % calculate SD1 and SD2 of the Poincare plot using the autocorrelation method
    autocorr_zero = 0.0;
    autocorr_lag = 0.0;
    % for (long index=dataStrt; index<maxlimit; index++)
    %% =>  maxlimit-1 = 20
    %% for test only
    allAutoCorrZero =[];
    allAutoCorrLag=[];
    %% for test only end
    for index=dataStrt:maxlimit-1
        % autocorr_zero += pow(vecData[index] - mean, 2.0);
        autocorr_zero = autocorr_zero+(vecData(index,1) - meanVal)^2;
        % autocorr_lag += (vecData[index] - mean) * (vecData[index+lag] - mean);
        autocorr_lag = autocorr_lag+(vecData(index,1) - meanVal) * (vecData(index+lag,1) - meanVal);
        
        %%for test
        allAutoCorrZero=[allAutoCorrZero autocorr_zero];
        allAutoCorrLag=[allAutoCorrLag autocorr_lag];
    end
    %% =>
    %% 
    %% chk value
%   %% => allAutoCorrZero 1.0e+04 *[0.0499    0.0811    0.1056    0.2168    0.3638    0.3639     0.5723    0.5958    0.6033    0.6781    0.7439    0.8032    0.8032     0.8419    0.9991    1.2075    1.2097    1.3418    1.4667    1.5260]
%   %%  => allAutoCorrLag  1.0e+03 *[0.7452    0.0682    0.0628   -1.4596   -0.8711   -0.8741    -2.1226   -2.5163   -2.7270   -2.7448   -2.2406   -3.2061   -3.1762    -3.0847   -4.5260   -6.1397   -6.2530   -7.5125   -6.6166   -6.0239]
    
    autocorr_zero = autocorr_zero/maxlength;                                    %% => autocorr_zero = 763.0044
    autocorr_lag = autocorr_lag/maxlength;                                      %% => autocorr_lag =  -301.1956
    % double SD2b = sqrt(autocorr_zero + autocorr_lag - 2.0 * pow(mean, 2.0));
    SD1b = (autocorr_zero - autocorr_lag)^(0.5);                                %% => SD1a =  32.6221
    % double SD2b = sqrt(autocorr_zero + autocorr_lag - 2.0 * pow(mean, 2.0));
    SD2b = (autocorr_zero + (autocorr_lag - 2.0 * (meanVal^2)))^(0.5);          %% => SD2b = 0.0000 +67.8798i    ??????????????
    
    SD1 = choose2(SD1a, SD1b);                                                  %% => SD1 = 33.3149
    SD2 = choose2(SD2a, SD2b);                                                  %% => SD2 = 11.5787 +33.9399i
    
    dSumArea = 0.0;
    % for (long index=dataStrt; index<maxlimit; index++)
    for index=dataStrt:maxlimit-1
    
         dAreaTriangle = 0.0;
        
        % dAreaTriangle += vecData[index]   * vecData[index+1+lag);   // u_1 * u_2+m
        dAreaTriangle = dAreaTriangle+ vecData(index,1)   * vecData(index+1+lag,1);  
        
        %dAreaTriangle -= vecData[index]   * vecData[index+2+lag);   // u_1 * u_3+m
        dAreaTriangle =dAreaTriangle- vecData(index,1)   * vecData(index+2+lag,1);   
        
        %dAreaTriangle += vecData[index+2] * vecData[index+lag);     // u_3 * u_1+m
        dAreaTriangle =dAreaTriangle+ vecData(index+2) * vecData(index+lag);    
        
        %dAreaTriangle -= vecData[index+1] * vecData[index+lag);     // u_2 * u_1+m
        dAreaTriangle = dAreaTriangle-  vecData(index+1) * vecData(index+lag);    
        
        %dAreaTriangle += vecData[index+1] * vecData[index+2+lag);   // u_2 * u_3+m
        dAreaTriangle =dAreaTriangle+ vecData(index+1) * vecData(index+2+lag);   
         
        %dAreaTriangle -= vecData[index+2] * vecData[index+1+lag);   // u_3 * u_2+m
        dAreaTriangle =dAreaTriangle - vecData(index+2) * vecData(index+1+lag);   
        
        dAreaTriangle = 0.5 * dAreaTriangle;
        
        dSumArea  = dSumArea+ abs(dAreaTriangle);
    end
    %% => dAreaTriangle = -1.5000
    %% => dSumArea      =  1.3176e+04
    dNormConst = M_PI * SD1 * SD2;                          %% => dNormConst = 1.2123e+03 + 3.5536e+03i
    dCCM = (dSumArea / dNormConst) / (maxlength - 2);       %% => dCCM = 0.0629 - 0.1845i
    
    poinCare = dSumArea;                                    %% => poinCare = 1.3176e+04
   
%     if (verbose >= 3)
%     {
%         printf("Poincare: %d %f\n", lag, dSumArea);
%         printf("Variance method: %f %f %f %f %f %f\n", variance, varidiff, meandiff, SD1a, SD2a, SD2x);
%         printf("Correlation: %f %f %f %f\n", autocorr_zero, autocorr_lag, SD1b, SD2b);
%     }
%    printf("%f %f %f\n", SD1, SD2, dCCM);
    
    