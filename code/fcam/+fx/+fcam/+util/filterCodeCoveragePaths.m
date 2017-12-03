function paths = filterCodeCoveragePaths( paths )
    currentPath = regexp( path, pathsep, 'split' );
    keep = true( 1, numel( paths ) );
    for pathIndex = 1:numel( paths )
        thisPath = paths{pathIndex};
        parts = strsplit( thisPath, filesep );
        lastFodler = parts{end};
        if ~any( strcmp( thisPath, currentPath ) ) && ~strncmp( lastFodler, '+', 1 )
            keep(pathIndex) = false;
        end
    end
    paths = paths(keep);
end