function rmsandbox( varargin )
    % Remove the sandbox from the MATLAB path
    % Removes the source code, and the test folders of the sandbox from the
    % MATLAB path.
    %
    %   rmsandbox() removes the sandbox in the current folder from the
    %   MATLAB path.
    %    
    %   rmsandbox( path ) removes the sandbox at the "path" location from
    %   the MALTAB path.
    %
    %   Example
    %      rmsandbox();
    %
    %   See also mksandbox, addsandbox, testsandbox, packagesandbox
    
    fx.mcam.command.rmsandbox( varargin{:} );
end