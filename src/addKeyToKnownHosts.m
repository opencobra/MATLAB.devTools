function keyAdded = addKeyToKnownHosts(callerName)
% Checks if the public key to `site.ext` exists
% If the public key of the `site.ext` does not exist,
% adds the public key to the known hosts
%
% USAGE:
%
%   keyAdded = addKeyToKnownHosts(callerName)
%
% INPUT:
%   callerName:     Name of the function calling (default: empty string)
%
% OUTPUT:
%   keyAdded:       Boolean (true if key has been added successfully or exists)
%
% .. Author:
%      - Laurent Heirendt

    global gitCmd

    % set default arguments
    if ~exist('callerName', 'var')
        callerName = '';
    end

    % add github.com as a known host
    [status_keyscan, result_keyscan] = system('ssh-keyscan');

    % user directory
    if ispc
        homeDir = getenv('userprofile');
    else
        homeDir = getenv('HOME');
    end

    if status_keyscan == 1 && ~isempty(strfind(result_keyscan, 'usage:'))

        % touch the file first
        system(['touch ', homeDir, filesep, '.ssh', filesep, 'known_hosts']);

        % read the known hosts file
        [~, result_grep] = system(['grep "^github.com " ', homeDir, filesep, '.ssh', filesep, 'known_hosts']);

        if strcmp(result_grep, '')
            [status_kh, result_kh] = system(['ssh-keyscan github.com >> ', homeDir, filesep, '.ssh', filesep, 'known_hosts']);

            if status_kh == 0 && ~isempty(strfind(result_kh, '# github.com'))
                printMsg(mfilename, [callerName, ' github.com has been added to the known hosts']);
                keyAdded = true;
            else
                fprintf(result_kh);
                error([gitCmd.lead, ' [', mfilename, ']', callerName, ' github.com could not be added to the known hosts file in ~/.ssh/known_hosts']);
            end
        else
            printMsg(mfilename, [callerName, ' github.com is already a known host.']);
            keyAdded = true;
        end
    else
        fprintf(result_keyscan);
        error([gitCmd.lead, ' [', mfilename, ']', callerName, ' ssh-keyscan is not installed.']);
    end
end
