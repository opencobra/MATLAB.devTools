function updateFork(force)
% Updates the fork and the submodules of the repository
%
% USAGE:
%
%    updateFork(force)
%
% INPUT:
%    force:          Boolean flag to use force for updating the fork
%
% .. Author:
%      - Laurent Heirendt

    global gitConf
    global gitCmd

    %set force = false by default
    if nargin < 1
        force = false;
    end

    % check first if the fork is correctly installed
    checkLocalFork();

    currentDir = strrep(pwd, '\', '\\');

    % list the branches that should be updated
    if checkRemoteBranchExistence('develop')
        branches = {'master', 'develop'};
    else
        branches = {'master'};  % fall back to master, which always exists
    end

    % change to the directory of the fork
    cd(gitConf.fullForkDir)

    % initialize and update the submodules
    updateSubmodules();

    % retrieve the status of the git repository
    [status_gitStatus, result_gitStatus] = system('git status -s');

    % only update if there are no local changes
    if status_gitStatus == 0 && isempty(result_gitStatus)

        % retrieve a list of all the branches
        filterColor = '';
        if ~ispc
            filterColor =  '| tr -s "[:cntrl:]" "\n"';
        end
        [status_gitBranch, resultList] = system(['git branch --list ', filterColor]);

        if status_gitBranch == 0

            % check if the develop branch exists on the fork
            [status_curl, result_curl] = system(['curl -s -k --head ', gitConf.remoteServerName, gitConf.userName, '/', gitConf.remoteRepoName, '/tree/develop']);

            if status_curl == 0 && ~isempty(strfind(result_curl, '200 OK'))
                % pull eventual changes from other contributors or administrators
                [status_gitFetchOrigin, result_gitFetchOrigin] = system('git fetch origin');  % no pull
                if status_gitFetchOrigin == 0
                    printMsg(mfilename, 'Changes of fork (origin) fetched.');
                else
                    fprintf(result_gitFetchOrigin);
                    error([gitCmd.lead, ' [', mfilename, '] Impossible to fetch changes from fork.', gitCmd.fail]);
                end
            else
                printMsg(mfilename, ['The develop branch does not exist on the fork.'], [gitCmd.fail, gitCmd.trail]);
            end

            % fetch the changes from upstream
            [status_gitFetchUpstream, result_gitFetchUpstream] = system('git fetch upstream');
            if status_gitFetchUpstream == 0
                printMsg(mfilename, 'Upstream fetched.');
            else
                fprintf(result_gitFetchUpstream);
                error([gitCmd.lead, ' [', mfilename, '] Impossible to fetch upstream.', gitCmd.fail]);
            end

            % loop through the list of branches
            for k = 1:length(branches)
                % checkout the branch k
                if status_gitBranch == 0 && ~isempty(strfind(resultList, branches{k}))
                    [status_gitCheckout, result_gitCheckout] = system(['git checkout ', branches{k}]);

                    if status_gitCheckout == 0
                        printMsg(mfilename, ['The branch <', branches{k}, '> was checked out.']);
                    else
                        fprintf(result_gitCheckout);
                        printMsg(mfilename, ['The branch <', branches{k}, '> could not be checked out.']);
                    end

                else
                    [status_gitCheckoutCreate, result_gitCheckoutCreate] = system(['git checkout -b ', branches{k}]);

                    if status_gitCheckoutCreate == 0
                        printMsg(mfilename, ['The branch <', branches{k}, '> was checked out.']);
                    else
                        fprintf(result_gitCheckoutCreate);
                        printMsg(mfilename, ['The branch <', branches{k}, '> could not be checked out.']);
                    end
                end

                % determine the number of commits that the local master branch is behind
                [status_gitCountUpstream, result_gitCountUpstream] = system(['git rev-list --left-right --count ', branches{k}, '...upstream/', branches{k}]);

                [status_gitCountOrigin, result_gitCountOrigin] = system(['git rev-list --left-right --count ', branches{k}, '...origin/', branches{k}]);

                if status_gitCountUpstream == 0 && status_gitCountOrigin == 0
                    commitsAheadBehindUpstream = str2num(char(strsplit(result_gitCountUpstream)));
                    commitsAheadBehindOrigin = str2num(char(strsplit(result_gitCountOrigin)));

                    if (length(commitsAheadBehindUpstream) > 0 && commitsAheadBehindUpstream(2) > 0) || (length(commitsAheadBehindOrigin) > 0 && commitsAheadBehindOrigin(1) > 0)

                        [status_gitPull, result_gitPull] = system(['git pull origin ', branches{k}]);
                        if status_gitPull == 0
                            printMsg(mfilename, ['The <', branches{k}, '> branch of the fork could not be pulled.']);
                        else
                            fprintf(result_gitPull);
                            error([gitCmd.lead, ' [', mfilename,'] Impossible to pull changes from the <', branches{k}, '> branch of the fork.', gitCmd.fail]);
                        end

                        if ~force
                            % merge the changes from upstream to the branch
                            [status_gitMergeUpstream, result_gitMergeUpstream] = system(['git merge upstream/', branches{k}]);
                            if status_gitMergeUpstream == 0
                                printMsg(mfilename, ['Merged upstream/', branches{k}, ' into ', branches{k}, '.']);
                            else
                                fprintf(result_gitMergeUpstream);
                                error([gitCmd.lead, ' [', mfilename,'] Impossible to merge upstream/', branches{k}, gitCmd.fail]);
                            end
                        end

                        if force
                            [status_gitReset, result_gitReset] = system(['git reset --hard upstream/', branches{k}]);
                            if status_gitReset == 0
                                printMsg(mfilename, ['The <', branches{k}, '> branch of the fork has been reset.']);
                            else
                                fprintf(result_gitReset);
                                error([gitCmd.lead, ' [', mfilename,'] Impossible to reset the <', branches{k}, '> branch of the fork.', gitCmd.fail]);
                            end

                            % set the flag for a force push
                            forceFlag = '--force';
                            forceText = ' by force';
                        else
                            % set the flag for a force push
                            forceFlag = '';
                            forceText = '';
                        end

                        % try to push to master - dry run only should ask for credentials if necessary
                        system(['git push origin ', branches{k}, ' ', forceFlag, ' -q --dry-run']);

                        % second command is to actually push
                        [status_gitPush, result_gitPush] = system(['git push origin ', branches{k}, ' ', forceFlag]);

                        if status_gitPush == 0
                            printMsg(mfilename, ['The <', branches{k}, '> branch has been updated on the fork', forceText, '.']);
                        else
                            fprintf(result_gitPush);
                            error([gitCmd.lead, ' [', mfilename,'] Impossible to update the <', branches{k}, '> branch on your fork (', gitConf.forkURL, ').', gitCmd.fail]);
                        end
                    end
                end
            end

            % initialize and update the submodules
            updateSubmodules();
        else
            fprintf(resultList);
            error([gitCmd.lead, ' [', mfilename,'] Impossible to retrieve the branches of your local fork.', gitCmd.fail]);
        end
    else
        fprintf(result_gitStatus);
        printMsg(mfilename, ['The local fork cannot be updated as you have uncommitted changes. Please submit/publish them first.']);
    end

    % change back to the original directory
    cd(currentDir);
end
