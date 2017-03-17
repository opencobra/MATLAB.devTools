function resetLocalFork()
% devTools
%
% PURPOSE: clean all files in the working directory and reset the fork
%
    global gitConf
    global gitCmd

    % retrieve a list of remotes
    [status_gitClean, result_gitClean] = system('git clean -d -f');

    if status_gitClean == 0
        printMsg(mfilename, 'All files have been cleaned.');
    else
        fprintf(result_gitClean);
        fprintf([gitCmd.lead, ' [', mfilename,'] There are no changes that could be cleaned', gitCmd.fail, gitCmd.trail]);
    end

    [status_gitStash, result_gitStash] = system('git stash');

    if status_gitStash == 0
        printMsg(mfilename, 'All local changes have been stashed.');
    else
        fprintf(result_gitStash);
        fprintf([gitCmd.lead, ' [', mfilename,'] There are no changes that could be stashed', gitCmd.fail, gitCmd.trail]);
    end

    % update the local fork
    updateFork();
end
