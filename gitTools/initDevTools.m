function initDevTools(repoURL)

    global gitConf
    global gitCmd

    % check if the system is configured properly
    checkSystem();

    % main public repository
    if nargin < 1
        gitConf.remoteRepoURL = 'https://github.com/cobrabot/trial_wo_errors.git';%'https://github.com/opencobra/cobratoolbox.git';
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

    % request the Github username
    if isempty(gitConf.userName)
        gitConf.userName = input([gitCmd.lead, ' -> Please enter your Github username: '], 's');
    end

    % check if the fork exists remotely
    checkRemoteFork();

    % request the local directory
    if isempty(gitConf.localDir)
        reply = input([gitCmd.lead, ' -> Please define the local path to your fork\n    example: ~/work/git\n    current: ', pwd,'\n    Enter the path (press ENTER to use the current path): '], 's');

        if isempty(reply)
            gitConf.localDir = pwd;
        else
            gitConf.localDir = reply;
        end

        % add a fileseparator if not included
        if ~strcmp(gitConf.localDir(end), filesep)
            gitConf.localDir = [gitConf.localDir, filesep];
        end

        if exist(gitConf.localDir, 'dir') ~= 7
            reply = input([' -> The specified directory (', gitConf.localDir,') does not exist. Do you want to create it? Y/N [Y]:'], 's');

            % create the directory if requested
            if isempty(reply) || strcmp(reply, 'Y')
                system(['mkdir ', gitConf.localDir]);
                if gitConf.verbose
                    fprintf([gitCmd.lead, 'The directory has been created.', gitCmd.success, gitCmd.trail]);
                end
            else
                error([gitCmd.lead, 'The specified directory does not exist.', gitCmd.fail]);
            end
        end
    end

    gitConf.forkDirName = [gitConf.leadForkDirName, gitConf.remoteRepoName];
    gitConf.fullForkDir = [gitConf.localDir, gitConf.forkDirName];

    % clone the fork
    cloneFork();

    % proceed with configuring the fork
    configureFork();

    % update the fork
    updateFork(true);

    % print the current configuration
    fprintf([gitCmd.lead, ' -- Configuration --', gitCmd.trail, gitCmd.trail])
    fprintf([gitCmd.lead, '    GitHub username:      ', gitConf.userName, gitCmd.trail]);
    fprintf([gitCmd.lead, '    Local directory :     ', gitConf.fullForkDir, gitCmd.trail])
    fprintf([gitCmd.lead, '    Remote fork URL:      ', gitConf.forkURL, gitCmd.trail]);
    fprintf([gitCmd.lead, '    Remote opencobra URL: ', gitConf.remoteRepoURL, gitCmd.trail]);

end
