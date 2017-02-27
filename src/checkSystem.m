function checkSystem(callerName)
% The COBRA Toolbox: Development tools
%
% PURPOSE: checks the configuration of the system (installation of git and curl)
%

    global gitConf
    global gitCmd

    gitConf.leadForkDirName = 'fork-';
    gitCmd.lead = 'dev>  ';
    gitCmd.success = ' (Success) ';
    gitCmd.fail = ' (Error) ';
    gitCmd.trail = '\n';

    if nargin < 1
        callerName = '';
    else
        callerName = ['(caller: ', callerName, ')'];
    end

    % check if git is properly installed
    [status, result] = system('git --version');

    if status == 0 && contains(result, 'git version')
        if gitConf.verbose
            fprintf([gitCmd.lead, ' [', mfilename, ']', callerName, ' git is properly installed.', gitCmd.success, gitCmd.trail]);
        end
    else
        error([gitCmd.lead, ' [', mfilename, ']', callerName, ' git is not installed. Please follow the guidelines how to install git.']);
    end

    % check if curl is properly installed
    [status, result] = system('curl --version');

    if status == 0 && contains(result, 'curl') && contains(result, 'http')
        if gitConf.verbose
            fprintf([gitCmd.lead, ' [', mfilename, ']', callerName, ' curl is properly installed.', gitCmd.success, gitCmd.trail]);
        end
    else
        error([gitCmd.lead, ' [', mfilename, ']', callerName, ' curl is not installed. Please follow the guidelines how to install curl.']);
    end
end
