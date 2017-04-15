function freshClone = cloneFork()
% devTools
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

        fprintf([gitCmd.lead, ' [', mfilename,'] Cloning the fork ', gitConf.forkURL, ' (might take some time)', gitCmd.trail]);

        [status_gitClone, result_gitClone] = system(['git clone -c http.sslVerify=false git@github.com:', gitConf.userName, '/', gitConf.nickName, '.git', ' ', gitConf.forkDirName]);

        if status_gitClone == 0
            printMsg(mfilename, ['The fork ', gitConf.forkURL, ' has been cloned.']);

            % change to the fork directory
            cd(gitConf.fullForkDir)

            % update the submodules
            updateSubmodules();

            freshClone = true;
        else
            fprintf(result_gitClone);
            error([gitCmd.lead, ' [', mfilename,'] The fork ', gitConf.forkURL, ' could not be cloned.', gitCmd.fail]);
        end

    % if the fork already exists
    else

        % change to the fork directory
        cd(gitConf.fullForkDir)

        % check if the origin is correctly configure as SSH, and not https
        [status_gitRemote, result_gitRemote] = system('git remote -v');

        remoteFrags = strsplit(result_gitRemote);

        if status_gitRemote == 0 && strcmp(remoteFrags(1), 'origin') && isempty(strfind(char(remoteFrags(2)), 'git@github.com'))

            % remove the origin
            [status_gitRemoveOrigin, result_gitRemoveOrigin] = system('git remote remove origin');

            if status_gitRemoveOrigin == 0
                printMsg(mfilename, 'Origin in local copy of fork removed.');
            else
                fprintf(result_gitRemoveOrigin);
                error([gitCmd.lead, ' [', mfilename,'] Origin in local copy of fork could not be removed.', gitCmd.success, gitCmd.trail]);
            end

            % set a new origin
            [status_gitSetOrigin, result_gitSetOrigin] = system(['git remote add origin git@github.com:', gitConf.userName, '/', gitConf.nickName, '.git']);

            if status_gitSetOrigin == 0
                printMsg(mfilename, 'Origin in local copy of fork set properly.');
            else
                fprintf(result_gitSetOrigin);
                error([gitCmd.lead, ' [', mfilename,'] Origin in local copy of fork could not be set.', gitCmd.fail]);
            end
        end

        % update the submodules
        updateSubmodules();

        % retrieve a short status from git
        [status_gitStatus, result_gitStatus] = system('git status -s');

        % check if the fork is up-to-date
        if status_gitStatus == 0 && isempty(result_gitStatus)
            printMsg(mfilename, ['Your fork (username: ', gitConf.userName, ') is already cloned and up-to-date.']);
        % proceed to update the fork
        else
            printMsg(mfilename, 'Your fork is not up-to-date. Please update using >> updateFork();', [gitCmd.fail, gitCmd.trail]);
        end
    end

    % change back to the original directory
    cd(currentDir)
end
