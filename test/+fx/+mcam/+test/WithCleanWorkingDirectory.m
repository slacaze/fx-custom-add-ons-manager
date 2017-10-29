classdef WithCleanWorkingDirectory < matlab.unittest.TestCase
    
    properties( GetAccess = protected, SetAccess = private )
        Root(1,:) char = char.empty
    end
    
    methods( TestMethodSetup )
        
        function getCleanWorkingDirectory( this )
            fixture = matlab.unittest.fixtures.WorkingFolderFixture();
            this.Root = fixture.Folder;
            this.applyFixture( fixture );
        end
        
    end
    
end