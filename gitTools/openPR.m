function openPR(branchName)

    global gitConf
    global gitCmd

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    % define the URL of the pull request
    prURL = [gitConf.remoteRepoURL(1:end-4), '/compare/develop...', gitConf.userName, ':', branchName];

    % check if this URL exists
    [status, result] = system(['curl -s --head ', prURL, '| head -n 1']);

    if status == 0 && contains(result, '200 OK')
        fprintf([gitCmd.lead, ' [', mfilename,'] You can open a pull request (PR) by clicking on \n\n\t', prURL, '?expand=1\n\n']);
    else
        result
        error([gitCmd.lead, ' [', mfilename,'] The branch <', branchName, '> does not exist or has no commits.', gitCmd.fail, gitCmd.trail])
    end
end
