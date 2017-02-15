function updateFork(force)

    global gitConf
    global gitCmd

    %set force = false by default
    if nargin < 1
        force = false;
    end

    % check first if the fork is correctly installed
    checkLocalFork();

    currentDir = pwd;

    % list the branches that should be updated
    branches = {'master', 'develop'};

    % change to the directory of the fork
    cd(gitConf.fullForkDir)

    % retrieve a list of all the branches
    [status, resultList] = system('git branch --list');

    % loop through the list of branches
    for k = 1:length(branches)
        % checkout the branch k
        if status == 0 && contains(resultList, branches{k})
            [status, ~] = system(['git checkout ', branches{k}]); % make sure that the branch is master
        else
            [status, ~] = system(['git checkout -b ', branches{k}]); % make sure that the branch is master
        end

        if status == 0 && contains(resultList, branches{k})
            if gitConf.verbose
                fprintf([gitCmd.lead, 'Local ', branches{k},' branch checked out.', gitCmd.success, gitCmd.trail]);
            end
        else
            error([gitCmd.lead, 'Impossible to checkout the ', branches{k},' branch.']);
        end

        % pull eventual changes from other contributors or administrators
        [status, ~] = system(['git pull origin ', branches{k}]);
        if status == 0
            if gitConf.verbose
                fprintf([gitCmd.lead, 'Changes on ', branches{k},' branch of fork pulled.', gitCmd.success, gitCmd.trail]);
            end
        else
            error([gitCmd.lead, 'Impossible to pull changes from ', branches{k},' branch of fork.']);
        end

        % fetch the changes from upstream
        [status, ~] = system('git fetch upstream');
        if status == 0
            if gitConf.verbose
                fprintf([gitCmd.lead, 'Upstream fetched.', gitCmd.success, gitCmd.trail]);
            end
        else
            error([gitCmd.lead, 'Impossible to fetch upstream.']);
        end

        % merge the changes from upstream to the branch
        [status, ~] = system(['git merge upstream/', branches{k}]);
        if status == 0
            if gitConf.verbose
                fprintf([gitCmd.lead, 'Merged upstream/', branches{k}, ' into ', branches{k}, '.', gitCmd.success, gitCmd.trail]);
            end
        else
            error([gitCmd.lead, 'Impossible to merge upstream/', branches{k}]);
        end

        if force
            [status, ~] = system(['git reset --hard upstream/', branches{k}]);
            if status == 0
                if gitConf.verbose
                    fprintf([gitCmd.lead, 'The ', branches{k}, ' branch of the fork has been reset by force.', gitCmd.success, gitCmd.trail]);
                end
            else
                error([gitCmd.lead, 'Impossible reset the branch', branches{k}, ' of the fork by force.']);
            end

            % set the flag for a force push
            forceFlag = '--force';
            forceText = ' by force';
        else
            % set the flag for a force push
            forceFlag = '';
            forceText = '';
        end

        [status, result] = system(['git push origin ', branches{k}, ' ', forceFlag]);
        if contains(result, 'Username for')
            gitConf.userName = input(' -> Please enter your Github username: ', '');
            gitConf.userName = input(' -> Please enter your Github password: ', '');
        else
            if status == 0
                if gitConf.verbose
                    fprintf([gitCmd.lead, 'The <', branches{k}, '> branch has been updated on the fork', forceText, '.', gitCmd.success, gitCmd.trail]);
                end
            else
                error([gitCmd.lead, 'Impossible to update <', branches{k}, '> on your fork (', gitConf.forkURL, ').']);
            end
        end
    end

    % change back to the original directory
    cd(currentDir);

end
