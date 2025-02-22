%% Group Data Analysis %%%%
% Adam Tiesman - 04/09/2024 
% 
% This script reads an excel file with individual participant data and
% performs group level analysis on the data.

clear;
close all;
clc;

%% Read in the excel file
dataAll = readtable('group_perf_data.xlsx',  'Sheet', 'data_to_analyze');

AUD_SD = table2array(dataAll(:, 9));
VIS_SD = table2array(dataAll(:, 10));
AUD_Mu = table2array(dataAll(:, 11));
VIS_Mu = table2array(dataAll(:, 12));


meanAUD_SD = mean(AUD_SD); medianAUD_SD = median(AUD_SD);
meanVIS_SD = mean(VIS_SD); medianVIS_SD = median(VIS_SD);

% Combine into a single matrix
sd_data = [AUD_SD, VIS_SD];

% Create box plots for SD data
figure;
h = boxplot(sd_data, 'Labels', {'Auditory', 'Visual'});
title('Auditory and Visual Standard Deviation (Sensitivity)');
ylabel('SD');

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

% Compute the differences in individual's SD
sd_diff = sd_data(:,1) - sd_data(:,2);
same_slope = [];
for i = 1:length(sd_diff)
    if -0.1 <= sd_diff(i) && sd_diff(i) <= 0.1
        same_slope = [same_slope sd_diff(i)]; 
    end
end

for i = 1:length(same_slope)
    same_indices = find(sd_diff == same_slope(i));
end

% Run a paired ttest on data to test for significant difference
[h_std, p_std] = ttest(AUD_SD, VIS_SD);
fprintf('Paired t-test = %d\n', h_std);
fprintf('Aud std and Vis std - p-value: %f\n', p_std);

% Add significance indicator if significant
if h_std == 1  % If test indicates significance
    ylims = get(gca, 'YLim');
    text(1.5, ylims(2)-0.3, '*', 'FontSize', 44, 'HorizontalAlignment', 'center'); % Place asterisk
    % Draw line
    %line([1,2], [ylims(2)-0.5, ylims(2)-0.5], 'Color', 'k'); % Adjust line position as needed
end

meanAUD_Mu = mean(AUD_Mu); medianAUD_Mu = median(AUD_Mu);
meanVIS_Mu = mean(VIS_Mu); medianVIS_Mu = median(VIS_Mu);

% Combine into a single matrix
mu_data = [AUD_Mu, VIS_Mu];

% Create box plots for Mu data
figure;
h = boxplot(mu_data, 'Labels', {'Auditory', 'Visual'});
title('Auditory and Visual Mu (PSE)');
ylabel('Mu');

% Color the boxes
set(h, {'linew'}, {2});
colors = {'b', 'r'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
   patch(get(h(j), 'XData'), get(h(j), 'YData'), colors{j}, 'FaceAlpha', 0.5);
end

% Add individual data points for Mu
hold on;
scatter(ones(size(AUD_Mu)), AUD_Mu, 'r', 'filled', 'SizeData', 70);
scatter(2 * ones(size(VIS_Mu)), VIS_Mu, 'b', 'filled', 'SizeData', 70);

% Connect corresponding column values with a line for Mu
for i = 1:length(AUD_Mu)
    plot([1, 2], [AUD_Mu(i), VIS_Mu(i)], 'k-', 'LineWidth', 1.5); % Thicker black line
end

hold off;
grid on;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

% Run a paired ttest on data to test for significant difference
[h_mu, p_mu] = ttest(AUD_Mu, VIS_Mu);
fprintf('Paired t-test = %d\n', h_mu);
fprintf('Aud mu and Vis mu - p-value: %f\n', p_mu);

% Add significance indicator if significant
if h_mu == 1  % If test indicates significance
    ylims = get(gca, 'YLim');
    text(1.5, ylims(2)-0.9, '*', 'FontSize', 44, 'HorizontalAlignment', 'center'); % Place asterisk
    % Draw line
    %line([1,2], [ylims(2)-0.5, ylims(2)-0.5], 'Color', 'k'); % Adjust line position as needed
end

AV_perf = table2array(dataAll(:, 15));
maxA_V = table2array(dataAll(:, 20));

AVacc_diff = AV_perf - maxA_V;

acc_data = [maxA_V, AV_perf];

% Create box plots for SD data
figure;
h = boxplot(acc_data, 'Labels', {'Best Unisensory', 'Audiovisual'});
title('Best Unisensory and Audiovisual Accuracies');
ylabel('Accuracy');

% Color the boxes
set(h, {'linew'}, {2});
colors = {'m', 'g'}; % Red for AUD, Blue for VIS
h = findobj(gca, 'Tag', 'Box');
for j = 1:length(h)
   patch(get(h(j), 'XData'), get(h(j), 'YData'), colors{j}, 'FaceAlpha', 0.5);
end

% Add individual data points for SD
hold on;
scatter(ones(size(maxA_V)), maxA_V, 'g', 'filled', 'SizeData', 70);
scatter(2 * ones(size(AV_perf)), AV_perf, 'm', 'filled', 'SizeData', 70);

% Connect corresponding column values with a line for SD
for i = 1:length(maxA_V)
    plot([1, 2], [maxA_V(i), AV_perf(i)], 'k-', 'LineWidth', 1.5); % Thicker black line
end

hold off;
grid on;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)

