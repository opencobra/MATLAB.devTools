function checkLocalFork()

    global gitConf
    global gitCmd

    checkSystem(mfilename);

    % retrieve the current directory
    currentDir = pwd;

    % check if the forked directory already exists
    if exist(gitConf.fullForkDir, 'dir') == 7
        cd(gitConf.fullForkDir);

        % check if the current directory is actually the fork, and not the main repository
        [status, result] = system('git remote -v');
        remoteFrags = strsplit(result);

        if status == 0 && strcmp(remoteFrags(1), 'origin') && strcmp(remoteFrags(2), gitConf.remoteRepoURL) && strcmp(remoteFrags(4), 'origin') && strcmp(remoteFrags(5), gitConf.remoteRepoURL)
            error([gitCmd.lead, 'The current folder contains the public version. Contributions can only be made from your own fork.'])
        end

        fprintf([gitCmd.lead, 'The local folder of the fork exists (', gitConf.fullForkDir,').', gitCmd.success, gitCmd.trail]);
    else
        fprintf([gitCmd.lead, 'The fork is not yet cloned in the folder ', gitConf.fullForkDir, '.', gitCmd.fail, gitCmd.trail]);
    end

    % change back to the current directory
    cd(currentDir);

end
