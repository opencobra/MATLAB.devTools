function freshClone = cloneFork()
% The COBRA Toolbox: Development tools
%
% PURPOSE: clones the fork and updates the submodules of the repository
%

    global gitConf
    global gitCmd

    currentDir = strrep(pwd, '\', '\\');

    % check if the fork exists remotely and locally
    checkLocalFork();

    % set the clone flag to false
    freshClone = false;

    % if the fork does not exist, clone it
    if exist(gitConf.localDir, 'dir') ~= 7
        % create the directory
        system(['mkdir ', gitConf.localDir]);

    elseif exist(gitConf.fullForkDir, 'dir') ~= 7
        % change to the local directory
        cd(gitConf.localDir);

        if gitConf.verbose
            fprintf([gitCmd.lead, ' [', mfilename,'] Cloning the fork ', gitConf.forkURL, gitCmd.trail]);
        end

        [status_gitClone, result_gitClone] = system(['git clone ', gitConf.forkURL, ' ', gitConf.forkDirName]);

        if status_gitClone == 0
            if gitConf.verbose
                fprintf([gitCmd.lead, ' [', mfilename,'] The fork ', gitConf.forkURL, ' has been cloned.', gitCmd.success, gitCmd.trail]);
            end

            % change to the fork directory
            cd(gitConf.fullForkDir)

            % update the submodules
            updateSubmodules();

            freshClone = true;
        else
            result_gitClone
            error([gitCmd.lead, ' [', mfilename,'] The fork ', gitConf.forkURL, ' could not be cloned.', gitCmd.fail]);
        end

    % if the fork already exists
    else

        % change to the fork directory
        cd(gitConf.fullForkDir)

        % retrieve a short status from git
        [status_gitStatus, result_gitStatus] = system('git status -s');

        % check if the fork is up-to-date
        if status_gitStatus == 0 && isempty(result_gitStatus)
            if gitConf.verbose
                fprintf([gitCmd.lead, ' [', mfilename,'] Your cobratoolbox fork (username: ', gitConf.userName, ') is already cloned and up-to-date. ', gitCmd.success, gitCmd.trail]);
            end

        % proceed to update the fork
        else
            if gitConf.verbose
                fprintf([gitCmd.lead, ' [', mfilename,'] Your fork is not up-to-date. Please update using "updateFork();".', gitCmd.fail, gitCmd.trail]);
            end
        end
    end

    % change back to the original directory
    cd(currentDir)
end
