classdef tSandboxConfigurationFile < fx.mcam.test.WithCleanWorkingDirectory
    
    properties( GetAccess = private, Constant )
        ShortName(1,:) char = 'somewhere'
        ParentPackage(1,:) char = 'fx'
        TestFolder(1,:) char = 'C:\elsewhere'
        TestPackages(:,2) cell = {'all', 'package'}
    end
    
    methods( Test )
        
        function testLoad( this )
            sampleConfig = this.makeSampleConfig();
            sbConfig = fx.mcam.SandboxConfigurationFile( sampleConfig );
            this.verifyEqual( sbConfig.ShortName, this.ShortName );
            this.verifyEqual( sbConfig.ParentPackage, this.ParentPackage );
            this.verifyEqual( sbConfig.TestFolder, this.TestFolder );
            this.verifyEqual( sbConfig.TestPackages, this.TestPackages );
        end
        
        function testWrite( this )
            this.verifyEqual( exist( 'mcam.json', 'file' ),  0 );
            sbConfig = fx.mcam.SandboxConfigurationFile( 'mcam.json' );
            this.verifyEqual( exist( 'mcam.json', 'file' ),  2 );
            sbConfig.ShortName = this.ShortName;
            sbConfig.ParentPackage = this.ParentPackage;
            sbConfig.TestFolder = this.TestFolder;
            sbConfig.TestPackages = this.TestPackages;
            config = jsondecode( fileread( 'mcam.json' ) );
            this.verifyEqual( config.short_name, this.ShortName );
            this.verifyEqual( config.parent_package, this.ParentPackage );
            this.verifyEqual( config.test.root, this.TestFolder );
            this.verifyEqual( config.test.suites, struct( this.TestPackages{1,1}, {this.TestPackages{1,2}} ) );
        end
        
        function testWritingDoesNotOverWriteOthers( this )
            sampleConfig = this.makeSampleConfig();
            sbConfig = fx.mcam.SandboxConfigurationFile( sampleConfig );
            sbConfig.TestPackages(end+1,:) = {'anothersuite', 'otherPackage'};
            this.verifyEqual( sbConfig.ShortName, this.ShortName );
        end
        
    end
    
    methods( Access = private )
        
        function filePath = makeSampleConfig( this )
            filePath = fullfile( this.Root, 'mcam.json' );
            config = struct(...
                'short_name', {this.ShortName},...
                'test', {struct( 'root', {this.TestFolder}, 'suites', struct( this.TestPackages{1,1}, {this.TestPackages{1,2}} ) )},...
                'parent_package', {this.ParentPackage} );
            file = fopen( filePath, 'w' );
            closeFile = onCleanup( @() fclose( file ) );
            fprintf( file, '%s',...
                jsonencode( config ) );
        end
        
    end
    
end