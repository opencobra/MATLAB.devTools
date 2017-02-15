function initContribution()

    global gitConf
    global gitCmd

    % initialize the development tools
    initDevTools();

    % request a name of the new feature
    branchName = input([gitCmd.lead, ' -> Please enter a name of the feature that you want to work on (example: add-constraints): '], 's');

    if isempty(branchName)
        branchName = ['new-feature-', num2str(floor(floor(sum(clock))*randi(100)/100))];
    end

    % checkout the branch of the feature
    checkoutBranch(branchName);

    % provide a success message
    fprintf([gitCmd.lead, ' -> You may now start working on your new feature on your branch <', branchName, '>.', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> Please run "submitContribution()" once you are done.', gitCmd.trail]);
