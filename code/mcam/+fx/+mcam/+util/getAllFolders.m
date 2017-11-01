function allFolders = getAllFolders( root )
    listing = dir( fullfile( root, '**' ) );
    listing = listing([listing.isdir]);
    rootListing = strcmp( {listing.name}, '.' );
    listing(rootListing) = [];
    parentListing = strcmp( {listing.name}, '..' );
    listing(parentListing) = [];
    allFolders = arrayfun( @(listing) fullfile( listing.folder, listing.name ), listing,...
        'UniformOutput', false );
end