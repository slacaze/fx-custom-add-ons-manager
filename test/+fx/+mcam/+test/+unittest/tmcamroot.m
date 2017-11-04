classdef tmcamroot < matlab.unittest.TestCase
    
    methods( Test )
        
        function this = testEnhance( this )
            expectedRoot = fileparts( which( 'mcamroot' ) );
            this.verifyEqual( mcamroot, expectedRoot );
        end
        
    end
    
end