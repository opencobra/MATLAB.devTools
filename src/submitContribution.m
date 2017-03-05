function submitContribution(branchName)
% devTools
%
% PURPOSE: submit an existing contribution named <branchName>
%

    global gitConf
    global gitCmd

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    % check if branch exists
    checkoutBranch(branchName);

    if gitConf.verbose
        originCall = [' [', mfilename, '] '];
    else
        originCall  = '';
    end

    % retrieve a list of remotes
    [status_gitStatus, result_gitStatus] = system('git status -s');

    if status_gitStatus == 0
        arrResult = strsplit(result_gitStatus, '\n');
    else
        result_gitStatus
        error([gitCmd.lead, originCall, 'The status of the repository cannot be retrieved', gitCmd.fail]);
    end

    % initialize the array for storing the file names to be added
    if ~isempty(result_gitStatus) > 0
        addFileOrder = true;
    else
        addFileOrder = false;
        fprintf([gitCmd.lead, originCall, 'There is nothing to contribute. Please make changes to ', strrep(pwd, '\', '\\'), gitCmd.trail]);

        reply = input([gitCmd.lead, originCall, ' -> Do you want to open a pull request (PR) and submit your feature (branch) <', branchName, '>? Y/N [N]: '], 's');

        if ~isempty(reply) && strcmpi(reply, 'y')
            openPR(branchName);
        else
            fprintf([gitCmd.lead, originCall, 'You can open a pull request (PR) later using "openPR(\''', branchName,'\'')".', gitCmd.trail]);
        end
    end

    % provide a warning if there are more than 10 files to add (and less than 20 files)
    if length(arrResult) > 10
        reply = input([gitCmd.lead, originCall, ' -> You currently have more than 10 changed files. Are you sure that you want to continue? Y/N [N]: '], 's');

        if isempty(reply) || ~isempty(strfind(reply, 'n')) || ~isempty(strfind(reply, 'N'))
            addFileOrder = false;
        end
    end

    % provide an error if more than 20 files to add
    if length(arrResult) > 20
        fprintf([gitCmd.lead, originCall, 'You currently have more than 50 new files to add. Consider splitting them into multiple commits (typically only a few files per commit).'])
    end

    if addFileOrder
        % initialize a counter variable
        countAddFiles = 0;

        % push the file(s) to the repository (there are changes) -> do not update the fork here with updateFork(false);

        % check out the branch to make sure to be on the correct branch
        checkoutBranch(branchName); % will only check out the branch if possible

        for i = 1:length(arrResult)
            tmpFileName = arrResult(i);

            % split the file name into 2 parts
            tmpFileNameChunks = strsplit(tmpFileName{1}, ' ');

            fullFileStatus = '';
            fullFileName = '';

            statusFlag = false;

            % retrieve the file name and the status of the file
            for k = 1:length(tmpFileNameChunks)-1
                if ~isempty(tmpFileNameChunks{k}) && isempty(strfind(tmpFileNameChunks{k}, '.'))
                    fullFileStatus = tmpFileNameChunks{k};
                    statusFlag = true;
                end
                if statusFlag
                    fullFileName = tmpFileNameChunks{k+1};
                end
            end

            % add deleted files
            if ~isempty(tmpFileName) && ~isempty(strfind(fullFileStatus, 'D'))
                reply = input([gitCmd.lead, originCall, ' -> You deleted ', fullFileName, '. Do you want to commit this deletion? Y/N [N]: '], 's');

                if ~isempty(reply) && strcmpi(reply, 'y')
                    countAddFiles = countAddFiles + 1;
                    [status, result] = system(['git add ', fullFileName]);
                    if status == 0
                        if gitConf.verbose
                            fprintf([gitCmd.lead, originCall, 'The file ', fullFileName, ' has been added to the stage.', gitCmd.success, gitCmd.trail]);
                        end
                    else
                        result
                        error([gitCmd.lead, ' [', mfilename,'] The file ', fullFileName, ' could not be added to the stage.', gitCmd.fail]);
                    end
                end
            end

            % add modified files
            if ~isempty(tmpFileName) && ~isempty(strfind(fullFileStatus, 'M'))
                reply = input([gitCmd.lead, originCall, ' -> You modified ', fullFileName, '. Do you want to commit the changes? Y/N [N]: '], 's');

                if ~isempty(reply) && strcmpi(reply, 'y')
                    countAddFiles = countAddFiles + 1;
                    [status, result] = system(['git add ', fullFileName]);
                    if status == 0
                        if gitConf.verbose
                            fprintf([gitCmd.lead, originCall, 'The file <', fullFileName, '> has been added to the stage.', gitCmd.success, gitCmd.trail]);
                        end
                    else
                        result
                        error([gitCmd.lead, ' [', mfilename,'] The file <', fullFileName, '> could not be added to the stage.', gitCmd.fail]);
                    end
                end
            end

            % add untracked files
            if ~isempty(tmpFileName) && ~isempty(strfind(fullFileStatus, '??'))
                reply = input([gitCmd.lead, originCall, ' -> Do you want to add the new file ', fullFileName, '? Y/N [N]: '], 's');
                if ~isempty(reply) && strcmpi(reply, 'y')
                    countAddFiles = countAddFiles + 1;
                    [status, result] = system(['git add ', fullFileName]);
                    if status == 0
                        if gitConf.verbose
                            fprintf([gitCmd.lead, originCall, 'The file <', fullFileName, '> has been added to the stage.', gitCmd.success, gitCmd.trail]);
                        end
                    else
                        result
                        error([gitCmd.lead, ' [', mfilename,'] The file <', fullFileName, '> could not be added to the stage.', gitCmd.fail]);
                    end
                end
            end

            % already staged file
            if ~isempty(tmpFileName) && ~isempty(strfind(fullFileStatus, 'A'))
                if gitConf.verbose
                    fprintf([gitCmd.lead, originCall, 'The file <', fullFileName, '> is already on stage.', gitCmd.success, gitCmd.trail]);
                end
                countAddFiles = countAddFiles + 1
            end
        end

        pushStatus = false;

        % set a commit message
        if countAddFiles > 0
            fprintf([gitCmd.lead, originCall, 'You have selected ', num2str(countAddFiles), ' files to be added in one commit.', gitCmd.trail]);

            commitMsg = input([gitCmd.lead, originCall, ' -> Please enter a commit message (example: "Fixing bug with input arguments"): '], 's');

            if ~isempty(commitMsg)

                if ~strcmp(commitMsg(1), '"') || ~strcmp(commitMsg(end), '"')
                    commitMsg = ['"', commitMsg, '"'];
                end

                [status_gitCommit, result_gitCommit] = system(['git commit -m', commitMsg]);
                fprintf([gitCmd.lead, originCall, 'Your commit message has been set.', gitCmd.success, gitCmd.trail]);
                if status_gitCommit == 0
                    pushStatus = true;
                else
                    result_gitCommit
                    error([gitCmd.lead, ' [', mfilename,'] Your commit message cannot be set.', gitCmd.fail]);
                end
            else
                error([gitCmd.lead, ' [', mfilename,'] Please enter a commit message that has more than 10 characters.', gitCmd.fail]);
            end
        end

        % push to the branch in the fork
        if pushStatus
            fprintf([gitCmd.lead, originCall, 'Pushing ', num2str(countAddFiles), ' change(s) to your feature (branch) <', branchName, '>', gitCmd.trail])
            [status_gitPush, result_gitPush] = system(['git push origin ', branchName, ' --force']);

            if status_gitPush == 0
                reply = input([gitCmd.lead, originCall, ' -> Do you want to open a pull request (PR) and submit your feature (branch) <', branchName, '>? Y/N [N]: '], 's');

                if ~isempty(reply) && strcmpi(reply, 'y')
                    openPR(branchName);
                else
                    fprintf([gitCmd.lead, originCall, 'You can open a pull request (PR) at later stage by running "contribute" and selecting "3".', gitCmd.trail]);
                end
            else
                result_gitPush
                error([gitCmd.lead, ' [', mfilename,'] Something went wrong when pushing. Please try again.', gitCmd.fail]);
            end
        end
    end
end
