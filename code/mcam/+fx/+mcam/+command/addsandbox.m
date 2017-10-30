function addsandbox( varargin )
    parser = inputParser;
    parser.addOptional( 'Path', pwd,...
        @fx.mcam.util.mustBeValidFileName );
    parser.parse( varargin{:} );
    inputs = parser.Results;
    sandbox = fx.mcam.Sandbox( inputs.Path );
    sandbox.addToPath();
end