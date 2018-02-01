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
        confDevTools(gitConf.launcher, gitConf.remoteRepoURL, gitConf.nickName, gitConf.printLevel);
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
        fprintf(result_curl);
        error([gitCmd.lead, ' [', mfilename, ']', callerName, ' curl is not installed. Please follow the guidelines how to install curl.']);
    end

    % add github.com as a known host
    [status_keyscan, result_keyscan] = system('ssh-keyscan');

    % user directory
    if ispc
        homeDir = getenv('userprofile');
    else
        homeDir = getenv('HOME');
    end

    if status_keyscan == 1 && ~isempty(strfind(result_keyscan, 'usage:'))

        [status_grep, result_grep] = system(['grep "^github.com " ', homeDir, filesep, '.ssh', filesep, 'known_hosts']);

        if status_grep == 1 && length(result_grep) == 0
            [status_kh, result_kh] = system(['ssh-keyscan github.com >> ', homeDir, filesep, '.ssh', filesep, 'known_hosts']);

            if status_kh == 0
                printMsg(mfilename, [callerName, ' github.com has been added to the known hosts']);
            else
                fprintf(result_kh);
                error([gitCmd.lead, ' [', mfilename, ']', callerName, ' github.com could not be added to the known hosts file in ~/.ssh/known_hosts']);
            end
       else
           fprintf(result_grep);
           error([gitCmd.lead, ' [', mfilename, ']', callerName, ' Known hosts cannot be determined.']);
       end
    else
        fprintf(result_keyscan);
        error([gitCmd.lead, ' [', mfilename, ']', callerName, ' ssh-keyscan is not installed.']);
    end

    if printLevel > 0
        gitConf.printLevel = gitConfprintLevel;
    end
end
