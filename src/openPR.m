function openPR(branchName)
% Provides a pull request URL from <branchName> to <develop> on the upstream
%
% USAGE:
%
%    openPR(branchName)
%
% INPUT:
%    branchName:     Name of the branch for which a pull request (PR) shall be opened
%
% .. Author:
%      - Laurent Heirendt

    global gitConf
    global gitCmd

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    if gitConf.printLevel > 0
        originCall = [' [', mfilename, '] '];
    else
        originCall  = '';
    end

    % check if the develop branch exists remotely
    if checkRemoteBranchExistence('develop')
        mainBranch = 'develop';
    else
        mainBranch = 'master';  % fall back to master, which always exists
    end

    % define the URL of the pull request
    prURL = [gitConf.remoteRepoURL(1:end-4), '/compare/' mainBranch '...', gitConf.userName, ':', branchName];

    % check if this URL exists
    [status_curl, result_curl] = system(['curl -s -k --head ', prURL]);

    if status_curl == 0 && ~isempty(strfind(result_curl, '200 OK'))
        fprintf([gitCmd.lead, originCall, 'You can open a pull request (PR) by clicking on \n\n\t', prURL, '?expand=1\n\n']);
    else
        fprintf(result_curl);
        error([gitCmd.lead, ' [', mfilename,'] The feature (branch) <', branchName, '> does not exist or has no commits.', gitCmd.fail])
    end
end
