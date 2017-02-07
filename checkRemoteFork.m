function checkRemoteFork()

    global gitConf
    global gitCmd

    checkSystem(mfilename);

    % check the URLs of the fork and the remote repository
    if ~isempty(gitConf.username)

        [status, result] = system(['curl -s --head ', gitConf.remoteServerName, gitConf.username, '/', gitConf.remoteRepoName, '| head -n 1']);

        % check if the URL exists
        if status == 0 && contains(result, '200 OK')
            gitConf.forkURL = [gitConf.remoteServerName, gitConf.username, '/', gitConf.remoteRepoName, '.git'];
            fprintf([gitCmd.lead, 'The original repository has already been forked on Github (', gitConf.forkURL,').', gitCmd.success, gitCmd.trail]);
        else
            tmpCmd = gitCmd;
            tmpConf = gitConf;
            resetDevTools();
            error([tmpCmd.lead, 'The URL of the fork is not reachable or does not exist. Please browse to ', tmpConf.remoteRepoURL, ' in order to fork the repository (click on the button FORK).', tmpCmd.fail, tmpCmd.trail]);
        end
    else
        error([gitCmd.lead, 'The entered Github username (', gitConf.username, ') is not valid.']);
    end

end
