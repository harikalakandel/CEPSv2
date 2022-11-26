%% Modified Diffusion Entropy  Analysis
%% https://github.com/garland-culbreth/Diffusion-Entropy-Analysis/blob/master/dea.ipynb
%% matlab conversion of dea.ipynb
function [rounded_data] = apply_stripes(data, stripes, show_plot)
%def apply_stripes(data, stripes, show_plot): 
%     """
%     Rounds `data` to `stripes` evenly spaced intervals.
% 
%     Parameters
%     ----------
%     data : array_like
%         Time-series data to be examined.
%     stripes : int
%         Number of stripes to apply. 
%     show_plot : bool
%         If True, show data plot with overlaid stripes.
% 
%     Returns
%     ----------
%     rounded_data : ndarray
%         `data` rounded to `stripes` number of equally spaced intervals.
%     """
%     
%     if show_plot == True:
%         lines = np.linspace(min(data), max(data), num=stripes)
%         plt.figure(figsize=(5, 4))
%         plt.plot(data)
%         plt.hlines(y=lines, xmin=0, xmax=len(data), colors='0.3', linewidths=1, alpha=0.4)
%         plt.xlabel('t')
%         plt.ylabel('Data(t)')
%         plt.title('Data with stripes')
%         sns.despine()
%         plt.show()
    
%     if min(data) <= 0:
%         data = data + abs(min(data))
%     elif min(data) > 0:
%         data = data - abs(min(data))

    if min(data) <=0
        data = data + abs(min(data))
    elseif min(data)>0
        data = data - abs(min(data))
    end

    max_data = max(data)
    min_data = min(data)
    data_width = abs(max_data - min_data)
    stripe_size = data_width / stripes
    rounded_data = data / stripe_size
   % return rounded_data
end


% def find_events(series):
%     """Records an event (1) when `series` changes value."""
function [events] = find_events(series)
    events = []
    %for i in range(1, len(series)):
    for i=2:size(series,1)+1
%         if (series[i] < np.floor(series[i-1])+1 and series[i] > np.ceil(series[i-1])-1):
%             # if both true, no crossing
        if series(i) < floor(series(i-1)+1 && series(i) > ceil(series(i-1))-1)
            %events.append(0)
            events=[events;0];
        else
            %events.append(1)
            events=[events;1];
        end
    end
    %np.append(events, 0)
    events=[events;0];
    %return events
end



%def make_trajectory(events):
function [trajectory]=make_trajectory(events)
    %"""Constructs diffusion trajectory from events."""
    %trajectory = np.cumsum(events)
    trajectory = cumsum(events);
    %return trajectory
end



%def entropy(trajectory):
function [S,window_lengths]=diff_entropy_A(trajectory)
%     """
%     Calculates the Shannon Entropy of the diffusion trajectory.
% 
%     Generates a range of window lengths L. Steps each one along 
%     'trajectory' and computes the displacement of 'trajectory' 
%     over each window position. Bins these displacements, and divides 
%     by the sum of all bins to make the probability distribution 'p'. 
%     Puts 'p' into the equation for Shannon Entropy to get s(L).
%     Repeats for all L in range 'window_lengths'.
% 
%     Parameters
%     ----------
%     trajectory : array_like
%         Diffusion trajectory. Constructed by make_trajectory.
% 
%     Returns
%     ----------
%     s : ndarray
%         Shannon Entropy values, S(L).
%     window_lengths : ndarray
%         Window lengths, L. 
% 
%     Notes
%     ----------
%     'tqdm(...)' makes the progress bar appear.
%     """
    S = []
    %window_lengths = np.arange(1, int(0.25*len(trajectory)), 1)
    window_lengths = [1:1:floor(0.25*length(trajectory))]
    %for L in tqdm(window_lengths):
    for L=window_lengths
        %window_starts = np.arange(0, len(trajectory)-L, 1)
        window_starts = [0:1:length(trajectory)-L];
        %window_ends = np.arange(L, len(trajectory), 1)
        window_ends = [L:1: length(trajectory)];
        %displacements = trajectory[window_ends] - trajectory[window_starts]
        displacements = trajectory(window_ends) - trajectory(window_starts);
        %counts, bin_edge = np.histogram(displacements, bins='doane')
        %% there is difference results in matlab hist and np.histogram
        %% ??? https://stackoverflow.com/questions/41869651/match-matlab-hist-with-numpy-histogram
        [counts,bin_edge]=hist(displacements)
        %counts = np.array(counts[counts != 0])
        counts = counts(count~=0)
        %binsize = bin_edge[1] - bin_edge[0]
        binsize = bin_edge(2) - bin_edge(1);
        P = counts / sum(counts)
       % S.append(-sum(P*np.log(P)) + np.log(binsize))
       S=[S;-sum(p*log(P))+ log(binsize)]
    %return S, window_lengths
    end
end


