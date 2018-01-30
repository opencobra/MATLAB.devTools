function history(fileName)
% Displays the history of a file
%
% USAGE:
%
%    history(fileName)
%
% INPUT:
%   fileName:     Name of the file for which the history shall be displayed
%
% .. Author:
%      - Laurent Heirendt


    global gitConf

    fullPath = which(fileName);
    if isempty(fullPath)
        error('The file is not present in your MATLAB path. Please add the local folder of your fork to your PATH.');
    else

        % change to the directory of the file
        cd(fullPath(1:end-length(fileName)));

        % output instructions
        fprintf(['You will be shown the history of \n\t', fullPath, '\n\n']);
        fprintf('You can get the specific commit details by attaching the commit hash at the end of:\n');
        fprintf(['\t', gitConf.remoteRepoURL(1:end-4), '/commit/\n\n']);
        fprintf('Example: For commit hash: 6f76816f30d5b2325047eb3edc743e1de17ef8e9, you can view the details by browsing to:\n');
        fprintf(['         ', gitConf.remoteRepoURL(1:end-4), '/commit/6f76816f30d5b2325047eb3edc743e1de17ef8e9\n\n']);

        reply = input(' -> You can exit the screen that will be displayed now by hitting `q` on your keyboard [press ENTER to continue]: ', 's');

        if isempty(reply) || strcmpi(reply, 'y') || strcmpi(reply, 'yes') || strcmpi(reply, 'enter')
            system(['git log --follow --pretty=short ', fullPath]);
        else
            fprintf('You simply have to press `q` on your keyboard. Try again.');
        end
    end
end
