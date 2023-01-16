%{
----------------------------------------------------------------------------------------
Computing entropy in depression for detecting early warning signals
using fuzzy entropy of fuzzy recurrence plot
----------------------------------------------------------------------------------------
%}

%--------------------------------------
rng('default') % set random number genenator to default values
%--------------------------------------
% Read data
%--------------------------------------
M = readmatrix('ESMdata-19moods.csv');
%-------------------------------------- 

L = 1476; % length from phase 1 to phase 5

%----------
N1 = 176; % end of phase 1
N2 = 286; % end of phase 2
N3 = 671; % end of phase 3
N4 = 988; % end of phase 4
N5 = 1476; % end of phase 5
%------------

% Convert scale [-3,3] to scale [1, 7]
M(:,4) = 8-(M(:,4)+4);
M(:,7) = 8-(M(:,7)+4);
M(:,8) = 8-(M(:,8)+4);
M(:,12) = 8-(M(:,12)+4);

% extract data across all 19 moods for all time points L 
for i=1:L
    T{i} = M(i,3:21);
end
    
% construct FRP and compute entropy
dim=1;
tau=1;
numclusters=2; % 2 phases: medication, no medication % not working for 3 clusters

F=[];
E=[];
N = L-((dim-1)*tau); % length of recosntructed time series


for i=1:L   
    F{i} = 1-frp(T{i},dim,tau,numclusters); % use actual fuzzy membership
    S1 = F{i}.*log2(F{i});
    S2 = (1-F{i}).*log2(1-F{i});
    S1(isnan(S1))=0;
    S2(isnan(S2))=0;
    E(i)  = -sum(S1+S2,'all');
end


figure
plot(E(1:3:L))
axis([1 246 0 inf])
xlabel('Time points') 
ylabel('Fuzzy entropy')
set(gca,'FontSize',14)
print('FE-frp-19moods-all', '-djpeg', '-r600')


%------------------------------------
% Compute entropy for each of 5 phases
%-------------------------------------

% extract data across all 19 moods for all time points L 
for i=1:N1
    T1{i} = M(i,3:21);
end

for i=N1+1:N2
    T2{i} = M(i,3:21);
end

for i=N2+1:N3
    T3{i} = M(i,3:21);
end

for i=N3+1:N4
    T4{i} = M(i,3:21);
end

for i=N4+1:N5
    T5{i} = M(i,3:21);
end


for i=1:N1   
    F1{i} = 1-frp(T1{i},dim,tau,numclusters); % use actual fuzzy membership
    S1 = F1{i}.*log2(F1{i});
    S2 = (1-F1{i}).*log2(1-F1{i});
    S1(isnan(S1))=0;
    S2(isnan(S2))=0;
    E1(i)  = -sum(S1+S2,'all');
end


for i=1:N2   
    F2{i} = 1-frp(T2{i},dim,tau,numclusters); % use actual fuzzy membership
    S1 = F2{i}.*log2(F2{i});
    S2 = (1-F2{i}).*log2(1-F2{i});
    S1(isnan(S1))=0;
    S2(isnan(S2))=0;
    E2(i)  = -sum(S1+S2,'all');
end


for i=1:N3   
    F3{i} = 1-frp(T3{i},dim,tau,numclusters); % use actual fuzzy membership
    S1 = F3{i}.*log2(F3{i});
    S2 = (1-F3{i}).*log2(1-F3{i});
    S1(isnan(S1))=0;
    S2(isnan(S2))=0;
    E3(i)  = -sum(S1+S2,'all');
end


for i=1:N4   
    F4{i} = 1-frp(T4{i},dim,tau,numclusters); % use actual fuzzy membership
    S1 = F4{i}.*log2(F4{i});
    S2 = (1-F4{i}).*log2(1-F4{i});
    S1(isnan(S1))=0;
    S2(isnan(S2))=0;
    E4(i)  = -sum(S1+S2,'all');
end


