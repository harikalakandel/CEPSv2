function [dCCM,poinCare] = getCCM(vecData,lag)

    %% change1 parameterize this
   %% int lag = 1;

    %%// set default values
    dataStrt = 1;
    dataWind = size(vecData,1);
    dataSkip = 1;
    dataReps = 1;
    M_PI = 22/7;
    
    %%matlab have mean function so 
    meanVal=mean(vecData,1);
    
%     variance = 0.0;
%     for (long index=dataStrt; index<maxlimit; index++)
%     {
%         variance += pow(mean - vecData[index], 2.0);
%     }
%     //cout << variance << endl;
%     variance /= (maxlength - 1);
    
    varianceVal = var(vecData);
    
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

    %long maxlength = dataWind + ((dataReps - 1) * dataSkip) - 3 - lag;
    %long maxlimit = dataStrt + maxlength;
    maxlength = dataWind + ((dataReps - 1) * dataSkip) - 3 - lag;
    maxlimit = dataStrt + maxlength;
    
    %% calculate SD1 and SD2 of the Poincare plot using the stdev method
    %% double varidiff = 0.0;   // variance of successive difference of RR intervals
    %% double meandiff = 0.0;
    %% double varisum = 0.0;
    
    %% calculate SD1 and SD2 of the Poincare plot using the stdev method
    varidiff = 0.0;   
    meandiff = 0.0;
    varisum = 0.0;
    %for (long index=dataStrt; index<maxlimit; index++)
    for index=dataStrt: maxlimit-1
        diff = vecData(index+lag,1) - vecData(index,1);
        meandiff = meandiff+ diff;
        varidiff = varidiff + diff.^2;
        %%varisum += pow(vecData[index+lag] + vecData[index] - mean - mean, 2.0);
        varisum = varisum + (vecData(index+lag,1) + vecData(index,1) - meanVal - meanVal)^2
    end
    meandiff = meandiff/maxlength;
    varidiff = varidiff/(maxlength - 1);
    varisum = varisum/ (maxlength - 1);
    
    % double SD1a = sqrt(0.5 * varidiff);
    SD1a = (0.5 * varidiff)^(0.5);
    % double SD2a = sqrt(2 * variance - 0.5 * varidiff);
    SD2a = (2 * varianceVal - 0.5 * varidiff)^(0.5);
    % double SD2x = sqrt(0.5 * varisum);
    SD2x = (0.5 * varisum)^(0.5);
    
    % calculate SD1 and SD2 of the Poincare plot using the autocorrelation method
    autocorr_zero = 0.0;
    autocorr_lag = 0.0;
    % for (long index=dataStrt; index<maxlimit; index++)
    for index=dataStrt:maxlimit-1
        % autocorr_zero += pow(vecData[index] - mean, 2.0);
        autocorr_zero = autocorr_zero+(vecData(index,1) - meanVal)^2;
        % autocorr_lag += (vecData[index] - mean) * (vecData[index+lag] - mean);
        autocorr_lag = autocorr_lag+(vecData(index,1) - meanVal) * (vecData(index+lag,1) - meanVal);
    end
    autocorr_zero = autocorr_zero/maxlength;
    autocorr_lag = autocorr_lag/maxlength;
    % double SD2b = sqrt(autocorr_zero + autocorr_lag - 2.0 * pow(mean, 2.0));
    SD1b = (autocorr_zero - autocorr_lag)^(0.5);
    % double SD2b = sqrt(autocorr_zero + autocorr_lag - 2.0 * pow(mean, 2.0));
    SD2b = (autocorr_zero + (autocorr_lag - 2.0 * (meanVal^2)))^(0.5);
    
    SD1 = choose2(SD1a, SD1b);
    SD2 = choose2(SD2a, SD2b);
    
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
    dNormConst = M_PI * SD1 * SD2;
    dCCM = (dSumArea / dNormConst) / (maxlength - 2);
    
    poinCare = dSumArea;
   
%     if (verbose >= 3)
%     {
%         printf("Poincare: %d %f\n", lag, dSumArea);
%         printf("Variance method: %f %f %f %f %f %f\n", variance, varidiff, meandiff, SD1a, SD2a, SD2x);
%         printf("Correlation: %f %f %f %f\n", autocorr_zero, autocorr_lag, SD1b, SD2b);
%     }
%    printf("%f %f %f\n", SD1, SD2, dCCM);
    
    
    

end

