function resetDevTools()
% devTools
%
% PURPOSE: reset the configuration of the development tools
%

    global gitConf
    global gitCmd

    % unset the user name
    [status_gitConfUserGet, result_gitConfUserGet] = system('git config --global --unset-all user.github-username');

    if status_gitConfUserGet == 0
        if gitConf.verbose
            fprintf([gitCmd.lead, ' [', mfilename,'] Your Github username has been removed. ', gitCmd.success, gitCmd.trail]);
        end
    else
        result_gitConfUserGet
        fprintf([gitCmd.lead, ' [', mfilename,'] Your Github username could not be removed.', gitCmd.fail, gitCmd.trail]);
    end

    clear global gitConf;
    clear global gitCmd;

    fprintf([' [', mfilename, '] The development tools have been reset.\n']);
end
