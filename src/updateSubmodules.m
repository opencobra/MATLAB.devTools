function updateSubmodules()
% devTools
%
% PURPOSE: clones the submodules and updates the repository
%

    global gitConf
    global gitCmd

    % temporary disable ssl verification
    [status_setSSLVerify, result_setSSLVerify] = system(['git config --global http.sslVerify false']);

    if status_setSSLVerify == 0
        if gitConf.verbose
            msg = 'Your global git configuration has been changed: `http.sslVerify = false`.';
            fprintf([gitCmd.lead, ' [', mfilename,'] ', msg, gitCmd.success, gitCmd.trail]);
        end
    else
        result_setSSLVerify
        error([gitCmd.lead, ' [', mfilename,'] Your global git configuration could not be changed.', gitCmd.fail]);
    end

    % Update/initialize submodules
    [status_gitSubmodule, result_gitSubmodule] = system(['git  submodule update --init']);

    if status_gitSubmodule == 0
        if gitConf.verbose
            fprintf([gitCmd.lead, ' [', mfilename,'] The submodules have been initialized.', gitCmd.success, gitCmd.trail]);
        end
    else
        result_gitSubmodule
        error([gitCmd.lead, ' [', mfilename,'] The submodules could not be initialized.', gitCmd.fail]);
    end

    % restore global configuration by unsetting http.sslVerify
    [status_setSSLVerify, result_setSSLVerify] = system(['git config --global --unset http.sslVerify']);

    if status_setSSLVerify == 0
        if gitConf.verbose
            msg = 'Your global git configuration has been changed: `http.sslVerify` was unset.';
            fprintf([gitCmd.lead, ' [', mfilename,'] ', msg, gitCmd.success, gitCmd.trail]);
        end
    else
        result_setSSLVerify
        error([gitCmd.lead, ' [', mfilename,'] Your global git configuration could not be restored.', gitCmd.fail]);
    end

end
