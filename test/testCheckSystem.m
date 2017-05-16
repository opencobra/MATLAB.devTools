global gitConf
global gitCmd

% define the configuration of the MATLAB.devTools
launcher = '\n\n       ~~~ MATLAB.devTools ~~~\n\n';
remoteRepoURL = 'https://github.com/uni-lu/MATLAB.devTools.CI.git';
nickName = 'MATLAB.devTools.CI';
verbose = true;

% reset the development tools
resetDevTools();

% set the configuration
confDevTools(launcher, remoteRepoURL, nickName, verbose);

% check the system
checkSystem();

% initialize the devTools
initDevTools();

% check the devTools
checkDevTools()

% remove the local fork
%system('rm -rf ~/fork-MATLAB.devTools.CI')

% check if the remote fork exists
checkRemoteFork();

% initialize the devTools
%initDevTools();

% update the fork
updateFork();

% create a test branch
initContribution('add-test-CI');

% create a user file
system('touch test-CI.txt;') %' git add test-CI.txt; git commit -m "Adding test-CI.txt from CI"; git push origin add-test-CI;')

submitContribution('add-test-CI')

% open a pull request
openPR('add-test-CI');

% delete the newly created branch
%deleteContribution('add-test-CI');

% test scenario
% create 3 files at the root
system('touch testFile1.txt;')
system('touch testFile2.txt;')
system('touch testFile3.txt;')

initContribution('branch-test-1');
submitContribution('branch-test-1');

initContribution('branch-test-2');
submitContribution('branch-test-2');


% list available features
listFeatures();

% reset the local fork
resetLocalFork();

% reset the development tools
resetDevTools();
