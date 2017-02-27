function contribute(verbose)
% The COBRA Toolbox: Development tools
%
% PURPOSE: displays a menu and calls the respective subfunctions
%

    global gitConf
    global gitCmd

    if nargin < 1
        gitConf.verbose = false;
    else
        gitConf.verbose = true;
    end

    fprintf('\n\n      _____   _____   _____   _____     _____     |\n     /  ___| /  _  \\ |  _  \\ |  _  \\   / ___ \\    |   COnstraint-Based Reconstruction and Analysis\n     | |     | | | | | |_| | | |_| |  | |___| |   |   The COBRA Toolbox - 2017\n     | |     | | | | |  _  { |  _  /  |  ___  |   |\n     | |___  | |_| | | |_| | | | \\ \\  | |   | |   |   Documentation:\n     \\_____| \\_____/ |_____/ |_|  \\_\\ |_|   |_|   |   http://opencobra.github.io/cobratoolbox\n                                                  | \n\n');

    choice = input('\n      [1] Initialize a contribution.\n      [2] Continue a contribution.\n      [3] Submit/publish a contribution.\n      [4] Delete a contribution.\n\n   -> Please select what you want to do (enter the number): ', 's');

    choice = str2num(choice);

    if length(choice) == 0 || choice > 4 || choice < 1
        error('Please enter a number between 1 and 4.')
    else
        if ~isempty(choice) && length(choice) > 0
            % ask for a name of the feature/branch
            if choice == 1
                reply = '';
                while isempty(reply)
                    reply = input('   -> Please enter a name of the new feature that you want to work on (example: add-constraints): ', 's');
                end
                exitFlag = false;
            else
                % initialize the development tools
                initDevTools();

                exitFlag = false;

                % change to the fork diretory
                cd(gitConf.fullForkDir);

                % retrieve a list of branches
                [status, result] = system('git branch --list');

                if status == 0
                    arrResult = strsplit(result, '\n');
                    arrResult(~cellfun(@isempty, arrResult));

                    if length(arrResult) > 2
                        fprintf('\n      Available features are:\n');
                        for i = 1:length(arrResult)
                            tmpName = arrResult(i);
                            tmpName = tmpName{1};
                            if ~contains(tmpName, 'develop') && ~contains(tmpName, 'master') && ~isempty(tmpName)
                                fprintf(['      - ', tmpName, '\n']);
                            end
                        end
                        fprintf('\n');
                    else
                        reply = input('   -> You do not have any features. Do you want to start a new contribution? Y/N [Y]', 's');
                        if ~isempty(reply) && (strcmp(reply, 'y') || strcmp(reply, 'Y'))
                            initContribution;
                            exitFlag = true;
                        else
                            fprintf('   -> Please start again. Goodbye.\n')
                            exitFlag = true;
                        end
                    end
                end

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
