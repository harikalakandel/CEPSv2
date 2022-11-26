function [SD1, SD2, dCCM] = djcCCM(vecData,lag)

    %%// set default values
    dataStrt = 1;
    dataWind = size(vecData,1);
    dataSkip = 1;
    dataReps = 1;
    % M_PI = 22/7;   this is a predefined constant
    
    meanVal = nanmean(vecData);
    varianceVal = nanvar(vecData);
    %printf("%d %f %f\n", dataWind, meanVal, varianceVal);

    maxlength = dataWind + ((dataReps - 1) * dataSkip) - 3 - lag;
    maxlimit = dataStrt + maxlength;
       
    %% calculate SD1 and SD2 of the Poincare plot using the stdev method
    varidiff = 0.0;   
    meandiff = 0.0;
    varisum = 0.0;
    for index=dataStrt: maxlimit-1
        diff = vecData(index+lag) - vecData(index);
        meandiff = meandiff + diff;
        varidiff = varidiff + diff.^2;
        %%varisum += pow(vecData[index+lag] + vecData[index] - mean - mean, 2.0);
        varisum = varisum + (vecData(index+lag) + vecData(index) - meanVal - meanVal)^2;
    end
    meandiff = meandiff/maxlength;
    varidiff = varidiff/(maxlength - 1);
    varisum = varisum/ (maxlength - 1);
    
    % double SD1a = sqrt(0.5 * varidiff);
    SD1a = sqrt(0.5 * varidiff);
    % double SD2a = sqrt(2 * variance - 0.5 * varidiff);
    SD2a = sqrt(2 * varianceVal - 0.5 * varidiff);
    %printf("SD2a = %f (%f %f)\n", SD2a, varianceVal, varidiff);
    % double SD2x = sqrt(0.5 * varisum);
    %SD2x = sqrt(0.5 * varisum);   dont need this
    
    % calculate SD1 and SD2 of the Poincare plot using the autocorrelation method
    autocorr_zero = 0.0;
    autocorr_lag = 0.0;
    % for (long index=dataStrt; index<maxlimit; index++)
    for index=dataStrt:maxlimit-1
        % autocorr_zero += pow(vecData[index] - mean, 2.0);
        autocorr_zero = autocorr_zero+(vecData(index) - meanVal)^2;
        % autocorr_lag += (vecData[index] - mean) * (vecData[index+lag] - mean);
        autocorr_lag = autocorr_lag+(vecData(index) - meanVal) * (vecData(index+lag) - meanVal);
    end
    autocorr_zero = autocorr_zero/maxlength;
    autocorr_lag = autocorr_lag/maxlength;
    % double SD1b = sqrt(autocorr_zero - autocorr_lag);
    SD1b = sqrt(autocorr_zero - autocorr_lag);
    % double SD2b = sqrt(autocorr_zero + autocorr_lag - 2.0 * pow(mean, 2.0));
    SD2b = sqrt(autocorr_zero + autocorr_lag - (2.0 * meanVal^2));
    %printf("SD2b = %f (%f %f %f)\n", SD2b, autocorr_zero, autocorr_lag, meanVal);
    
    SD1 = choose2(SD1a, SD1b);
    SD2 = choose2(SD2a, SD2b);
    
    dSumArea = 0.0;
    % for (long index=dataStrt; index<maxlimit; index++)
    for index=dataStrt:maxlimit-1
    
        dAreaTriangle = 0.0;
        % dAreaTriangle += vecData[index]   * vecData[index+1+lag);   // u_1 * u_2+m
        dAreaTriangle = dAreaTriangle + vecData(index) * vecData(index+1+lag);  
        %dAreaTriangle -= vecData[index]   * vecData[index+2+lag);   // u_1 * u_3+m
        dAreaTriangle = dAreaTriangle - vecData(index) * vecData(index+2+lag);   
        %dAreaTriangle += vecData[index+2] * vecData[index+lag);     // u_3 * u_1+m
        dAreaTriangle = dAreaTriangle + vecData(index+2) * vecData(index+lag);    
        %dAreaTriangle -= vecData[index+1] * vecData[index+lag);     // u_2 * u_1+m
        dAreaTriangle = dAreaTriangle - vecData(index+1) * vecData(index+lag);    
        %dAreaTriangle += vecData[index+1] * vecData[index+2+lag);   // u_2 * u_3+m
        dAreaTriangle = dAreaTriangle + vecData(index+1) * vecData(index+2+lag);   
        %dAreaTriangle -= vecData[index+2] * vecData[index+1+lag);   // u_3 * u_2+m
        dAreaTriangle = dAreaTriangle - vecData(index+2) * vecData(index+1+lag);   
        dAreaTriangle = 0.5 * dAreaTriangle;
        
        dSumArea = dSumArea + abs(dAreaTriangle);
    end
    dNormConst = pi * SD1 * SD2;
    dCCM = (dSumArea / dNormConst) / (maxlength - 2);
    
    % printf("dCCM: %f %f\n", dSumArea, dNormConst); 
end

