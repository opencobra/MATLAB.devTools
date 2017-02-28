function initContribution(branchName)
% devTools
%
% PURPOSE: initializes a contribution named <branchName>
%

    global gitConf
    global gitCmd

    % initialize the development tools
    initDevTools();

    if gitConf.verbose
        originCall = [' [', mfilename, '] '];
    else
        originCall  = '';
    end

    % request a name of the new feature
    if nargin < 1 || nargin == 1 && (strcmp(branchName, '') || contains(branchName, 'develop') || contains(branchName, 'master'))
        branchName = '';
        while isempty(branchName)
            branchName = input([gitCmd.lead, originCall, ' -> Please enter a name of the feature that you want to work on (example: add-constraints): '], 's');
            if contains(branchName, 'develop') || contains(branchName, 'master')
                branchName = '';
                fprintf([gitCmd.lead, 'Please use a different name that does not contain <develop> or <master>.', gitCmd.fail, gitCmd.trail]);
            end
        end
    end

    % replace non-literal characters or non-numbers with a dash
    branchName = regexprep(branchName,'[^a-zA-Z0-9]','-');

    % checkout the branch of the feature
    checkoutBranch(branchName);

    % provide a success message
    fprintf([gitCmd.lead, ' -> You may now start working on your new feature <', branchName, '>.', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> Run "contribute" and select "2" to continue working on your feature named <', branchName, '>.', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> Run "contribute" and select "3" to publish your feature named <', branchName, '>.', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> Run "contribute" and select "4" to delete your feature named <', branchName, '>.', gitCmd.trail]);
end
