function [rounded_data] = displayDiffusionEPlots(data,number_of_stripes,f1,f2,f3)

%close all
M = MyWork

% fig = figure(66)
% 
%  t=tiledlayout(fig,2,2);
%                 ax1=nexttile(t);
%                 ax2=nexttile(t);
%                 ax3=nexttile(t);
%                 ax4=nexttile(t);
             





%random_walk = M.sample_data(10000)

%data = random_walk
%data = load('file_1.txt');

if size(data,1)>1
    data = data';
end
% number_of_stripes = 40

rounded_data = M.apply_stripes(data, number_of_stripes);
%lines = np.linspace(rounded_data[2], rounded_data[3], num=number_of_stripes+1)
lines = linspace(rounded_data{1,3}, rounded_data{1,4}, number_of_stripes+1)
%rounded_lines = np.linspace(min(rounded_data[1]), max(rounded_data[1]), num=number_of_stripes+1)
rounded_lines = linspace(min(rounded_data{1,2}), max(rounded_data{1,2}), number_of_stripes+1)
%figure(1)
%f, (ax1, ax2) = plt.subplots(2, 1, sharex=True, figsize=(10, 5))
%subplot(2,1,1)
%ax1.plot(data)
plot(f1{1},data)
%ax1.xaxis.set_tick_params(labelbottom=True)
%ax1.set_ylabel('Data')
ylabel(f1{1},'Data')
%ax1.xaxis.grid(False)
grid(f1{1},'on')
%ax1.set_title("a", loc="left", fontweight="bold")
%sns.despine(left=True, ax=ax1)
%ax1.tick_params(bottom=True, length=5, color="#cccccc")

%ax2.plot(rounded_data[1])
%subplot(2,1,2)
plot(f1{2},rounded_data{1,2})
%ax2.hlines(xmin=0, xmax=len(data), y=rounded_lines, color="0.6", lw=1)

% ax2.set_xlabel('Time')
xlabel(f1{2},'Time')
% ax2.set_ylabel('Rounded data')
ylabel(f1{2},'Rounded data')
% ax2.grid(False)
grid(f1{2},'on')
% ax2.set_title("b", loc="left", fontweight="bold")
% sns.despine(ax=ax2, left=True)
% ax2.tick_params(left=True, bottom=True, length=5, color="#cccccc")
%
% f.tight_layout()
% plt.show()




%hd2 = figure(2)
%events = find_events(rounded_data[1]) 
  events = M.find_events(rounded_data{1,2})


%f, (ax1, ax2) = plt.subplots(2, 1, sharex=True, figsize=(10, 5))figure(2)
% %ax1.plot(rounded_data[1])
% 
% %subplot(2,1,1)
% plot(f1{3},rounded_data{1,2})
% % ax1.set_xticks(np.arange(0, len(rounded_data[0])+1, 0.1*(len(rounded_data[0]))))
% xticks(f1{3},[0:0.1*length(rounded_data{1,1}):length(rounded_data{1,1})])
% %ax1.hlines(xmin=0, xmax=len(data), y=rounded_lines, color="0.6", lw=1)
% xlim(f1{3},[0 length(data)]) %% ?????
% %ax1.xaxis.set_tick_params(labelbottom=True)
% %ax1.set_ylabel('Rounded data')
% ylabel(f1{3},'Rounded data')
% %ax1.grid(False)
% grid(f1{3},'off')
% % ax1.set_title("a", loc="left", fontweight="bold")
% % sns.despine(ax=ax1, left=True)
% % ax1.tick_params(left=True, bottom=True, length=5, color="#cccccc")
% 
% %ax2.stem(events, markerfmt="none", basefmt="C0-", use_line_collection=True)
% %subplot(2,1,2)
% stem(f1{4},events)
% %ax2.set_yticks([0, 1])
% yticks(f1{4},[0, 1])
% %ax2.set_xlabel("Time")
% xlabel(f1{4},"Time")
% %ax2.set_ylabel('Events')
% ylabel(f1{4},'Events')
% %ax2.xaxis.grid(False)
% grid(f1{4},'off')
% % ax2.set_title("b", loc="left", fontweight="bold")
% % sns.despine(ax=ax2, left=True)
% % ax2.tick_params(bottom=True, length=5, color="#cccccc")


% fig = figure(67)
% 
%  t=tiledlayout(fig,2,2);
%                 ax11=nexttile(t);
%                 ax12=nexttile(t);
%                 ax13=nexttile(t);
%                 ax14=nexttile(t);





%figure(3)
diffusion_trajectory = M.make_trajectory(events);


%f, (ax1, ax2) = plt.subplots(2, 1, sharex=True, figsize=(10, 5))

%ax1.stem(events, markerfmt="none", basefmt="C0-", use_line_collection=True)
%subplot(2,1,1)
stem(f2{1},events)
%ax1.set_xticks(np.arange(0, len(events)+1, 0.1*(len(events))))
xticks(f2{1},[0:0.1*length(events):length(events)]);
%ax1.xaxis.set_tick_params(labelbottom=True)
%ax1.set_yticks([0, 1])
yticks(f2{1},[0,1]);
%ax1.set_ylabel('Events')
ylabel(f2{1},'Events');
%ax1.xaxis.grid(False)
grid(f2{1},'off');
%ax1.set_title("a", loc="left", fontweight="bold")
%sns.despine(left=True)
%ax1.tick_params(bottom=True, length=5, color="#cccccc")

%subplot(2,1,2)

