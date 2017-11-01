function testResults = testsandbox( varargin )
    parser = inputParser;
    parser.addOptional( 'Path', pwd,...
        @fx.mcam.util.mustBeValidPath );
    parser.addOptional( 'Suite', '',...
        @fx.mcam.util.mustBeValidPackageName );
    parser.parse( varargin{:} );
    inputs = parser.Results;
    sandbox = fx.mcam.Sandbox( inputs.Path );
    testResults = sandbox.test( inputs.Suite );
end