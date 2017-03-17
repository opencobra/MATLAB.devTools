function configureFork()
% devTools
%
% PURPOSE: configures the remotes of the local fork (upstream)
%

    global gitConf
    global gitCmd

    % save the currentDir
    currentDir = strrep(pwd, '\', '\\');

    % if the fork does not exist, clone it
    if exist(gitConf.fullForkDir, 'dir') ~= 7
        cloneFork();

    % if the local fork directory exists
    else
        % change the directory to the current fork
        cd(gitConf.fullForkDir);

        % retrieve a list of remotes
        [status_gitRemote, result_gitRemote] = system('git remote -v');

        if status_gitRemote == 0 && ~isempty(strfind(result_gitRemote, 'origin')) && ~isempty(strfind(result_gitRemote, 'upstream')) && ~isempty(strfind(result_gitRemote, gitConf.userName)) && ~isempty(strfind(result_gitRemote, gitConf.remoteUserName))
            printMsg(mfilename, 'Your fork is properly configured.');
        else
            [status_gitRemoteAdd, result_gitRemoteAdd] = system(['git remote add upstream ', gitConf.remoteRepoURL]);
            if status_gitRemoteAdd == 0
                printMsg(mfilename, [gitConf.remoteRepoURL, ' added with remote name <upstream>.']);
            else
                fprintf(result_gitRemoteAdd);
                error([gitCmd.lead, ' [', mfilename,'] ', gitConf.remoteRepoURL, ' could not be added as remote named "upstream".', gitCmd.fail]);
            end
        end
    end

    % change back to the current directory
    cd(currentDir);
end
