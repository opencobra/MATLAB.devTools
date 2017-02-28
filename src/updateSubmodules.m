function updateSubmodules()
% The COBRA Toolbox: Development tools
%
% PURPOSE: clones the submodules and updates the repository
%

    global gitConf
    global gitCmd

    [status_gitSubmodule, result_gitSubmodule] = system(['git submodule update --init']);

    if status_gitSubmodule == 0
        if gitConf.verbose
            fprintf([gitCmd.lead, ' [', mfilename,'] The submodules have been initialized.', gitCmd.success, gitCmd.trail]);
        end
    else
        result_gitSubmodule
        error([gitCmd.lead, ' [', mfilename,'] The submodules could not be initialized.', gitCmd.fail]);
    end

end
