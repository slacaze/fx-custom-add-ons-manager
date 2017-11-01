classdef SandboxConfig
    
    properties( GetAccess = public, SetAccess = public )
        Name(1,:) char = char.empty
        ParentPackage(1,:) char {fx.mcam.util.mustBeValidPackageName} = char.empty
        ShortName(1,:) char {fx.mcam.util.mustBeValidFileName} = char.empty
        TestFolder(1,:) char {fx.mcam.util.mustBeValidFileName} = char.empty
        TestPackages(:,2) cell {fx.mcam.util.mustBeValidPackageName} = cell.empty
    end
    
    methods( Access = public )
        
        function this = SandboxConfig()
        end
        
    end
    
    methods( Access = public, Static )
        
        function this = fromFile( filePath )
            validateattributes( filePath,...
                {'char'}, {'scalartext'} );
            assert( exist( filePath, 'file' ) == 2,...
                'MCAM:InvalidFile',...
                'The file "%s" does not exist.' );
            this = fx.mcam.SandboxConfig;
            config = jsondecode( fileread( filePath ) );
            validateattributes( config,...
                {'struct'}, {'scalar'} );
            this = this.deserialize( config );
        end
        
    end
    
    methods( Access = public )
        
        function toFile( this, filePath )
            validateattributes( filePath,...
                {'char'}, {'scalartext'} );
            config = this.serialize();
            file = fopen( filePath, 'w' );
            closeFile = onCleanup( @() fclose( file ) );
            fprintf( file, '%s',...
                fx.mcam.util.prettifyJson( jsonencode( config ) ) );
        end
        
    end
    
    methods( Access = private, Static )
        
        function propertyNames = getConfigProperties()
            propertyNames = properties( 'fx.mcam.SandboxConfig' );
        end
        
    end
    
    methods( Access = private )
        
        function config = serialize( this )
            config = struct();
            % AddOn info
            config.name = this.Name;
            config.parent_package = this.ParentPackage;
            config.short_name = this.ShortName;
            % Test config
            config.test = struct();
            config.test.root = this.TestFolder;
            config.test.suites = struct();
            for testIndex = 1:size( this.TestPackages, 1 )
                config.test.suites.(this.TestPackages{testIndex,1}) =...
                    this.TestPackages{testIndex,2};
            end
        end
        
        function this = deserialize( this, config )
            % AddOn info
            if isfield( config, 'name' )
                this.Name = config.name;
            end
            if isfield( config, 'parent_package' )
                this.ParentPackage = config.parent_package;
            end
            if isfield( config, 'short_name' )
                this.ShortName = config.short_name;
            end
            % Test config
            if isfield( config, 'test' )
                if isfield( config.test, 'root' )
                    this.TestFolder = config.test.root;
                end
                if isfield( config.test, 'suites' )
                    suiteNames = fieldnames( config.test.suites );
                    for suiteIndex = 1:numel( suiteNames )
                        this.TestPackages(end+1,:) = {...
                            suiteNames{suiteIndex},...
                            config.test.suites.(suiteNames{suiteIndex}),...
                            };
                    end
                end
            end
        end
        
    end
    
end