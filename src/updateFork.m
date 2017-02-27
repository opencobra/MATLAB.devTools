function updateFork(force)
% The COBRA Toolbox: Development tools
%
% PURPOSE: updates the fork and the submodules of the repository
%

    global gitConf
    global gitCmd

    %set force = false by default
    if nargin < 1
        force = false;
    end

    % check first if the fork is correctly installed
    checkLocalFork();

    currentDir = strrep(pwd,'\','\\');

    % list the branches that should be updated
    branches = {'master', 'develop'};

    % change to the directory of the fork
    cd(gitConf.fullForkDir)

    % initialize and update the submodules
    updateSubmodules();

    % retrieve a list of all the branches
    [status, resultList] = system('git branch --list | tr -s "[:cntrl:]" "\n"');

    if status == 0
        % loop through the list of branches
        for k = 1:length(branches)
            % checkout the branch k
            if status == 0 && contains(resultList, branches{k})
                [status, result] = system(['git checkout ', branches{k}]);

                if status == 0
                    if gitConf.verbose
                        fprintf([gitCmd.lead, ' [', mfilename,'] The branch <', branches{k}, '> was checked out.', gitCmd.success, gitCmd.trail]);
                    end
                else
                    result
                    if gitConf.verbose
                        fprintf([gitCmd.lead, ' [', mfilename,'] The branch <', branches{k}, '> could not be checked out.', gitCmd.fail]);
                    end
                end
            else
                [status, result] = system(['git checkout -b ', branches{k}]);

                if status == 0
                    if gitConf.verbose
                        fprintf([gitCmd.lead, ' [', mfilename,'] The branch <', branches{k}, '> was checked out.', gitCmd.success, gitCmd.trail]);
                    end
                else
                    result
                    if gitConf.verbose
                        fprintf([gitCmd.lead, ' [', mfilename,'] The branch <', branches{k}, '> could not be checked out.', gitCmd.fail]);
                    end
                end
            end

            [status, resultList] = system('git branch --list | tr -s "[:cntrl:]" "\n"');

            if status == 0 && contains(resultList, branches{k})
                if gitConf.verbose
                    fprintf([gitCmd.lead, ' [', mfilename,'] Local ', branches{k},' branch checked out.', gitCmd.success, gitCmd.trail]);
                end
            else
                result
                error([gitCmd.lead, ' [', mfilename,'] Impossible to checkout the ', branches{k},' branch.', gitCmd.fail]);
            end

            % pull eventual changes from other contributors or administrators
            [status, result] = system(['git fetch origin ', branches{k}]);  % no pull
            if status == 0
                if gitConf.verbose
                    fprintf([gitCmd.lead, ' [', mfilename,'] Changes on ', branches{k},' branch of fork pulled.', gitCmd.success, gitCmd.trail]);
                end
            else
                result
                error([gitCmd.lead, 'Impossible to pull changes from ', branches{k},' branch of fork.', gitCmd.fail]);
            end

            % fetch the changes from upstream
            [status, result] = system('git fetch upstream');
            if status == 0
                if gitConf.verbose
                    fprintf([gitCmd.lead, ' [', mfilename,'] Upstream fetched.', gitCmd.success, gitCmd.trail]);
                end
            else
                result
                error([gitCmd.lead, ' [', mfilename,'] Impossible to fetch upstream.', gitCmd.fail]);
            end

            if ~force
                % merge the changes from upstream to the branch
                [status, result] = system(['git merge upstream/', branches{k}]);
                if status == 0
                    if gitConf.verbose
                        fprintf([gitCmd.lead, ' [', mfilename,'] Merged upstream/', branches{k}, ' into ', branches{k}, '.', gitCmd.success, gitCmd.trail]);
                    end
                else
                    result
                    error([gitCmd.lead, ' [', mfilename,'] Impossible to merge upstream/', branches{k}, gitCmd.fail]);
                end
            end

            if force
                [status, result] = system(['git reset --hard upstream/', branches{k}]);
                if status == 0
                    if gitConf.verbose
                        fprintf([gitCmd.lead, ' [', mfilename,'] The ', branches{k}, ' branch of the fork has been reset.', gitCmd.success, gitCmd.trail]);
                    end
                else
                    result
                    error([gitCmd.lead, ' [', mfilename,'] Impossible to reset the branch', branches{k}, ' of the fork.', gitCmd.fail]);
                end

                % set the flag for a force push
                forceFlag = '--force';
                forceText = ' by force';
            else
                % set the flag for a force push
                forceFlag = '';
                forceText = '';
            end

            % push and asking the password
            system(['git push origin ', branches{k}, ' ', forceFlag, ' -q --dry-run']);

            % second push is to retr
            [status, result] = system(['git push origin ', branches{k}, ' ', forceFlag]);

            if status == 0
                if gitConf.verbose
                    fprintf([gitCmd.lead, ' [', mfilename,'] The <', branches{k}, '> branch has been updated on the fork', forceText, '.', gitCmd.success, gitCmd.trail]);
                end
            else
                result
                error([gitCmd.lead, ' [', mfilename,'] Impossible to update <', branches{k}, '> on your fork (', gitConf.forkURL, ').', gitCmd.fail]);
            end
        end
    else
      resultList
      error([gitCmd.lead, ' [', mfilename,'] Impossible to retrieve the branches of your local fork.', gitCmd.fail]);
    end

    % change back to the original directory
    cd(currentDir);
end
