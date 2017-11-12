function jsonString = prettifyJson( jsonString )
    jsonString = org.json.JSONObject( jsonString );
    jsonString = char( jsonString.toString( 4 ) );
end

