function [] = checkRemoteFork()
% Checks whether the fork exists remotely
%
% USAGE:
%
%    [] = checkRemoteFork()
%
% .. Author:
%      - Laurent Heirendt



    global gitConf
    global gitCmd

    % check the system and set the configuration
    checkSystem(mfilename);

    % check the URLs of the fork and the remote repository
    if isfield(gitConf, 'userName') && ~isempty(gitConf.userName)

        [status_curl, result_curl] = system(['curl -s -k --head ', gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName]);

        % check if the URL exists
        if status_curl == 0 && ~isempty(strfind(result_curl, '200 OK'))
            gitConf.forkURL = [gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName, '.git'];

            printMsg(mfilename, ['The original repository has already been forked on Github (', gitConf.forkURL,').']);
        else
            fprintf(result_curl);
            tmpCmd = gitCmd;
            tmpConf = gitConf;
            resetDevTools();
            error([tmpCmd.lead, ' [', mfilename, '] The URL of the fork (', tmpConf.remoteServerName, tmpConf.userName, '/', tmpConf.remoteRepoName, ') is not reachable or does not exist. Please browse to ', tmpConf.remoteRepoURL, ' in order to fork the repository (click on the button FORK).', tmpCmd.fail]);
        end
    else
        error([gitCmd.lead, ' [', mfilename, '] The entered Github username is not valid.']);
    end
end
