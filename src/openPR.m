function openPR(branchName)
% devTools
%
% PURPOSE: provides a pull request URL from <branchName> to <develop> on the upstream
%

    global gitConf
    global gitCmd

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    if gitConf.verbose
        originCall = [' [', mfilename, '] '];
    else
        originCall  = '';
    end

    % define the URL of the pull request
    prURL = [gitConf.remoteRepoURL(1:end-4), '/compare/develop...', gitConf.userName, ':', branchName];

    % check if this URL exists
    [status_curl, result_curl] = system(['curl -s --head ', prURL]);

    if status_curl == 0 && strfind(result_curl, '200 OK')
        fprintf([gitCmd.lead, originCall, 'You can open a pull request (PR) by clicking on \n\n\t', prURL, '?expand=1\n\n']);
    else
        result_curl
        error([gitCmd.lead, ' [', mfilename,'] The feature (branch) <', branchName, '> does not exist or has no commits.', gitCmd.fail])
    end
end
