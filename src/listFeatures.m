function [exitFlag, currentBranch, arrResult, exampleBranch] = listFeatures()
% devTools
%
% PURPOSE: lists all available branches/features
%

    global gitConf

    exitFlag = false;

    % change to the fork diretory
    cd(gitConf.fullForkDir);

    % retrieve a list of all the branches
    filterColor = '';
    if ~ispc
        filterColor =  '| tr -s "[:cntrl:]" "\n"';
    end
    [status, result] = system(['git branch --list ', filterColor]);

    % determine name of the current branch
    currentBranch = getCurrentBranchName();

    % give an example name
    exampleBranch = gitConf.exampleBranch;

    if status == 0
        arrResult = regexp(result,'\s+','split'); %strsplit is not compatible with older versions of MATLAB
        arrResult = strtrim(arrResult);
        arrResult = arrResult(~cellfun(@isempty, arrResult));

        if length(arrResult) > 2
            fprintf('\n      Available features are:\n');

            % list the number of available features
            for i = 1:length(arrResult)
                tmpName = arrResult(i);
                tmpName = tmpName{1};
                if isempty(strfind(tmpName, '*')) && isempty(strfind(tmpName, 'develop')) && isempty(strfind(tmpName, 'master')) && ~isempty(tmpName)
                    fprintf(['      - ', tmpName, '\n']);

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
