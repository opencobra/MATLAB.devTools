% do not change the paths below
addpath(genpath('/var/lib/jenkins/MOcov'));
addpath(genpath('/var/lib/jenkins/jsonlab'));

% include the root folder and all subfolders

pwd

addpath(genpath(pwd))


global gitConf
global gitCmd

% turn on the verbose mode
gitConf.verbose = true;

%checkSystem();


exit_code = 0;
