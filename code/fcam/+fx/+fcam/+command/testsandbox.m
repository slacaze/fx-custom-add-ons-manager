function testResults = testsandbox( varargin )
    parser = inputParser;
    parser.addOptional( 'Path', pwd,...
        @fx.fcam.util.mustBeValidPath );
    parser.addOptional( 'Suite', '',...
        @fx.fcam.util.mustBeValidPackageName );
    parser.parse( varargin{:} );
    inputs = parser.Results;
    try
        sandbox = fx.fcam.Sandbox( inputs.Path );
        testResults = sandbox.test( inputs.Suite );
    catch matlabException
        if strcmp( matlabException.identifier, 'FCAM:InvalidRoot' )
            % Try if the first argument was a suite
            inputs.Suite = inputs.Path;
            inputs.Path = pwd;
            sandbox = fx.fcam.Sandbox( inputs.Path );
            testResults = sandbox.test( inputs.Suite );
        else
            matlabException.rethrow();
        end
    end
end