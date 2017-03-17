function printMsg(fileName, msg, endMsg)
% devTools
%
% PURPOSE: print a message
%

    global gitConf
    global gitCmd

    if nargin < 3
        endMsg = [gitCmd.success, gitCmd.trail];
    end

    if gitConf.verbose
        fprintf([gitCmd.lead, ' [', fileName, '] ', msg, endMsg]);
    end
end
