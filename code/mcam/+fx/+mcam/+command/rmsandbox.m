function rmsandbox( varargin )
    parser = inputParser;
    parser.addOptional( 'Path', pwd,...
        @fx.mcam.util.validFileName );
    parser.parse( varargin{:} );
    inputs = parser.Results;
    sandbox = fx.mcam.Sandbox( inputs.Path );
    sandbox.removeFromPath();
end