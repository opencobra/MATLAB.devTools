function checkLocalFork()
% devTools
%
% PURPOSE: checks the configuration of remotes in the local copy of the fork
%

    global gitConf
    global gitCmd

    checkSystem(mfilename);

    % retrieve the current directory
    currentDir = strrep(pwd, '\', '\\');

    % check if the forked directory already exists
    if exist(gitConf.fullForkDir, 'dir') == 7
        cd(gitConf.fullForkDir);

        % check if the current directory is actually the fork, and not the main repository
        [status_gitRemote, result_gitRemote] = system('git remote -v');

        remoteFrags = strsplit(result_gitRemote);

        indexOrigin_cell = strfind(remoteFrags, 'origin');
        indexOrigin = find(not(cellfun('isempty', indexOrigin_cell)));

        if status_gitRemote == 0 && strcmpi(remoteFrags(indexOrigin(1)), 'origin') && strcmpi(remoteFrags(indexOrigin(1) + 1), gitConf.remoteRepoURL) && strcmpi(remoteFrags(indexOrigin(2)), 'origin') && strcmpi(remoteFrags(indexOrigin(2) + 1), gitConf.remoteRepoURL)
            error([gitCmd.lead, ' [', mfilename, '] The current folder contains the public version. Contributions can only be made from your own fork.'])
        end

        % try to push to master - dry run only should ask for credentials if necessary
        system('git push origin master -q --dry-run');

        printMsg(mfilename, ['The local folder of the fork exists (', gitConf.fullForkDir, ').']);
    else
        printMsg(mfilename, ['The fork is not yet cloned in the folder ', gitConf.fullForkDir, '.'], gitCmd.trail);
    end

    % change back to the current directory
    cd(currentDir);
end
