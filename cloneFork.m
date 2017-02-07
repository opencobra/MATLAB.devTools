function cloneFork()

    global gitConf
    global gitCmd

    currentDir = pwd;

    % check if the fork exists remotely
    checkRemoteFork();

    % check if the fork exists locally
    checkLocalFork();

    % if the fork does not exist, clone it
    if exist(gitConf.localDir, 'dir') ~= 7
        % create the directory
        system(['mkdir ', gitConf.localDir]);

    elseif exist(gitConf.fullForkDir, 'dir') ~= 7
        % change to the local directory
        cd(gitConf.localDir);

        fprintf(['Cloning the fork ', gitConf.forkURL, gitCmd.trail]);
        system(['git clone ', gitConf.forkURL, ' ', gitConf.forkDirName]);

    % if the fork already exists
    else

        % change to the fork directory
        cd(gitConf.fullForkDir)

        % retrieve a short status from git
        [status, result] = system('git status -s');

        % check if the fork is up-to-date
        if status == 0 && isempty(result)
            fprintf([gitCmd.lead, 'Your cobratoolbox fork (username: ', gitConf.username, ') is already cloned and up-to-date. ', gitCmd.success, gitCmd.trail]);
        % proceed to update the fork
        else
            fprintf([gitCmd.lead, 'Your fork is not up-to-date. Please update using "updateMyFork();".', gitCmd.fail, gitCmd.trail]);
        end
    end

    % change back to the original directory
    cd(currentDir)
end
