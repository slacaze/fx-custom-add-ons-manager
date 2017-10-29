function decision = validFileName( string )
    decision = isempty( regexp( string, '[ \\/<>]', 'once' ) );
end