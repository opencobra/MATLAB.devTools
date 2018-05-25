function deleteContribution(branchName)
% Delete an existing branch named `branchName`
%
% USAGE:
%
%     deleteContribution(branchName)
%
% INPUT:
%     branchName:     Name of the local branch to be deleted
%
% .. Author:
%      - Laurent Heirendt

    global gitConf
    global gitCmd

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    if gitConf.printLevel > 0
        originCall = [' [', mfilename, '] '];
    else
        originCall  = '';
    end

    if isempty(strfind(branchName, 'develop')) && isempty(strfind(branchName, 'master'))
        reply = '';

        while isempty(reply) || ~strcmpi(reply, 'yes')

            reply = input([gitCmd.lead, originCall, 'Are you sure that you want to delete the branch <', branchName, '>? YES/NO [NO]: '], 's');

            if strcmpi(reply, 'yes') % users MUST enter 'yes', not only 'y'

                % check if the develop branch exists remotely
                if checkRemoteBranchExistence('develop')
                    mainBranch = 'develop';
                else
                    mainBranch = 'master';  % fall back to master, which always exists
                end

               % checkout the develop branch
                checkoutBranch(mainBranch);

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
                            fprintf([gitCmd.lead, originCall, 'The local <', branchName, '> branch has been deleted.', gitCmd.success, gitCmd.trail]);
                        else
                            fprintf(result_gitBranchDelete);
                            error([gitCmd.lead, ' [', mfilename,'] The local <', branchName,'> branch could not be deleted. You might have unpublished/uncommitted changes.', gitCmd.fail]);
                        end
                    else
                        fprintf([gitCmd.lead, originCall, 'The local <', branchName,'> branch does not exist.', gitCmd.fail, gitCmd.trail]);
                    end
                else
                    error([gitCmd.lead, ' [', mfilename,'] The list of branches could not be retrieved.', gitCmd.fail]);
                end

                % delete the remote branch
                if checkRemoteBranchExistence(branchName)

                    [status_gitPush, result_gitPush] = system(['git push origin --delete ', branchName]);

                    if status_gitPush == 0
                        fprintf([gitCmd.lead, originCall, 'The remote <', branchName, '> branch has been deleted.', gitCmd.success, gitCmd.trail]);
                    else
                        fprintf(result_gitPush);
                        error([gitCmd.lead, ' [', mfilename,'] The remote <', branchName,'> branch could not be deleted.', gitCmd.fail]);
                    end
                else
                    fprintf([gitCmd.lead, originCall, 'The remote <', branchName,'> branch does not exist.', gitCmd.fail, gitCmd.trail]);
                end
            end
        end
    else
        error([gitCmd.lead, ' [', mfilename,'] You cannot delete the <master> or the <develop> branch.', gitCmd.fail]);
    end

    %list all available branches
    listFeatures();
end
