%% IMGEXTRACT
%
% Author(s): Alex Cochran
% Email: Alexander.Cochran@cchmc.org, acochran50@gmail.com
% Group: CCHMC CPIR
% Date: 2018
%
% This is a method for extracting image data from a saved MATLAB figure (*.fig). The data is
% returned as a properly sized and scaled image data matrix. The colormap scheme used to create the
% image can also be extracted.


%% Constants

sliceDim = 128;


%% Open figure

imgFilename = uigetfile('*.fig', 'Select *.fig file');
imgFig = openfig(imgFilename, 'new', 'invisible');


%% Extract data

% Extract images as MATLAB "Image" types
imgs = findobj(imgFig, 'type', 'image');
savedColormap = get(imgFig, 'colormap');

% Preallocate image data matrix
imgData = zeros(sliceDim, sliceDim, length(imgs));

for n = 1:length(imgs)
    imgData(:, :, n) = get(imgs(n), 'CData');
end
