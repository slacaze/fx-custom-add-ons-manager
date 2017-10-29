classdef SandboxConfig
    
    properties( GetAccess = public, SetAccess = private )
        Name(1,:) char {fx.mcam.util.validFileName} = char.empty
        SourceCodeFolder(1,:) char {fx.mcam.util.validFileName} = char.empty
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
            propertyNames = this.getConfigProperties();
            config = struct();
            for propertyIndex = 1:numel( propertyNames )
                thisProperty = propertyNames{propertyIndex};
                config.(thisProperty) = this.(thisProperty);
            end
        end
        
        function this = deserialize( this, config )
            propertyNames = this.getConfigProperties();
            for propertyIndex = 1:numel( propertyNames )
                thisProperty = propertyNames{propertyIndex};
                if isfield( config, thisProperty )
                    this.(thisProperty) = config.(thisProperty);
                end
            end
        end
        
    end
    
end