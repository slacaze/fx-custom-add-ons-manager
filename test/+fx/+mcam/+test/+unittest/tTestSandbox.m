classdef tTestSandbox < fx.mcam.test.WithSampleSandbox
    
    methods( Test )
        
        function testPath( this )
            sandbox = fx.mcam.Sandbox( this.Root );
            sandbox.addToPath();
            [~, results] = evalc( 'sandbox.test();' );
            this.verifyNumElements( results, 2,...
                'There should be 2 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
            [~, results] = evalc( 'sandbox.test( ''unittest'' );' );
            sandbox.removeFromPath();
            this.verifyNumElements( results, 1,...
                'There should be 1 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
        end
        
        function testAlias( this )
            addsandbox();
            [~, results] = evalc( 'testsandbox();' );
            this.verifyNumElements( results, 2,...
                'There should be 2 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
            [~, results] = evalc( 'testsandbox( ''unittest'' );' );
            rmsandbox();
            this.verifyNumElements( results, 1,...
                'There should be 1 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
        end
        
        function testPackagedAddon( this )
            sandbox = fx.mcam.Sandbox( this.Root ); %#ok<NASGU>
            [~, results] = evalc( 'sandbox.testPackagedAddon();' );
            this.verifyNumElements( results, 2,...
                'There should be 2 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
            [~, results] = evalc( 'sandbox.testPackagedAddon( ''unittest'' );' );
            this.verifyNumElements( results, 1,...
                'There should be 1 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
        end
        
        function testPacakgedAddonAlias( this )
            [~, results] = evalc( 'testaddon();' );
            this.verifyNumElements( results, 2,...
                'There should be 2 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
            [~, results] = evalc( 'testaddon( ''unittest'' );' );
            this.verifyNumElements( results, 1,...
                'There should be 1 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass.' );
        end
        
        function testTestPacakgedAddonFlagsPackagingProblems( this )
            sandbox = fx.mcam.Sandbox( this.Root );
            try %#ok<TRYNC>
                sandbox.Configuration.TestPackages(end+1,:) = {'failing', 'fx.submission.sample.failingTestOncePackaged'};
            end
            copyfile(...
                fullfile( mcamtestroot, 'Sample', 'prjfile.prj' ),...
                fullfile( this.Root, 'code', this.ShortName, 'prjfile.prj' ) );
            copyfile(...
                fullfile( mcamtestroot, 'Sample', 'prjFileExist.m' ),...
                fullfile( this.Root, 'code', this.ShortName, 'prjFileExist.m' ) );
            packagePath = cellfun( @(str) sprintf( '+%s', str ), this.ParentPackages,...
                'UniformOutput', false );
            mkdir( fullfile( this.Root, this.TestFolder, packagePath{:}, sprintf( '+%s', this.ShortName ), '+failingTestOncePackaged' ) );
            copyfile(...
                fullfile( mcamtestroot, 'Sample', 'tprjFileExist.m' ),...
                fullfile( this.Root, this.TestFolder, packagePath{:}, sprintf( '+%s', this.ShortName ), '+failingTestOncePackaged', 'tprjFileExist.m' ) );
            sandbox.addToPath();
            [~, results] = evalc( 'sandbox.test( ''failing'' );' );
            this.verifyNumElements( results, 1,...
                'There should be 1 test results.' );
            this.verifyTrue( ~any( [results.Failed] ),...
                'All tests should pass in sandbox mode.' );
            [~, results] = evalc( 'sandbox.testPackagedAddon( ''failing'' );' );
            this.verifyNumElements( results, 1,...
                'There should be 1 test results.' );
            this.verifyTrue( all( [results.Failed] ),...
                'All tests should be failing in packaged mode.' );
            sandbox.removeFromPath();
        end
        
    end
    
end