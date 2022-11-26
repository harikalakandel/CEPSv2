load signal.mat
plot(signal)

% init m and t
m = 4;
t = 1;

%%%%%%%%%%%%%%%%%%%%%%% Original PE  %%%%%%%%%%%%%%%%%%%%%%%
% Original Permutation Entropy (PE)
originalPE = pec(signal,m,t);
fprintf('Original PE value: %d \n', originalPE) 
%%%%%%%%%%%%%%%%%%%%%%% Original PE  %%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%% Edge PE  %%%%%%%%%%%%%%%%%%%%%%%
% Edge PE
% set r = 0 ,when r = 0, edgePE = OriginalPE
r = 0;
ePE = edgePE(signal,m,t,r);
disp('r=0')
fprintf('Edge PE value: %d \n', ePE)


% you can set up r = 2 based on your experiment
r = 2;
ePE = edgePE(signal,m,t,r);
disp('r=2')
fprintf('Edge PE value: %d \n', ePE)

% you can set up r = 4 based on your experiment
r = 4;
ePE = edgePE(signal,m,t,r);
disp('r=4')
fprintf('Edge PE value: %d \n', ePE)
%%%%%%%%%%%%%%%%%%%%%%% Edge PE  %%%%%%%%%%%%%%%%%%%%%%%


