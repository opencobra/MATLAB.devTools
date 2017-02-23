function resetDevTools()
% The COBRA Toolbox: Development tools
%
% PURPOSE: reset the configuration of the development tools
%

    global gitConf
    global gitCmd

    clear global gitConf;
    clear global gitCmd;

    fprintf(' [', mfilename,'] The development tools have been reset.\n');
end
