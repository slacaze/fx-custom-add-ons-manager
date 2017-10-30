function decision = mustBeValidPackageName( string )
    validateattributes( string,...
        {'char'}, {'scalartext'} );
    decision = isempty( regexp( string, '[^a-zA-Z.]', 'once' ) );
end