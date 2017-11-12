function mksandbox( varargin )
    parser = inputParser;
    parser.KeepUnmatched = true;
    if mod( nargin, 2 ) == 1
        % Infer that the first argument is the path, only if odd number of
        % input arguments
        parser.addOptional( 'Path', pwd,...
            @fx.fcam.util.mustBeValidPath );
    else
        parser.addParameter( 'Path', pwd,...
            @fx.fcam.util.mustBeValidPath );
    end
    parser.parse( varargin{:} );
    inputs = parser.Results;
    unmatched = parser.Unmatched;
    if exist( inputs.Path, 'dir' ) ~= 7
        mkdir( inputs.Path );
    end
    sandbox = fx.fcam.Sandbox( inputs.Path );
    sandbox.createStub( unmatched );
    cd( inputs.Path );
end