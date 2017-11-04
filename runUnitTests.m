function testResults = runUnitTests( mode )
    if nargin < 1
        mode = 'fast';
    end
    switch mode
        case 'fast'
            testResults = runtests( 'fx.mcam.test.unittest',...
                'IncludeSubpackages', true );
            disp( testResults );
        case 'codeCoverage'
            suite = matlab.unittest.TestSuite.fromPackage(...
                'fx.mcam.test.unittest',...
                'IncludingSubpackages', true );
            runner = matlab.unittest.TestRunner.withTextOutput();
            coberturaReport = matlab.unittest.plugins.codecoverage.CoberturaFormat(...
                fullfile( mcamtestroot, 'codeCoverage.xml' ) );
            codeCoverageFolders = fx.mcam.util.getAllFolders( mcamroot );
            exclusion = fullfile( mcamroot, 'templates' );
            foldersToExclude = ismember( codeCoverageFolders, exclusion );
            codeCoverageFolders(foldersToExclude) = [];
            codeCoveragePlugin = matlab.unittest.plugins.CodeCoveragePlugin.forFolder(...
                codeCoverageFolders,...
                'IncludingSubfolders', false,...
                'Producing', coberturaReport );
            runner.addPlugin( codeCoveragePlugin );
            testResults = runner.run( suite );
            disp( testResults );
    end
end