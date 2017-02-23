function checkRemoteFork()
% The COBRA Toolbox: Development tools
%
% PURPOSE: checks whether the fork exists remotely
%

    global gitConf
    global gitCmd

    % check the system
    checkSystem(mfilename);

    % check the URLs of the fork and the remote repository
    if ~isempty(gitConf.userName)

        [status, result] = system(['curl -s --head ', gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName]);

        % check if the URL exists
        if status == 0 && contains(result, '200 OK')
            gitConf.forkURL = [gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName, '.git'];

            if gitConf.verbose
                fprintf([gitCmd.lead, ' [', mfilename, '] The original repository has already been forked on Github (', gitConf.forkURL,').', gitCmd.success, gitCmd.trail]);
            end
        else
            result
            tmpCmd = gitCmd;
            tmpConf = gitConf;
            resetDevTools();
            error([tmpCmd.lead, ' [', mfilename, '] The URL of the fork (', tmpConf.remoteServerName, tmpConf.userName, '/', tmpConf.remoteRepoName, ') is not reachable or does not exist.\n Please browse to ', tmpConf.remoteRepoURL, ' in order to fork the repository (click on the button FORK).', tmpCmd.fail, tmpCmd.trail]);
        end
    else
        error([gitCmd.lead, ' [', mfilename, '] The entered Github username (', gitConf.userName, ') is not valid.']);
    end
end
