RR=load('N_IBI_BM_b_10_5_hrv_e.txt');

[toneE,tones]=getMultiLagToneEntropy_Karm(RR,10);

disp('           lag        tones      toneE')
disp(' ---------------------------------------------')
disp([1:10 ;tones ;toneE]')