% Run a paired ttest on data to test for significant difference
[h, p] = ttest(maxA_V, AV_perf);
fprintf('Paired t-test = %d\n', h);
fprintf('Max A,V and AV - p-value: %f\n', p);

% Add significance indicator if significant
if h == 1  % If test indicates significance
    ylims = get(gca, 'YLim');
    text(1.5, ylims(2)-0.7, '*', 'FontSize', 44, 'HorizontalAlignment', 'center'); % Place asterisk
    % Draw line
    %line([1,2], [ylims(2)-0.5, ylims(2)-0.5], 'Color', 'k'); % Adjust line position as needed
end

SDRatio = table2array(dataAll(:,24));
MSGain = table2array(dataAll(:,21));
Violation = table2array(dataAll(:,26));
AudWeight = table2array(dataAll(:,28));
AudCoh = table2array(dataAll(:,5));
AOAcc = table2array(dataAll(:,13));
VisWeight = table2array(dataAll(:,29));
VisCoh = table2array(dataAll(:,6));
VOAcc = table2array(dataAll(:,14));
Anoise_Ratio = table2array(dataAll(:,31));

% figure; hold on;
% scatter(maxA_V, MSGain, 'k', 'filled', 'SizeData', 70);
% ylabel('MS Gain');
% xlabel('Max A,V Accuracy');
% title('Scatter between Max A,V and MS Gain');
% beautifyplot;
% 
% figure; hold on;
% scatter(AudWeight, MSGain, 'k', 'filled', 'SizeData', 70);
% ylabel('MS Gain');
% xlabel('Aud Weight');
% title('Scatter between Aud/Vis Weight and MS Gain');
% beautifyplot;
% 
% figure; hold on;
% scatter(AUD_SD, AUD_Mu, 'k', 'filled', 'SizeData', 70);
% ylabel('Aud MU');
% xlabel('Aud STD');
% title('Scatter between Aud Coh and Acc');
% beautifyplot;
% 
% figure; hold on;
% scatter(VisCoh, VOAcc, 'k', 'filled', 'SizeData', 70);
% ylabel('Vis Acc');
% xlabel('Vis Coh');
% title('Scatter between Vis Coh and Acc');
% beautifyplot;
% 
% figure; hold on;
% scatter(AudWeight, Anoise_Ratio, 'k', 'filled', 'SizeData', 70);
% ylabel('Ratio Anoise');
% xlabel('Aud Weight');
% title('Scatter between Aud Weight and Anoise Ratio');
% beautifyplot;
% 
% figure; hold on;
% scatter(Anoise_Ratio, MSGain, 'k', 'filled', 'SizeData', 70);
% ylabel('MS Gain');
% xlabel('Ratio Anoise');
% title('Scatter between Anoise Ratio and MS Gain');
% beautifyplot;


% Define logical conditions for each category
weight1 = 0.4;
weight2 = 0.6;
dataAll_raw = table2array(dataAll);
conditionEqual = dataAll_raw(:,28) > weight1 & dataAll_raw(:,28) < weight2;
conditionVis = dataAll_raw(:,28) <= weight1;
conditionAud = dataAll_raw(:,28) >= weight2;

% Create separate arrays based on conditions
EqualReliabilities = dataAll_raw(conditionEqual, :);
VisCapture = dataAll_raw(conditionVis, :);
AudCapture = dataAll_raw(conditionAud, :);

group1_Av_stim = EqualReliabilities(:, 16);
group1_aV_stim = EqualReliabilities(:, 17);
group2_Av_stim = AudCapture(:, 16);
group2_aV_stim = AudCapture(:, 17);
group3_Av_stim = VisCapture(:, 16);
group3_aV_stim = VisCapture(:, 17);

group1_AO = EqualReliabilities(:, 13);
group2_AO = AudCapture(:, 13);
group3_AO = VisCapture(:, 13);

