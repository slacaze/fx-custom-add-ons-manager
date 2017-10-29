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
        
        function testWrite( this )
            sbConfig = fx.mcam.SandboxConfig();
            sbConfig.Name = this.Name;
            sbConfig.SourceCodeFolder = this.SourceCodeFolder;
            sbConfig.toFile( 'actual.json' );
            this.verifyEqual( exist( 'actual.json', 'file' ), 2 );
            config = jsondecode( fileread( 'actual.json' ) );
            this.verifyEqual( config.Name, this.Name );
            this.verifyEqual( config.SourceCodeFolder, this.SourceCodeFolder );
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