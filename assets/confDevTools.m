function confDevTools(launcher, remoteRepoURL, nickName, verbose)
% devTools
%
% PURPOSE: define the configuration of the devTools
%

    global gitConf
    global gitCmd

    % definition of parameters
    gitConf.leadForkDirName = 'fork-';
    gitConf.exampleBranch = 'add-constraints';

    if nargin < 4  % default values
        gitConf.verbose = false;
        gitConf.launcher = '\n\n      _____   _____   _____   _____     _____     |\n     /  ___| /  _  \\ |  _  \\ |  _  \\   / ___ \\    |   COnstraint-Based Reconstruction and Analysis\n     | |     | | | | | |_| | | |_| |  | |___| |   |   The COBRA Toolbox - 2017\n     | |     | | | | |  _  { |  _  /  |  ___  |   |\n     | |___  | |_| | | |_| | | | \\ \\  | |   | |   |   Documentation:\n     \\_____| \\_____/ |_____/ |_|  \\_\\ |_|   |_|   |   http://opencobra.github.io/cobratoolbox\n                                                  | \n\n';
        gitConf.remoteRepoURL = 'https://github.com/opencobra/cobratoolbox.git';
        gitConf.nickName = 'cobratoolbox';
    else
        gitConf.verbose = verbose;
        gitConf.launcher = launcher;
        gitConf.remoteRepoURL = remoteRepoURL;
        gitConf.nickName = nickName;
    end

    % definition of commands
    gitCmd.lead = 'dev>  ';
    gitCmd.success = ' (Success) ';
    gitCmd.fail = ' (Error) ';
    gitCmd.trail = '\n';

end
