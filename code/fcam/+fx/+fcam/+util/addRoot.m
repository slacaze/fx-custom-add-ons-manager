function addRoot( path, name )
    newFileName = fullfile( path, sprintf( '%s.m', name ) );
    rootContent = fileread( fullfile( fcamroot, 'templates', 'root.m' ) );
    file = fopen( newFileName, 'w' );
    closeFile = onCleanup( @() fclose( file ) );
    fprintf( file, '%s', regexprep( rootContent, '\<root\>', name ) );
end