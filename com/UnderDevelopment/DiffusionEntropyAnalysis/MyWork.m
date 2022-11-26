classdef MyWork
    %MYWORK Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Property1
        
        % = get_scaling(S, L, start, stop)


    end

    methods
        function [retVal] = apply_stripes(obj,data, stripes, show_plot)
            %def apply_stripes(data, stripes, show_plot):
            %     """
            %     Rounds `data` to `stripes` evenly spaced intervals.
            %
            %     Parameters
            %     ----------7616


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
            % return data, rounded_data, min_data, max_data
            retVal{1,1}=data
            retVal{1,2}=rounded_data
            retVal{1,3}=min_data
            retVal{1,4}=max_data
            MyWork.rounded_data = rounded_data;
        end


        % def find_events(series):
        %     """Records an event (1) when `series` changes value."""
        function [events] = find_events(obj,series)
            events = []
            %for i in range(1, len(series)):
            for i=2:size(series,2)
                %         if (series[i] < np.floor(series[i-1])+1 and series[i] > np.ceil(series[i-1])-1):
                %             # if both true, no crossing
                if (series(1,i) < (floor(series(1,i-1)+1)) && (series(1,i) > ceil(series(1,i-1))-1))
                    %events.append(0)
                    events=[events 0];
                else
                    %events.append(1)
                    events=[events 1];
                end
            end
            %np.append(events, 0)
            events=[events 0];
           
        end



        %def make_trajectory(events):
        function [trajectory]=make_trajectory(obj,events)
            %"""Constructs diffusion trajectory from events."""
            %trajectory = np.cumsum(events)
            trajectory = cumsum(events);
            MyWork.diffusion_trajectory = trajectory;
            %return trajectory
        end



        %def entropy(trajectory):
        function [S,window_lengths]=entropy(obj,trajectory)
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
            S = [];
            %window_lengths = np.arange(1, int(0.25*len(trajectory)), 1)
            window_lengths = [1:1:floor(0.25*length(trajectory))-1];
            %for L in tqdm(window_lengths):
            for L=window_lengths
                %window_starts = np.arange(0, len(trajectory)-L, 1)
                window_starts = [1:1:length(trajectory)-L];
                %window_ends = np.arange(L, len(trajectory), 1)
                window_ends = [L+1:1: length(trajectory)];
                %displacements = trajectory[window_ends] - trajectory[window_starts]
                displacements = trajectory(window_ends) - trajectory(window_starts);
                %counts, bin_edge = np.histogram(displacements, bins='doane')
                %% there is difference results in matlab hist and np.histogram
                %% ??? https://stackoverflow.com/questions/41869651/match-matlab-hist-with-numpy-histogram
                [counts,bin_edge]=histcounts(displacements);
                %counts = np.array(counts[counts != 0])
                counts = counts(counts~=0);
                %binsize = bin_edge[1] - bin_edge[0]
                binsize = bin_edge(2) - bin_edge(1);
                P = counts / sum(counts);
                % S.append(-sum(P*np.log(P)) + np.log(binsize))
                S=[S;-sum(P.*log(P))+ log(binsize)];
                %return S, window_lengths
            end

            MyWork.S=S;
            MyWork.L=window_lengths;
        end

        %def demo_snapshots(trajectory, window_length):
        function[trajectory, slices]= demo_snapshots(obj,trajectory, window_length)
            %slices = np.arange(0, len(trajectory)+2, window_length)
            slices = [1:window_length:length(trajectory)+2];
            %return trajectory, slices
        end


        %def no_stripe_entropy(trajectory):
        function[S, window_lengths]= no_stripe_entropy(obj,trajectory)
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
                window_ends = [L:1: length(trajectory)];
                %traj = trajectory[window_starts] - trajectory[window_ends]
                %%?? indexing error here
                traj = trajectory(window_starts+1) - trajectory(window_ends);
                %counts, bin_edge = np.histogram(traj, bins='doane')  # doane least bad for nongaussian
                %?????
                [counts, bin_edge] = hist(traj);
                %counts = np.array(counts[counts != 0])
                counts = counts(counts ~= 0);
                %binsize = bin_edge[1] - bin_edge[0]
                binsize = bin_edge(2) - bin_edge(1);
                P = counts / sum(counts)
                %S.append(-sum(P*np.log(P)) + np.log(binsize))
                S=[S;-sum(P*log(P)) + log(binsize)];
            end
            % return S, window_lengths
        end


        %     def get_displacements(trajectory, L):
        function[displacements] = get_displacements(obj,trajectory,L)
            %     displacements = []
            displacements = []
            %     for i in range(len(trajectory)-L):
            for i =1:length(trajectory)-L

                %         displacements.append(trajectory[i+L] - trajectory[i])
                displacements=[displacements trajectory(1,i+L)-trajectory(1,i)];
            end
            %     return displacements

        end





        %def get_scaling(S, L, start, stop):
        function[L_slice, coefficients]= get_scaling(obj,S,L, start, stop)
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
            try
                S_slice = S(start+1:stop);
            catch
                S_slice = S(start+1:stop);
            end
            %L_slice = L[start:stop]
            L_slice = L(start+1:stop)
            %coefficients = np.polyfit(np.log(L_slice), S_slice, 1)
            coefficients =polyfit(log(L_slice), S_slice, 1)
            %return L_slice, coefficients
        end

        % %             %def get_mu(delta):
        % %             function [mu1,mu2]=get_mu(obj,delta)
        % %                 %     """
        % %                 %     Calculates the mu.
        % %                 %
        % %                 %     Parameters
        % %                 %     ----------
        % %                 %     delta : float
        % %                 %         Scaling of the time-series process.
        % %                 %
        % %                 %     Returns
        % %                 %     ----------
        % %                 %     mu : float
        % %                 %         Complexity parameter. Powerlaw index for inter-event
        % %                 %         time distribution.
        % %                 %     Notes
        % %                 %     ----------
        % %                 %     mu is calculated by both rules. later both are plotted
        % %                 %     against the line relating delta and mu, to hopefully
        % %                 %     let users graphically determine the correct mu.
        % %                 %     """
        % %                 mu1 = 1 + delta
        % %                 mu2 = 1 + (1 / delta)
        % %                 %return mu1, mu2
        % %             end

        %                 def get_mu(delta):
        function[mu]=get_mu(delta)
            %                     """
            %                     Calculates mu (powerlaw index of inter-event time distribution).
            %                     Parameters
            %                     ----------
            %                     delta : float
            %                         Scaling of the time-series process.
            %                     Returns
            %                     ----------
            %                     mu : float
            %                         Complexity parameter. Powerlaw index for inter-event time
            %                         distribution.
            %                     """
            %                     mu = 1 + (1 / delta)
            mu = 1 + (1/delta);
            %                     if mu > 3:
            if mu > 3

                %                         mu = 1 + delta
                mu = 1+delta
            end
            %                     return
        end


        %def plot_results(L, S, x_interval, slope, y_intercept, mu):
        function[hd1]= plot_results(obj,L, S, x_interval, slope, y_intercept, mu)

            %"""testing a plotting function"""
            %fig, ax = plt.subplots()
            hd1 = figure();

            %     subplot(L, S, linestyle='', marker='.')
            %     ax.plot(x_interval, slope * np.log(x_interval) + y_intercept, color='k',
            %             label='$\delta = $'+str(np.round(slope, 2)))
            %     ax.plot([], [], linestyle='',label='$\mu = $'+str(np.round(mu, 2)))

            plot(L, S, linestyle='--', marker='.')
            hold on
            label=strcat('$\delta = $',num2str(round(slope, 2)))
            plot(x_interval, slope *log(x_interval) + y_intercept, color='k')
            %plot([], [], linestyle='--')
            xlabel(strcat('$\mu = $',num2str(round(mu, 2))))


            %return ax

        end

        %def plot_mu_candidates(delta, mu1, mu2):
        function plot_mu_candidates(obj,delta,mu1,mu2)


            %     x1 = np.linspace(1, 2, 100)
            %     x2 = np.linspace(2, 3, 100)
            %     x3 = np.linspace(3, 4, 100)

            x1 = linspace(1, 2, 100);
            x2 = linspace(2, 3, 100);
            x3 = linspace(3, 4, 100);



            y1 = x1 - 1;
            y2 = 1 ./ (x2 - 1);
            %y3 = np.full(100, 0.5)
            y3 = ones(1,100)*0.5;

            %fig, ax = plt.subplots(figsize=(5, 4))
            ax = figure;

            %ax.plot(x1, y1, color='k')
            subplot(5,1,1)
            plot(x1, y1, color='k')
            %ax.plot(x2, y2, color='k')
            subplot(5,1,2)
            plot(x2, y2, color='k')
            %ax.plot(x3, y3, color='k')
            subplot(5,1,3)
            plot(x3, y3, color='k')
            subplot(5,1,4)
            %ax.plot(mu1, delta, marker='o',label='$\\mu$ = '+str(np.round(mu1, 2)))
            %plot(mu1, delta, marker='o',label=strcat(' mu '+num2str(round(mu1, 2))))

            plot(mu1, delta, marker='o')
            subplot(5,1,5)
            %ax.plot(mu2, delta, marker='o',label='$\\mu$ = '+str(np.round(mu2, 2)))
            %plot(mu2, delta, marker='o',label=strcat('mu ', num2str(round(mu2, 2))))
            plot(mu2, delta, marker='X')
            %ax.set_xticks(ticks=np.linspace(1, 4, 7))
            %xticks(ticks=linspace(1, 4, 7))

            xticks(linspace(1, 4, 7))
            %xticklabels({'x = 0','x = 5','x = 10'})


            %ax.set_yticks(ticks=np.linspace(0, 1, 5))
            yticks(linspace(0, 1, 5))
            %ax.set_xlabel('$\\mu$')
            xlabel('$\\mu$')
            %ax.set_ylabel('$\\delta$')
            ylabel('$\\delta$')
            legend("loc=0")
            %% grid(True) %% ??
            %%sns.despine(left=True, bottom=True) ???
            %plt.show(fig)
            %return None
        end



        %def dea_no_stripes(data, start, stop):
        function dea_no_stripes(obj,data, start, stop)

            %     """
            %     Applies DEA without the stripes refinement.
            %
            %     Original DEA. Takes the original time series as the diffusion
            %     trajectory.
            %
            %     Parameters
            %     ----------
            %     data : array_like
            %         Time-series to be analysed.
            %     start : int
            %         Array index at which to start linear fit.
            %     stop : int
            %         Array index at which to stop linear fit.
            %
            %     Returns
            %     ----------
            %     figure
            %         A figure plotting S(l) vs. ln(l), overlaid with the fit
            %         line, labelled with the scaling and mu values.
            %     """
            [S, L] = no_stripe_entropy(data)
            fit = get_scaling(S, L, start, stop)
            %   mu = get_mu(fit[1][0])
            mu = get_mu(fit(1,1)) %% ????
            fig = figure
            %     fig, ax = plt.subplots(figsize=(5, 4))
            %     ax.plot(L, S, linestyle='', marker='.', alpha=0.5)
            subplot(3,1,1)
            plot(L, S, 'o-','color',[1,0,0,0.5])
            %     ax.plot(fit[0], fit[1][0] * np.log(fit[0]) + fit[1][1], color='k',
            %              label='$\delta = {}$'.format(np.round(fit[1][0], 2)))
            subplot(3,1,2)
            plot(fit(1,:),fit(2,1)*log(fit(1,:)+fit(2,2)),'color','k')
            %     ax.plot([], [], linestyle='',
            %              label='$\mu = {}$'.format(np.round(mu, 2)))
            subplot(3,1,3)
            % ????
            %     ax.xscale('log')
            %     ax.xlabel('$ln(l)$')
            xlabel('log(l)')
            %     ax.ylabel('$S(l)$')
            ylabel('l')
            %     ax.legend(loc=0)
            %     ax.grid(False)
            %     ax.tick_params(which="major", bottom=True, left=True, length=5,
            %                    color="#cccccc")
            %     ax.tick_params(which="minor", bottom=True, left=True, length=3,
            %                    color="#cccccc")
            %     sns.despine(trim=True)
            %     plt.show(fig)
            %     return None

        end


        %def dea_with_stripes(data, stripes, start, stop, data_plot):
        function dea_with_strips(obj,data,stripes,start,stop, data_plot)
            %     """
            %     Applies DEA with the stripes refinement.
            %
            %     Runs a sequence of functions to apply stripes and then
            %     perform DEA on the data series.
            %
            %     Parameters
            %     ----------
            %     data : array_like
            %         Time-series to be analysed.
            %     stripes : int
            %         Number of stripes to be applied to the data.
            %     start : int
            %         Array index at which to start linear fit.
            %     stop : int
            %         Array index at which to stop linear fit.
            %     data_plot : bool
            %         If True, show data plot with overlaid stripes.
            %
            %     Returns
            %     ----------
            %     fig : figure
            %         A figure plotting S(l) vs. ln(l), overlaid with the fit
            %         line, labelled with the scaling and mu values.
            %     """
            rounded_data = apply_stripes(data, stripes, data_plot)
            event_array = find_events(rounded_data)
            diffusion_trajectory = make_trajectory(event_array)
            %s, L = entropy(diffusion_trajectory)
            [s, L] = entropy(diffusion_trajectory)
            fit = get_scaling(s, L, start, stop)
            %mu = get_mu(fit[1][0])
            mu = get_mu(fit(2,1))
            %fig, ax = plt.subplots(figsize=(5, 4))
            fig = figure
            subplot(2,1,1)
            %ax.plot(L, s, linestyle='', marker='.', alpha=0.5)
            plot(L,s,'.-','color',[0,0,1,0.5])
            %ax.plot(fit[0], fit[1][0] * np.log(fit[0]) + fit[1][1], color='k',
            %label='$\delta = $'+str(np.round(fit[1][0], 2)))
            subplot(2,1,2)
            plot(fit(1,:),fit(2,1)*log(fit(1,:))+fit(2,2),'color','k') %% ??
            %     ax.set_xscale('log')
            %     ax.set_xlabel('$ln(L)$')
            %     ax.set_ylabel('$S(L)$')
            %     ax.legend(loc=0)
            %     ax.grid(False)
            %     ax.tick_params(which="major", bottom=True, left=True, length=5,
            %                    color="#cccccc")
            %     ax.tick_params(which="minor", bottom=True, left=True, length=3,
            %                    color="#cccccc")
            %     sns.despine(trim=True)
            %     plt.show(fig)

            %    plot_mu_candidates(fit[1][0], mu[0], mu[1])
            plot_mu_candidates(fit(2,1),mu(1,:),mu(2,:))
            %   return None

        end

        %def sample_data(length):
        function [random_walk]= sample_data(obj,length)
            %"""Generates an array of sample data."""
            %     np.random.seed(1010)  # for baseline consistency


            %     random_steps = np.random.choice([-1, 1], length)
            A=[-1,1]
            random_steps=[];
            for i=1:length
                random_steps=[random_steps A(randperm(2,1))];
            end

            %     random_steps[0] = 0  # always start from 0
            random_steps(1,1)=0
            %     random_walk = np.cumsum(random_steps)
            random_walk = cumsum(random_steps)
            %     return random_walk

        end




%         %
%         %             def dea_with_stripes(data, stripes, start, stop, data_plot):
%         function dea_with_strips(data,fit,strips,start,stop,fig)
%             %     """
%             %     Applies DEA with the stripes refinement.
%             %     Runs a sequence of functions to apply stripes and then perform
%             %     DEA on the data series.
%             %     Parameters
%             %     ----------
%             %     data : array_like
%             %         Time-series to be analysed.
%             %     stripes : int
%             %         Number of stripes to be applied to the data.
%             %     start : int
%             %         Array index at which to start linear fit.
%             %     stop : int
%             %         Array index at which to stop linear fit.
%             %     data_plot : int
%             %         If 1, show data plot with overlaid stripes.
%             %     Returns
%             %     ----------
%             %     fig : figure
%             %         A figure plotting S(l) vs. ln(l), overlaid with the fit line,
%             %         labelled with the scaling and mu values.
%             %     """
%             %     rounded_data = apply_stripes(data, stripes, data_plot)
% 
%             %     event_array = find_events(rounded_data)
% 
%             %     diffusion_trajectory = make_trajectory(event_array)
% 
%             %     S, L = entropy(diffusion_trajectory)
% 
%             %     fit = get_scaling(S, L, start, stop)
% 
%             %     mu = get_mu(fit[1][0])
% 
%             %
%             %     fig = plt.figure(figsize=(6, 5))
%             %     plt.plot(L, S, linestyle='', marker='.')
%             %     plt.plot(fit[0], fit[1][0]*np.log(fit[0]) + fit[1][1],
%             %              color='k', label='$\\delta = $'+str(np.round(fit[1][0], 2)))
%             %     plt.plot([], [], linestyle='', label='$\\mu = $'+str(np.round(mu, 2)))
%             %     plt.xscale('log')
%             %     plt.xlabel('$ln(L)$')
%             %     plt.ylabel('$S(L)$')
%             %     plt.legend(loc=0)
%             %     return fig
%         end













    end
end

