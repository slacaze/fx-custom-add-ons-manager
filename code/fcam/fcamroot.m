function thisPath = fcamroot()
    % Root of the Fx Custom Add-Ons Manager Toolbox
    %
    %   path = fcamroot() return the root of the Fx Custom Add-Ons Manager
    %   Toolbox in the "path" variable.
    
    thisPath = fileparts( mfilename( 'fullpath' ) );
end