classdef Sandbox < handle
    
    properties( GetAccess = public, SetAccess = immutable )
        Root char = char.empty
    end
    
    properties( GetAccess = public, SetAccess = private )
        Configuration(1,1) fx.mcam.SandboxConfig = fx.mcam.SandboxConfig
        Prj(1,:) fx.mcam.PrjFile {fx.mcam.util.mustBeEmptyOrScalar} = fx.mcam.PrjFile.empty
    end
    
    properties( GetAccess = public, SetAccess = private, Dependent )
        ConfigFile(1,:) char
        PrjFile(1,:) char
        SourceCodeFolder(1,:) char
        TestFolder(1,:) char
    end
    
    methods
        
        function value = get.ConfigFile( this )
            value = fullfile(...
                this.Root,...
                'mcam.json' );
        end
        
        function value = get.PrjFile( this )
            value = fullfile(...
                this.Root,...
                sprintf( '%s.prj', this.Configuration.ShortName ) );
        end
        
        function value = get.SourceCodeFolder( this )
            value = fullfile(...
                this.Root,...
                'code',...
                this.Configuration.ShortName );
        end
        
        function value = get.TestFolder( this )
            value = fullfile(...
                this.Root,...
                this.Configuration.TestFolder );
        end
        
    end
    
    methods( Access = public )
        
        function this = Sandbox( root )
            validateattributes( root,...
                {'char'}, {'scalartext'} );
            root = fx.mcam.util.getFullPath( root );
            assert( exist( root, 'dir' ) == 7,...
                'MCAM:InvalidRoot',...
                'The path "%s" does not exist.',...
                root );
            this.Root = root;
            this.attemptToInitialize();
        end
        
    end
    
    methods( Access = public )
        
        function refreshConfiguration( this )
            this.ensureConfigFileExist();
            this.Configuration = fx.mcam.SandboxConfig.fromFile( this.ConfigFile );
        end
        
        function createStub( this, varargin )
            % Parse Inputs
            parser = inputParser();
            parser.addParameter( 'Name', 'My AddOn Name',...
                @(x) validateattributes( x, {'char'}, {'scalartext'} ) );
            parser.addParameter( 'ShortName', 'myaddon',...
                @(x) validateattributes( x, {'char'}, {'scalartext'} ) );
            parser.addParameter( 'ParentPackage', 'fx',...
                @(x) validateattributes( x, {'char'}, {'scalartext'} ) );
            parser.addParameter( 'TestFolder', 'test',...
                @(x) validateattributes( x, {'char'}, {'scalartext'} ) );
            parser.parse( varargin{:} );
            inputs = parser.Results;
            usingDefaults = parser.UsingDefaults;
            % Grab config if exist
            if exist( this.ConfigFile, 'file' )
                this.Configuration = fx.mcam.SandboxConfig.fromFile( this.ConfigFile );
                if ~any( strcmp( 'Name', usingDefaults ) ) && ~isempty( this.Configuration.Name )
                    inputs.Name = this.Configuration.Name;
                end
                if ~any( strcmp( 'ShortName', usingDefaults ) ) && ~isempty( this.Configuration.ShortName )
                    inputs.ShortName = this.Configuration.ShortName;
                end
                if ~any( strcmp( 'ParentPackage', usingDefaults ) ) && ~isempty( this.Configuration.ParentPackage )
                    inputs.ParentPackage = this.Configuration.ParentPackage;
                end
                if ~any( strcmp( 'TestFolder', usingDefaults ) ) && ~isempty( this.Configuration.TestFolder )
                    inputs.TestFolder = this.Configuration.TestFolder;
                end
                delete( this.ConfigFile );
            end
            this.validateRootIsEmpty();
            % Code stub
            codeRoot = fullfile( this.Root, 'code' );
            codePath = codeRoot;
            mkdir( codePath );
            codePath = fullfile( codePath, inputs.ShortName );
            mkdir( codePath );
            fx.mcam.util.addRoot( codePath, sprintf( '%sroot', inputs.ShortName ) );
            % Test stub
            testRoot = fullfile( this.Root, inputs.TestFolder );
            testPath = testRoot;
            mkdir( testPath );
            fx.mcam.util.addRoot( testPath, sprintf( '%stestroot', inputs.ShortName ) );
            % Add parent package tree
            parentPackages = strsplit( inputs.ParentPackage, '.' );
            for packageIndex = 1:numel( parentPackages )
                thisPackage = parentPackages{packageIndex};
                codePath = fullfile( codePath, sprintf( '+%s', thisPackage ) );
                mkdir( codePath );
                testPath = fullfile( testPath, sprintf( '+%s', thisPackage ) );
                mkdir( testPath );
            end
            % Add main package
            codePath = fullfile( codePath, sprintf( '+%s', inputs.ShortName ) );
            mkdir( codePath );
            testPath = fullfile( testPath, sprintf( '+%s', inputs.ShortName ) );
            mkdir( testPath );
            % Lay down test specifics
            testPath = fullfile( testPath, '+test' );
            mkdir( testPath );
            testPath = fullfile( testPath, '+unittest' );
            mkdir( testPath );
            % Place the config
            this.Configuration.ShortName = inputs.ShortName;
            this.Configuration.ParentPackage = inputs.ParentPackage;
            this.Configuration.TestFolder = inputs.TestFolder;
            if ~isempty( this.Configuration.ParentPackage )
                testPackage = this.Configuration.ParentPackage;
            else
                testPackage = char.empty;
            end
            testPackage = sprintf( '%s.%s.test', testPackage, this.Configuration.ShortName );
            this.Configuration.TestPackages(end+1,:) = {'all', testPackage};
            testPackage = sprintf( '%s.unittest', testPackage );
            this.Configuration.TestPackages(end+1,:) = {'unittest', testPackage};
            this.Configuration.toFile( this.ConfigFile );
            % Place the Prj
            this.Prj = fx.mcam.PrjFile( this.PrjFile );
        end
        
        function addToPath( this )
            this.refreshConfiguration();
            addpath( this.TestFolder, '-end' )
            addpath( this.SourceCodeFolder, '-end' )
        end
        
        function removeFromPath( this )
            this.refreshConfiguration();
            rmpath( this.TestFolder )
            rmpath( this.SourceCodeFolder )
        end
        
        function testResults = test( this, suiteName )
            this.refreshConfiguration();
            if nargin < 2
                suiteName = '';
            end
            if isempty( this.Configuration.TestPackages )
                testResults = matlab.unittest.TestResult.empty;
                return;
            end
            if isempty( suiteName )
                testIndex = 1;
            else
                testIndex = find( strcmp( suiteName, this.Configuration.TestPackages(:,1) ), 1, 'first' );
            end
            if isempty( testIndex )
                testResults = matlab.unittest.TestResult.empty;
                return;
            else
                testPackage = this.Configuration.TestPackages{testIndex,2};
            end
            testResults = runtests( testPackage, 'IncludeSubpackages', true );
        end
        
    end
    
    methods( Access = private )
        
        function ensureConfigFileExist( this )
            if exist( this.ConfigFile, 'file' ) ~= 2
                file = fopen( this.ConfigFile, 'w' );
                closeFile = onCleanup( @() fclose( file ) );
            end
        end
        
        function validateRootIsEmpty( this )
            entries = dir( this.Root );
            filtered = {...
                '.git' };
            for filteredIndex = 1:numel( filtered )
                match = ismember( filtered{filteredIndex}, {entries.name} );
                entries(match) = [];
            end
            isEmpty = numel( entries ) == 2 &...
                all( ismember( {entries.name}, {'.', '..'} ) );
            assert( isEmpty,...
                'MCAM:RootNotEmpty',...
                'The path "%s" is not empty.',...
                this.Root );
        end
        
        function attemptToInitialize( this )
            if exist( this.ConfigFile, 'file' ) == 2
                this.Configuration = fx.mcam.SandboxConfig.fromFile( this.ConfigFile );
                if exist( this.PrjFile, 'file' ) == 2
                    this.Prj = fx.mcam.PrjFile( this.PrjFile );
                end
            end
        end
        
    end
    
end