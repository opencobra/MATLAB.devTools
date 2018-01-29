function [] = checkoutBranch(branchName, updateForkFlag)
% checks out a branch named <branchName> locally and remotely
%
% USAGE:
%
%    [] = checkoutBranch(branchName, updateForkFlag)
%
% INPUT:
%   branchName:       Name of the local branch to be checked out
%   updateForkFlag:   Boolean to update the fork before checking out the branch
%
% .. Author:
%      - Laurent Heirendt

    global gitConf
    global gitCmd

    if nargin < 2
        updateForkFlag = true;
    end

    % save the currentDir
    currentDir = strrep(pwd, '\', '\\');

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    % determine name of the current branch
    currentBranch = getCurrentBranchName();

    % retrieve a list of all the branches
    if ispc
        filterColor = '';
    else
        filterColor =  '| tr -s "[:cntrl:]" "\n"';
    end
    [status_gitBranch, resultList] = system(['git branch --list ', filterColor]);

    % retrieve the status
    [status_gitStatus, result_gitStatus] = system('git status -s');

    if status_gitBranch == 0 && ~strcmpi('develop', currentBranch) && isempty(result_gitStatus) && status_gitStatus == 0

        printMsg(mfilename, ['The current feature (branch) ', currentBranch, ' is not the <develop> feature (branch).'], [gitCmd.fail, gitCmd.trail]);

        % update the fork locally
        if updateForkFlag
            updateFork(true);
        end

        % checkout the develop branch (after update of the fork)
        [status_gitCheckout, result_gitCheckout] = system('git checkout develop');

        % retrieve the name of the current branch
        currentBranch = getCurrentBranchName();

        if status_gitCheckout == 0 && strcmpi('develop', currentBranch)
            printMsg(mfilename, 'The current feature (branch) is <develop>.');
        else
            fprintf(result_gitCheckout);
            error([gitCmd.lead, 'An error occurred and the <develop> feature (branch) cannot be checked out']);
        end

        % reset the develop branch
        [status_gitReset, result_gitReset] = system('git reset --hard upstream/develop');
        if status_gitReset == 0
            if gitConf.printLevel > 0
                fprintf([gitCmd.lead, ' [', mfilename, '] The current feature (branch) is <develop>.', gitCmd.success, gitCmd.trail]);
            end
        else
            fprintf(result_gitReset);
            error([gitCmd.lead, 'The <develop> feature (branch) cannot be checked out']);
        end

        % update all submodules
        updateSubmodules();

        % make sure that the develop branch is up to date
        [status_gitPull, result_gitPull] = system('git pull origin develop');

        if status_gitPull == 0
            printMsg(mfilename, 'The changes on the <develop> feature (branch) of your fork have been pulled.');
        else
            fprintf(result_gitPull);
            error([gitCmd.lead, 'The changes on the <develop> feature (branch) could not be pulled.', gitCmd.fail]);
        end
    end

    if ~checkBranchExistence(branchName)
        checkoutFlag = '-b';
    else
        checkoutFlag = '';
    end

    % retrieve the status
    [status_gitStatus, result_gitStatus] = system('git status -s');

    if (status_gitStatus == 0 && isempty(result_gitStatus)) || ~updateForkFlag
        % properly checkout the branch
        [status_gitCheckout, result_gitCheckout] = system(['git checkout ', checkoutFlag, ' ', branchName]);

        if status_gitCheckout == 0
            printMsg(mfilename, ['The <', branchName, '> feature (branch) has been checked out.']);

            % rebase if the branch already existed
            if ~strcmp(checkoutFlag, '-b') && isempty(strfind(branchName, 'develop')) && isempty(strfind(branchName, 'master'))
                %if there are no unstaged changes
                [status_gitStatus, result_gitStatus] = system('git status -s');

                if status_gitStatus == 0 && isempty(result_gitStatus)

                    % perform a rebase
                    [status_gitRebase, result_gitRebase] = system('git rebase develop');

                    % if the message after rebase does not contain up to data and not cannot rebase
                    if status_gitRebase == 0 && isempty(strfind(result_gitRebase, 'up to date')) && isempty(strfind(result_gitRebase, 'Cannot rebase'))
                        printMsg(mfilename, ['The <', branchName, '> feature (branch) has been rebased with <develop>.']);

                        % push by force the rebased branch
                        [status_gitPush, result_gitPush] = system(['git push origin ', branchName, ' --force']);
                        if status_gitPush == 0
                            printMsg(mfilename, ['The <', branchName, '> feature (branch) has been pushed to your fork by force.']);
                        else
                            fprintf(result_gitPush);
                            error([gitCmd.lead, ' [', mfilename, '] The <', branchName ,'> feature (branch) could not be pushed to your fork.', gitCmd.fail]);
                        end
                    else
                        [status_gitRebaseAbort, ~] = system('git rebase --abort');

                        if status_gitRebaseAbort == 0
                            printMsg(mfilename, ['The rebase process of <', branchName,'> with <develop> has been aborted.'], [gitCmd.fail, gitCmd.trail]);
                        end

                        % if the message after rebase contains : cannot rebase
                        if ~isempty(strfind(result_gitRebase, 'Cannot rebase'))
                            % ask the user first to reset
                            reply = input([gitCmd.lead, ' -> Do you want to reset your feature (branch) <', branchName, '>. Y/N [N]: '], 's');

                            if ~isempty(reply) || strcmpi(reply, 'y') || strcmpi(reply, 'yes')
                                [status_curl, result_curl] = system(['curl -s -k --head ', gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName, '/tree/', branchName]);

                                if status_curl == 0 && ~isempty(strfind(result_curl, '200 OK'))
                                    % hard reset of an existing branch
                                    [status_gitReset, result_gitReset] = system(['git reset --hard origin/', branchName]);
                                    if status_gitReset == 0
                                        printMsg(mfilename, ['The <', branchName, '> feature (branch) has not been rebased with <develop> and is up to date.']);
                                    else
                                        fprintf(result_gitReset);
                                        error([gitCmd.lead, ' [', mfilename, '] The <', branchName, '> could not be reset.', gitCmd.fail]);
                                    end
                                else
                                    printMsg(mfilename, ['The remote feature (branch) <', branchName, '> does not exist and could not be reset.'], [gitCmd.fail, gitCmd.trail]);
                                end
                            else
                                printMsg(mfilename, ['The <', branchName, '> feature (branch) has not been reset.']);
                            end
                        end
                    end
                end
            else
                % push the newly created branch to the fork
                [status_gitPush, result_gitPush] = system(['git push origin ', branchName]);

                if status_gitPush == 0
                    printMsg(mfilename, ['The <', branchName, '> feature (branch) has been pushed to your fork.']);
                else
                    fprintf(result_gitPush);
                    error([gitCmd.lead, ' [', mfilename, '] The <', branchName, '> feature (branch) could not be pushed to your fork.', gitCmd.fail]);
                end
            end
        else
            if gitConf.printLevel > 0
                fprintf(result_gitCheckout);
                fprintf([gitCmd.lead, ' [', mfilename, '] The feature (branch) <', branchName, '> could not be checked out.', gitCmd.fail, gitCmd.trail]);
            end
        end
    else
        if gitConf.printLevel > 0 && ~strcmp(branchName, currentBranch)
            fprintf(result_gitStatus);
            fprintf([gitCmd.lead, ' [', mfilename, '] Uncommited changes of the current feature (branch) <', currentBranch, '> have been migrated to the new feature <', branchName, '>.', gitCmd.success, gitCmd.trail]);
        end

        if ~strcmp(branchName, currentBranch)
            % checkout the develop branch (soft checkout without merg)
            [status_gitCheckout, result_gitCheckout] = system('git checkout develop');

            % retrieve the name of the current branch
            currentBranch = getCurrentBranchName();

            if status_gitCheckout == 0 && strcmpi('develop', currentBranch)
                printMsg(mfilename, 'The current feature (branch) is <develop>.');

                % update all submodules
                updateSubmodules();

                % make sure that the develop branch is up to date
                [status_gitPull, result_gitPull] = system('git pull origin develop');

                if status_gitPull == 0
                    printMsg(mfilename, 'The changes on the <develop> feature (branch) of your fork have been pulled.');
                else
                    fprintf(result_gitPull);
                    error([gitCmd.lead, 'The changes on the <develop> feature (branch) could not be pulled.', gitCmd.fail]);
                end

                % checkout the branch but do not update the fork
                checkoutBranch(branchName, false);
            else
                fprintf(result_gitCheckout);
                fprintf([gitCmd.lead, 'The <develop> feature (branch) cannot be checked out']);
            end
        end
    end

    % check the system
    checkSystem(mfilename);

    % if a branch does not exist remotely but exists locally, push it after confirmation from the user
    [status_curl, result_curl] = system(['curl -s -k --head ', gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName, '/tree/', branchName]);

    % check if the branch exists remotely
    if status_curl == 0 && ~isempty(strfind(result_curl, '200 OK')) && checkBranchExistence(branchName)
        printMsg(mfilename, ['The <', branchName, '> feature (branch) exists locally and remotely on <', gitConf.forkURL, '>.']);
    else  % the branch exists locally but not remotely!

        reply = input([gitCmd.lead, ' -> Your <', branchName, '> feature (branch) exists locally, but not remotely. Do you want to have your local <', branchName, '> published? Y/N [Y]:'], 's');

        if isempty(reply) || strcmpi(reply, 'y') || strcmpi(reply, 'yes')
            % push the newly created branch to the fork
            [status_gitPush, result_gitPush] = system(['git push origin ', branchName]);

            if status_gitPush == 0
                printMsg(mfilename, ['The <', branchName, '> feature (branch) has been pushed to your fork.']);
            else
                fprintf(result_gitPush);
                error([gitCmd.lead, ' [', mfilename, '] The <', branchName, '> feature (branch) could not be pushed to your fork.', gitCmd.fail]);
            end
        else
            printMsg(mfilename, ['Your <', branchName, '> feature (branch) exists locally, but not remotely.'], gitCmd.trail);
        end

    end

    % change back to the current directory
    cd(currentDir);
end
