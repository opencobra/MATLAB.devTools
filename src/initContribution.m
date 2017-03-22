function initContribution(branchName)
% devTools
%
% PURPOSE: initializes a new feature (branch) named <branchName>
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

    checkoutFlag = false;

    while ~checkoutFlag
        % request a name of the new feature
        if nargin < 1 || nargin == 1 && (strcmpi(branchName, '') || ~isempty(strfind(branchName, 'develop')) || ~isempty(strfind(branchName, 'master')))
            branchName = '';
            while isempty(branchName) && ~checkoutFlag
                branchName = input([gitCmd.lead, originCall, ' -> Please enter a name of the feature that you want to work on (example: add-constraints): '], 's');
                if ~isempty(strfind(branchName, 'develop')) || ~isempty(strfind(branchName, 'master'))
                    branchName = '';
                    fprintf([gitCmd.lead, ' -> Please use a different name that does not contain <develop> or <master>.', gitCmd.fail, gitCmd.trail]);
                else
                    checkoutFlag = true;
                end
            end
        end

        % replace non-literal characters or non-numbers with a dash
        branchName = regexprep(branchName, '[^a-zA-Z0-9]', '-');

        % check if the branch already exists, and if, ask if the user wants to continue
        if checkBranchExistence(branchName) && checkoutFlag
            % list the available features if the fork is already configured
            if exist('gitConf.fullForkDir', 'var')
                listFeatures();
            end

            reply = input([gitCmd.lead, ' -> You already worked on a feature (branch) named <', branchName, '>. Do you want to continue working on <', branchName, '>? Y/N [Y]:'], 's');

            if isempty(reply) || strcmpi(reply, 'y') || strcmpi(reply, 'yes')
                checkoutFlag = true;
            else
                checkoutFlag = false;
            end
        else
            checkoutFlag = true;
        end
    end

    % checkout the branch of the feature
    if checkoutFlag
        checkoutBranch(branchName);

        % provide a success message
        fprintf([gitCmd.lead, gitCmd.trail]);
        fprintf([gitCmd.lead, ' -> You may now start working on your new feature (branch) <', branchName, '>.', gitCmd.trail]);
    end

    % provide instructions
    fprintf([gitCmd.lead, gitCmd.trail]);
    fprintf([gitCmd.lead, '    For future reference:', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> Run "contribute" and select "2" to choose the feature (branch) to work on.', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> Run "contribute" and select "3" to publish your feature (branch) named <', branchName, '>.', gitCmd.trail]);
    fprintf([gitCmd.lead, ' -> Run "contribute" and select "4" to delete your feature (branch) named <', branchName, '>.', gitCmd.trail]);
end
