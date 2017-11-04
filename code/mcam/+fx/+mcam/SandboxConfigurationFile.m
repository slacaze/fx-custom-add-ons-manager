classdef SandboxConfigurationFile < fx.mcam.internal.File
    
    properties( GetAccess = protected, Constant )
        ValidNames = 'mcam[.]json'
    end
    
    properties( GetAccess = public, SetAccess = public, Dependent )
        ParentPackage(1,:) char = char.empty
        ShortName(1,:) char = char.empty
        TestFolder(1,:) char = char.empty
        TestPackages(:,2) cell = cell.empty
    end
    
    properties( GetAccess = private, SetAccess = private )
        ParentPackage_(1,:) char {fx.mcam.util.mustBeValidPackageName} = char.empty
        ShortName_(1,:) char {fx.mcam.util.mustBeValidFileName} = char.empty
        TestFolder_(1,:) char {fx.mcam.util.mustBeValidFileName} = char.empty
        TestPackages_(:,2) cell {fx.mcam.util.mustBeValidPackageName} = cell.empty
    end
    
    methods
        
        function value = get.ParentPackage( this )
            this = this.deserialize();
            value = this.ParentPackage_;
        end
        
        function this = set.ParentPackage( this, value )
            this.ParentPackage_ = value;
            this = this.serialize();
        end
        
        function value = get.ShortName( this )
            this = this.deserialize();
            value = this.ShortName_;
        end
        
        function this = set.ShortName( this, value )
            this.ShortName_ = value;
            this = this.serialize();
        end
        
        function value = get.TestFolder( this )
            this = this.deserialize();
            value = this.TestFolder_;
        end
        
        function this = set.TestFolder( this, value )
            this.TestFolder_ = value;
            this = this.serialize();
        end
        
        function value = get.TestPackages( this )
            this = this.deserialize();
            value = this.TestPackages_;
        end
        
        function this = set.TestPackages( this, value )
            this.TestPackages_ = value;
            this = this.serialize();
        end
        
    end
    
    methods( Access = public )
        
        function this = SandboxConfigurationFile( path )
            this@fx.mcam.internal.File( path );
        end
        
    end
    
    methods( Access = protected )
        
        function this = createStub( this )
            this.serialize();
        end
        
    end
    
    methods( Access = private )
        
        function this = serialize( this )
            config = struct();
            % AddOn info
            config.parent_package = this.ParentPackage_;
            config.short_name = this.ShortName_;
            % Test config
            config.test = struct();
            config.test.root = this.TestFolder_;
            config.test.suites = struct();
            for testIndex = 1:size( this.TestPackages_, 1 )
                config.test.suites.(this.TestPackages_{testIndex,1}) =...
                    this.TestPackages_{testIndex,2};
            end
            % Serialize to file
            this.updateFileContent(...
                fx.mcam.util.prettifyJson( jsonencode( config ) ) );
        end
        
        function this = deserialize( this )
            config = jsondecode( fileread( this.FilePath ) );
            validateattributes( config,...
                {'struct'}, {'scalar'} );
            % AddOn info
            if isfield( config, 'parent_package' )
                this.ParentPackage_ = config.parent_package;
            else
                this.ParentPackage_ = char.empty;
            end
            if isfield( config, 'short_name' )
                this.ShortName_ = config.short_name;
            else
                this.ShortName_ = char.empty;
            end
            % Test config
            if isfield( config, 'test' )
                if isfield( config.test, 'root' )
                    this.TestFolder_ = config.test.root;
                else
                    this.TestFolder_ = char.empty;
                end
                if isfield( config.test, 'suites' )
                    suiteNames = fieldnames( config.test.suites );
                    for suiteIndex = 1:numel( suiteNames )
                        this.TestPackages_(end+1,:) = {...
                            suiteNames{suiteIndex},...
                            config.test.suites.(suiteNames{suiteIndex}),...
                            };
                    end
                else
                    this.TestPackages_ = cell.empty;
                end
            else
                this.TestFolder_ = char.empty;
                this.TestPackages_ = cell.empty;
            end
        end
        
    end
    
end