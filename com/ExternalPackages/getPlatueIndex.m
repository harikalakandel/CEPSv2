function[index]= getPlatueIndex(data,showGraph)


format long g;
%source https://uk.mathworks.com/matlabcentral/answers/324597-detecting-plateau-in-a-data
format compact;

fontSize = 20;



%y = [9.1382875;9.6605644;9.5544062;9.1403189;8.3296022;7.1736870;5.9494658;4.8966575;4.0415068;3.1646166;2.5283923;1.9758664;1.5139828;0.98420805;0.83403659;0.52328163;0.30553690;0.14569098;0.17771824;0.065542839;0.053332146;0.041690052;-0.057317857;0.044289846;-0.0055398578;-0.066662073;-0.032653969;-0.072456174;0.077120677;0.064909987;0.042586125;0.057097465;0.13626869;0.055818811;-0.10009535;0;0;0;0;0;0;0];
y=data;

if showGraph
    figure();
    subplot(2, 1, 1);
    plot(y, 'b.-', 'MarkerSize', 11);
    grid on;
    xlabel('Index', 'FontSize', fontSize);
    ylabel('Y Signal', 'FontSize', fontSize);
    title('Standard Deviation', 'FontSize', fontSize);
end


filteredSignal = stdfilt(y, ones(5, 1));



xMax = length(filteredSignal);

if showGraph

    subplot(2, 1, 2);
    plot(filteredSignal, 'b.-', 'MarkerSize', 11);
    grid on;
    xlim([1, xMax]);
    xlabel('Index', 'FontSize', fontSize);
    ylabel('Standard Deviation of Y', 'FontSize', fontSize);
    title('Standard Deviation', 'FontSize', fontSize);
end


% Find out where the standard deviation is less than 0.2

index = find(filteredSignal < 0.2, 1, 'first');
if showGraph
    % Draw a green patch over it
    yl = ylim
    hold on;
    patch([index, index, xMax, xMax, index],[yl(1), yl(2), yl(2), yl(1), yl(1)], 'g', 'FaceAlpha', 0.3);
    message = sprintf('The plateau indexes start at %d', index)
    uiwait(helpdlg(message));
end