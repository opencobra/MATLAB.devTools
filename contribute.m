function contribute(repoName, printLevel)
% devTools
%
% PURPOSE: displays a menu and calls the respective subfunctions
%
%       1. Start a new feature (branch):
%       2. Select an existing feature (branch) to work on.
%       3. Publish a feature (branch).
%       4. Delete a feature (branch).
%
% INPUT:
%
%     printLevel:     0: minimal printout (default)
%                     1: detailed printout (debug mode)

    global gitConf
    global gitCmd
    global resetDevToolsFlag
    global DEFAULTREPONAME

    resetDevToolsFlag = true;

    % retrieve the current directory
    currentDir = pwd;

    % adding the src folder of the devTools
    addpath(genpath(fileparts(which(mfilename))));

    finishup = onCleanup(@() resetDevTools());

    % treatment of input arguments
    if ~exist('repoName', 'var')
        DEFAULTREPONAME = 'opencobra/cobratoolbox';  % set the default repository
        repoName = DEFAULTREPONAME;
    end

    % check the system and set the configuration
    if exist('printLevel', 'var')
        checkSystem(mfilename, repoName, printLevel);
    else
        checkSystem(mfilename, repoName);
    end

    devToolsDir = fileparts(which(mfilename));

    % change to the directory of the devTools
    cd(devToolsDir);

    % update the devTools
    updateDevTools();

    fprintf(gitConf.launcher);

    choice = input('\n      (You can abort any process using CTRL+C)\n\n      [1] Start a new feature (branch).\n      [2] Select an existing feature (branch) to work on.\n      [3] Publish a feature (branch).\n      [4] Delete a feature (branch).\n      [5] Update the fork.\n\n   -> Please select what you want to do (enter the number): ', 's');

    choice = str2num(choice);

    if length(choice) == 0 || choice > 5 || choice < 0
        error('Please enter a number between 1 and 5.')
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
                initDevTools(repoName);

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
