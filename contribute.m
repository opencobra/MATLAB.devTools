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
                    exampleBranch = 'add-constraints';
                end

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
                [exitFlag, ~, ~, exampleBranch] = listFeatures();

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
