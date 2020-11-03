function [branchExists_up, branchExists_org] = checkRemoteBranchExistence(branchName)
% Checks if a branch exists remotely (origin and upstream)
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
%      - Agnieszka Wegrzyn allow to check both upstream and origin remotes
%      (with upstream being the first argument for legacy issues)

    global gitConf

    % remove .git from the remoteRepoURL (upstream)
    if strcmpi(gitConf.remoteRepoURL(end-3:end), '.git')
        tmpRepoName_up = gitConf.remoteRepoURL(1:end-4);
    else
        tmpRepoName_up = gitConf.remoteRepoURL;
    end
    
     % remove .git from the forkURL (origin)
    if strcmpi(gitConf.forkURL(end-3:end), '.git')
        tmpRepoName_org = gitConf.forkURL(1:end-4);
    else
        tmpRepoName_org = gitConf.forkURL;
    end

    % retrieve a list of all the branches
    [status_curl_up, result_curl_up] = system(['curl -s -k --head ' tmpRepoName_up '/tree/' branchName]);
    
    [status_curl_org, result_curl_org] = system(['curl -s -k --head ' tmpRepoName_org '/tree/' branchName]);
    
    if status_curl_up == 0 && contains(result_curl_up, '200 OK')
        printMsg(mfilename, ['The branch <' branchName '> exists remotely on upstream.']);
        branchExists_up = true;
    else
        printMsg(mfilename, ['The remote <' branchName '> does not exist remotely on upstream.']);
        branchExists_up = false;
    end
    
    if status_curl_org == 0 && contains(result_curl_org, '200 OK')
        printMsg(mfilename, ['The branch <' branchName '> exists remotely on origin.']);
        branchExists_org = true;
    else
        printMsg(mfilename, ['The remote <' branchName '> does not exist remotely on origin.']);
        branchExists_org = false;
    end
end
