function testResults = testsandbox( varargin )
    parser = inputParser;
    parser.addOptional( 'Path', pwd,...
        @fx.mcam.util.mustBeValidPath );
    parser.addOptional( 'Suite', '',...
        @fx.mcam.util.mustBeValidPackageName );
    parser.parse( varargin{:} );
    inputs = parser.Results;
    try
        sandbox = fx.mcam.Sandbox( inputs.Path );
        testResults = sandbox.test( inputs.Suite );
    catch
        % Try if the first argument was a suite
        inputs.Suite = inputs.Path;
        inputs.Path = pwd;
        sandbox = fx.mcam.Sandbox( inputs.Path );
        testResults = sandbox.test( inputs.Suite );
    end
end