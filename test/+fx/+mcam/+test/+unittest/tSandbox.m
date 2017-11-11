classdef tSandbox < fx.mcam.test.WithCleanWorkingDirectory
    
    properties( TestParameter )
        PrjAliasedProperty = {...
            'Name',...
            'Author',...
            'Email',...
            'Company',...
            'Summary',...
            'Description',...
            'Version',...
            }
        InitialExpectedValue = {...
            'My AddOn Name',...
            '',...
            '',...
            '',...
            '',...
            '',...
            '1.0.0',...
            }
        NewValue = {...
            'My New Name',...
            'me',...
            'me@gmail.com',...
            'mw',...
            'short text',...
            'much longer text',...
            '1.3.2',...
            }
    end
    
    properties( GetAccess = private, Constant )
        Name(1,:) char = 'testAddOn'
        ShortName(1,:) char = 'somewhere'
        TestFolder(1,:) char = 'C:\elsewhere'
        ParentPackage(1,:) char = 'fx'
    end
    
    properties( GetAccess = private, SetAccess = private )
        Sandbox(1,:) fx.mcam.Sandbox
    end
    
    methods( TestMethodSetup )
        
        function createSandboxWithStub( this )
            this.Sandbox = fx.mcam.Sandbox( pwd );
            this.Sandbox.createStub();
        end
        
    end
    
    methods( Test )
        
        function testSandboxCreation( this )
            this.verifyEqual( exist( sprintf( 'mcam.json' ), 'file' ), 2 );
            this.verifyEqual( exist( sprintf( 'myaddon.prj' ), 'file' ), 2 );
            this.verifyEqual( exist( 'code', 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'myaddon' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'myaddon', '+fx' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'myaddon', '+fx', '+myaddon' ), 'dir' ), 7 );
            this.verifyEqual( exist( 'test', 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+myaddon' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+myaddon', '+test' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'test', '+fx', '+myaddon', '+test', '+unittest' ), 'dir' ), 7 );
            this.verifyEqual( exist( 'mcam.json', 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'code', 'myaddon', 'myaddonroot.m' ), 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'test', 'myaddontestroot.m' ), 'file' ), 2 );
            rootContent = fileread( fullfile( 'code', 'myaddon', 'myaddonroot.m' ) );
            this.verifyEqual( rootContent, sprintf( 'function thisPath = myaddonroot()\r\n    thisPath = fileparts( mfilename( ''fullpath'' ) );\r\nend' ) );
            rootContent = fileread( fullfile( 'test', 'myaddontestroot.m' ) );
            this.verifyEqual( rootContent, sprintf( 'function thisPath = myaddontestroot()\r\n    thisPath = fileparts( mfilename( ''fullpath'' ) );\r\nend' ) );
        end
        
        function testAddAndRemoveSandbox( this )
            oldPath = strsplit( path, ';' );
            this.Sandbox.addToPath();
            newPath = strsplit( path, ';' );
            addedPath = setdiff( newPath, oldPath );
            expectedPathAdded = {...
                fullfile( this.Root, 'code', 'myaddon' ),...
                fullfile( this.Root, 'test' ),...
                };
            this.verifyTrue( all( ismember( addedPath, expectedPathAdded ) ) );
            this.Sandbox.removeFromPath();
            newPath = strsplit( path, ';' );
            this.verifyEqual( oldPath, newPath );
        end
        
        function testSandboxCanDetectConfigAndPrjFile( this )
            newSandbox = fx.mcam.Sandbox( this.Root );
            this.verifyNotEmpty( newSandbox.Prj );
            this.verifyNotEmpty( newSandbox.Configuration );
            this.verifyEqual( this.Sandbox.Guid, this.Sandbox.Prj.Guid );
        end
        
        function testPackage( this )
            this.verifyEqual( exist( sprintf( '%s v1.0.0.mltbx', this.Name ), 'file' ), 0 );
            this.Sandbox.Name = this.Name;
            this.Sandbox.package();
            this.verifyEqual( exist( sprintf( '%s v1.0.0.mltbx', this.Name ), 'file' ), 2 );
        end
        
    end
    
    methods( Test, ParameterCombination = 'sequential' )
        
        function testChangingName( this, PrjAliasedProperty, InitialExpectedValue, NewValue )
            this.verifyEqual( this.Sandbox.(PrjAliasedProperty), InitialExpectedValue );
            this.Sandbox.(PrjAliasedProperty) = NewValue;
            this.verifyEqual( this.Sandbox.(PrjAliasedProperty), NewValue );
            this.verifyEqual( this.Sandbox.Prj.(PrjAliasedProperty), NewValue );
        end
        
    end
    
end