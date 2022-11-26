clear all
close all

addpath('Functions/')
%% INPUTS:
data = importdata('Sample Data/fft_signal_synthesized.mat'); % The fractal signal (this should be on column of data)
data = data(1:200,1);
order = 6; % highest order of DFA to be computed
config_num = 1; % 1 for un-modified DFA
dt = 1; % time interval
q = 2; % for normal DFA
SL = 95; % Significance level used to interpret r-DFA results (%)


%% DFA COMPUTATION (WHETHER R-DFA OR UNMODIFIED DFA)
tic
[windows, F_L_DFA, F_L_DFA_mod] = DFA_calc(order, q, config_num, data);
toc

%% ROBUST REGRESSION AND VISUALIZATION

colour = hsv(floor(order));
shape = ['o', '^', 's', '*', '<', '>'];
nstick=[2,2,2,2,2,2];

% Unmodified DFA
figure(1)
for ii = 1:order
    figure(1)
    hold on, h(ii,1) = loglog(windows{ii,1}*dt, F_L_DFA{ii,1},'color',colour(ii,:)),
    [co_robust_unmod{ii}, slope_rob_unmod{ii}] = PLR(log(windows{ii,1}*dt),log(F_L_DFA{ii,1}),1,SL);
    figure(1), hold on, xl = xlim;
    h(ii,2) = loglog(xl,exp(interp1(co_robust_unmod{ii}(:,1),co_robust_unmod{ii}(:,2),log(xl),'linear','extrap')),'color',[0.5 0.5 0.5]);
    set(gca,'Xscale','log','Yscale','log')
    legstr{ii}=strcat('DFA',num2str(ii));
end
title('Unmodified DFA Results')
xlabel('Scale (L)')
ylabel(strcat('q^{th} Moment Estimate F(L)^',num2str(q))), grid on
legend([h(:,1);h(1,2)],[legstr,'Robust Regression'],'Location','southeast')

% r-DFA (if required)
if config_num > 1 % i.e. modified DFA performed
    figure(2)
    for ii = 1:order
        figure(2), hold on,
        h(ii,3)=loglog(windows{ii,1}*dt, F_L_DFA_mod{ii,1},shape(ii),'color',colour(ii,:));
        set(gca,'Xscale','log','Yscale','log')
        xl = xlim; title('r-DFA Results'),
        xlabel('Scale (L)'), ylabel(strcat('q^{th} Moment Estimate F(L)^',num2str(q)))
        nstick = input(strcat('Enter the number of sticks to fit the r-DFA', num2str(ii),' just plotted: '));
        [co_robust{ii}, slope_rob{ii}] = PLR(log(windows{ii,1}*dt),log(F_L_DFA_mod{ii,1}),1,SL);
        figure(2), hold on,
        h(ii,4)=loglog(xl,exp(interp1(co_robust{ii}(:,1),co_robust{ii}(:,2),log(xl),'linear','extrap')),'color',[0.5 0.5 0.5]);
        set(gca,'Xscale','log','Yscale','log')
        [co{ii}, slope{ii}] = PLR(log(windows{ii,1}*dt),log(F_L_DFA_mod{ii,1}),nstick,SL);
        co{ii} = exp(co{ii});
        figure(2), hold on,
        h(ii,5)=loglog(co{ii}(:,1),co{ii}(:,2),'-*','color',colour(ii,:),'LineWidth',2);
        legstr{ii}=strcat('r-DFA',num2str(ii));
    end
    legend([h(:,5);h(1,4)],[legstr,'Robust Regression'],'Location','southeast')
    grid on
end


