function mksandbox( varargin )
    parser = inputParser;
    parser.KeepUnmatched = true;
    parser.addOptional( 'Path', pwd,...
        @fx.mcam.util.mustBeValidFileName );
    parser.parse( varargin{:} );
    inputs = parser.Results;
    unmatched = parser.Unmatched;
    if exist( inputs.Path, 'dir' ) ~= 7
        mkdir( inputs.Path );
    end
    sandbox = fx.mcam.Sandbox( inputs.Path );
    sandbox.createStub( unmatched );
    cd( inputs.Path );
end