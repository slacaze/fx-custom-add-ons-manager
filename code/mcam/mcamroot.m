function thisPath = mcamroot()
    % Root of the MALTAB Custom Add-Ons Manager Toolbox
    %
    %   path = mcamroot() return the root of the MATLAB Custom Add-Ons
    %   Manager Toolbox in the "path" variable.
    
    thisPath = fileparts( mfilename( 'fullpath' ) );
end