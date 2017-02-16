function deleteContribution(branchName)

    global gitConf
    global gitCmd

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    reply = input([gitCmd.lead, 'Are you sure that you want to delete the branch <', branchName, '>? Y/N [N]: '], 's');

    if ~isempty(reply) && (strcmp(reply, 'y') || strcmp(reply, 'Y'))
        % checkout the develop branch
        checkoutBranch('develop');

        %check here if branch exists
        [status, result] = system(['curl -s --head ', gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName, '/tree/', branchName, '| head -n 1']);

        if status == 0 && contains(result, '200 OK')

            % delete the remote branch
            [status, ~] = system(['git push origin --delete ', branchName]);

            if status == 0
                fprintf([gitCmd.lead, 'The remote <', branchName, '> branch has been deleted.', gitCmd.success, gitCmd.trail]);
            else
                error([gitCmd.lead, 'The remote <', branchName,'> branch could not be deleted.', gitCmd.fail, gitCmd.trail]);
            end

        end

        [status, result] = system(['git branch -D ', branchName]);

        if status == 0
            fprintf([gitCmd.lead, 'The local <', branchName, '> branch has been deleted.', gitCmd.success, gitCmd.trail]);
        else
            result
            error([gitCmd.lead, 'The local <', branchName,'> branch could not be deleted.', gitCmd.fail, gitCmd.trail]);
        end
    end
end
