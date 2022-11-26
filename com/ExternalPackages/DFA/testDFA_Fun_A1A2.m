data = load('ECG_BO_a_25_7_hrv.txt');

[alpah1, a] = DFA_fun(data(4:16,1),5,1)
[alpah2, b] = DFA_fun(data(16:64,1),5,1)