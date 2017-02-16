function submitContribution(branchName)

    global gitConf
    global gitCmd

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    % retrieve a list of remotes
    [status, result] = system('git status -s');

    if status == 0
        arrResult = strsplit(result, '\n');
    else
        error([gitCmd.lead, 'The status of the repository cannot be retrieved', gitCmd.fail, gitCmd.trail]);
    end

    % initialize the array for storing the file names to be added
    if ~isempty(result) > 0
        addFileOrder = true;
    else
        addFileOrder = false;
        fprintf([gitCmd.lead, 'There is nothing to contribute. Please make changes to ', pwd, gitCmd.fail, gitCmd.trail]);
    end

    if length(arrResult) > 10
        reply = input([gitCmd.lead, ' -> You currently have more than 10 changed files. Are you sure that you want to continue? Y/N [N]: '], 's');

        if isempty(reply) || contains(reply, 'n') || contains(reply, 'N')
            addFileOrder = false;
        end
    end
    if length(arrResult) > 20
        error([gitCmd.lead, 'You currently have more than 50 new files to add. Consider splitting them into multiple commits (typically only a few files per commit).'])
    end

    if addFileOrder
        % initialize a counter variable
        countAddFiles = 0;

        % push the file(s) to the repository
        updateFork(false);

        % get the branch name
        checkoutBranch(branchName);

        for i = 1:length(arrResult)
            tmpFileName = arrResult(i);

            % split the file name into 2 parts
            tmpFileNameChunks = strsplit(tmpFileName{1}, ' ');

            fullFileStatus = '';
            fullFileName = '';

            statusFlag = false;

            % retrieve the file name and the status of the file
            for k = 1:length(tmpFileNameChunks)-1
                if ~isempty(tmpFileNameChunks{k}) && ~contains(tmpFileNameChunks{k}, '.')
                    fullFileStatus = tmpFileNameChunks{k};
                    statusFlag = true;
                end
                if statusFlag
                    fullFileName = tmpFileNameChunks{k+1};
                end
            end

            % add deleted files
            if ~isempty(tmpFileName) && contains(fullFileStatus, 'D')
                reply = input([gitCmd.lead, ' -> You deleted ', fullFileName, '. Do you want to commit this deletion? Y/N [N]: '], 's');

                if ~isempty(reply) && (strcmp(reply, 'y') || strcmp(reply, 'Y'))
                    countAddFiles = countAddFiles + 1;
                    [status, ~] = system(['git add ', fullFileName]);
                    if status == 0
                        if gitConf.verbose
                            fprintf([gitCmd.lead, 'The file ', fullFileName, ' has been added to the stage.', gitCmd.success, gitCmd.trail]);
                        end
                    else
                        error([gitCmd.lead, 'The file ', fullFileName, ' could not be added to the stage.', gitCmd.fail, gitCmd.trail]);
                    end
                end
            end

            % add modified files
            if ~isempty(tmpFileName) && contains(fullFileStatus, 'M')
                reply = input([gitCmd.lead, ' -> You modified ', fullFileName, '. Do you want to commit the changes? Y/N [N]: '], 's');

                if ~isempty(reply) && (strcmp(reply, 'y') || strcmp(reply, 'Y'))
                    countAddFiles = countAddFiles + 1;
                    [status, ~] = system(['git add ', fullFileName]);
                    if status == 0
                        if gitConf.verbose
                            fprintf([gitCmd.lead, 'The file <', fullFileName, '> has been added to the stage.', gitCmd.success, gitCmd.trail]);
                        end
                    else
                        error([gitCmd.lead, 'The file <', fullFileName, '> could not be added to the stage.', gitCmd.fail, gitCmd.trail]);
                    end
                end
            end

            % add untracked files
            if ~isempty(tmpFileName) && contains(fullFileStatus, '??')
                reply = input([gitCmd.lead, ' -> Do you want to add the new file ', fullFileName, '? Y/N [N]: '], 's');
                if ~isempty(reply) && (strcmp(reply, 'y') || strcmp(reply, 'Y'))
                    countAddFiles = countAddFiles + 1;
                    [status, ~] = system(['git add ', fullFileName]);
                    if status == 0
                        if gitConf.verbose
                            fprintf([gitCmd.lead, 'The file <', fullFileName, '> has been added to the stage.', gitCmd.success, gitCmd.trail]);
                        end
                    else
                        error([gitCmd.lead, 'The file <', fullFileName, '> could not be added to the stage.', gitCmd.fail, gitCmd.trail]);
                    end
                end
            end

            % already staged file
            if ~isempty(tmpFileName) && contains(fullFileStatus, 'A')
                if gitConf.verbose
                    fprintf([gitCmd.lead, 'The file <', fullFileName, '> is already on stage.', gitCmd.success, gitCmd.trail]);
                end
                countAddFiles = countAddFiles + 1
            end
        end

        pushStatus = false;

        % set a commit message
        if countAddFiles > 0
            fprintf([gitCmd.lead, 'You have selected ', num2str(countAddFiles), ' files to be added in one commit.', gitCmd.trail]);

            commitMsg = input([gitCmd.lead, ' -> Please enter a commit message (example: "Fixing bug with input arguments"): '], 's');

            if ~isempty(commitMsg)
                [status, ~] = system(['git commit -m', commitMsg]);
                fprintf([gitCmd.lead, 'Your commit message has been set.', gitCmd.success, gitCmd.trail]);
                if status == 0
                    pushStatus = true;
                else
                    error([gitCmd.lead, 'Your commit message cannot be set.', gitCmd.fail, gitCmd.trail]);
                end
            else
                error([gitCmd.lead, 'Please enter a commit message that has more than 10 characters.', gitCmd.fail, gitCmd.trail]);
            end
        end

        % push to the branch in the fork
        if pushStatus
            fprintf([gitCmd.lead, 'Pushing ', num2str(countAddFiles), ' file(s) to your branch <', branchName, '>', gitCmd.trail])
            [status, ~] = system(['git push origin ', branchName, ' --force']);

            if status == 0
                reply = input([gitCmd.lead, ' -> Do you want to open a pull request (PR)? Y/N [N]: '], 's');

                if ~isempty(reply) && (strcmp(reply, 'y') || strcmp(reply, 'Y'))
                    openPR(branchName);
                else
                    fprintf([gitCmd.lead, 'You opted not to submit a pull request (PR). You may open a PR using "openPR()".', gitCmd.trail]);
                end
            else
                error([gitCmd.lead, 'Something went wrong. Please try again.', gitCmd.fail, gitCmd.trail]);
            end
        end
    end
