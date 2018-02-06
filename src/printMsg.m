function printMsg(fileName, msg, endMsg)
% Print a message
%
% USAGE:
%
%    printMsg(fileName, msg, endMsg)
%
% INPUT:
%   fileName:       Name of the file from which the message is issued
%   msg:            Message as string
%   endMsg:         End of message, generally a new line character
%
% .. Author:

    global gitConf
    global gitCmd

    % define the message
    if ~isempty(gitConf) && ~isempty(gitCmd)
        % define the end of the message
        if nargin < 3
            endMsg = [gitCmd.success, gitCmd.trail];
        end

        if gitConf.printLevel > 0
            message = [gitCmd.lead, ' [', fileName, '] ', msg, endMsg];
        end
    else
        message = [' [', fileName, '] ', msg];
    end

    % print the message properly speaking
    fprintf(message);
end
