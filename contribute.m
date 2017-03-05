function contribute(verbose)
% devTools
%
% PURPOSE: displays a menu and calls the respective subfunctions
%

    global gitConf
    global gitCmd

    % define the main path of the devTools
    pth = which('contribute.m');

    % adding the src folder of the devTools
    addpath(genpath(pth(1:end - (length('contribute.m') + 1))));

    % check the system and set the configuration
    checkSystem();

    if nargin > 0
        gitConf.verbose = true;
    end

    fprintf(gitConf.launcher);

    choice = input('\n      (You can abort any process using CTRL-C)\n\n      [1] Initialize a contribution.\n      [2] Continue a contribution.\n      [3] Submit/publish a contribution.\n      [4] Delete a contribution.\n\n   -> Please select what you want to do (enter the number): ', 's');

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

                reply = '';
                while isempty(reply)
                    reply = input('   -> Please enter a name of the new feature that you want to work on (example: add-constraints): ', 's');
                    if ~isempty(strfind(reply, 'develop')) || ~isempty(strfind(reply, 'master'))
                        reply = '';
                        fprintf([gitCmd.lead, 'Please use a different name that does not contain <develop> or <master>.', gitCmd.fail, gitCmd.trail]);
                    end
                end
                exitFlag = false;
            else
                % initialize the development tools
                initDevTools();

                exitFlag = false;

                % change to the fork diretory
                cd(gitConf.fullForkDir);

                %list all available features
                listFeatures();

                if ~exitFlag
                    reply = '';
                    if choice == 2
                        while isempty(reply)
                            reply = input('   -> Please enter the name of the feature that you want to continue working on (example: add-constraints): ', 's');
                        end
                    elseif choice == 3
                        while isempty(reply)
                            reply = input('   -> Please enter the name of the feature that you want to submit/publish (example: add-constraints): ', 's');
                        end
                    elseif choice == 4

                        % list the available features if the fork is already configured
                        if exist('gitConf.fullForkDir', 'var')
                            %list all available features
                            listFeatures();
                        end

                        while isempty(reply)
                            reply = input('   -> Please enter the name of the feature that you want to delete (example: add-constraints): ', 's');
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
end
