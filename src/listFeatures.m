function [exitFlag, currentBranch, arrResult, exampleBranch] = listFeatures()
% Lists all available branches/features
%
% USAGE:
%
%    [exitFlag, currentBranch, arrResult, exampleBranch] = listFeatures()
%
% OUTPUT:
%    exitFlag:         Boolean (true if proper exit of function)
%    currentBranch:    Name of current branch
%    arrResult:        Cell with all names of branches
%    exampleBranch:    Name of a branch given as an example
%
% .. Author:
%      - Laurent Heirendt



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

    % check if the develop branch exists remotely
    if checkRemoteBranchExistence('develop')
        nbBranches = 3;
    else
        nbBranches = 2;
    end

    if status == 0
        arrResult = regexp(result,'\s+','split'); %strsplit is not compatible with older versions of MATLAB
        arrResult = strtrim(arrResult);
        arrResult = arrResult(~cellfun(@isempty, arrResult));

        if length(arrResult) > nbBranches
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
            reply = '';
            while isempty(reply)

                reply = input('   -> You do not have any features (branches). Do you want to start a new feature (branch)? Y/N [Y]: ', 's');

                % decide whether to start a new feature (branch) or not
                if strcmpi(reply, 'y') || strcmpi(reply, 'yes')
                    initContribution;
                    exitFlag = true;
                    break;
                elseif strcmpi(reply, 'n') || strcmpi(reply, 'no')
                    fprintf('   -> Please start again. Goodbye.\n')
                    exitFlag = true;
                else
                    reply = '';
                end
            end
        end
    end

end
