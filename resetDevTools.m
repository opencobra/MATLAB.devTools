function resetDevTools()

    global gitConf
    global gitCmd

    tmpCmd = gitCmd;

    clear global gitConf;
    clear global gitCmd;

    fprintf([tmpCmd.lead, 'The development tools have been reset.', tmpCmd.success, tmpCmd.trail]);
end
