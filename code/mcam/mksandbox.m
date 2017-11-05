function mksandbox( varargin )
    % Create a new sandbox
    % Creates a new sandbox, with a starting fodler structure, an
    % "mcam.json" file, and PRJ file, some generic starting packages and
    % functions.
    %
    %   mksandbox() creates a sandbox in the current folder, with default
    %   starting parameters.
    %    
    %   mksandbox( Name, Value ) uses the specified name-value pairs.
    %    
    %   mksandbox( path ) creates a sandbox in the "path" location, with
    %   default starting parameters, and makes it the starting directory.
    %    
    %   mksandbox( path, Name, Value ) uses the specified name-value pairs.
    %
    %   Example
    %      mksandbox( 'ShortName', 'filesystem' );
    %      packagesandbox();
    %      ver filesystem
    %
    %   Name-Value Pairs
    %      Name - The name of the Add-On, default, "My AddOn Name".
    %      ShortName - The short name of the Add-On, used to name the PRJ
    %      and the source code folder. Also used to retrieve version
    %      information with the "<a href="matlab: help ver;">ver</a>"
    %      command. Default, "myaddon".
    %      ParentPackage - The parent package of this Add-On. Useful to
    %      group components (Add-Ons) under a common namespace. Default,
    %      "fx".
    %      TestFolder - The name of the test folder. Deafult, "test".
    %
    %   See also addsandbox, rmsandbox, testsandbox, testaddon,
    %   packagesandbox
    
    fx.mcam.command.mksandbox( varargin{:} );
end