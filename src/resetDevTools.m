function resetDevTools()
% Reset the configuration of the development tools
%
% USAGE:
%
%    resetDevTools()
%
% .. Author:
%      - Laurent Heirendt

    global gitConf
    global gitCmd
    global resetDevToolsFlag

    % call checkSystem to set default values for gitConf and gitCmd
    checkSystem(mfilename);

    if resetDevToolsFlag
        % unset the path to the local fork
        [status_gitConfForkDirGet, result_gitConfForkDirGet] = system(['git config --global --unset user.', gitConf.leadForkDirName, gitConf.nickName, '.path']);

        if status_gitConfForkDirGet == 0
            printMsg(mfilename, 'Your fork directory has been removed from your local git configuration.');
        else
            fprintf(result_gitConfForkDirGet);
            fprintf([gitCmd.lead, ' [', mfilename,'] Your fork directory could not be removed from your local git configuration.', gitCmd.fail, gitCmd.trail]);
        end

        % unset the user name
        [status_gitConfUserGet, result_gitConfUserGet] = system('git config --global --unset-all user.github-username');

        if status_gitConfUserGet == 0
            printMsg(mfilename, 'Your Github username has been removed from your local git configuration.');
        else
            fprintf(result_gitConfUserGet);
            fprintf([gitCmd.lead, ' [', mfilename,'] Your Github username could not be removed from your local git configuration.', gitCmd.fail, gitCmd.trail]);
        end

        clear global gitConf;
        clear global gitCmd;
        clear global resetDevToolsFlag;

        fprintf([' [', mfilename, '] The development tools have been reset.\n']);
    else
        resetDevToolsFlag = true;
    end
end
