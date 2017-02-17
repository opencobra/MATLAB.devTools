function contribute

    fprintf('\n\n      _____   _____   _____   _____     _____     |\n     /  ___| /  _  \\ |  _  \\ |  _  \\   / ___ \\    |   COnstraint-Based Reconstruction and Analysis\n     | |     | | | | | |_| | | |_| |  | |___| |   |   COBRA Toolbox 3.0 - 2017\n     | |     | | | | |  _  { |  _  /  |  ___  |   |\n     | |___  | |_| | | |_| | | | \\ \\  | |   | |   |   Documentation:\n     \\_____| \\_____/ |_____/ |_|  \\_\\ |_|   |_|   |   http://opencobra.github.io/cobratoolbox\n                                                  | \n\n');


    choice = input('\n     [1] Initialize a contribution.\n     [2] Continue a contribution.\n     [3] Submit/publish your contribution.\n\n  -> Please select what you want to do (enter the number): ', 's');

    choice = str2num(choice);

    if length(choice) == 0 || choice > 3 || choice < 1
        error('Please enter a number between 1 and 3')
    else
        if isempty(choice) || choice == 1 || choice == 2
            % ask for a name of the feature/branch
            if choice == 1
                reply = input('  -> Please enter a name of the feature that you want to work on (example: add-constraints): ', 's');
            else
                reply = input('  -> Please enter the name of the feature that you want to continue working on (example: add-constraints): ', 's');
            end

            % call initContribution
            if isempty(reply)
                initContribution;
            else
                initContribution(strtrim(reply));
            end
        end

        if choice == 3
            % ask for a name of the feature/branch
            reply = '';
            while isempty(reply)
                reply = input('  -> Please enter the name of the feature that you want to submit/publish (example: add-constraints): ', 's');
            end

            % call submitContribution
            submitContribution(reply);
        end

    end
end
