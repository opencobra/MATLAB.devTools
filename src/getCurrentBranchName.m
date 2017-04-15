function currentBranch = getCurrentBranchName()
% devTools
%
% PURPOSE: retrieve the name of the current branch
%

    global gitConf
    global gitCmd

    [status, currentBranch] =  system('git rev-parse --abbrev-ref HEAD');

    if status == 0
        currentBranch = currentBranch(1:end-1);
        printMsg(mfilename, ['The name of the current feature (branch) is <', currentBranch, '>']);
    else
        fprintf(currentBranch);
        error([gitCmd.lead, ' [', mfilename, '] The name of the current feature (branch) could not be retrieved.', gitCmd.fail]);
    end
end
