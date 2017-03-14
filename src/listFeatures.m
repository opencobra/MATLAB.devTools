function exitFlag = listFeatures()
% devTools
%
% PURPOSE: lists all available branches/features
%

    global gitConf
    global gitCmd

    exitFlag = false;

    % change to the fork diretory
    cd(gitConf.fullForkDir);

    % retrieve a list of branches
    [status, result] = system('git branch --list');

    if status == 0
        arrResult = strsplit(result, '\n');
        arrResult = strtrim(arrResult);
        arrResult = arrResult(~cellfun(@isempty, arrResult));

        if length(arrResult) > 2
            fprintf('\n      Available features are:\n');
            for i = 1:length(arrResult)
                tmpName = arrResult(i);
                tmpName = tmpName{1};
                if isempty(strfind(tmpName, 'develop')) && isempty(strfind(tmpName, 'master')) && ~isempty(tmpName)
                    fprintf(['      - ', tmpName, '\n']);
                end
            end
            fprintf('\n');
        else
            reply = input('   -> You do not have any features (branches). Do you want to start a new contribution? Y/N [Y]: ', 's');
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
