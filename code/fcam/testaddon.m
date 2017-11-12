function testResults = testaddon( varargin )
    % Run the tests on the packaged Add-On
    % Runs a test suite defined in "fcam.json" on the packaged Add-On.
    %
    %   testaddon() runs the first test suite defined in "fcam.json", for
    %   the sandbox in the current path.
    %    
    %   testaddon( path ) runs the first test suite defined in
    %   "fcam.json", for the sandbox at the "path" location.
    %    
    %   testaddon( suite ) runs the "suite" test suite defined in
    %   "fcam.json", for the sandbox in the current path.
    %    
    %   testaddon( path, suite ) runs the "suite" test suite defined in
    %   "fcam.json", for the sandbox at the "path" location.
    %
    %   Example
    %      testaddon( 'unittest' );
    %
    %   See also mksandbox, addsandbox, rmsandbox, testsandbox, packagesandbox
    
    testResults = fx.fcam.command.testaddon( varargin{:} );
end