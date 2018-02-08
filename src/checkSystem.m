function checkSystem(callerName)
% Checks the configuration of the system (installation of git and curl)
%
% USAGE:
%
%    checkSystem(callerName)
%
% INPUT:
%   callerName:     Name of the function calling `checkSystem()`
%
% .. Author:
%      - Laurent Heirendt


    global gitConf
    global gitCmd

    % if a configuration has already been set, configure the devTools accordingly
    if isempty(gitConf)
        confDevTools();
    else
        confDevTools('launcher', gitConf.launcher, 'remoteRepoURL', ...
                     gitConf.remoteRepoURL, 'nickName', gitConf.nickName, 'printLevel', gitConf.printLevel);
    end

    % set the callerName
    if nargin < 1
        callerName = '';
        printLevel = 1;
    else
        printLevel = 0;
        callerName = ['(caller: ', callerName, ')'];
    end

    if printLevel > 0
        gitConfprintLevel = gitConf.printLevel;
        gitConf.printLevel = 1;
    end

    % check if git is properly installed
    [status_gitVersion, result_gitVersion] = system('git --version');

    if status_gitVersion == 0 && ~isempty(strfind(result_gitVersion, 'git version'))
        printMsg(mfilename, [callerName, ' git is properly installed.']);
    else
        fprintf(result_gitVersion);
        error([gitCmd.lead, ' [', mfilename, ']', callerName, ' git is not installed. Please follow the guidelines how to install git.']);
    end

    % check if curl is properly installed
    [status_curl, result_curl] = system('curl --version');

    if status_curl == 0 && ~isempty(strfind(result_curl, 'curl')) && ~isempty(strfind(result_curl, 'http'))
        printMsg(mfilename, [callerName, ' curl is properly installed.']);
    else
        error([gitCmd.lead, ' [', mfilename, ']', callerName, ' curl is not installed. Please follow the guidelines how to install curl.']);
    end

    if printLevel > 0
        gitConf.printLevel = gitConfprintLevel;
    end
end
