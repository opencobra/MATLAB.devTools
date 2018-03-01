function branchExists = checkRemoteBranchExistence(branchName)
% Checks if a branch exists locally
%
% USAGE:
%
%   branchExists = checkRemoteBranchExistence(branchName)
%
% INPUT:
%   branchName:     Name of the remote branch to be checked for existence
%
% OUTPUT:
%   branchExists:   Boolean (true if `branchName` esists)
%
% .. Author:
%      - Laurent Heirendt

    global gitConf

    % remove .git from the remoteRepoURL
    if strcmpi(gitConf.remoteRepoURL(end-3:end), '.git')
        tmpRepoName = gitConf.remoteRepoURL(1:end-4);
    else
        tmpRepoName = gitConf.remoteRepoURL;
    end

    % retrieve a list of all the branches
    [status_curl, result_curl] = system(['curl -s -k --head ' tmpRepoName '/tree/' branchName]);

    if status_curl == 0 && ~isempty(strfind(result_curl, '200 OK'))
        printMsg(mfilename, ['The branch <' branchName '> exists remotely.']);
        branchExists = true;
    else
        printMsg(mfilename, ['The remote <' branchName '> does not exist remotely.']);
        branchExists = false;
    end
end
