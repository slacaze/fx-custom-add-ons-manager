classdef tmcamroot < matlab.unittest.TestCase
    
    methods( Test )
        
        function this = testEnhance( this )
            expectedRoot = fileparts( which( 'fcamroot' ) );
            this.verifyEqual( fcamroot, expectedRoot );
        end
        
    end
    
end