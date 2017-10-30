function decision = validFileName( string )
    validateattributes( string,...
        {'char'}, {'scalartext'} );
    decision = isempty( regexp( string, '[ \\/<>]', 'once' ) );
end