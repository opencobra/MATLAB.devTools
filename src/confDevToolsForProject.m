function confDevToolsForProject(projectName)
% devTools
%
% INPUT:
%     projectName:    Name of the project (default: 'cobratoolbox')
% PURPOSE: define the configuration of the devTools
%
% Note:
%    Currently, only 2 projects are defined:
%      - cobratoolbox: https://www.github.com/opencobra/cobratoolbox
%      - COBRA.tutorials: https://www.github.com/opencobra/COBRA.tutorials
%
% .. Author:
%      - Laurent Heirendt, January 2018

    global gitConf
    global gitCmd

    % check if a project name has been specified
    if ~exist('projectName', 'var')
        projectName = 'cobratoolbox';
    end

    if strcmp(projectName, 'cobratoolbox') % configure the devTools for https://www.github.com/opencobra/cobratoolbox
        confDevTools();

        % print out a success message
        printMsg(mfilename, [' The devTools have been configured for ', projectName, '.']);

    elseif strcmp(projectName, 'COBRA.tutorials') % configure the devTools for https://www.github.com/opencobra/COBRA.tutorials
        % print out a success message
        printMsg(mfilename, [' The devTools have been configured for ', projectName, '.']);

    else
        error('You have to specify a project name that is pre-configured or configure the devTools manually.');
    end

