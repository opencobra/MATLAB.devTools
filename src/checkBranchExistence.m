function branchExists = checkBranchExistence(branchName)
% Checks if a branch exists locally
%
% USAGE:
%
%   branchExists = checkBranchExistence(branchName)
%
% INPUT:
%   branchName:     Name of the local branch to be checked for existence
%
% OUTPUT:
%   branchExists:   Boolean (true if `branchName` esists)
%
% .. Author:
%      - Laurent Heirendt

    global gitConf

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    % retrieve a list of all the branches
    [status_gitShowRef, result_gitShowRef] = system(['git show-ref refs/heads/', branchName]);

    if status_gitShowRef == 1 && isempty(result_gitShowRef)
        branchExists = false;
    else
        branchExists = true;
    end
end
