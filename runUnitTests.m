function testResults = runUnitTests( mode )
    if nargin < 1
        mode = 'fast';
    end
    switch mode
        case 'fast'
            testResults = runtests( 'fx.fcam.test.unittest',...
                'IncludeSubpackages', true );
            disp( testResults );
        case 'codeCoverage'
            suite = matlab.unittest.TestSuite.fromPackage(...
                'fx.fcam.test.unittest',...
                'IncludingSubpackages', true );
            runner = matlab.unittest.TestRunner.withTextOutput();
            jUnitPlugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat(...
                fullfile( fcamtestroot, 'junitResults.xml' ) );
            coberturaReport = matlab.unittest.plugins.codecoverage.CoberturaFormat(...
                fullfile( fcamtestroot, 'codeCoverage.xml' ) );
            codeCoverageFolders = fx.fcam.util.getAllFolders( fcamroot );
            exclusion = fullfile( fcamroot, 'templates' );
            foldersToExclude = ismember( codeCoverageFolders, exclusion );
            codeCoverageFolders(foldersToExclude) = [];
            codeCoveragePlugin = matlab.unittest.plugins.CodeCoveragePlugin.forFolder(...
                codeCoverageFolders,...
                'IncludingSubfolders', false,...
                'Producing', coberturaReport );
            runner.addPlugin( jUnitPlugin );
            runner.addPlugin( codeCoveragePlugin );
            testResults = runner.run( suite );
            disp( testResults );
    end
end