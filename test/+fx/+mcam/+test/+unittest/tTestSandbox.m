classdef tTestSandbox < fx.mcam.test.WithSampleSandbox
    
    methods( Test )
        
        function testPath( this )
            sandbox = fx.mcam.Sandbox( this.Root );
            sandbox.addToPath();
            [~, results] = evalc( 'sandbox.test();' );
            this.verifyNumElements( results, 2 );
            this.verifyTrue( ~any( [results.Failed] ) );
            [~, results] = evalc( 'sandbox.test( ''unittest'' );' );
            sandbox.removeFromPath();
            this.verifyNumElements( results, 1 );
            this.verifyTrue( ~any( [results.Failed] ) );
        end
        
        function testAlias( this )
            addsandbox();
            [~, results] = evalc( 'testsandbox();' );
            this.verifyNumElements( results, 2 );
            this.verifyTrue( ~any( [results.Failed] ) );
            [~, results] = evalc( 'testsandbox( this.Root, ''unittest'' );' );
            rmsandbox();
            this.verifyNumElements( results, 1 );
            this.verifyTrue( ~any( [results.Failed] ) );
        end
        
    end
    
end