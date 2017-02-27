function initContribution(branchName)
% The COBRA Toolbox: Development tools
%
% PURPOSE: initializes a contribution named <branchName>
%

    global gitConf
    global gitCmd

    % initialize the development tools
    initDevTools();

    % request a name of the new feature
    if nargin < 1
        branchName = input([gitCmd.lead, ' [', mfilename,'] -> Please enter a name of the feature that you want to work on (example: add-constraints.): '], 's');

        if isempty(branchName)
            branchName = ['new-feature-', num2str(floor(floor(sum(clock))*randi(100)/100))];
        end
    end

    % checkout the branch of the feature
    checkoutBranch(branchName);

    % provide a success message
    fprintf([gitCmd.lead, ' -> You may now start working on your new feature <', branchName, '>.', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> Run "contribute" and select "2" to continue working on your feature named <', branchName, '>.', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> Run "contribute" and select "3" to publish your feature named <', branchName, '>.', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> Run "contribute" and select "4" to delete your feature named <', branchName, '>.', gitCmd.trail]);
end