group1_VO = EqualReliabilities(:, 14);
group2_VO = AudCapture(:, 14);
group3_VO = VisCapture(:, 14);

% Create a scatter plot with different shapes and colors for each group
figure;
hold on;
scatter(group1_AO, group1_Av_stim, 500, 'o', 'filled', 'DisplayName', 'Equal Reliabilities');
scatter(group2_AO, group2_Av_stim, 500, '^', 'filled', 'DisplayName', 'Auditory Capture');
scatter(group3_AO, group3_Av_stim, 500, 's', 'filled', 'DisplayName', 'Visual Capture');

% Set labels and legend
xlabel('AO Accuracy');
ylabel('AV Accuracy (Stim Matched A)');
xlim([0.3 1]);
ylim([0.3 1]);
axis equal
legend('show', 'Location', 'northwest');
beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44)
hold off;

% Create a scatter plot with different shapes and colors for each group
figure;
hold on;
scatter(group1_VO, group1_aV_stim, 500, 'o', 'filled', 'DisplayName', 'Equal Reliabilities');
scatter(group2_VO, group2_aV_stim, 500, '^', 'filled', 'DisplayName', 'Auditory Capture');
scatter(group3_VO, group3_aV_stim, 500, 's', 'filled', 'DisplayName', 'Visual Capture');

% Set labels and legend
xlabel('VO Accuracy');
ylabel('AV Accuracy (Stim Matched V)');
xlim([0.3 1]);
ylim([0.3 1]);
axis equal
legend('show', 'Location', 'northwest');
beautifyplot;
set(gca, 'XTickLabelRotation', 45);
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 44)
hold off;

figure; hold on;
scatter(Anoise_Ratio, MSGain, 'k', 'filled', 'SizeData', 70);
ylabel('MS Gain');
xlabel('Ratio Anoise');
title('Scatter between Anoise Ratio and MS Gain');
beautifyplot;



% Assuming AudWeight and VisualWeight arrays are available
VisualWeight = VisWeight;

% Define properties for both histograms
numBins = 50;
binEdges = linspace(0, 1, numBins + 1);

% Create a figure with a tiled layout for perfect alignment
figure;
tiledlayout(2, 1, 'TileSpacing', 'none', 'Padding', 'none');

% Auditory weight histogram (top)
nexttile;
histogram(AudWeight, binEdges, 'FaceColor', 'r', 'DisplayName', 'Auditory Weights');
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24);
grid on;
xlim([0 1]);
legend('show', 'Location', 'northwest');

% Visual weight histogram (bottom, mirrored)
nexttile;
h = histogram(VisWeight, binEdges, 'FaceColor', 'b', 'DisplayName', 'Visual Weights');
ylim = get(gca, 'YLim'); % Get the y-axis limits of the visual weight histogram
set(gca, 'YDir', 'reverse', 'YLim', ylim); % Invert the y-axis
xlabel('Weight');
ylabel('Frequency');
grid on;
xlim([0 1]);
legend('show', 'Location', 'southwest');

% Set uniform properties for both plots
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24);
set(gca, 'XTickLabelRotation', 45);





% figure; % Create a new figure window
% histogram(AUD_SD, 100, 'FaceColor', 'r'); 
% title('Distribution of Auditory SD');
% xlabel('SD');
% xlim([0 1]);
% ylim([0 10]);
% ylabel('Frequency');
% set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
% grid on;
% set(gca, 'XTickLabelRotation', 45);
% 
% figure; % Create a new figure window
% histogram(AUD_Mu, 25, 'FaceColor', 'r'); 
% title('Distribution of Auditory Mu');
% xlabel('Mu');
% xlim([-0.5 0.5]);
% ylim([0 12]);
% ylabel('Frequency');
% set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
% grid on;
% set(gca, 'XTickLabelRotation', 45);
% 
% figure; % Create a new figure window
% histogram(VIS_SD, 100, 'FaceColor', 'b'); 
% title('Distribution of Visual SD');
% xlabel('SD');
% xlim([0 1]);
% ylim([0 10]);
% ylabel('Frequency');
% set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
% grid on;
% set(gca, 'XTickLabelRotation', 45);
% 
% figure; % Create a new figure window
% histogram(VIS_Mu, 50, 'FaceColor', 'b'); 
% title('Distribution of Visual Mu');
% xlabel('Mu');
% xlim([-0.5 0.5]);
% ylim([0 12]);
% ylabel('Frequency');
% set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
% grid on;
% set(gca, 'XTickLabelRotation', 45);

