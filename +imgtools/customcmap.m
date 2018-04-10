function customcmap(varargin)
    %APPLYCMAP Applies a new colormap. Defaults to a custom "jet" that sets values < 0 to 0.
    %   APPLYCMAP applies a custom "jet" colormap to the current figure that sets values below 0 to
    %   0.
    %   APPLYCMAP('colormap') applies the specified colormap to the current figure.
    
    switch nargin
        case 0
            colormap('jet');
            customJet = colormap;
            customJet(1, :) = 0;
            colormap(customJet);

        case 1
            colormap(varargin(1))
            
        otherwise
            error('Too many arguments.');
    end
end