%def no_stripe_entropy(trajectory):
function[S, window_lengths]= no_stripe_entropy(trajectory)
%     """
%     Calculates the Shannon Entropy of the diffusion trajectory.
% 
%     Generates a range of window lengths L. Steps each one along 
%     'trajectory' and computes the displacement of 'trajectory' 
%     over each window position. Bins these displacements, and divides 
%     by the sum of all bins to make the probability distribution 'p'. 
%     Puts 'p' into the equation for Shannon Entropy to get s(L).
%     Repeats for all L in range 'window_lengths'.
% 
%     Parameters
%     ----------
%     trajectory : array_like
%         Diffusion trajectory. FOR NO STRIPES JUST PASS THE DATA SERIES.
% 
%     Returns
%     ----------
%     S : ndarray
%         Shannon Entropy values, S(L).
%     window_lengths : ndarray
%         Window lengths, L.
% 
%     Notes
%     ----------
%     `tqdm()` makes the progress bar appear.
%     """
    %window_lengths = np.arange(1, int(0.25*len(trajectory)), 1)
    window_lengths = [1:1:floor(0.25*length(trajectory))];
    S = []
    %for L in tqdm(window_lengths):
    for L =window_lengths
        %window_starts = np.arange(0, len(trajectory)-L, 1)
        window_starts = [0:1: length(trajectory)-L];
        %window_ends = np.arange(L, len(trajectory), 1)
        window_ends = [L:1: lenth(trajectory)];
        %traj = trajectory[window_starts] - trajectory[window_ends]
        traj = trajectory(window_starts+1) - trajectory(window_ends+1);
        %counts, bin_edge = np.histogram(traj, bins='doane')  # doane least bad for nongaussian
        %?????
        counts, bin_edge = hist(traj, bins);
        %counts = np.array(counts[counts != 0])
        counts = counts(counts ~= 0);
        %binsize = bin_edge[1] - bin_edge[0]
        binsize = bin_edge(2) - bin_edge(1);
        P = counts / sum(counts)
        %S.append(-sum(P*np.log(P)) + np.log(binsize))
        S=[S;append(-sum(P*log(P)) + log(binsize))];
    end
   % return S, window_lengths
end

%def get_scaling(S, L, start, stop):
function[L_slice, coefficients]= get_scaling(S,L, start, stop)
%     """
%     Calculates scaling.
%     
%     Calculates the scaling of the time-series by performing a 
%     least-squares linear fit over S(l) and ln(l).
% 
%     Parameters
%     ----------
%     s : array_like
%         Shannon Entropy values. 
%     L : array_like
%         Window Lengths. 
%     start : int
%         Index at which to start the fit slice.
%     stop : int
%         Index at which to stop the fit slice.
% 
%     Returns
%     ----------
%     L_slice : ndarray 
%         The slice of window lengths L.
%     coefficients : ndarray
%         Slope and intercept of the fit. 
% 
%     Notes
%     ----------
%     Least-squares linear fits on log scale data have issues, 
%     see doi:10.1371/journal.pone.0085777
%     Making a version that uses the powerlaw package instead 
%     would be better...
%     """
    %S_slice = S[start:stop]
    S_slice = S(start+1:stop+1);
    %L_slice = L[start:stop]
    L_slice = L(start+1:stop+1)
    %coefficients = np.polyfit(np.log(L_slice), S_slice, 1)
    coefficients =polyfit(log(L_slice), S_slice, 1)
    %return L_slice, coefficients
end

%def get_mu(delta):
function [mu1,mu2]=get_mu(delta)
%     """
%     Calculates the mu.
% 
%     Parameters
%     ----------
%     delta : float
%         Scaling of the time-series process. 
% 
%     Returns
%     ----------
%     mu : float
%         Complexity parameter. Powerlaw index for inter-event 
%         time distribution.
%     Notes
%     ----------
%     mu is calculated by both rules. later both are plotted
%     against the line relating delta and mu, to hopefully
%     let users graphically determine the correct mu.
%     """
    mu1 = 1 + delta
    mu2 = 1 + (1 / delta)
    %return mu1, mu2
end



%def plot_results(L, S, x_interval, slope, y_intercept, mu):
function[hd1]= plot_results(L, S, x_interval, slope, y_intercept, mu)

    %"""testing a plotting function"""
    %fig, ax = plt.subplots()
    hd1 = figure();
    
%     subplot(L, S, linestyle='', marker='.')
%     ax.plot(x_interval, slope * np.log(x_interval) + y_intercept, color='k',
%             label='$\delta = $'+str(np.round(slope, 2)))
%     ax.plot([], [], linestyle='',label='$\mu = $'+str(np.round(mu, 2)))

    plot(hd1,L, S, linestyle='', marker='.')
    hold on
    label=strcat('$\delta = $',num2str(round(slope, 2)))
    plot(hd1,x_interval, slope *log(x_interval) + y_intercept, color='k')
    plot(hd1,[], [], linestyle='',label=strcat('$\mu = $',num2str(round(mu, 2))))


    %return ax

end


