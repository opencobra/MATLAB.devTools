function [exitFlag, currentBranch, arrResult, exampleBranch] = listFeatures()
% devTools
%
% PURPOSE: lists all available branches/features
%

    global gitConf

    exitFlag = false;

    % change to the fork diretory
    cd(gitConf.fullForkDir);

    % retrieve a list of branches
    [status, result] = system('git branch --list');

    % initialize the default value of the currentBranch
    currentBranch = 'develop';

    % give an example name
    exampleBranch = 'add-constraints';

    if status == 0
        arrResult = strsplit(result, '\n');
        arrResult = strtrim(arrResult);
        arrResult = arrResult(~cellfun(@isempty, arrResult));

        if length(arrResult) > 2
            fprintf('\n      Available features are:\n');

            % list the number of available features
            for i = 1:length(arrResult)
                tmpName = arrResult(i);
                tmpName = tmpName{1};
                if isempty(strfind(tmpName, 'develop')) && isempty(strfind(tmpName, 'master')) && ~isempty(tmpName)
                    fprintf(['      - ', tmpName, '\n']);

                    % define the currentBranch
                    if ~isempty(strfind(tmpName, '*'))
                        currentBranch = tmpName;
                    end

                    % define an example branch name
                    exampleBranch = tmpName;
                end
            end

            fprintf('\n');
        else
            reply = input('   -> You do not have any features (branches). Do you want to start a new feature (branch)? Y/N [Y]: ', 's');

            % decide whether to start a new feature (branch) or not
            if ~isempty(reply) && (strcmpi(reply, 'y') || strcmpi(reply, 'yes'))
                initContribution;
                exitFlag = true;
            else
                fprintf('   -> Please start again. Goodbye.\n')
                exitFlag = true;
            end
        end
    end

end
