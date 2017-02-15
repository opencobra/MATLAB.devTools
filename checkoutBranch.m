function checkoutBranch(branchName)

    global gitConf
    global gitCmd

    % save the currentDir
    currentDir = pwd;

    % change the directory to the local directory of the fork
    cd(gitConf.fullForkDir);

    % retrieve a list of all the branches
    [status, resultList] = system('git branch --list');

    checkoutFlag = '';

    % check if the current branch is the develop branch
    indexDevelop = strfind(resultList, 'develop');
    indexStar = strfind(resultList, '*');

    if status == 0 && abs(indexDevelop-indexStar) > 10 % colors might be denoted as [32m etc.
        fprintf([gitCmd.lead, 'The current branch is not the develop branch.', gitCmd.fail, gitCmd.trail]);

        % update the fork locally
        updateFork();

        % checkout the develop branch
        [status, result] = system('git checkout develop');

        if status == 0 && (contains(resultList, '* develop') || contains(result, 'Already on'))
            fprintf([gitCmd.lead, 'The current branch is develop.', gitCmd.success, gitCmd.trail]);
        else
            error([gitCmd.lead, 'An error occurred and the develop branch cannot be checked out']);
        end

        % make sure that the develop branch is up to date
        [status, ~] = system('git pull origin develop');

        if status == 0
            fprintf([gitCmd.lead, 'The changes of the develop branch of your fork have been pulled.', gitCmd.success, gitCmd.trail]);
        else
            error([gitCmd.lead, 'The changes of the develop branch could not be pulled.', gitCmd.fail, gitCmd.trail]);
        end
    end

    % checkout a new branch if it doesn't exist
    if status == 0 && ~contains(resultList, branchName)
        checkoutFlag = '-b';
    end

    [status, ~] = system(['git checkout ', checkoutFlag, ' ', branchName]);

    if status == 0
        fprintf([gitCmd.lead, 'The ', branchName, ' branch has been checked out.', gitCmd.success, gitCmd.trail]);
        % push the newly created branch to the fork

        [status, ~] = system(['git push origin ', branchName]);

        if status == 0
            fprintf([gitCmd.lead, 'The ', branchName, ' branch has been pushed to your fork.', gitCmd.success, gitCmd.trail]);
        else
            error([gitCmd.lead, 'The ', branchName, ' branch could not be pushed to your fork.', gitCmd.fail, gitCmd.trail]);
        end
    else
        error([gitCmd.lead, 'The branch ', branchName, ' cannot be checked out.', gitCmd.fail, gitCmd.trail]);
    end

    % change back to the current directory
    cd(currentDir);
end
