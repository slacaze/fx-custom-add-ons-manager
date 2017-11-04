classdef tSandbox < fx.mcam.test.WithCleanWorkingDirectory
    
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
        end
        
    end
    
end