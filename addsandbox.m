function addsandbox()
    thisPath = fileparts( mfilename( 'fullpath' ) );
    addpath( fullfile(...
        thisPath,...
        'code',...
        'mcam' ) );
    addpath( fullfile(...
        thisPath,...
        'test' ) );
end