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
            [status, result] = system('git branch --list | tr -s "[:cntrl:]" "\n"');

            if status == 0
                arrResult = strsplit(result, '\n');
                arrResult(~cellfun(@isempty, arrResult));

                if checkBranchExistence(branchName) % contains(result, branchName)
                    % delete the branch locally
                    [status, result2] = system(['git branch -D ', branchName]);

                    if status == 0
                        fprintf([gitCmd.lead, originCall, 'The local <', branchName, '> branch has been deleted.', gitCmd.success, gitCmd.trail]);
                    else
                        result2
                        error([gitCmd.lead, ' [', mfilename,'] The local <', branchName,'> branch could not be deleted.', gitCmd.fail]);
                    end
                else
                    fprintf([gitCmd.lead, originCall, 'The local <', branchName,'> does not exist.', gitCmd.fail, gitCmd.trail]);
                end
            else
                result
                error([gitCmd.lead, ' [', mfilename,'] The branch list could not be retrieved.', gitCmd.fail]);
            end

            % check if branch exists remotely
            [status, result] = system(['curl -s --head ', gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName, '/tree/', branchName]);

            % delete the remote branch
            if status == 0 && contains(result, '200 OK')

                [status, result1] = system(['git push origin --delete ', branchName]);

                if status == 0
                    fprintf([gitCmd.lead, originCall, 'The remote <', branchName, '> branch has been deleted.', gitCmd.success, gitCmd.trail]);
                else
                    result1
                    error([gitCmd.lead, ' [', mfilename,'] The remote <', branchName,'> branch could not be deleted.', gitCmd.fail]);
                end
            else
                fprintf([gitCmd.lead, originCall, 'The remote <', branchName,'> does not exist.', gitCmd.fail, gitCmd.trail]);
            end
        end
    else
        error([gitCmd.lead, ' [', mfilename,'] You cannot delete the <master> or the <develop> branche', gitCmd.fail]);
    end
end
