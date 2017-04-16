function updateDevTools()
% devTools
%
% PURPOSE: update the devTools and set the SSH origin if necessary
%

    global gitConf
    global gitCmd

    % check if the origin is set to the SSH origin of the devTools
    [status_gitRemote, result_gitRemote] = system('git remote -v');

    remoteFrags = strsplit(result_gitRemote);

    indexOrigin_cell = strfind(remoteFrags, 'origin');
    indexOrigin = find(not(cellfun('isempty', indexOrigin_cell)));

    if status_gitRemote == 0 && strcmpi(remoteFrags(indexOrigin(1)), 'origin') && strcmpi(remoteFrags(indexOrigin(1) + 1), gitConf.devToolsURL_HTTPS)
        reply = input(['   -> The URL of the devTools is not set properly. Did you set the SSH key in GitHub? Y/N [N]: '], 's');
        if ~isempty(reply) && (strcmpi(reply, 'y') || strcmpi(reply, 'yes'))
            % set a new origin
            [status_gitSetOrigin, result_gitSetOrigin] = system(['git remote set-url origin ', gitConf.devToolsURL_SSH]);

            if status_gitSetOrigin == 0
                printMsg(mfilename, ['Origin of the ', gitConf.devTools_name, ' set to ', gitConf.devToolsURL_SSH, '.']);
            else
                fprintf(result_gitSetOrigin);
                error([gitCmd.lead, ' [', mfilename,'] Origin in local copy of ', gitConf.devTools_name, ' could not be set.', gitCmd.error]);
            end
        else
            error(['Please set the SSH key in Github before using the ', devTools_name, '.', gitCmd.error]);
        end
    end

    % checkout the master branch of the devTools
    [status_gitCheckoutMaster, result_gitCheckoutMaster] = system('git checkout master');
    if status_gitCheckoutMaster == 0
        printMsg(mfilename, ['The <master> branch of the ', gitConf.devTools_name, ' has been checked out.']);
    else
        fprintf(result_gitCheckoutMaster);
        error([gitCmd.lead, ' [', mfilename,'] The <master> branch of the ', gitConf.devTools_name, ' could not be checked out.', gitCmd.error]);
    end

    % fetch all content from remote
    [status_gitFetch, result_gitFetch] = system('git fetch origin');
    if status_gitFetch == 0
        printMsg(mfilename, ['All changes of ', gitConf.devTools_name, 'have been fetched']);
    else
        fprintf(result_gitFetch);
        error([gitCmd.lead, ' [', mfilename,'] The changes of ', gitConf.devTools_name, ' could not be fetched.', gitCmd.error]);
    end

    % determine the number of commits that the local master branch is behind
    [status_gitCount, result_gitCount] = system('git rev-list --count origin/master...@');
    result_gitCount = char(result_gitCount);
    result_gitCount = result_gitCount(1:end-1);

    if status_gitCount == 0
        printMsg(mfilename, ['There are ', result_gitCount, ' new commit(s).']);

        if str2num(result_gitCount) > 0
            reply = input(['   -> Do you want to update the ', gitConf.devTools_name,'? Y/N [Y]: '], 's');

            if ~isempty(reply) && (strcmpi(reply, 'y') || strcmpi(reply, 'yes'))
                [status_gitPull, result_gitPull] = system('git pull origin master');

                if status_gitPull == 0
                    printMsg(mfilename, ['The ', gitConf.devTools_name, 'have been updated.']);
                else
                    fprintf(result_gitPull);
                    error([gitCmd.lead, ' [', mfilename,'] The ', gitConf.devTools_name, ' could not be updated.', gitCmd.error]);
                end
            end
        else
            printMsg(mfilename, ['The ', gitConf.devTools_name, ' are up-to-date.']);
        end
    else
        fprintf(result_gitCount);
        error([gitCmd.lead, ' [', mfilename,'] Eventual changes of the <master> branch of the ', gitConf.devTools_name, ' could not be counted.', gitCmd.error]);
    end
end
