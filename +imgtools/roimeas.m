function [roiMean, roiSTD, roiRange, roiMax, roiMin] = roimeas(imgData, varargin)
    %ROIMEAS Draw an ROI over a figure and return statistics on the region.
    %   Load a MATLAB figure and draw an ROI over it to return its the mean, standard deviation,
    %   range, maximum, and minimum for the region. The ROI can also be plotted on the figure in
    %   order to better preserve the analysis.
    %
    %   [outputParams...] = ROIMEAS(imgData) will use uigetfile to get a saved MATLAB figure to
    %       perform the ROI measurement on.
    %   [outputParams...] = ROIMEAS(imgData, 'plot', true) will plot the drawn ROI on the axes.
    %   [outputParams...] = ROIMEAS(imgData, 'dispResults', true) will also display the statistical
    %       values in a table format.
    %   [outputParams...] = ROIMEAS(imgData, 'saveFigure', true) will allow the user to save the
    %       figure with the ROI.
    
    
    %% Configs
    
    defaultPlotSetting = false;
    defaultDispSetting = true;
    defaultSaveSetting = true;
    
    
    %% Handle function arguments
    
    % Define anonymouse function to check if image data matrix is valid
    validateImageMatrix = @(x) validateattributes(x, {'double'}, {'2d', 'nonempty', 'square'});
    
    % Define anonymous function to check if an input is a 1x1 logical value
    validateLogical = @(x) validateattributes(x, {'logical'}, {'scalar'});
    
    % Instantiate input parser and handle function arguments
    p = inputParser;
    addRequired(p, 'imgData', validateImageMatrix);
    addParameter(p, 'plot', defaultPlotSetting, validateLogical);
    addParameter(p, 'dispResults', defaultDispSetting, validateLogical);
    addParameter(p, 'saveFigure', defaultSaveSetting, validateLogical);
    parse(p, imgData, varargin{:})

    
    %% Draw ROI
    
    roiFigure = figure('Name', 'Image ROI');
    imagesc(imgData);
    
    [roiMask, x, y] = roipoly;
    
    % Validate image data and ROI sizes
    if size(imgData) ~= size(roiMask)
        error('Image matrix and ROI mask sizes are not identical.');
    end

    
    %% Apply ROI to image data
    
    % Multiply drawn ROI selection by the image data matrix to separate values of interest
    roiSelection = imgData .* roiMask;
    roiSelection = roiSelection(roiMask == 1);
    
    % Plot ROI on figure axes if set to do so
    if p.Results.plot
        hold on;
        plot(x, y, 'r.-', 'MarkerSize', 15);
    end
    
    % Save the figure
    if p.Results.saveFigure
        figureFilename = char(inputdlg({'Figure filename:'}, 'Save Figure'));
        savefig(roiFigure, strcat(figureFilename, '.fig'));
    end
    
    
    %% Compute and display statistical values
    
    % Compute ROI statistics
    roiMean = mean(roiSelection);
    roiSTD = std(roiSelection);
    roiRange = range(roiSelection);
    roiMax = max(roiSelection);
    roiMin = min(roiSelection);

    % Display output information in a table format.
    if p.Results.dispResults
        resultsTable = table(roiMean, roiSTD, roiRange, roiMax, roiMin);
        disp(resultsTable);
    end
end

