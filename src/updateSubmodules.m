function updateSubmodules()
% Clones the submodules and updates the repository
%
% USAGE:
%
%   updateSubmodules()
%
% .. Author:
%      - Laurent Heirendt, Ronan Fleming

    global gitConf
    global gitCmd

    currentDir = strrep(pwd, '\', '\\');

    % change to the directory of the fork
    cd(gitConf.fullForkDir)

    % temporary disable ssl verification
    [status_setSSLVerify, result_setSSLVerify] = system('git config --global http.sslVerify false');

    if status_setSSLVerify == 0
        printMsg(mfilename, 'Your global git configuration has been changed: `http.sslVerify = false`.');
    else
        fprintf(result_setSSLVerify);
        error([gitCmd.lead, ' [', mfilename,'] Your global git configuration could not be changed.', gitCmd.fail]);
    end

    % initialize submodules
    [status_gitSubmodule, result_gitSubmodule] = system('git submodule init');

    if status_gitSubmodule == 0
        printMsg(mfilename, 'The submodules have been initialized.');
    else
        fprintf(result_gitSubmodule);
        error([gitCmd.lead, ' [', mfilename,'] The submodules could not be initialized.', gitCmd.fail]);
    end

    if 0
        % retrieve the count for each submodule
        [status_gitSubmoduleCount, result_gitSubmoduleCount] = system('git submodule foreach --recursive git rev-list --count origin/master...HEAD');
        
        % split the array at line breaks
        arrResult = regexp(result_gitSubmoduleCount,'\n+','split'); %strsplit is not compatible with older versions of MATLAB
        arrResult = strtrim(arrResult);
        
        % filter out the empty ones
        arrResult = arrResult(~cellfun(@isempty, arrResult));
        
        % calculate the total number of changes
        sumChanges = 0;
        nSubmodules = length(arrResult)/2;
        for k = 1:nSubmodules
            sumChanges  = sumChanges + str2num(arrResult{2*k});
        end
        
        % update submodules
        [status_gitSubmodule, result_gitSubmodule] = system('git submodule update');
        
        if status_gitSubmodule == 0
            printMsg(mfilename, 'The submodules have been updated.');
        else
            fprintf(result_gitSubmodule);
            error([gitCmd.lead, ' [', mfilename,'] The submodules could not be updated.', gitCmd.fail]);
        end
        
        % update the submodules
        if sumChanges > 0
            % reset each submodule
            [status_gitReset result_gitReset] = system('git submodule foreach --recursive git reset --hard');
            if status_gitReset == 0
                printMsg(mfilename, 'The submodules have been reset.');
            else
                fprintf(result_gitReset);
                error([gitCmd.lead, ' [', mfilename,'] The submodules could not be reset.', gitCmd.fail]);
            end
        end
    else
        % update submodules
        [status_gitSubmodule, result_gitSubmodule] = system('git submodule update');
        
        if status_gitSubmodule == 0
            printMsg(mfilename, 'The submodules have been updated.');
        else
            fprintf(result_gitSubmodule);
            error([gitCmd.lead, ' [', mfilename,'] The submodules could not be updated.', gitCmd.fail]);
        end

        %Check for changes to submodules
        [status_gitSubmodule, result_gitSubmodule] = system('git submodule foreach git status');
        if status_gitSubmodule==0
            if contains(result_gitSubmodule,'modified') || contains(result_gitSubmodule,'Untracked files')
                submoduleWarning = 1;
                [status_gitSubmodule, result_gitSubmodule] = system('git submodule foreach git stash push -u');
                if status_gitSubmodule==0
                    fprintf('\n%s\n','***Local changes to submodules have been stashed. See https://git-scm.com/docs/git-stash.')
                    disp(result_gitSubmodule)
                end
            end
        end
        
        % update submodules
        [status_gitSubmodule, result_gitSubmodule] = system('git submodule foreach git checkout master');% 30/9/21 RF submodules point to master
        [status_gitSubmodule, result_gitSubmodule] = system('git submodule foreach git pull');% 30/9/21 RF pull in remote submodule changes to master branch
        
    end
    
    % restore global configuration by unsetting http.sslVerify
    [status_setSSLVerify, result_setSSLVerify] = system('git config --global --unset http.sslVerify');

    if status_setSSLVerify == 0
        printMsg(mfilename, 'Your global git configuration has been changed: `http.sslVerify` was unset.');
    else
        fprintf(result_setSSLVerify);
        error([gitCmd.lead, ' [', mfilename,'] Your global git configuration could not be restored.', gitCmd.fail]);
    end

    % change back to the original directory
    cd(currentDir);
end
