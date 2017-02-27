function updateSubmodules()
% The COBRA Toolbox: Development tools
%
% PURPOSE: clones the submodules and updates the repository
%

    global gitConf
    global gitCmd

    [status1, result1] = system(['git submodule update --init']);
    if status1 == 0
        fprintf([gitCmd.lead, ' [', mfilename,'] The submodules have been initialized.', gitCmd.success, gitCmd.trail]);
    else
        result1
        error([gitCmd.lead, ' [', mfilename,'] The submodules could not be initialized.', gitCmd.fail]);
    end

end
