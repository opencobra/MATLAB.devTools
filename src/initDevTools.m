function initDevTools()
% devTools
%
% PURPOSE: initializes the development tools (username and email are requested if not configured)
%

    global gitConf
    global gitCmd

    % check the system and set the configuration
    checkSystem();

    if ~isfield(gitConf, 'username'), gitConf.userName = []; end
    if ~isfield(gitConf, 'localDir'), gitConf.localDir = []; end

    % parse the remoteRepoURL
    sepIndices = strfind(gitConf.remoteRepoURL, '/');
    gitConf.remoteServerName = gitConf.remoteRepoURL(1:sepIndices(3));
    gitConf.remoteRepoName = gitConf.remoteRepoURL(sepIndices(4)+1:end-4);
    gitConf.remoteUserName = gitConf.remoteRepoURL(sepIndices(3)+1:sepIndices(4)-1);

    [status_gitConfUserGet, result_gitConfUserGet] = system('git config --get user.github-username');
    gitConf.userName = strtrim(result_gitConfUserGet);

    if gitConf.verbose
        originCall = [' [', mfilename, '] '];
    else
        originCall  = '';
    end

    if status_gitConfUserGet == 0 && isempty(strfind(gitConf.userName, ' '))
        fprintf([gitCmd.lead, originCall, 'Your Github username is: ', gitConf.userName, '. ', gitCmd.success, gitCmd.trail]); %
    else
        if gitConf.verbose
            fprintf([gitCmd.lead, originCall, 'The Github username could not be retrieved or is not valid.', gitCmd.fail, gitCmd.trail]);
        end

        % request the Github username if it is not known or if the username contains whitespaces
        if isempty(gitConf.userName) || ~isempty(strfind(gitConf.userName, ' '))
            gitConf.userName = input([gitCmd.lead, originCall, ' -> Please enter your Github username: '], 's');
            [status_gitConfUserSet, result_gitConfUserSet] = system(['git config --global --add user.github-username "', gitConf.userName, '"']);
            if status_gitConfUserSet == 0
                fprintf([gitCmd.lead, originCall, 'Your Github username is: ', gitConf.userName, '. ', gitCmd.success, gitCmd.trail]);
            else
                fprintf(result_gitConfUserSet);
                error([gitCmd.lead, ' [', mfilename,'] Your Github username could not be set.', gitCmd.fail]);
            end
        end
    end

    [status_gitConfEmailGet, result_gitConfEmailGet] = system('git config --get user.email');
    gitConf.userEmail = strtrim(result_gitConfEmailGet);

    if status_gitConfEmailGet == 0
        fprintf([gitCmd.lead, originCall, 'Your Github email is: ', gitConf.userEmail, '. ', gitCmd.success, gitCmd.trail]);
    else
        if gitConf.verbose
            fprintf([gitCmd.lead, originCall, 'The Github email could not be retrieved.', gitCmd.fail, gitCmd.trail]);
        end

        % request the Github username
        if isempty(gitConf.userEmail)
            gitConf.userEmail = input([gitCmd.lead, originCall, ' -> Please enter your Github email: '], 's');

            [status_gitConfEmailSet, result_gitConfEmailSet] = system(['git config --global user.email "', gitConf.userEmail, '"']);
            if status_gitConfEmailSet == 0
                fprintf([gitCmd.lead, originCall, 'Your Github email is: ', gitConf.userEmail, '. ', gitCmd.success, gitCmd.trail]);
            else
                fprintf(result_gitConfEmailSet);
                error([gitCmd.lead, ' [', mfilename,'] Your Github email could not be set.', gitCmd.fail]);
            end
        end
    end

    % check if the fork exists remotely
    checkRemoteFork();

    % request the local directory
    if isempty(gitConf.localDir)

        createDir = false;

        while ~createDir
            reply = input([gitCmd.lead, originCall, ' -> Please define the local path to your fork\n       current: ', strrep(pwd,'\','\\'),'\n       Enter the path (press ENTER to use the current path): '], 's');

            if isempty(reply)
                gitConf.localDir = strrep(pwd, '\', '\\');
            else
                gitConf.localDir = reply;
            end

            % add a fileseparator if not included
            if ~strcmp(gitConf.localDir(end), filesep)
                gitConf.localDir = strrep([gitConf.localDir, filesep], '\', '\\');
            end

            % warn the user of not using a fork-cobratoolbox or cobratoolbox directory as it will be cloned
            if ~isempty(strfind(gitConf.localDir, gitConf.nickName)) || exist([gitConf.localDir, '/.git'], 'dir') == 7  % contains the nickname or a .git folder
                reply = input([gitCmd.trail, gitCmd.lead, originCall, ' -> The specified directory already contains a ', gitConf.nickName, ' copy (clone) or is a git directory.', ...
                               gitCmd.trail, gitCmd.lead, originCall, ' -> Please provide the directory into which your fork should be cloned. Do you want to continue? Y/N [Y]:'], 's');

                if isempty(reply) || strcmpi(reply, 'y') || strcmpi(reply, 'yes')
                    createDir = true;
                else
                    createDir = false;
                end
            else
                createDir = true;
            end
        end

        if exist(gitConf.localDir, 'dir') ~= 7
            reply = input([gitCmd.lead, originCall, ' -> The specified directory (', gitConf.localDir, ') does not exist. Do you want to create it? Y/N [Y]:'], 's');

            % create the directory if requested
            if (isempty(reply) || strcmpi(reply, 'y') || strcmpi(reply, 'yes')) && createDir
                system(['mkdir ', gitConf.localDir]);
                if gitConf.verbose
                    fprintf([gitCmd.lead, ' [', mfilename,'] The directory has been created.', gitCmd.success, gitCmd.trail]);
                end
            else
                error([gitCmd.lead, ' [', mfilename,'] The specified directory does not exist.', gitCmd.fail]);
            end
        end
    end

    % define the fork directory name
    gitConf.forkDirName = strrep([gitConf.leadForkDirName, gitConf.remoteRepoName], '\', '\\');
    gitConf.fullForkDir = strrep([gitConf.localDir, gitConf.forkDirName], '\', '\\');

    % clone the fork
    freshClone = cloneFork();

    % proceed with configuring the fork
    configureFork();

    % update the fork
    if ~freshClone

        % change to the local fork directory
        cd(gitConf.fullForkDir);

        % retrieve the status of the git repository
        [status_gitStatus, result_gitStatus] = system('git status -s');

        % only update if there are no local changes
        if status_gitStatus == 0 && isempty(result_gitStatus)
            updateFork(true);
        else
            if gitConf.verbose
                fprintf([gitCmd.lead, ' [', mfilename,'] The local fork cannot be updated as you have uncommitted changes.', gitCmd.fail, gitCmd.trail]);
            end
        end
    end

    % set the preferences for a password cache helper
    if isunix
        system('git config --global credential.helper cache');
        system('git config --global credential.helper "cache --timeout=3600"'); % set the cache to timeout after 1 hour (setting is in seconds)
    elseif ispc
        system('git config --global credential.helper wincred');
    end

    % print the current configuration
    fprintf([gitCmd.lead, originCall, ' -- Configuration -------- ', gitCmd.trail])
    fprintf([gitCmd.lead, originCall, '    GitHub username:       ', gitConf.userName, gitCmd.trail]);
    fprintf([gitCmd.lead, originCall, '    Local directory :      ', gitConf.fullForkDir, gitCmd.trail])
    fprintf([gitCmd.lead, originCall, '    Remote fork URL:       ', gitConf.forkURL, gitCmd.trail]);
    fprintf([gitCmd.lead, originCall, '    Remote repository URL: ', gitConf.remoteRepoURL, gitCmd.trail]);

end
