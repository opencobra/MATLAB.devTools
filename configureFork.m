function configureFork()

    global gitConf
    global gitCmd

    % save the currentDir
    currentDir = pwd;

    % if the fork does not exist, clone it
    if exist(gitConf.fullForkDir) ~= 7
        %cloneMyFork();

    % if the local fork directory exists
    else
        % change the directory to the current fork
        cd(gitConf.fullForkDir);

        % retrieve a list of remotes
        [status, result] = system('git remote -v');

        if status == 0 && contains(result, 'origin') && contains(result, 'upstream') && contains(result, gitConf.username) && contains(result, gitConf.remoteUserName)
            fprintf([gitCmd.lead, 'Your fork is properly configured. ', gitCmd.success, gitCmd.trail]);
        else
            [status, ~] = system(['git remote add upstream ', gitConf.remoteRepoURL]);
            if status == 0
                fprintf([gitCmd.lead, gitConf.remoteRepoURL, ' added with remote name "upstream".', gitCmd.success, gitCmd.trail]);
            else
                fprintf([gitCmd.lead, gitConf.remoteRepoURL, ' could not be added as remote named "upstream".', gitCmd.fail, gitCmd.trail]);
            end
        end
    end

    % change back to the current directory
    cd(currentDir);
end
