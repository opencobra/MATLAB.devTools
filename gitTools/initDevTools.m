function initDevTools(repoURL)

    global gitConf
    global gitCmd

    % check if the system is configured properly
    checkSystem();

    % main public repository
    if nargin < 1
        gitConf.remoteRepoURL = 'https://github.com/cobrabot/trial_wo_errors.git'; %https://github.com/opencobra/cobratoolbox.git';
    else
        gitConf.remoteRepoURL = repoURL;
    end

    if ~isfield(gitConf, 'username'), gitConf.userName = []; end
    if ~isfield(gitConf, 'localDir'), gitConf.localDir = []; end

    % parse the remoteRepoURL
    sepIndices = strfind(gitConf.remoteRepoURL, '/');
    gitConf.remoteServerName = gitConf.remoteRepoURL(1:sepIndices(3));
    gitConf.remoteRepoName = gitConf.remoteRepoURL(sepIndices(4)+1:end-4);
    gitConf.remoteUserName = gitConf.remoteRepoURL(sepIndices(3)+1:sepIndices(4)-1);

    [status, result] = system('git config --get user.name');
    gitConf.userName = strtrim(result);

    if status == 0
        fprintf([gitCmd.lead, ' [', mfilename,'] Your Github username is: ', gitConf.userName, '. ', gitCmd.success, gitCmd.trail]);
    else
        fprintf([gitCmd.lead, ' [', mfilename,'] The Github username could not be retrieved.', gitCmd.fail, gitCmd.trail]);

        % request the Github username
        if isempty(gitConf.userName)
            gitConf.userName = input([gitCmd.lead, ' [', mfilename,'] -> Please enter your Github username: '], 's');
            [status, result1] = system(['git config --global user.name "', gitConf.userName, '"']);
            if status == 0
                fprintf([gitCmd.lead, ' [', mfilename,'] Your Github username is: ', gitConf.userName, '. ', gitCmd.success, gitCmd.trail]);
            else
                result1
                error([gitCmd.lead, ' [', mfilename,'] Your Github username could not be set.', gitCmd.fail]);
            end
        end
    end
    
    [status, result] = system('git config --get user.email');
    gitConf.userEmail = strtrim(result);

    if status == 0
        fprintf([gitCmd.lead, ' [', mfilename,'] Your Github email is: ', gitConf.userEmail, '. ', gitCmd.success, gitCmd.trail]);
    else
        fprintf([gitCmd.lead, ' [', mfilename,'] The Github email could not be retrieved.', gitCmd.fail, gitCmd.trail]);

        % request the Github username
        if isempty(gitConf.userEmail)
            gitConf.userEmail = input([gitCmd.lead, ' [', mfilename,'] -> Please enter your Github email: '], 's');
            
            [status, result1] = system(['git config --global user.email "', gitConf.userEmail, '"']);
            if status == 0
                fprintf([gitCmd.lead, ' [', mfilename,'] Your Github email is: ', gitConf.userEmail, '. ', gitCmd.success, gitCmd.trail]);
            else
                result1
                error([gitCmd.lead, ' [', mfilename,'] Your Github email could not be set.', gitCmd.fail]);
            end
        end
    end
    

    % check if the fork exists remotely
    checkRemoteFork();

    % request the local directory
    if isempty(gitConf.localDir)
        reply = input([gitCmd.lead, ' [', mfilename,'] -> Please define the local path to your fork\n       current: ', strrep(pwd,'\','\\'),'\n       Enter the path (press ENTER to use the current path): '], 's');

        if isempty(reply)
            gitConf.localDir = strrep(pwd,'\','\\');
        else
            gitConf.localDir = reply;
        end

        % add a fileseparator if not included
        if ~strcmp(gitConf.localDir(end), filesep)
            gitConf.localDir = strrep([gitConf.localDir, filesep],'\','\\');
        end

        if exist(gitConf.localDir, 'dir') ~= 7
            reply = input([gitmd.lead, ' [', mfilename,'] -> The specified directory (', gitConf.localDir,') does not exist. Do you want to create it? Y/N [Y]:'], 's');

            % create the directory if requested
            if isempty(reply) || strcmp(reply, 'Y')
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
    gitConf.forkDirName = strrep([gitConf.leadForkDirName, gitConf.remoteRepoName],'\','\\');
    gitConf.fullForkDir = strrep([gitConf.localDir, gitConf.forkDirName],'\','\\');

    % clone the fork
    freshClone = cloneFork();

    % proceed with configuring the fork
    configureFork();

    % update the fork
    if ~freshClone
        updateFork(true);
    end

    % print the current configuration
    fprintf([gitCmd.lead, ' [', mfilename,'] -- Configuration --      ', gitCmd.trail])
    fprintf([gitCmd.lead, ' [', mfilename,']    GitHub username:      ', gitConf.userName, gitCmd.trail]);
    fprintf([gitCmd.lead, ' [', mfilename,']    Local directory :     ', gitConf.fullForkDir, gitCmd.trail])
    fprintf([gitCmd.lead, ' [', mfilename,']    Remote fork URL:      ', gitConf.forkURL, gitCmd.trail]);
    fprintf([gitCmd.lead, ' [', mfilename,']    Remote opencobra URL: ', gitConf.remoteRepoURL, gitCmd.trail]);

end
