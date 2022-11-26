data = load('../../../../../Data/SampleData/RR_Data/ECG_BC_c_25_8_hrv.txt')
fs=1024;
tNN = [1:size(data,1)]/fs
sqi=1
HRVparams = InitializeHRVparams('testing');
tWin=1
[alpha1, alpha2] = EvalDFA(data,tNN)