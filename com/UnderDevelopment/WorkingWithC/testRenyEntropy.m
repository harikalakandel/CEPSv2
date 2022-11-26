%files= dir('E:\WorkSpace\Matlab\Projects\CEPS\com\UnderDevelopment\DataToDelete\RR_Data\*.txt')

exponent=0.2;
%% parameters
%% 1 - vecData
%% 2 - pattern
%% 3 - tolerance
%% 4 - exponent
%% function [renyi_mean,renyi_stdev] = getRenyEntropy(vecData,varargin)
disp('ECG_BO_a_25_7_hrv.txt')
currData=load('E:\WorkSpace\Matlab\Projects\CEPS\com\UnderDevelopment\DataToDelete\RR_Data\ECG_BO_a_25_7_hrv.txt');
displayData=zeros(10,10); 
for pattern=1:10
    for tolerance=1:10
        displayData(pattern,tolerance)=getRenyEntropy(currData,pattern,tolerance,exponent);
    end
end
disp(displayData)

disp('ECG_BC_c_25_8_hrv.txt');
currData=load('E:\WorkSpace\Matlab\Projects\CEPS\com\UnderDevelopment\DataToDelete\RR_Data\ECG_BC_c_25_8_hrv.txt');
displayData=zeros(10,10); 
for pattern=1:10
    for tolerance=1:10
        displayData(pattern,tolerance)=getRenyEntropy(currData,pattern,tolerance,exponent);
    end
end
disp(displayData)

