function deleteContribution(branchName)
% devTools
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

    if ~~isempty(strfind(branchName, 'develop')) && ~~isempty(strfind(branchName, 'master'))
        reply = input([gitCmd.lead, originCall, 'Are you sure that you want to delete the feature (branch) <', branchName, '>? Y/N [N]: '], 's');

        if ~isempty(reply) && strcmpi(reply, 'y')

            % checkout the develop branch
            checkoutBranch('develop');

            % retrieve a list of all the branches
            if ispc
                filterColor = '';
            else
                filterColor =  '| tr -s "[:cntrl:]" "\n"';
            end
            [status_gitBranch, resultList] = system(['git branch --list ', filterColor]);

            % delete the local branch
            if status_gitBranch == 0
                arrResult = strsplit(resultList, '\n');
                arrResult(~cellfun(@isempty, arrResult));

                if checkBranchExistence(branchName)
                    % delete the branch locally
                    [status_gitBranchDelete, result_gitBranchDelete] = system(['git branch -D ', branchName]);

                    if status_gitBranchDelete == 0
                        fprintf([gitCmd.lead, originCall, 'The local <', branchName, '> feature (branch) has been deleted.', gitCmd.success, gitCmd.trail]);
                    else
                        result_gitBranchDelete
                        error([gitCmd.lead, ' [', mfilename,'] The local <', branchName,'> feature (branch) could not be deleted. You might have unpublished/uncommitted changes.', gitCmd.fail]);
                    end
                else
                    fprintf([gitCmd.lead, originCall, 'The local <', branchName,'> feature (branch) does not exist.', gitCmd.fail, gitCmd.trail]);
                end
            else
                result_gitBranchDelete
                error([gitCmd.lead, ' [', mfilename,'] The list of features (branches) could not be retrieved.', gitCmd.fail]);
            end

            % check if branch exists remotely
            [status_curl, result_curl] = system(['curl -s --head ', gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName, '/tree/', branchName]);

            % delete the remote branch
            if status_curl == 0 && ~isempty(strfind(result_curl, '200 OK'))

                [status_gitPush, result_gitPush] = system(['git push origin --delete ', branchName]);

                if status_gitPush == 0
                    fprintf([gitCmd.lead, originCall, 'The remote <', branchName, '> feature (branch) has been deleted.', gitCmd.success, gitCmd.trail]);
                else
                    result_gitPush
                    error([gitCmd.lead, ' [', mfilename,'] The remote <', branchName,'> feature (branch) could not be deleted.', gitCmd.fail]);
                end
            else
                fprintf([gitCmd.lead, originCall, 'The remote <', branchName,'> feature (branch) does not exist.', gitCmd.fail, gitCmd.trail]);
            end
        end
    else
        error([gitCmd.lead, ' [', mfilename,'] You cannot delete the <master> or the <develop> feature (branch).', gitCmd.fail]);
    end
end
