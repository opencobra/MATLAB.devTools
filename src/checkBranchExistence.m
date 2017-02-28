function branchExists = checkBranchExistence(branchName)
% devTools
%
% PURPOSE: checks if a branch exists locally
%

    global gitConf
    global gitCmd

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
