function [h] = delta_histogram_plotter(x, y, color, figure_font_size, x_name, y_name, single_group)
% Calculate the delta and remove outliers based on z-scores
if single_group
    if y == 0
        delta = x;
    else
        delta = x - y;
    end
    data = delta; 
    mu = mean(data);
    sigma = std(data);
    z_scores = (data - mu) / sigma;
    outlier_indices = abs(z_scores) > 3;
    cleaned_data = data(~outlier_indices);
    delta = cleaned_data;
    
    if y == 0
        binWidth = 0.5;
        maxEdge = 10;  % Ensure bins cover data
        binEdges = 0 : binWidth : 10;
    else
         % Define the edges for bins symmetric around 0
        binWidth = 1;  % Adjust the bin width as desired
        maxEdge = ceil(max(abs(delta)) / binWidth) * binWidth;  % Ensure bins cover data
        binEdges = -maxEdge-binWidth/10 : binWidth : maxEdge+binWidth/10;  % Centered on 0
    end

    
    figure;
    [h] = histogram(delta, 'BinEdges', binEdges, 'FaceColor', color, 'FaceAlpha', 1, 'EdgeColor', 'k', 'LineWidth', 2.5);
    xlim([-maxEdge maxEdge]);  % Symmetric x-axis range based on data
    
    % Remove axis and add vertical dotted line at x = 0
    if y == 0
        xlim([0 10])
        xlabel_name = x_name;
    else
        xlim([-20 20])
        xlabel_name = sprintf('%s - %s', x_name, y_name);
    end
    xlabel(xlabel_name, 'FontSize', 38);
    ax = gca;               % Get the current axes
    ax.YAxis.Visible = 'off'; % Turn off the y-axis completely
    hold on;
    if y ~= 0
        plot([0 0], ylim, '--', 'Color', '#bbbbbb', 'LineWidth', 2.5);
    end
    delta = delta(~isnan(delta));
    delta_median = median(delta); 
    %plot([delta_median delta_median], ylim, '-', 'Color', 'k', 'LineWidth', 2.5);  % Vertical line at delta_median
    
    
    % Perform Wilcoxon Signed-Rank Test
    [p] = signrank(delta);  % h is 1 if significant, 0 if not
    
    % Apply styling functions
    beautifyplot;
    unmatlabifyplot(1);
    
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', figure_font_size);
    
    y_limits = ylim;  % Get current y-axis limits
    p_rounded = round(p, 4);
    median_rounded = round(delta_median, 2);
    
    % Display median and p-value on the plot
    if y ==0
        text_location_x = 7;
    else
        text_location_x = 10;
    end
    text_location_y = y_limits(2) - 1;
    text_str = sprintf('median = %.3f\np = %.3f', median_rounded, p_rounded);
    text(text_location_x, text_location_y, text_str, 'FontSize', 36, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
    
    % text(10, y_limits(2) - 1, "median = " + num2str(median_rounded), 'FontName', 'Times New Roman', 'FontSize', 36);
    % text(10, y_limits(2) - 1.3, "p = " + num2str(p_rounded), 'FontName', 'Times New Roman', 'FontSize', 36);
    
    hold off;
else
    if y == 0
        delta = x;
    else
        delta = x - y;
    end
    data = delta; 
    mu = mean(data);
    sigma = std(data);
    z_scores = (data - mu) / sigma;
    outlier_indices = abs(z_scores) > 3;
    cleaned_data = data(~outlier_indices);
    delta = cleaned_data;
    
    % Define the edges for bins symmetric around 0
    binWidth = 1;  % Adjust the bin width as desired
    maxEdge = ceil(max(abs(delta)) / binWidth) * binWidth;  % Ensure bins cover data
    binEdges = -maxEdge-binWidth/10 : binWidth : maxEdge+binWidth/10;  % Centered on 0
    
    [h] = histogram(delta, 'BinEdges', binEdges, 'FaceColor', color, 'FaceAlpha', 1, 'EdgeColor', 'k', 'LineWidth', 2.5);
    xlim([-maxEdge maxEdge]);  % Symmetric x-axis range based on data
    
    % Remove axis and add vertical dotted line at x = 0
    if y == 0
        xlim([0 1])
        xlabel_name = x_name;
    else
        xlim([-20 20])
        xlabel_name = sprintf('%s - %s', x_name, y_name);
    end
    xlabel(xlabel_name, 'FontSize', 38);
    ax = gca;               % Get the current axes
    ax.YAxis.Visible = 'off'; % Turn off the y-axis completely
    hold on;
    plot([0 0], ylim, '--', 'Color', '#bbbbbb', 'LineWidth', 2.5);
    delta_median = median(delta); 
    %plot([delta_median delta_median], ylim, '-', 'Color', 'k', 'LineWidth', 2.5);  % Vertical line at delta_median
    
    
    % Perform Wilcoxon Signed-Rank Test
    [p] = signrank(delta);  % h is 1 if significant, 0 if not
    
    % Apply styling functions
    beautifyplot;
    unmatlabifyplot(1);
    
    set(findall(gcf, '-property', 'FontSize'), 'FontSize', figure_font_size);
    
    y_limits = ylim;  % Get current y-axis limits
    p_rounded = round(p, 4);
    median_rounded = round(delta_median, 2);
    
    % Display median and p-value on the plot
    text_location_x = 10;
    text_location_y = y_limits(2) - 1;
    if y == 0
        text_str = sprintf('median = %.3f', median_rounded);
    else
        text_str = sprintf('median = %.3f\np = %.3f', median_rounded, p_rounded);
    end
    text(text_location_x, text_location_y, text_str, 'FontSize', 36, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
    
    hold on;
end
end
