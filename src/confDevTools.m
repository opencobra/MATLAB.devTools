function confDevTools(repoName, varargin)
% Configure the devTools by defining the `gitConf` object
%
% USAGE:
%
%    confDevTools(repoName, remoteRepoURL, varargin)
%
% INPUTS:
%     repoName:       Name of the repository (default: `'cobratoolbox'`)
%
% OPTIONAL INPUTS:
%     remoteRepoURL:  URL of the repository
%     launcher:       String with a header to be displayed when starting
%     nickName:       Short name of the repository
%     printLevel:     Verbose level (default: 1)
%
% Note:
%      Currently, only 2 projects are defined:
%      `The COBRA Toolbox <https://www.github.com/opencobra/cobratoolbox>`__
%      and `COBRA.tutorials <https://www.github.com/opencobra/COBRA.tutorials>`__
%
% .. Author:
%      - Laurent Heirendt, January 2018
%

    global gitConf
    global gitCmd

    % define default values
    defaultPrintLevel = 0;

    % setup the parser
    parser = inputParser();
    parser.addRequired('repoName', @ischar);
    parser.addParamValue('remoteRepoURL', ['https://github.com/' repoName '.git'], @ischar);

    % set the defaultLauncher
    if strcmpi(repoName, 'opencobra/cobratoolbox')
        c = clock;
        defaultLauncher = ['\n\n      _____   _____   _____   _____     _____     |\n     /  ___| /  _  \\ |  _  \\ |  _  \\   / ___ \\    |   COnstraint-Based Reconstruction and Analysis\n     | |     | | | | | |_| | | |_| |  | |___| |   |   The COBRA Toolbox - ', num2str(c(1)) , '\n     | |     | | | | |  _  { |  _  /  |  ___  |   |\n     | |___  | |_| | | |_| | | | \\ \\  | |   | |   |   Documentation:\n     \\_____| \\_____/ |_____/ |_|  \\_\\ |_|   |_|   |   http://opencobra.github.io/cobratoolbox\n                                                  | \n\n'];
        defaultNickName = 'cobratoolbox';
    elseif strcmpi(repoName, 'opencobra/COBRA.tutorials')
        defaultLauncher = '\n\n       ~~~ COBRA.tutorials ~~~\n\n';
        defaultNickName = 'COBRA.tutorials';
    else
        defaultLauncher = ['\n\n      ~~~ ' repoName ' ~~~\n\n'];
        defaultNickName = repoName;
    end
    parser.addParamValue('launcher', defaultLauncher, @ischar);
    parser.addParamValue('nickName', defaultNickName, @ischar);
    parser.addParamValue('printLevel', defaultPrintLevel, @(x) isnumeric(x));

    % parse the input arguments
    if ~isempty(varargin)
        parser.parse(repoName, varargin{:});
    else
        parser.parse(repoName);
    end

    % retrieve the variables
    repoName = parser.Results.repoName;
    remoteRepoURL = parser.Results.remoteRepoURL;
    printLevel = parser.Results.printLevel;

    % strip the .git at the end
    tmpRemoteRepoURL = remoteRepoURL(1:end-4);

    % check if the remoteRepoURL exists before proceeding
    [status_curl, result_curl] = system(['curl -s -k --head ', tmpRemoteRepoURL]);
    if ~(status_curl == 0 && ~isempty(strfind(result_curl, '200')))
         error([' [', mfilename, '] The URL (' remoteRepoURL ') is not reachable or does not exist.']);
    end

    % set the default nickName
    urlSplit = strsplit(remoteRepoURL, '/');
    tmpNickName = strsplit(urlSplit{end}, '.git');
    nickName = tmpNickName{1};

    % define the configuration of other projects here
    if printLevel > 0
        fprintf([' -- Assuming the default configuration (', nickName, ' repository)\n']);
    end

    % definition of parameters
    gitConf.leadForkDirName = 'fork-';
    gitConf.exampleBranch = 'add-constraints';

    % define the printLevel
    gitConf.printLevel = printLevel;
    gitConf.launcher = parser.Results.launcher;
    gitConf.remoteRepoURL = remoteRepoURL;
    gitConf.nickName = nickName;

    % define the URL of the devTools
    gitConf.devToolsURL_SSH = 'git@github.com:opencobra/MATLAB.devTools.git';
    gitConf.devToolsURL_HTTPS = 'https://github.com/opencobra/MATLAB.devTools.git';
    gitConf.devTools_name = 'MATLAB.devTools';

    % definition of commands
    gitCmd.lead = 'dev>  ';
    gitCmd.success = ' (Success) ';
    gitCmd.fail = ' (Error) ';
    gitCmd.trail = '\n';

    % print out a success message
    printMsg(mfilename, [' The devTools have been configured (', nickName, ').']);
end
