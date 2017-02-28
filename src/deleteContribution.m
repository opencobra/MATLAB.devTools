function deleteContribution(branchName)
% The COBRA Toolbox: Development tools
%
% PURPOSE: deletes and existing contribution named <branchName>
%

    global gitConf
    global gitCmd

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    if gitConf.verbose
        originCall = [' [', mfilename, '] '];
    else
        originCall  = '';
    end

    if ~contains(branchName, 'develop') && ~contains(branchName, 'master')
        reply = input([gitCmd.lead, originCall, 'Are you sure that you want to delete the branch <', branchName, '>? Y/N [N]: '], 's');

        if ~isempty(reply) && (strcmp(reply, 'y') || strcmp(reply, 'Y'))
            % checkout the develop branch
            checkoutBranch('develop');

            % delete the local branch

            % retrieve a list of branches
            [status_gitBranch, resultList] = system('git branch --list | tr -s "[:cntrl:]" "\n"');

            if status_gitBranch == 0
                arrResult = strsplit(resultList, '\n');
                arrResult(~cellfun(@isempty, arrResult));

                if checkBranchExistence(branchName)
                    % delete the branch locally
                    [status_gitBranchDelete, result_gitBranchDelete] = system(['git branch -D ', branchName]);

                    if status_gitBranchDelete == 0
                        fprintf([gitCmd.lead, originCall, 'The local <', branchName, '> feature has been deleted.', gitCmd.success, gitCmd.trail]);
                    else
                        result_gitBranchDelete
                        error([gitCmd.lead, ' [', mfilename,'] The local <', branchName,'> feature could not be deleted.', gitCmd.fail]);
                    end
                else
                    fprintf([gitCmd.lead, originCall, 'The local <', branchName,'> does not exist.', gitCmd.fail, gitCmd.trail]);
                end
            else
                result_gitBranchDelete
                error([gitCmd.lead, ' [', mfilename,'] The feature list could not be retrieved.', gitCmd.fail]);
            end

            % check if branch exists remotely
            [status_curl, result_curl] = system(['curl -s --head ', gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName, '/tree/', branchName]);

            % delete the remote branch
            if status_curl == 0 && contains(result_curl, '200 OK')

                [status_gitPush, result_gitPush] = system(['git push origin --delete ', branchName]);

                if status_gitPush == 0
                    fprintf([gitCmd.lead, originCall, 'The remote <', branchName, '> feature has been deleted.', gitCmd.success, gitCmd.trail]);
                else
                    result_gitPush
                    error([gitCmd.lead, ' [', mfilename,'] The remote <', branchName,'> feature could not be deleted.', gitCmd.fail]);
                end
            else
                fprintf([gitCmd.lead, originCall, 'The remote <', branchName,'> does not exist.', gitCmd.fail, gitCmd.trail]);
            end
        end
    else
        error([gitCmd.lead, ' [', mfilename,'] You cannot delete the <master> or the <develop> feature.', gitCmd.fail]);
    end
end
