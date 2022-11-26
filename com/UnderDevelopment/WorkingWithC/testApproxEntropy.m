%files= dir('E:\WorkSpace\Matlab\Projects\CEPS\com\UnderDevelopment\DataToDelete\RR_Data\*.txt')


% void Analyse::RenyiEntropy(char* command)
%% parameters
%% 1 - vecData
%% 2 - pattern
%% 3 - tolerance
%% 4 - exponent

exponent=2; %%?????
disp('ECG_BO_a_25_7_hrv.txt')
currData=load('E:\WorkSpace\Matlab\Projects\CEPS\com\UnderDevelopment\DataToDelete\RR_Data\ECG_BO_a_25_7_hrv.txt');
displayData=zeros(10,1); 
for pattern=1:10
    for tolerance=1:10
        displayData(pattern,tolerance)=getApproxEntropy(currData,pattern,tolerance/10);
    end
end
disp(displayData)

disp('ECG_BC_c_25_8_hrv.txt');
currData=load('E:\WorkSpace\Matlab\Projects\CEPS\com\UnderDevelopment\DataToDelete\RR_Data\ECG_BC_c_25_8_hrv.txt');
displayData=zeros(10,1); 
for pattern=1:10
    for tolerance=1:10
        displayData(pattern,tolerance)=getApproxEntropy(currData,pattern,tolerance);
    end
end
disp(displayData)

