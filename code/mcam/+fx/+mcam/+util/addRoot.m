function addRoot( path, name )
    newFileName = fullfile( path, sprintf( '%s.m', name ) );
    rootContent = fullfile( mcamroot, 'templates', 'root.m' );
    file = fopen( newFileName, 'w' );
    closeFile = onCleanup( @() fclose( file ) );
    fprintf( file, '%s', regexprep( rootContent, '\<root\>', name ) );
end