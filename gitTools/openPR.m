function openPR(branchName)

    global gitConf
    global gitCmd

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    prURL = [gitConf.remoteRepoURL(1:end-4), '/compare/develop...', gitConf.userName, ':', branchName];

    [status, result] = system(['curl -s --head ', prURL, '| head -n 1']);

    if status == 0 && contains(result, '200 OK')
        fprintf([gitCmd.lead, 'You can open a pull request (PR) by clicking on \n\n\t', prURL, '?expand=1\n\n']);
    else
        error([gitCmd.lead, 'The branch ', branchName, ' does not exist or has no commits.', gitCmd.fail, gitCmd.trail])
    end
