function [imgData, savedColormap] = imgextract(varargin)
    %IMGEXTRACT Extracts the image data matrix from a saved MATLAB figure (*.fig).
    %   imgData = IMGEXTRACT lets the user select a saved *.fig file and returns the image matrix.
    %   imgData = IMGEXTRACT('imgSize', ...) allows the use of an extra name-value pair that will
    %       set the size of each image matrix dimension; e.g. imgData = IMGEXTRACT('imgSize', 100)
    %       will return a 100x100 matrix to imgData. The default value is 128.
    
    
    %% Configs
    
    defaultImageDim = 128;
    
    
    %% Handle function arguments
    
    % Define anyonymous function to check if an input could be a valid image dimension
    validateImageDim = @(x) validateattributes(x, {'numeric'}, {'scalar', 'integer', 'positive'});
    
    % Instantiate input parser and handle function arguments
    p = inputParser;
    addParameter(p, 'imgDim', defaultImageDim, validateImageDim)
    parse(p, varargin{:});
    

    %% Open figure

    imgFilename = uigetfile('*.fig', 'Select *.fig file');
    imgFig = openfig(imgFilename, 'new', 'invisible');


    %% Extract data

    % Extract images as MATLAB "Image" types
    imgs = findobj(imgFig, 'type', 'image');
    savedColormap = get(imgFig, 'colormap');

    % Preallocate image data matrix
    imgData = zeros(p.Results.imgDim, p.Results.imgDim, length(imgs));

    for n = 1:length(imgs)
        imgData(:, :, n) = get(imgs(n), 'CData');
    end
end

