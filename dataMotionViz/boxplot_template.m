% Data for SD
AUD_SD = [0.27512
0.4372
0.26784
0.47078
0.22731
0.27953
0.21355
0.33879
0.57529
0.26563
0.46107
0.32507
0.25191
0.45722
0.20148
0.30142
0.22456
0.29466
0.032033
0.22489
0.33886
0.21723
0.32151
0.27523
0.17707
0.2895
0.45235
0.18036
0.76224
0.50088
1.2892
0.33999
0.23055
0.30304
0.22643];
VIS_SD = [0.12911
1.2164
1.1077
0.31181
0.38456
0.8688
0.25127
0.13106
0.82861
0.35632
0.43908
0.21289
0.39296
2.2038
0.1602
0.45691
0.29228
2.0834
0.0168665
0.66047
0.17655
0.3873
0.32601
0.47192
0.33141
0.33894
0.26337
0.65264
0.2919
0.14771
0.725
0.63371
0.52504
1.8038
0.47833];

% Combine into a single matrix
sd_data = [AUD_SD, VIS_SD];

% Create box plots for SD data
figure;
h = boxplot(sd_data, 'Labels', {'AUD SD', 'VIS SD'});
title('Box Plots for Auditory and Visual SD');
ylabel('SD Values');

% Color the boxes
set(h, {'linew'}, {2});
colors = {'b', 'r'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
   patch(get(h(j), 'XData'), get(h(j), 'YData'), colors{j}, 'FaceAlpha', 0.5);
end

% Add individual data points for SD
hold on;
scatter(ones(size(AUD_SD)), AUD_SD, 'r', 'filled', 'SizeData', 70);
scatter(2 * ones(size(VIS_SD)), VIS_SD, 'b', 'filled', 'SizeData', 70);

% Connect corresponding column values with a line for SD
for i = 1:length(AUD_SD)
    plot([1, 2], [AUD_SD(i), VIS_SD(i)], 'k-', 'LineWidth', 1.5); % Thicker black line
end

hold off;
grid on;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

