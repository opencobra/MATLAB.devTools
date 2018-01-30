function checkDevTools()
% Checks the configuration of the development tools
%
% USAGE:
%
%    checkDevTools()
%
% .. Author:
%      - Laurent Heirendt

    global gitConf
    global gitCmd

    % check if the forked directory already exists
    if ~isfield(gitConf, 'userName') || ~isfield(gitConf, 'localDir')
        initDevTools();
    else
        fprintf([gitCmd.lead, ' [', mfilename,'] The development tools are properly configured.', gitCmd.success, gitCmd.trail]);
    end
end
