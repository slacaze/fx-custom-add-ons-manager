function rmsandbox()
    thisPath = fileparts( mfilename( 'fullpath' ) );
    rmpath( fullfile(...
        thisPath,...
        'code',...
        'mcam' ) );
    rmpath( fullfile(...
        thisPath,...
        'test' ) );
end