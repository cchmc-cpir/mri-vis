function [roiMean, roiSTD, roiRange, roiMax, roiMin] = roimeas(varargin)
    %ROIMEAS Draw an ROI over a figure and return statistics on the region.
    %   Load a MATLAB figure and draw an ROI over it to return its the mean, standard deviation,
    %   range, maximum, and minimum for the region. The ROI can also be plotted on the figure in
    %   order to better preserve the analysis.
    %
    %   [outputParams...] = ROIMEAS will use uigetfile to get a saved MATLAB figure to perform the
    %       ROI measurement on.
    %   [outputParams...] = ROIMEAS('plot', true) will plot the drawn ROI on the axes.
    
    
    %% Configs
    
    defaultPlotSetting = false;
    defaultDispSetting = true;
    
    
    %% Handle function arguments
    
    % Define anonymous function to check if an input is a 1x1 logical value
    validateLogical = @(x) validateattributes(x, {'logical'}, {'scalar'});
    
    % Instantiate input parser and handle function arguments
    p = inputParser;
    addParameter(p, 'plot', defaultPlotSetting, validateLogical);
    addParameter(p, 'dispResults', defaultDispSetting, validateLogical);
    parse(p, varargin{:})


    %% Draw ROI
    
    [roiMask, x, y] = roipoly;

    % Multiply drawn ROI selection by the image data matrix to separate values of interest
    roiSelection = imgMatrix(:, :, slice) .* roiMask;
    roiSelection = roiSelection(roiMask == 1);
    
    % Plot ROI on figure axes if set to do so
    if p.Results.plot
        plot(x, y, 'r.-', MarkerSize, 15)
    end
    
    
    % Compute ROI statistics
    roiMean = mean(roiSelection);
    roiSTD = std(roiSelection);
    roiRange = range(roiSelection);
    roiMax = max(roiSelection);
    roiMin = min(roiSelection);
    
    % Display output information in a table format.
    if p.Results.dispResults
        table(roiMean, roiSTD, roiRange, roiMax, roiMin);
    end
end

