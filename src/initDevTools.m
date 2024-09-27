function initDevTools(repoName,currentDir,printLevel)
% Initializes the development tools (username and email are requested if not configured)
%
% USAGE:
%
%    initDevTools(repoName)
%
% INPUT:
%   repoName:       Name of the repository for which the devTools shall
%                   be configured (default: `opencobra/cobratoolbox`)
% .. Authors:
%      - Laurent Heirendt, Ronan Fleming

    global gitConf
    global gitCmd
    global resetDevToolsFlag
    global DEFAULTREPONAME

    % set the repoName if not given
    if ~exist('repoName', 'var')
        repoName = DEFAULTREPONAME;
    end
    if ~exist('currentDir', 'var')
        currentDir = pwd;
    end
    if ~exist('printLevel', 'var')
        printLevel = 1;%by default print to screen
    end
    resetDevToolsFlag = true;

    finishup = onCleanup(@() resetDevTools());

    % check the system and set the configuration
    checkSystem(mfilename, repoName, printLevel);

    if ~isfield(gitConf, 'userName'), gitConf.userName = []; end
    if ~isfield(gitConf, 'localDir'), gitConf.localDir = []; end

    % parse the remoteRepoURL
    sepIndices = strfind(gitConf.remoteRepoURL, '/');
    gitConf.remoteServerName = gitConf.remoteRepoURL(1:sepIndices(3));
    gitConf.remoteRepoName = gitConf.remoteRepoURL(sepIndices(4) + 1:end - 4);
    gitConf.remoteUserName = gitConf.remoteRepoURL(sepIndices(3) + 1:sepIndices(4) - 1);

    % ignore case for the current fork (avoids problems for untracked files with case conflicts)
    [status_gitIgnoreCase, result_gitIgnoreCase] = system('git config core.ignorecase true');

    % retrieve the user name
    [status_gitConfUserGet, result_gitConfUserGet] = system('git config --get user.github-username');
    gitConf.userName = strtrim(result_gitConfUserGet);

    if gitConf.printLevel > 0
        originCall = [' [', mfilename, '] '];
    else
        originCall = '';
    end

    if status_gitConfUserGet == 0 && isempty(strfind(gitConf.userName, ' '))
        fprintf([gitCmd.lead, originCall, 'Your Github username is: ', gitConf.userName, '. ', gitCmd.success, gitCmd.trail]);
    else
        printMsg(mfilename, 'The Github username could not be retrieved or is not valid.', [gitCmd.fail, gitCmd.trail]);

        % request the Github username if it is not known or if the username contains whitespaces
        if isempty(gitConf.userName) || ~isempty(strfind(gitConf.userName, ' '))
            gitConf.userName = input([gitCmd.lead, originCall, ' -> Please enter your Github username: '], 's');
            [status_gitConfUserSet, result_gitConfUserSet] = system(['git config --global --add user.github-username "', gitConf.userName, '"']);
            if status_gitConfUserSet == 0
                fprintf([gitCmd.lead, originCall, 'Your Github username is: ', gitConf.userName, '. ', gitCmd.success, gitCmd.trail]);
            else
                fprintf(result_gitConfUserSet);
                error([gitCmd.lead, ' [', mfilename, '] Your Github username could not be set.', gitCmd.fail]);
            end
        end
    end

    % retrieve the user's email address
    [status_gitConfEmailGet, result_gitConfEmailGet] = system('git config --get user.email');
    gitConf.userEmail = strtrim(result_gitConfEmailGet);

    if status_gitConfEmailGet == 0
        fprintf([gitCmd.lead, originCall, 'Your Github email is: ', gitConf.userEmail, '. ', gitCmd.success, gitCmd.trail]);
    else
        printMsg(mfilename, 'The Github email could not be retrieved.', [gitCmd.fail, gitCmd.trail]);

        % request the Github username
        if isempty(gitConf.userEmail)
            gitConf.userEmail = input([gitCmd.lead, originCall, ' -> Please enter your Github email: '], 's');

            [status_gitConfEmailSet, result_gitConfEmailSet] = system(['git config --global user.email "', gitConf.userEmail, '"']);
            if status_gitConfEmailSet == 0
                fprintf([gitCmd.lead, originCall, 'Your Github email is: ', gitConf.userEmail, '. ', gitCmd.success, gitCmd.trail]);
            else
                fprintf(result_gitConfEmailSet);
                error([gitCmd.lead, ' [', mfilename, '] Your Github email could not be set.', gitCmd.fail]);
            end
        end
    end

    % define the name of the local fork directory
    gitConf.forkDirName = strrep([gitConf.leadForkDirName, gitConf.remoteRepoName], '\', '\\');

    % retrieve the directory of the fork from the local git configuration
    [~, result_gitConfForkDirGet] = system(['git config --get user.', gitConf.leadForkDirName, gitConf.nickName, '.path']);
    if ~isempty(result_gitConfForkDirGet)
        gitConf.fullForkDir = strtrim(result_gitConfForkDirGet);
        gitConf.localDir = gitConf.fullForkDir;
    else
        fprintf('%s\n','No existing information about the location of the fork directory.')
        gitConf.fullForkDir = '';
        gitConf.localDir = '';
    end

    % check if the fork exists remotely
    checkRemoteFork();

    % request the local directory if the fullForkDir is not yet known
    if isempty(gitConf.localDir) && isempty(gitConf.fullForkDir)

        createDir = false;

        while ~createDir
            reply = input([gitCmd.lead, originCall, ' -> Please define the location of your fork\n       current: ', strrep(currentDir, '\','\\'),'\n       Enter the path(press ENTER to use the current path): '], 's');

            % define the local directory as the current directory if the reply is empty
            if isempty(reply)
                gitConf.localDir = strrep(pwd, '\', '\\');
            else
                gitConf.localDir = reply;
            end

            % strip the fork-nickName folder from the localDir if present
            if ~isempty(gitConf.localDir) && length(gitConf.forkDirName) <= length(gitConf.localDir)
                if strcmp(gitConf.localDir(end - length(gitConf.forkDirName) + 1:end), gitConf.forkDirName)
                    gitConf.localDir = gitConf.localDir(1:end - length(gitConf.forkDirName));
                end
            end

            % add a fileseparator if not included
            if ~strcmp(gitConf.localDir(end), filesep)
                gitConf.localDir = strrep([gitConf.localDir, filesep], '\', '\\');
            end

            % warn the user of not using a fork-nickName directory or a git cloned directory as it will be cloned
            if ~isempty(strfind(gitConf.localDir, gitConf.nickName))  % contains the nickname
                printMsg(mfilename, ['The specified directory already contains a ', gitConf.nickName, ' copy (clone).'], gitCmd.trail);
                createDir = true;
                gitConf.localDir = gitConf.localDir(1:end - length(gitConf.nickName) - 1 - length(gitConf.leadForkDirName));

            elseif exist([gitConf.localDir filesep '.git'], 'dir') == 7  % contains a .git folder
                printMsg(mfilename, ['The specified directory already is a git repository (git-tracked).'], gitCmd.trail);

            else
                createDir = true;
            end
        end

        % define the fork directory name
        gitConf.fullForkDir = strrep([gitConf.localDir, gitConf.forkDirName], '\', '\\');

        if exist(gitConf.localDir, 'dir') ~= 7
            reply = input([gitCmd.lead, originCall, ' -> The specified directory (', gitConf.localDir, ') does not exist. Do you want to create it? Y/N [Y]:'], 's');

            % create the directory if requested
            if (isempty(reply) || strcmpi(reply, 'y') || strcmpi(reply, 'yes')) && createDir
                system(['mkdir ', gitConf.localDir]);
                printMsg(mfilename, 'The directory has been created.');
            else
                error([gitCmd.lead, ' [', mfilename, '] The specified directory does not exist.', gitCmd.fail]);
            end
        end
    end

    resetDevToolsFlag = false;

    % permanently store the fork directory in the git configuration (ask the user explicitly)
    [status_gitConfForkDirSet, result_gitConfForkDirSet] = system(['git config --global user.', gitConf.leadForkDirName, gitConf.nickName, '.path "', gitConf.fullForkDir, '"']);
    if status_gitConfForkDirSet == 0
        fprintf([gitCmd.lead, originCall, 'Your fork directory has been set to: ', gitConf.fullForkDir, '. ', gitCmd.success, gitCmd.trail]);
    else
        fprintf(result_gitConfForkDirSet);
        error([gitCmd.lead, ' [', mfilename, '] Your fork directory could not be set.', gitCmd.fail]);
    end

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
            reply = input([gitCmd.lead, originCall, ' Do you want to update your fork? Y/N [Y]:'], 's');

            % update fork if requested
            if (isempty(reply) || strcmpi(reply, 'y') || strcmpi(reply, 'yes'))
                updateFork(true);
            end
            
            
        else
            printMsg(mfilename, 'The local fork cannot be updated as you have uncommitted changes.', [gitCmd.fail, gitCmd.trail]);
        end
    end

    % print the current configuration
    fprintf([gitCmd.lead, originCall, ' -- Configuration -------- ', gitCmd.trail])
    fprintf([gitCmd.lead, originCall, '    GitHub username:       ', gitConf.userName, gitCmd.trail]);
    fprintf([gitCmd.lead, originCall, '    GitHub email:          ', gitConf.userEmail, gitCmd.trail]);
    fprintf([gitCmd.lead, originCall, '    Local directory :      ', gitConf.fullForkDir, gitCmd.trail])
    fprintf([gitCmd.lead, originCall, '    Remote fork URL:       ', gitConf.forkURL, gitCmd.trail]);
    fprintf([gitCmd.lead, originCall, '    Remote repository URL: ', gitConf.remoteRepoURL, gitCmd.trail]);

end
