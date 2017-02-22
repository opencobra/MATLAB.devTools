function configureFork()

    global gitConf
    global gitCmd

    % save the currentDir
    currentDir = strrep(pwd,'\','\\');

    % if the fork does not exist, clone it
    if exist(gitConf.fullForkDir) ~= 7
        cloneFork();

    % if the local fork directory exists
    else
        % change the directory to the current fork
        cd(gitConf.fullForkDir);

        % retrieve a list of remotes
        [status, result] = system('git remote -v');

        if status == 0 && contains(result, 'origin') && contains(result, 'upstream') && contains(result, gitConf.userName) && contains(result, gitConf.remoteUserName)
            if gitConf.verbose
                fprintf([gitCmd.lead, ' [', mfilename,'] Your fork is properly configured. ', gitCmd.success, gitCmd.trail]);
            end
        else
            [status, result] = system(['git remote add upstream ', gitConf.remoteRepoURL]);
            if status == 0
                if gitConf.verbose
                    fprintf([gitCmd.lead, ' [', mfilename,'] ', gitConf.remoteRepoURL, ' added with remote name "upstream".', gitCmd.success, gitCmd.trail]);
                end
            else
                result
                error([gitCmd.lead, ' [', mfilename,'] ', gitConf.remoteRepoURL, ' could not be added as remote named "upstream".', gitCmd.fail]);
            end
        end
    end

    % change back to the current directory
    cd(currentDir);
end
