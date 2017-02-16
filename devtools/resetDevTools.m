function resetDevTools()

    global gitConf
    global gitCmd

    clear global gitConf;
    clear global gitCmd;

    fprintf(' [', mfilename,'] The development tools have been reset.\n');
end
