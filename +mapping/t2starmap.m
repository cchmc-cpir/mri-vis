%% MRI Image Masking

% Author(s): Alex Cochran
% Email: Alexander.Cochran@cchmc.org, acochran50@gmail.com
% Group: CCHMC CPIR
% Date: 2018

% This script loads Amira masks and MRI images as DICOM and TIFF image stacks, respectively, in
% order to mask the images appropriately. The images are then masked appropriately in order to
% eliminate areas of noise and high-signal body tissue for analysis.

% Notes:
%   Normal Amira mask values:
%       * Noise:    1
%       * Lung:     2


%% Config

% Define image matrix size
imageSize = [128 128 128];

% Define echo times for the mapping operation
longerEchoTime = 0.400; % ms
shorterEchoTime = 0.200; % ms

% Define T2* thresholding values
mapThreshHigh = 3;
mapThreshLow = 0;

subjectID = input('Enter the subject ID: ', 's'); % e.g. BT4


%% Directory control

% Choose top-level study path for the images that will be used
topDir = uigetdir;


%% Select and load RAW image stacks for mapping algorithm

% Define file paths to one longer and one shorter echo time image
[longerEchoImageFile, longerEchoImagePath] = uigetfile(fullfile(topDir, '*.*'), ...
    'Choose longer echo time image');
[shorterEchoImageFile, shorterEchoImagePath] = uigetfile(fullfile(topDir, '*.*'), ...
    'Choose shorter echo time image');

% Open both files
longerEchoFileID = fopen(fullfile(longerEchoImagePath, longerEchoImageFile));
shorterEchoFileID = fopen(fullfile(shorterEchoImagePath, shorterEchoImageFile));

% Load data from both files
longerEchoData = fread(longerEchoFileID, 'float32');
shorterEchoData = fread(shorterEchoFileID, 'float32');

% Close both files
fclose(longerEchoFileID);
fclose(shorterEchoFileID);


%% Pre-process image data

% Reshape images to predefined matrix size
longerEchoData = reshape(longerEchoData, imageSize);
shorterEchoData = reshape(shorterEchoData, imageSize);

% Rotate images
longerEchoData = rot90(longerEchoData, 3);
shorterEchoData = rot90(shorterEchoData, 3);


%% Calculate T2* values for each image voxel

T2Star = (longerEchoTime - shorterEchoTime) ./ log(shorterEchoData ./ longerEchoData);

% Threshold T2* matrix
T2Star(T2Star > mapThreshHigh) = mapThreshHigh;
T2Star(T2Star < mapThreshLow) = mapThreshLow;


%% Load RAW (MRI images) and DICOM (Amira masks) stacks

% DICOM sequence
[amiraMasks, dicomPath, dicomName] = DICOM_Load;


%% Generate binary lung mask from the loaded DICOM sequence

% Enter the value of the masks that Amira assigned
lungIndex = input('Enter the index value of the lung mask: ');

% Create binary lung mask from Amira stack
lungMask = zeros(imageSize);
lungMask(amiraMasks == lungIndex) = 1;


%% Mask T2* maps

% Multiply T2* and lung mask element-by-element
T2StarMaps = T2Star .* lungMask;


%% Formatting and output

% Create a figure for the image
mapFigure = figure;

% Define custom colormap
colormap('jet');
customJet = colormap;

% Display image
imslice(T2StarMaps);

% Change colormap of image
customJet(1, :) = 0;
colormap(customJet);

% Save figure and associated data
savefig(mapFigure, strcat('t2starmap_', subjectID, '.fig'));

