addpath(genpath('../'))


global gitConf
global gitCmd

% turn on the verbose mode
gitConf.verbose = true;

checkSystem();

initDevTools('https://github.com/cobrabot/trial_wo_errors.git')

%contribute(1)

%matlab -r "testDevTools" < testInput_1.txt

%system('rm -rf fork-trial_wo_errors');
