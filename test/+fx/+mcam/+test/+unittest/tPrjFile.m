classdef tPrjFile < fx.mcam.test.WithCleanWorkingDirectory
    
    properties
        FilePath = 'myAddon.prj'
    end
    
    properties( TestParameter )
        PropertyName = {...
            'Name',...
            'Author',...
            'Email',...
            'Company',...
            'Summary',...
            'Description',...
            }
        Token = {...
            'param.appname',...
            'param.authnamewatermark',...
            'param.email',...
            'param.company',...
            'param.summary',...
            'param.description',...
            }
    end
    
    methods( Test )
        
        function testCreateStubFile( this )
            this.verifyEqual( exist( this.FilePath, 'file' ), 0 );
            fx.mcam.PrjFile( this.FilePath );
            this.verifyEqual( exist( this.FilePath, 'file' ), 2 );
        end
        
        function testCheckGuidInitializedAndNotModifiable( this )
            prjFile = fx.mcam.PrjFile( this.FilePath );
            this.verifyNotEmpty( prjFile.Guid );
            this.verifyError(...
                @() this.setProp( prjFile, 'Guid', 'someGuid' ),...
                'MATLAB:class:SetProhibited' );
        end
        
        function testCheckVersionInitialized( this )
            prjFile = fx.mcam.PrjFile( this.FilePath );
            this.verifyEqual( prjFile.Version, '1.0.0' );
        end
        
    end
    
    methods( Test, ParameterCombination = 'sequential' )
        
        function testCheckTokenUpdate( this, PropertyName, Token )
            prjFile = fx.mcam.PrjFile( this.FilePath );
            this.verifyEqual( prjFile.(PropertyName), '' );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s[ ]?/>', Token ) ), 2 );
            prjFile.(PropertyName) = 'SomeValue';
            this.verifyEqual( prjFile.(PropertyName), 'SomeValue' );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s[ ]?/>', Token ) ), 0 );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s>%s</%s>', Token, 'SomeValue', Token ) ), 1 );
            prjFile.(PropertyName) = 'Some Other Value';
            this.verifyEqual( prjFile.(PropertyName), 'Some Other Value' );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s[ ]?/>', Token ) ), 0 );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s>%s</%s>', Token, 'Some Other Value', Token ) ), 1 );
        end
        
    end
    
    methods( Access = private )
        
        function setProp( ~, prjFile, propName, propValue )
            prjFile.(propName) = propValue;
        end
        
    end
    
end