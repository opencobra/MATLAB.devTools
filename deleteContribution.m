function deleteContribution(branchName)

    global gitConf
    global gitCmd

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    if ~contains(branchName, 'develop') && ~contains(branchName, 'master')
        reply = input([gitCmd.lead, ' [', mfilename,'] Are you sure that you want to delete the branch <', branchName, '>? Y/N [N]: '], 's');

        if ~isempty(reply) && (strcmp(reply, 'y') || strcmp(reply, 'Y'))
            % checkout the develop branch
            checkoutBranch('develop');

            % delete the local branch

                [status, result2] = system(['git branch -D ', branchName]);

                if status == 0
                    fprintf([gitCmd.lead, ' [', mfilename,'] The local <', branchName, '> branch has been deleted.', gitCmd.success, gitCmd.trail]);
                else
                    result2
                    error([gitCmd.lead, ' [', mfilename,'] The local <', branchName,'> branch could not be deleted.', gitCmd.fail]);
                end

            % check if branch exists remotely
            [status, result] = system(['curl -s --head ', gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName, '/tree/', branchName, '| head -n 1']);

            % delete the remote branch
            if status == 0 && contains(result, '200 OK')

                [status, result1] = system(['git push origin --delete ', branchName]);

                if status == 0
                    fprintf([gitCmd.lead, ' [', mfilename,'] The remote <', branchName, '> branch has been deleted.', gitCmd.success, gitCmd.trail]);
                else
                    result1
                    error([gitCmd.lead, ' [', mfilename,'] The remote <', branchName,'> branch could not be deleted.', gitCmd.fail]);
                end
            else
                result
                error([gitCmd.lead, ' [', mfilename,'] The remote <', branchName,'> does not exist.', gitCmd.fail]);
            end
        end
    else
        error([gitCmd.lead, ' [', mfilename,'] You cannot delete the <master> or the <develop> branche', gitCmd.fail]);
    end
end
