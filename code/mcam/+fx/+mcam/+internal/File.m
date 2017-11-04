classdef(Abstract) File
    
    properties( Abstract, GetAccess = protected, Constant )
        ValidNames
    end
    
    properties( GetAccess = public, SetAccess = immutable )
        FilePath char = char.empty
    end
    
    methods( Access = public )
        
        function this = File( path )
            fx.mcam.util.mustBeValidPath( path );
            path = fx.mcam.util.getFullPath( path );
            [~, name, ext] = fileparts( path );
            assert( ~isempty( regexp( [name ext], sprintf( '^%s$', this.ValidNames ), 'once' ) ),...
                'MCAM:InvalidFile',...
                'This name "%s" does not mathc the regexp "%s".',...
                [name ext],...
                this.ValidNames );
            this.FilePath = path;
            if exist( this.FilePath, 'file' ) ~= 2
                this = this.createStub();
            end
        end
        
    end
    
    methods( Abstract, Access = protected )
        this = createStub( this )
    end
    
    methods( Access = protected )
        
        function updateFileContent( this, newContent )
            file = fopen( this.FilePath, 'w' );
            closeFile = onCleanup( @() fclose( file ) );
            fprintf( file, '%s', newContent );
        end
        
    end
    
end