for i=1:N5   
    F5{i} = 1-frp(T5{i},dim,tau,numclusters); % use actual fuzzy membership
    S1 = F5{i}.*log2(F5{i});
    S2 = (1-F5{i}).*log2(1-F5{i});
    S1(isnan(S1))=0;
    S2(isnan(S2))=0;
    E5(i)  = -sum(S1+S2,'all');
end


s=3;

figure
plot(E1(1:s:N1))
axis([1 ceil(N1/s) 0 inf])
xlabel('Time points') 
ylabel('Fuzzy entropy')
set(gca,'FontSize',14)
print('fuzzyEntropy-19moods-phase1', '-djpeg', '-r600')

figure
plot(E2(1:s:N2))
axis([1 ceil(N2/s) 0 inf])
xlabel('Time points') 
ylabel('Fuzzy entropy')
set(gca,'FontSize',14)
print('fuzzyEntropy-19moods-phase2', '-djpeg', '-r600')


figure
plot(E3(1:s:N3))
axis([1 ceil(N3/s) 0 inf])
xlabel('Time points') 
ylabel('Fuzzy entropy')
set(gca,'FontSize',14)
print('fuzzyEntropy-19moods-phase3', '-djpeg', '-r600')


figure
plot(E4(1:s:N4))
axis([1 ceil(N4/s) 0 inf])
xlabel('Time points') 
ylabel('Fuzzy entropy')
set(gca,'FontSize',14)
print('fuzzyEntropy-19moods-phase4', '-djpeg', '-r600')


figure
plot(E5(1:3:N5))
axis([1 ceil(N5/s) 0 inf])
xlabel('Time points') 
ylabel('Fuzzy entropy')
set(gca,'FontSize',14)
print('fuzzyEntropy-19moods-phase5', '-djpeg', '-r600')


% Phase-space reconstruction of entropy time series
eLag = 1;
eDim=2;


% Phase 1
figure
phaseSpaceReconstruction(E1,eLag,eDim);
print('fphaseSpace-19moods-phase1', '-djpeg', '-r600')
corDimE(1) = correlationDimension(E1,eLag,eDim);
%lyapunovExponent(E1);
lyapExpE(1) = lyapunovExponent(E1);

% Phase 2
figure
phaseSpaceReconstruction(E2,eLag,eDim);
print('fphaseSpace-19moods-phase2', '-djpeg', '-r600')
corDimE(2) = correlationDimension(E2,eLag,eDim);
%lyapunovExponent(E2);
lyapExpE(2) = lyapunovExponent(E2);

% Phase 3
figure
phaseSpaceReconstruction(E3,eLag,eDim);
print('fphaseSpace-19moods-phase3', '-djpeg', '-r600')
corDimE(3) = correlationDimension(E3,eLag,eDim);
%lyapunovExponent(E3);
lyapExpE(3) = lyapunovExponent(E3);

% Phase 4
figure
phaseSpaceReconstruction(E4,eLag,eDim);
print('fphaseSpace-19moods-phase4', '-djpeg', '-r600')
corDimE(4) = correlationDimension(E4,eLag,eDim);
%lyapunovExponent(E4);
lyapExpE(4) = lyapunovExponent(E4);

% Phase 5
figure
phaseSpaceReconstruction(E5,eLag,eDim);
print('fphaseSpace-19moods-phase5', '-djpeg', '-r600')
corDimE(5) = correlationDimension(E5,eLag,eDim);
%lyapunovExponent(E5);
lyapExpE(5) = lyapunovExponent(E5);

% Total phases
figure
phaseSpaceReconstruction(E,eLag,eDim);
print('fphaseSpace-19moods-all', '-djpeg', '-r600')
corDimT = correlationDimension(E,eLag,eDim);
% lyapExp = lyapunovExponent(X,fs,lag,dim)
% default: fs = 2pi, lag = 1, dim = 2
%lyapunovExponent(E);  % show plot
lyapExpT = lyapunovExponent(E);

%-------------------------------------------------
display(lyapExpT)
display(corDimT)

display(lyapExpE) 
display(corDimE)

