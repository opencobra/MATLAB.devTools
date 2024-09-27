function contribute(repoName, printLevel, autoOption)
% devTools
%
% INPUT:
%
%     repoName:       Name of the repository (default: opencobra/cobratoolbox)
%     printLevel:     0: minimal printout (default)
%                     1: detailed printout (debug mode)
%     autoOption:     menu option
%                       1. Start a new branch:
%                       2. Select an existing branch to work on.
%                       3. Publish a branch.
%                       4. Delete a branch.
%                       5. Update the fork
%
% EXAMPLES:
%     contribute('opencobra/cobratoolbox')
%     contribute('opencobra/COBRA.tutorials')

    global gitConf
    global gitCmd
    global resetDevToolsFlag
    global DEFAULTREPONAME

    resetDevToolsFlag = true;

    % retrieve the current directory
    currentDir = pwd;

    % adding the src folder of the devTools
    addpath(genpath(fileparts(which(mfilename))));

    % check the automatic option argument
    autoOptionFlag = false;
    if exist('autoOption', 'var')
        if ~isempty(autoOption) && autoOption > 0 && autoOption < 6
            autoOptionFlag = true;
        else
            error('Please enter an automatic menu option between 1 and 5.')
        end
    end

    % treatment of input arguments
    if ~exist('repoName', 'var') || isempty(repoName)
        DEFAULTREPONAME = 'opencobra/cobratoolbox';  % set the default repository
        repoName = DEFAULTREPONAME;
    end

    % soft reset if the repository name is different
    if ~isempty(gitConf) && exist('repoName', 'var') && isfield(gitConf, 'remoteUserName') && isfield(gitConf, 'remoteRepoName')
        if ~strcmpi(repoName, [gitConf.remoteUserName '/' gitConf.remoteRepoName])
            resetDevTools();
        end
    end

    % check the system and set the configuration
    if exist('printLevel', 'var')
        checkSystem(mfilename, repoName, printLevel);
    else
        checkSystem(mfilename, repoName);
    end

    % perform a soft reset if interrupted
    finishup = onCleanup(@() resetDevTools());

    % determine the directory of the devTools
    devToolsDir = fileparts(which(mfilename));

    % change to the directory of the devTools
    cd(devToolsDir);

    % update the devTools
    updateDevTools();

    % print the launcher
    fprintf(gitConf.launcher);

    % show the menu to select an option
    if autoOptionFlag
        choice = autoOption;
    else
        choice = input('\n      (You can abort any process using CTRL+C)\n\n      [1] Start a new branch.\n      [2] Select an existing branch to work on.\n      [3] Publish a branch.\n      [4] Delete a branch.\n      [5] Update the fork.\n\n   -> Please select what you want to do (enter the number): ', 's');
        choice = str2num(choice);
    end

    % evaluate the option
    if length(choice) == 0 || choice > 5 || choice < 0
        error('Please enter a number between 1 and 5.')
    else
        if ~isempty(choice) && length(choice) > 0
            % ask for a name of the branch
            if choice == 1

                % list the available branches if the fork is already configured
                if exist('gitConf.fullForkDir', 'var')
                    %list all available branches
                    listBranches();
                end

                % define a name of an example branch
                exampleBranch = gitConf.exampleBranch;

                reply = '';
                while isempty(reply)
                    reply = input(['   -> Please enter a name of the new branch that you want to work on (example: ', exampleBranch, '): '], 's');
                    if ~isempty(strfind(reply, 'develop')) || ~isempty(strfind(reply, 'master'))
                        reply = '';
                        fprintf([gitCmd.lead, 'Please use a different name that does not contain <develop> or <master>.', gitCmd.fail, gitCmd.trail]);
                    end
                end
                exitFlag = false;
            else
                % initialize the development tools
                initDevTools(repoName,currentDir);

                % change to the fork diretory
                cd(gitConf.fullForkDir);

                %list all available branches
                [exitFlag, currentBranch, ~, exampleBranch] = listBranches();

                if ~strcmpi('develop', currentBranch) && ~strcmpi('master', currentBranch)
                    exampleBranch = currentBranch;
                end

                if ~exitFlag
                    reply = '';
                    if choice == 2
                        while isempty(reply) && ~exitFlag
                            reply = input(['   -> Please enter the name of the existing branch that you want to work on (example: ', exampleBranch, '): '], 's');
                        end
                    elseif choice == 3
                        while isempty(reply)
                            reply = input(['   -> Please enter the name of the branch that you want to publish (example: ', exampleBranch, '): '], 's');
                        end
                    elseif choice == 4

                        % list the available branches if the fork is already configured
                        if exist('gitConf.fullForkDir', 'var')
                            %list all available branches
                            listBranches();
                        end

                        while isempty(reply)
                            reply = input(['   -> Please enter the name of the branch that you want to delete (example: ', exampleBranch, '): '], 's');
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
                    % call deleteContribution
                    deleteContribution(reply);
                elseif choice == 5
                    % call updateFork
                    updateFork();
                end
            end
        end
    end

    resetDevToolsFlag = false;

    % change back to the current directory
    cd(currentDir);

end
