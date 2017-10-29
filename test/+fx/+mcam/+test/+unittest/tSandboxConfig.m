classdef tSandboxConfig < fx.mcam.test.WithCleanWorkingDirectory
    
    properties( GetAccess = private, Constant )
        Name(1,:) char = 'testAddOn'
        SourceCodeFolder(1,:) char = 'C:\somewhere'
    end
    
    methods( Test )
        
        function testLoad( this )
            sampleConfig = this.makeSampleConfig();
            sbConfig = fx.mcam.SandboxConfig.fromFile( sampleConfig );
            this.verifyEqual( sbConfig.Name, this.Name );
            this.verifyEqual( sbConfig.SourceCodeFolder, this.SourceCodeFolder);
        end
        
    end
    
    methods( Access = private )
        
        function filePath = makeSampleConfig( this )
            filePath = fullfile( this.Root, 'sample.json' );
            config = struct(...
                'Name', {this.Name},...
                'SourceCodeFolder', {this.SourceCodeFolder} );
            file = fopen( filePath, 'w' );
            closeFile = onCleanup( @() fclose( file ) );
            fprintf( file, '%s',...
                jsonencode( config ) );
        end
        
    end
    
end