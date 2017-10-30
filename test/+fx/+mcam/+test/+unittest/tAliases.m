classdef tAliases < fx.mcam.test.WithCleanWorkingDirectory
    
    methods( Test )
        
        function testMkSandbox( this )
            folder = 'thisRoot';
            mksandbox( folder,...
                'ShortName', 'rockstar',...
                'TestFolder', 'fancytests',...
                'ParentPackage', 'super.tramp' );
            this.verifyEqual( pwd, fullfile( this.Root, 'thisRoot' ) );
            this.verifyEqual( exist( 'code', 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'rockstar' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'rockstar', '+super' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'rockstar', '+super', '+tramp' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'code', 'rockstar', '+super', '+tramp', '+rockstar' ), 'dir' ), 7 );
            this.verifyEqual( exist( 'fancytests', 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'fancytests', '+super' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'fancytests', '+super', '+tramp' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'fancytests', '+super', '+tramp', '+rockstar' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'fancytests', '+super', '+tramp', '+rockstar', '+test' ), 'dir' ), 7 );
            this.verifyEqual( exist( fullfile( 'fancytests', '+super', '+tramp', '+rockstar', '+test', '+unittest' ), 'dir' ), 7 );
            this.verifyEqual( exist( 'mcam.json', 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'code', 'rockstar', 'rockstarroot.m' ), 'file' ), 2 );
            this.verifyEqual( exist( fullfile( 'fancytests', 'rockstartestroot.m' ), 'file' ), 2 );
        end
        
        function testAddAndRemoveSandbox( this )
            folder = 'thisRoot';
            mksandbox( folder,...
                'ShortName', 'rockstar',...
                'TestFolder', 'fancytests',...
                'ParentPackage', 'super.tramp' );
            cd( '..' );
            oldPath = strsplit( path, ';' );
            addsandbox( folder );
            newPath = strsplit( path, ';' );
            addedPath = setdiff( newPath, oldPath );
            expectedPathAdded = {...
                fullfile( this.Root, folder, 'code', 'rockstar' ),...
                fullfile( this.Root, folder, 'fancytests' ),...
                };
            this.verifyTrue( all( ismember( addedPath, expectedPathAdded ) ) );
            rmsandbox( folder )
            newPath = strsplit( path, ';' );
            this.verifyEqual( oldPath, newPath );
        end
        
    end
    
end