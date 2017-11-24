classdef Sandbox < handle
    
    properties( GetAccess = public, SetAccess = immutable )
        Root char = char.empty
    end
    
    properties( GetAccess = public, SetAccess = public, Dependent )
        Name(1,:) char
        Author(1,:) char
        Email(1,:) char
        Company(1,:) char
        Summary(1,:) char
        Description(1,:) char
        Version(1,:) char
    end
    
    properties( GetAccess = public, SetAccess = private, Dependent )
        Guid(1,:) char
    end
    
    properties( GetAccess = public, SetAccess = private, Hidden )
        Configuration(1,:) fx.fcam.SandboxConfigurationFile {fx.fcam.util.mustBeEmptyOrScalar} = fx.fcam.SandboxConfigurationFile.empty
        Prj(1,:) fx.fcam.PrjFile {fx.fcam.util.mustBeEmptyOrScalar} = fx.fcam.PrjFile.empty
    end
    
    properties( GetAccess = public, SetAccess = private, Dependent, Hidden )
        ConfigFile(1,:) char
        PrjFile(1,:) char
        ContentsFile(1,:) char
        SourceCodeFolder(1,:) char
        TestFolder(1,:) char
    end
    
    methods
        
        function value = get.Name( this )
            value = this.Prj.Name;
        end
        
        function set.Name( this, value )
            this.Prj.Name = value;
        end
        
        function value = get.Author( this )
            value = this.Prj.Author;
        end
        
        function set.Author( this, value )
            this.Prj.Author = value;
        end
        
        function value = get.Email( this )
            value = this.Prj.Email;
        end
        
        function set.Email( this, value )
            this.Prj.Email = value;
        end
        
        function value = get.Company( this )
            value = this.Prj.Company;
        end
        
        function set.Company( this, value )
            this.Prj.Company = value;
        end
        
        function value = get.Summary( this )
            value = this.Prj.Summary;
        end
        
        function set.Summary( this, value )
            this.Prj.Summary = value;
        end
        
        function value = get.Description( this )
            value = this.Prj.Description;
        end
        
        function set.Description( this, value )
            this.Prj.Description = value;
        end
        
        function value = get.Version( this )
            value = this.Prj.Version;
        end
        
        function set.Version( this, value )
            this.Prj.Version = value;
        end
        
        function value = get.Guid( this )
            value = this.Prj.Guid;
        end
        
        function value = get.ConfigFile( this )
            value = fullfile(...
                this.Root,...
                'fcam.json' );
        end
        
        function value = get.PrjFile( this )
            value = fullfile(...
                this.Root,...
                sprintf( '%s.prj', this.Configuration.ShortName ) );
        end
        
        function value = get.ContentsFile( this )
            value = fullfile(...
                this.SourceCodeFolder,...
                'Contents.m' );
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
            root = fx.fcam.util.getFullPath( root );
            assert( exist( root, 'dir' ) == 7,...
                'FCAM:InvalidRoot',...
                'The path "%s" does not exist.',...
                root );
            this.Root = root;
            if exist( this.ConfigFile, 'file' ) == 2
                this.Configuration = fx.fcam.SandboxConfigurationFile( this.ConfigFile );
                if exist( this.PrjFile, 'file' ) == 2
                    this.Prj = fx.fcam.PrjFile( this.PrjFile );
                end
            end
        end
        
    end
    
    methods( Access = public )
        
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
                this.Configuration = fx.fcam.SandboxConfig.fromFile( this.ConfigFile );
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
            fx.fcam.util.addRoot( codePath, sprintf( '%sroot', inputs.ShortName ) );
            % Test stub
            testRoot = fullfile( this.Root, inputs.TestFolder );
            testPath = testRoot;
            mkdir( testPath );
            fx.fcam.util.addRoot( testPath, sprintf( '%stestroot', inputs.ShortName ) );
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
            this.Configuration = fx.fcam.SandboxConfigurationFile( this.ConfigFile );
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
            % Place the Prj
            this.Prj = fx.fcam.PrjFile( this.PrjFile );
            this.Prj.Name = inputs.Name;
        end
        
        function addToPath( this )
            this.verifyConfigFileExist();
            addpath( this.TestFolder, '-end' )
            addpath( this.SourceCodeFolder, '-end' )
        end
        
        function removeFromPath( this )
            this.verifyConfigFileExist();
            rmpath( this.TestFolder )
            rmpath( this.SourceCodeFolder )
        end
        
        function testResults = test( this, suiteName )
            this.verifyConfigFileExist();
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
            testResults = runtests( testPackage,...
                'IncludeSubpackages', true );
        end
        
        function package( this, outputFile )
            this.verifyConfigFileExist();
            this.verifyPrjFileExist();
            if ~any( strcmp( this.SourceCodeFolder, strsplit( path, ';' ) ) )
                addpath( this.SourceCodeFolder, '-end' );
                removeSourceCodeFolderFromPath = onCleanup(...
                    @() rmpath( this.SourceCodeFolder ) );
            end
            if any( strcmp( this.TestFolder, strsplit( path, ';' ) ) )
                rmpath( this.TestFolder );
                reAddTestFolderToPath = onCleanup(...
                    @() addpath( this.TestFolder, '-end' ) );
            end
            this.prepareForPackaging();
            if nargin < 2
                outputFile = fullfile(...
                    this.Root,...
                    sprintf( '%s v%s.mltbx',...
                    this.Name,...
                    this.Version ) );
            end
            fx.fcam.util.flushEventQueue();
            matlab.addons.toolbox.packageToolbox( this.PrjFile, outputFile );
            fx.fcam.util.flushEventQueue();
        end
        
        function testResults = testPackagedAddon( this, suiteName )
            this.verifyConfigFileExist();
            this.verifyPrjFileExist();
            if nargin < 2
                suiteName = '';
            end
            tempFile = sprintf( '%s.mltbx', tempname );
            this.package( tempFile );
            deleteFile = onCleanup( @() delete( tempFile ) );
            fx.fcam.util.flushEventQueue();
            tempToolbox = matlab.addons.toolbox.installToolbox( tempFile, true );
            uninstallAddOn = onCleanup(...
                @() matlab.addons.toolbox.uninstallToolbox( tempToolbox ) );
            fx.fcam.util.flushEventQueue();
            if any( strcmp( this.SourceCodeFolder, strsplit( path, ';' ) ) )
                rmpath( this.SourceCodeFolder );
                reAddSourceCodeFolderToPath = onCleanup(...
                    @() addpath( this.SourceCodeFolder, '-end' ) );
                reAddSourceCode = true;
            else
                reAddSourceCode = false;
            end
            if ~any( strcmp( this.TestFolder, strsplit( path, ';' ) ) )
                addpath( this.TestFolder, '-end' );
                removeTestFolderFromPath = onCleanup(...
                    @() rmpath( this.TestFolder ) );
                removeTest = true;
            else
                removeTest = false;
            end
            fx.fcam.util.flushEventQueue();
            testResults = this.test( suiteName );
            if reAddSourceCode
                delete( reAddSourceCodeFolderToPath );
            end
            if removeTest
                delete( removeTestFolderFromPath );
            end
            fx.fcam.util.flushEventQueue();
            delete( uninstallAddOn );
            fx.fcam.util.flushEventQueue();
        end
        
    end
    
    methods( Access = private )
        
        function verifyConfigFileExist( this )
            assert( exist( this.ConfigFile, 'file' ) == 2,...
                'FCAM:MissingConfigFile',...
                'Missing "fcam.json" at localtion "%s".',...
                this.ConfigFile );
        end
        
        function verifyPrjFileExist( this )
            assert( exist( this.PrjFile, 'file' ) == 2,...
                'FCAM:MissingPrjFile',...
                'Missing "%s.prj" at localtion "%s".',...
                this.Configuration.ShortName,...
                this.PrjFile );
        end
        
        function validateRootIsEmpty( this )
            entries = dir( this.Root );
            filtered = { ...
                '.git', ...
                '.svn', ...
                };
            match = ismember( {entries.name}, filtered );
            entries(match) = [];
            isEmpty = numel( entries ) == 2 &...
                all( ismember( {entries.name}, {'.', '..'} ) );
            assert( isEmpty,...
                'FCAM:RootNotEmpty',...
                'The path "%s" is not empty.',...
                this.Root );
        end
        
        function prepareForPackaging( this )
            versionLine = sprintf( "%% Version %s (R%s) %s",...
                this.Version,...
                version( '-release' ),...
                datetime( 'now', 'Format', 'dd-MMM-yyyy' ) );
            if exist( this.ContentsFile, 'file' ) ~= 2
                oldPath = pwd;
                cd( this.SourceCodeFolder );
                makecontentsfile( this.SourceCodeFolder );
                cd( oldPath );
                contents = splitlines( string( fileread( this.ContentsFile ) ) );
                contents = [...
                    contents(1);...
                    versionLine;
                    contents(2:end);...
                    ];
            else
                oldPath = pwd;
                cd( this.SourceCodeFolder );
                fixcontents( this.ContentsFile, 'all' );
                cd( oldPath );
                contents = splitlines( string( fileread( this.ContentsFile ) ) );
                contents(2) = versionLine;
            end
            emptyLines = contents == "";
            contents(emptyLines) = [];
            file = fopen( this.ContentsFile, 'w' );
            closeFile = onCleanup( @() fclose( file ) );
            fprintf( file, '%s\n', contents );
        end
        
    end
    
end