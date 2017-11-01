classdef tSandboxConfig < fx.mcam.test.WithCleanWorkingDirectory
    
    properties( GetAccess = private, Constant )
        Name(1,:) char = 'testAddOn'
        ShortName(1,:) char = 'somewhere'
        ParentPackage(1,:) char = 'fx'
        TestFolder(1,:) char = 'C:\elsewhere'
        TestPackages(:,2) cell = {'all', 'package'}
    end
    
    methods( Test )
        
        function testLoad( this )
            sampleConfig = this.makeSampleConfig();
            sbConfig = fx.mcam.SandboxConfig.fromFile( sampleConfig );
            this.verifyEqual( sbConfig.Name, this.Name );
            this.verifyEqual( sbConfig.ShortName, this.ShortName );
            this.verifyEqual( sbConfig.ParentPackage, this.ParentPackage );
            this.verifyEqual( sbConfig.TestFolder, this.TestFolder );
            this.verifyEqual( sbConfig.TestPackages, this.TestPackages );
        end
        
        function testWrite( this )
            sbConfig = fx.mcam.SandboxConfig();
            sbConfig.Name = this.Name;
            sbConfig.ShortName = this.ShortName;
            sbConfig.ParentPackage = this.ParentPackage;
            sbConfig.TestFolder = this.TestFolder;
            sbConfig.TestPackages = this.TestPackages;
            sbConfig.toFile( 'actual.json' );
            this.verifyEqual( exist( 'actual.json', 'file' ), 2 );
            config = jsondecode( fileread( 'actual.json' ) );
            this.verifyEqual( config.name, this.Name );
            this.verifyEqual( config.short_name, this.ShortName );
            this.verifyEqual( config.parent_package, this.ParentPackage );
            this.verifyEqual( config.test.root, this.TestFolder );
            this.verifyEqual( config.test.suites, struct( this.TestPackages{1,1}, {this.TestPackages{1,2}} ) );
        end
        
    end
    
    methods( Access = private )
        
        function filePath = makeSampleConfig( this )
            filePath = fullfile( this.Root, 'sample.json' );
            config = struct(...
                'name', {this.Name},...
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