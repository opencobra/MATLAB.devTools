function contribute(verbose)
% devTools
%
% PURPOSE: displays a menu and calls the respective subfunctions
%
%       1. Start a new feature (branch):
%       2. Select an existing feature (branch) to work on.
%       3. Publish a feature (branch).
%       4. Delete a feature (branch).

    global gitConf
    global gitCmd

    % retrieve the current directory
    currentDir = pwd;

    % adding the src folder of the devTools
    addpath(genpath(fileparts(which(mfilename))));

    % check the system and set the configuration
    checkSystem();

    if nargin > 0
        if verbose
            gitConf.verbose = verbose;
        else
            gitConf.verbose = false;
        end
    end

    devToolsDir = fileparts(which('contribute.m'));

    % change to the directory of the devTools
    cd(devToolsDir);

    % check if the origin is set to the SSH origin of the devTools
    [status_gitRemote, result_gitRemote] = system('git remote -v');

    remoteFrags = strsplit(result_gitRemote);

    if status_gitRemote == 0 && strcmp(remoteFrags(1), 'origin') && strcmp(remoteFrags(2), gitConf.devToolsURL_HTTPS)
        reply = input(['   -> The URL of the devTools is not set properly. Did you set the SSH key in GitHub? Y/N [N]: '], 's');
        if ~isempty(reply) && (strcmpi(reply, 'y') || strcmpi(reply, 'yes'))
            % set a new origin
            [status_gitSetOrigin, result_gitSetOrigin] = system(['git remote set-url origin ', gitConf.devToolsURL_SSH]);

            if status_gitSetOrigin == 0
                printMsg(mfilename, ['Origin of the ', gitConf.devTools_name, ' set to ', gitConf.devToolsURL_SSH, '.']);
            else
                fprintf(result_gitSetOrigin);
                error([gitCmd.lead, ' [', mfilename,'] Origin in local copy of ', gitConf.devTools_name, ' could not be set.', gitCmd.error]);
            end
        else
            error(['Please set the SSH key in Github before using the ', devTools_name, '.']);
        end

    end

    % checkout the master branch of the devTools
    [status_gitCheckoutMaster, result_gitCheckoutMaster] = system('git checkout master');
    if status_gitCheckoutMaster == 0
        printMsg(mfilename, ['The <master> branch of the ', gitConf.devTools_name, ' has been checked out.']);
    else
        fprintf(result_gitCheckoutMaster);
        error([gitCmd.lead, ' [', mfilename,'] The <master> branch of the ', gitConf.devTools_name, ' could not be checked out.', gitCmd.error]);
    end

    % fetch all content from remote
    [status_gitFetch, result_gitFetch] = system('git fetch');
    if status_gitFetch == 0
        printMsg(mfilename, ['All changes of ', gitConf.devTools_name, 'have been fetched']);
    else
        fprintf(result_gitFetch);
        error([gitCmd.lead, ' [', mfilename,'] The changes of ', gitConf.devTools_name, ' could not be fetched.', gitCmd.error]);
    end

    % determine the number of commits that the local master branch is behind
    [status_gitCount, result_gitCount] = system('git rev-list --count origin/master...@');
    result_gitCount = char(result_gitCount);
    result_gitCount = result_gitCount(1:end-1);
    if status_gitFetch == 0
        printMsg(mfilename, ['There are ', result_gitCount, ' new commit(s).']);

        if str2num(result_gitCount) > 0
            reply = input(['   -> Do you want to update the ', gitConf.devTools_name,'? Y/N [Y]: '], 's');

            if ~isempty(reply) && (strcmpi(reply, 'y') || strcmpi(reply, 'yes'))
                [status_gitPull, result_gitPull] = system('git pull');

                if status_gitPull == 0
                    printMsg(mfilename, ['The ', gitConf.devTools_name, 'have been updated.']);
                else
                    fprintf(result_gitPull);
                    error([gitCmd.lead, ' [', mfilename,'] The ', gitConf.devTools_name, ' could not be updated.', gitCmd.error]);
                end
            end
        else
            printMsg(mfilename, ['The ', gitConf.devTools_name, ' are up-to-date.']);
        end
    else
        fprintf(result_gitFetch);
        error([gitCmd.lead, ' [', mfilename,'] The changes of ', gitConf.devTools_name, ' could not be fetched.', gitCmd.error]);
    end

    fprintf(gitConf.launcher);

    choice = input('\n      (You can abort any process using CTRL-C)\n\n      [1] Start a new feature (branch).\n      [2] Select an existing feature (branch) to work on.\n      [3] Publish a feature (branch).\n      [4] Delete a feature (branch).\n\n   -> Please select what you want to do (enter the number): ', 's');

    choice = str2num(choice);

    if length(choice) == 0 || choice > 4 || choice < 1
        error('Please enter a number between 1 and 4.')
    else
        if ~isempty(choice) && length(choice) > 0
            % ask for a name of the feature/branch
            if choice == 1

                % list the available features if the fork is already configured
                if exist('gitConf.fullForkDir', 'var')
                    %list all available features
                    listFeatures();
                end

                % define a name of an example branch
                exampleBranch = gitConf.exampleBranch;

                reply = '';
                while isempty(reply)
                    reply = input(['   -> Please enter a name of the new feature (branch) that you want to work on (example: ', exampleBranch, '): '], 's');
                    if ~isempty(strfind(reply, 'develop')) || ~isempty(strfind(reply, 'master'))
                        reply = '';
                        fprintf([gitCmd.lead, 'Please use a different name that does not contain <develop> or <master>.', gitCmd.fail, gitCmd.trail]);
                    end
                end
                exitFlag = false;
            else
                % initialize the development tools
                initDevTools();

                % change to the fork diretory
                cd(gitConf.fullForkDir);

                %list all available features
                [exitFlag, currentBranch, ~, exampleBranch] = listFeatures();

                if ~strcmpi('develop', currentBranch) && ~strcmpi('master', currentBranch)
                    exampleBranch = currentBranch;
                end

                if ~exitFlag
                    reply = '';
                    if choice == 2
                        while isempty(reply) && ~exitFlag
                            reply = input(['   -> Please enter the name of the existing feature (branch) that you want to work on (example: ', exampleBranch, '): '], 's');
                        end
                    elseif choice == 3
                        while isempty(reply)
                            reply = input(['   -> Please enter the name of the feature (branch) that you want to publish (example: ', exampleBranch, '): '], 's');
                        end
                    elseif choice == 4

                        % list the available features if the fork is already configured
                        if exist('gitConf.fullForkDir', 'var')
                            %list all available features
                            listFeatures();
                        end

                        while isempty(reply)
                            reply = input(['   -> Please enter the name of the feature (branch) that you want to delete (example: ', exampleBranch, '): '], 's');
                        end
                    end
                end
            end

            if ~exitFlag
                if choice == 1 || choice == 2
                    % call initContribution
                    if isempty(reply)
                        initContribution;
                    else
                        initContribution(strtrim(reply));
                    end
                elseif choice == 3
                    % call submitContribution
                    submitContribution(reply);
                elseif choice == 4
                    % call submitContribution
                    deleteContribution(reply);
                end
            end
        end
    end

    % change back to the current directory
    cd(currentDir);
end
