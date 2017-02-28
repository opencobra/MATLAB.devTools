function configureFork()
% The COBRA Toolbox: Development tools
%
% PURPOSE: configures the remotes of the local fork (upstream)
%

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
        [status_gitRemote, result_gitRemote] = system('git remote -v');

        if status_gitRemote == 0 && contains(result_gitRemote, 'origin') && contains(result_gitRemote, 'upstream') && contains(result_gitRemote, gitConf.userName) && contains(result_gitRemote, gitConf.remoteUserName)
            if gitConf.verbose
                fprintf([gitCmd.lead, ' [', mfilename,'] Your fork is properly configured. ', gitCmd.success, gitCmd.trail]);
            end
        else
            [status_gitRemoteAdd, result_gitRemoteAdd] = system(['git remote add upstream ', gitConf.remoteRepoURL]);
            if status_gitRemoteAdd == 0
                if gitConf.verbose
                    fprintf([gitCmd.lead, ' [', mfilename,'] ', gitConf.remoteRepoURL, ' added with remote name "upstream".', gitCmd.success, gitCmd.trail]);
                end
            else
                result_gitRemoteAdd
                error([gitCmd.lead, ' [', mfilename,'] ', gitConf.remoteRepoURL, ' could not be added as remote named "upstream".', gitCmd.fail]);
            end
        end
    end

    % change back to the current directory
    cd(currentDir);
end
