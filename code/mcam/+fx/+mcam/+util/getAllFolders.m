function allFolders = getAllFolders( root )
    fx.mcam.util.mustBeValidPath( root );
    assert( exist( root, 'dir' ) == 7,...
        'MCAM:InvalidPath',...
        'The folder "%s" does not exist.' );
    listing = dir( fullfile( root, '**' ) );
    listing = listing([listing.isdir]);
    rootListing = strcmp( {listing.name}, '.' );
    listing(rootListing) = [];
    parentListing = strcmp( {listing.name}, '..' );
    listing(parentListing) = [];
    allFolders = arrayfun( @(listing) fullfile( listing.folder, listing.name ), listing,...
        'UniformOutput', false )';
    allFolders = [...
        {root},...
        allFolders,...
        ];
end