%% ??????????????
%ax2.step(np.arange(0, len(diffusion_trajectory), 1), diffusion_trajectory)
plot(f2{2},[1:length(diffusion_trajectory)], diffusion_trajectory)
% Matlab code ???? step([0:1:length(diffusion_trajectory)],diffusion_trajectory)
%ax2.set_xlabel('Time')
xlabel(f2{2},'Time')
%ax2.set_ylabel('Trajectory')
ylabel(f2{2},'Trajectory')
%ax2.xaxis.grid(False)
grid(f2{2},'off')
% ax2.set_title("b", loc="left", fontweight="bold")
% sns.despine(left=True)
% ax2.tick_params(bottom=True, length=5, color="#cccccc")

%f.tight_layout()
%plt.show()




%figure(4)
window_length = 100
[trajectory, slices] = M.demo_snapshots(diffusion_trajectory, window_length)


% vline_locs = np.arange(0, len(rounded_data[0])+1, 0.1*(len(rounded_data[0])))
 vline_locs = [1: 0.1*(length(rounded_data{1,1})):length(rounded_data{1,1})+2];
% 
% f, (ax1, ax2) = plt.subplots(1, 2, figsize=(10, 4.5))
% 

% ax1.plot(trajectory)
%subplot(2,1,1)
plot(f2{3},trajectory)
hold(f2{3},'on')
% ax1.vlines(vline_locs, 0, max(trajectory), linewidth=1, color='0.5', alpha=0.5)
%%???/
xline(f2{3},vline_locs);%,0,max(trajectory),'color',[0.5,1,1,0.5])
% ax1.set_xlabel('Time, with window positions')
xlabel(f2{3},'Time, with window positions')
% ax1.set_ylabel('Diffusion trajectory')
ylabel(f2{3},'Diffusion trajectory')
% ax1.set_title("a", loc="left", fontweight="bold")
% ax1.grid(False)
grid(f2{3},'off')
% sns.despine(left=True, ax=ax1)
% ax1.tick_params(bottom=True, left=True, length=5, color="#cccccc")
% 
%subplot(2,1,2)
%hold on

% for i in range(len(slices)-1):
%     ax2.plot(trajectory[slices[i]:slices[i+1]] - trajectory[slices[i]])
for i=1:length(slices)-1
    
    plot(f2{4},trajectory(1,slices(1,i):slices(1,i+1)-1)-trajectory(1,slices(1,i)));
    hold(f2{4},'on')
    
end
% ax2.set_xticks(ticks=slices[0:2])
%xticks(slices(1,1:3))
% ax2.set_xlabel('Window length')
xlabel(f2{4},'Window Length')
% ax2.set_ylabel('Displacement')
ylabel(f2{4},'Displacement')
% ax2.yaxis.grid(False)
grid(f2{4},'off')
% ax2.set_title("b", loc="left", fontweight="bold")
title(f2{4},'b')
% sns.despine(left=True, ax=ax2)
% ax2.tick_params(bottom=True, left=True, length=5, color="#cccccc")
% 
% f.tight_layout()
% plt.show()


%%%%% Displacement

%displacement = get_displacements(trajectory, window_length)
displacement = M.get_displacements(trajectory, window_length);

% fig = figure(68)
% 
%  t=tiledlayout(fig,1,2);
%  ax21=nexttile(t);
%  ax22=nexttile(t);




%figure(5)
% f, ax = plt.subplots(figsize=(5, 4))
% sns.histplot(displacement, stat='density', discrete=True)
histogram(f3{1},displacement)
% ax.set_xlabel('Displacement')
xlabel(f3{1},'Displacement')
% ax.set_ylabel('Probability Density')
ylabel(f3{1},'Probability Density')
% ax.xaxis.grid(False)
grid(f3{1},'off')
% sns.despine(left=True)
% ax.tick_params(bottom=True, length=5, color="#cccccc")
% 
% f.tight_layout()
% plt.show()




[s, L] = M.entropy(diffusion_trajectory)
%figure(6)
% f, ax = plt.subplots(figsize = (5, 4))
% ax.plot(L, s, linestyle='', marker='.', alpha=0.4)
plot(f3{2},L,s);

% ax.set_xscale('log')
% ax.set_xlabel('$ln(L)$')
xlabel(f3{2},'ln(L)')
% ax.set_ylabel('$S(L)$')
ylabel(f3{2},'$(L)')
% ax.grid(False)
grid(f3{2},'off')
title(f3{2},'Diffusion Trajectory')
% sns.despine(trim=True)
% ax.tick_params(which="major", bottom=True, left=True, length=5, color="#cccccc")
% ax.tick_params(which="minor", bottom=True, left=True, length=3, color="#cccccc")
% plt.show()








%  fit_start = 20;
%  fit_stop = max(size(data,2))
% %  fit = M.get_scaling(s, L, fit_start, fit_stop)
% [L_slice, coefficients] = M.get_scaling(s, L, fit_start, fit_stop);
% %mu = M.get_mu(fit[2][10])
% % 
% % f, ax = plt.subplots(figsize = (5, 4))
% ax.plot(L, s, linestyle='', marker='.', alpha=0.4)
% ax.plot(L, fit[1][0] * np.log(L) + fit[1][1], color='0.1',
% %         label='$\delta = {}$'.format(np.round(fit[1][0], 3)))
%  ax.set_xscale('log')
%  ax.set_xlabel('$ln(L)$')
%  ax.set_ylabel('$S(L)$')
%  ax.legend(loc=0)
%  ax.grid(False)
%  sns.despine(trim=True)
%  ax.tick_params(which="major", bottom=True, left=True, length=5, color="#cccccc")
%  ax.tick_params(which="minor", bottom=True, left=True, length=3, color="#cccccc")
%  plt.show()







end