% AV_perf = EqualReliabilities(:, 15);
% maxA_V = EqualReliabilities(:, 20);
% group_type = 'Equal Reliabilities';
% acc_boxplotter(maxA_V, AV_perf, group_type);
% 
% AV_perf = AudCapture(:, 15);
% maxA_V = AudCapture(:, 20);
% group_type = 'Auditory Capture';
% acc_boxplotter(maxA_V, AV_perf, group_type);
% 
% AV_perf = VisCapture(:, 15);
% maxA_V = VisCapture(:, 20);
% group_type = 'Visual Capture';
% acc_boxplotter(maxA_V, AV_perf, group_type);
% 
% 
% AO_acc = EqualReliabilities(:, 13);
% A_Vnoise = EqualReliabilities(:, 18);
% group_type = 'Equal Reliabilities';
% acc_boxplotter(maxA_V, AV_perf, group_type);
% 
% AO_acc = AudCapture(:, 13);
% A_Vnoise = AudCapture(:, 18);
% group_type = 'Auditory Capture';
% acc_boxplotter(maxA_V, AV_perf, group_type);
% 
% AO_acc = VisCapture(:, 13);
% A_Vnoise = VisCapture(:, 18);
% group_type = 'Visual Capture';
% acc_boxplotter(maxA_V, AV_perf, group_type);
% 
% %% VO accuracy vs V_Anoise
% 
% VO_acc = EqualReliabilities(:, 14);
% V_Anoise = EqualReliabilities(:, 19);
% group_type = 'Equal Reliabilities';
% acc_boxplotter(maxA_V, AV_perf, group_type);
% 
% VO_acc = AudCapture(:, 14);
% V_Anoise = AudCapture(:, 19);
% group_type = 'Auditory Capture';
% acc_boxplotter(maxA_V, AV_perf, group_type);
% 
% VO_acc = VisCapture(:, 14);
% V_Anoise = VisCapture(:, 19);
% group_type = 'Visual Capture';
% acc_boxplotter(maxA_V, AV_perf, group_type);
% 
% 
% 
% figure; hold on;
% scatter(VIS_Mu, AVacc_diff, 'k', 'filled', 'SizeData', 70);
% ylabel('MS Gain');
% xlabel('Vis Mu');
% title('');
% beautifyplot;

dataAll_raw = table2array(dataAll);
condition0_2 = dataAll_raw(:,28) >= 0 & dataAll_raw(:,28) < 0.2;
condition2_4 = dataAll_raw(:,28) >= 0.2 & dataAll_raw(:,28) < 0.4;
condition4_6 = dataAll_raw(:,28) >= 0.4 & dataAll_raw(:,28) < 0.6;
condition6_8 = dataAll_raw(:,28) >= 0.6 & dataAll_raw(:,28) < 0.8;
condition8_10 = dataAll_raw(:,28) >= 0.8 & dataAll_raw(:,28) < 1;

weights0_2 = dataAll_raw(condition0_2, :);
weights2_4 = dataAll_raw(condition2_4, :);
weights4_6 = dataAll_raw(condition4_6, :);
weights6_8 = dataAll_raw(condition6_8, :);
weights8_10 = dataAll_raw(condition8_10, :);

AV_perf = weights0_2(:, 15);
maxA_V = weights0_2(:, 20);
MS_Gain = weights0_2(:, 21);
group_type = '0 - 0.2 Aud Weight';
acc_boxplotter(maxA_V, AV_perf, group_type);
figure; % Create a new figure window
histogram(MS_Gain, 25, 'FaceColor', 'm'); 
title('Distribution of MsGain');
xlabel('Gain');
%xlim([-0.5 0.5]);
ylim([0 12]);
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;
set(gca, 'XTickLabelRotation', 45);


AV_perf = weights2_4(:, 15);
maxA_V = weights2_4(:, 20);
MS_Gain = weights2_4(:, 21);
group_type = '0.2 - 0.4 Aud Weight';
acc_boxplotter(maxA_V, AV_perf, group_type);
figure; % Create a new figure window
histogram(MS_Gain, 25, 'FaceColor', 'm'); 
title('Distribution of MsGain');
xlabel('Gain');
%xlim([-0.5 0.5]);
ylim([0 12]);
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;
set(gca, 'XTickLabelRotation', 45);

AV_perf = weights4_6(:, 15);
maxA_V = weights4_6(:, 20);
MS_Gain = weights4_6(:, 21);
group_type = '0.4 - 0.6 Aud Weight';
acc_boxplotter(maxA_V, AV_perf, group_type);
figure; % Create a new figure window
histogram(MS_Gain, 25, 'FaceColor', 'm'); 
title('Distribution of MsGain');
xlabel('Gain');
%xlim([-0.5 0.5]);
ylim([0 12]);
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;
set(gca, 'XTickLabelRotation', 45);

