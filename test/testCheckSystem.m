global gitConf
global gitCmd

% define the configuration of the MATLAB.devTools
launcher = '\n\n       ~~~ MATLAB.devTools ~~~\n\n';
remoteRepoURL = 'https://github.com/LCSB-Biocore/MATLAB.devTools.CI.git';
nickName = 'MATLAB.devTools.CI';
printLevel = 1;

% reset the development tools
resetDevTools();

% set the configuration
confDevTools(nickName, 'remoteRepoURL', remoteRepoURL, 'launcher', launcher, ...
             'nickName', nickName, 'printLevel', printLevel);

% check the system
checkSystem();

% initialize the devTools
initDevTools(); % <-- input 1: cobrabot, input 2: ~/

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

% test scenario
% create 3 files at the root
system('touch testFile1.txt;')
system('touch testFile2.txt;')

initContribution('branch-test-1');
submitContribution('branch-test-1'); % <-- input 4: y, input 5: n, input 6: testFile1, input 7: y

initContribution('branch-test-2');
submitContribution('branch-test-2'); % < -- input 8: y, input 9: testFile2, input 10: n

% delete the branches
system('git branch -D branch-test-1');
system('git branch -D branch-test-2');
system('git push origin --delete branch-test-1');
system('git push origin --delete branch-test-2');

% create a test branch
initContribution('add-test-CI');

% create a user file
system('touch test-CI.txt;'); %' git add test-CI.txt; git commit -m "Adding test-CI.txt from CI"; git push origin add-test-CI;')

submitContribution('add-test-CI'); % <-- input 3: n

% open a pull request
openPR('add-test-CI');

delete('test-CI.txt');

% list available branches
listBranches();

% check the status of the repository
checkStatus();

% reset the local fork
resetLocalFork();

% reset the development tools
resetDevTools();
