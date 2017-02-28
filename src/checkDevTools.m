function checkDevTools()
% devTools
%
% PURPOSE: checks the configuration of the development tools
%

    global gitConf
    global gitCmd

    % check if the forked directory already exists
    if ~isfield(gitConf, 'username') || ~isfield(gitConf, 'localDir')
        initDevTools();
    else
        fprintf([gitCmd.lead, ' [', mfilename,'] The development tools are properly configured.', gitCmd.success, gitCmd.trail]);
    end
end
