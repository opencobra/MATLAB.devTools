function initContribution(branchName)

    global gitConf
    global gitCmd

    % initialize the development tools
    initDevTools();

    % request a name of the new feature
    if nargin < 1
        branchName = input([gitCmd.lead, ' [', mfilename,'] -> Please enter a name of the feature that you want to work on (example: add-constraints): '], 's');

        if isempty(branchName)
            branchName = ['new-feature-', num2str(floor(floor(sum(clock))*randi(100)/100))];
        end
    end

    % checkout the branch of the feature
    checkoutBranch(branchName);

    % provide a success message
    fprintf([gitCmd.lead, ' -> You may now start working on your new feature <', branchName, '>.', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> You may run "deleteContribution(\''', branchName, '\'');" if you want to delete your existing contribution.', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> Please run "submitContribution(\''', branchName, '\'');" once you are done.', gitCmd.trail]);
