function packagesandbox( varargin )
    parser = inputParser;
    parser.addOptional( 'Path', pwd,...
        @fx.fcam.util.mustBeValidPath );
    parser.parse( varargin{:} );
    inputs = parser.Results;
    sandbox = fx.fcam.Sandbox( inputs.Path );
    sandbox.package();
end