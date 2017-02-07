function checkSystem(callerName)

    global gitConf
    global gitCmd

    gitConf.leadForkDirName = 'fork-';
    gitCmd.lead = 'dev>  ';
    gitCmd.success = ' (Success) ';
    gitCmd.fail = ' (Error) ';
    gitCmd.trail = '\n';

    if nargin < 1
        callerName = mfilename;
    end

    % check if git is properly installed
    [status, result] = system('git --version');

    if status == 0 && contains(result, 'git version')
        fprintf([gitCmd.lead, '(', callerName, ') git is properly installed.', gitCmd.success, gitCmd.trail]);
    else
        error([gitCmd.lead, '(', callerName, ') git is not installed. Please follow the guidelines how to install git.']);
    end

    % check if curl is properly installed
    [status, result] = system('curl --version');

    if status == 0 && contains(result, 'curl') && contains(result, 'http')
        fprintf([gitCmd.lead, '(', callerName, ') curl is properly installed.', gitCmd.success, gitCmd.trail]);
    else
        error([gitCmd.lead, '(', callerName, ') curl is not installed. Please follow the guidelines how to install curl.']);
    end

end
