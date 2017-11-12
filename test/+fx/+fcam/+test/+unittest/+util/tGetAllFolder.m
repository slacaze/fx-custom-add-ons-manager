classdef tGetAllFolder < fx.fcam.test.WithCleanWorkingDirectory

    properties( GetAccess = protected, Constant )
        Folders = {...
            fullfile( 'test' ),...
            fullfile( 'test', 'childOne' ),...
            fullfile( 'test', 'childTwo' ),...
            fullfile( 'test', 'childOne', 'granChild' ),...
            };
    end
    
    methods( TestMethodSetup )
        
        function makeFolderTree( this )
            cellfun( @mkdir, this.Folders );
        end
        
    end
    
    methods( Test )
        
        function testGetThemAll( this )
            expected = fullfile(...
                this.Root,...
                this.Folders );
            this.verifyEqual( fx.fcam.util.getAllFolders( fullfile( this.Root, 'test' ) ), expected );
        end
        
    end
    
end