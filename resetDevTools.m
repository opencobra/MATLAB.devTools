function resetDevTools()

    global gitConf
    global gitCmd

    tmpCmd = gitCmd;

    clear global gitConf;
    clear global gitCmd;

    if exist(tmpCmd, 'var')
        fprintf([tmpCmd.lead, 'The development tools have been reset.', tmpCmd.success, tmpCmd.trail]);
    else
        fprintf('Nothing to be done.\n')
    end
end
