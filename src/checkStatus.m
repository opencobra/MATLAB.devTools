function checkStatus()
% Checks the status of the repository
%
% USAGE:
%
%    checkStatus()
%
% .. Author:
%      - Laurent Heirendt

    global gitConf
    global gitCmd

    % change to the local directory of the fork
    cd(gitConf.fullForkDir);

    % check the status of the repository
    [status_gitStatus, result_gitStatus] = system(['git status -v']);

    if status_gitStatus == 0
        fprintf(result_gitStatus);
    else
        error([gitCmd.lead, ' [', mfilename, '] The status of the repository could not be retrieved.']);
    end
end