AV_perf = weights6_8(:, 15);
maxA_V = weights6_8(:, 20);
MS_Gain = weights6_8(:, 21);
group_type = '0.6 - 0.8 Aud Weight';
acc_boxplotter(maxA_V, AV_perf, group_type);
figure; % Create a new figure window
histogram(MS_Gain, 25, 'FaceColor', 'm'); 
title('Distribution of MsGain');
xlabel('Gain');
%xlim([-0.5 0.5]);
ylim([0 12]);
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;
set(gca, 'XTickLabelRotation', 45);

AV_perf = weights8_10(:, 15);
maxA_V = weights8_10(:, 20);
MS_Gain = weights8_10(:, 21);
group_type = '0.8 - 1 Aud Weight';
acc_boxplotter(maxA_V, AV_perf, group_type);
figure; % Create a new figure window
histogram(MS_Gain, 25, 'FaceColor', 'm'); 
title('Distribution of MsGain');
xlabel('Gain');
%xlim([-0.5 0.5]);
ylim([0 12]);
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;
set(gca, 'XTickLabelRotation', 45);

MRE_RT = table2array(dataAll(:,27));
%group_type = 'All Aud Weights';
%acc_boxplotter(AV_perf, maxA_V, group_type);
figure; % Create a new figure window
histogram(MRE_RT, 50, 'FaceColor', 'm'); 
title('Distribution of RT MRE');
xlabel('MRE (ms)');
%xlim([-0.5 0.5]);
ylim([0 12]);
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;
set(gca, 'XTickLabelRotation', 45);

% Define logical conditions for participants that have GAIN and/or MRE
condition_Gain = dataAll_raw(:,21) > 0;
condition_noGain = dataAll_raw(:,21) <= 0;
condition_RT = dataAll_raw(:,27) > 0;
condition_noRT = dataAll_raw(:,27) <= 0;
condition_Gain_and_RT = condition_Gain & condition_RT;
condition_noGain_nor_RT = condition_noGain & condition_noRT;

% Create separate arrays based on conditions
group_Gain = dataAll_raw(condition_Gain, :);
group_noGain = dataAll_raw(condition_noGain, :);
group_RT = dataAll_raw(condition_RT, :);
group_noRT = dataAll_raw(condition_noRT, :);
group_Gain_and_RT = dataAll_raw(condition_Gain_and_RT, :);

AV_perf = group_Gain(:, 15);
maxA_V = group_Gain(:, 20);
group_type = 'Gain Group';
acc_boxplotter(maxA_V, AV_perf, group_type);
AudWeight = group_Gain(:, 28);
figure; % Create a new figure window
histogram(AudWeight, 25, 'FaceColor', 'm'); 
title('Distribution of Auditory Weights');
xlabel('Aud Weight');
xlim([0 1]);
ylim([0 12]);
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;
set(gca, 'XTickLabelRotation', 45);

AV_perf = group_noGain(:, 15);
maxA_V = group_noGain(:, 20);
group_type = 'NO Gain Group';
acc_boxplotter(maxA_V, AV_perf, group_type);
AudWeight = group_noGain(:, 28);
figure; % Create a new figure window
histogram(AudWeight, 25, 'FaceColor', 'm'); 
title('Distribution of Auditory Weights');
xlabel('Aud Weight');
xlim([0 1]);
ylim([0 12]);
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;
set(gca, 'XTickLabelRotation', 45);

SD_Ratio = table2array(dataAll(:,24));
figure; % Create a new figure window
histogram(SD_Ratio, 50, 'FaceColor', 'g'); 
title('Distribution of SD Ratio');
xlabel('Ratio (Aud SD / Vis SD)');
xlim([0 4]);
ylim([0 12]);
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;
set(gca, 'XTickLabelRotation', 45);

Mu_Ratio = table2array(dataAll(:,25));
figure; % Create a new figure window
histogram(Mu_Ratio, 200, 'FaceColor', 'g'); 
title('Distribution of Mu Ratio');
xlabel('Ratio (Aud Mu / Vis Mu)');
xlim([0 4]);
ylim([0 20]);
ylabel('Frequency');
set(findall(gcf, '-property', 'FontSize'), 'FontSize', 24)
grid on;
set(gca, 'XTickLabelRotation', 45);

skew = skewness(AudWeight);
kur = kurtosis(AudWeight);
