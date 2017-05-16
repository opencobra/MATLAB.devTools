<p align="center">
  <img src="assets/devTools_logo.png" height="160px"/>
</p>
<br>

|  MATLAB R2016b | MATLAB R2015b | Code Coverage | Code Grade |
|--------|--------|--------|--------|
| [![Build Status](https://prince.lcsb.uni.lu/jenkins/buildStatus/icon?job=devTools-branches-auto/MATLAB_VER=R2016b)](https://prince.lcsb.uni.lu/jenkins/job/devTools-branches-auto/MATLAB_VER=R2016b/) | [![Build Status](https://prince.lcsb.uni.lu/jenkins/buildStatus/icon?job=devTools-branches-auto/MATLAB_VER=R2015b)](https://prince.lcsb.uni.lu/jenkins/job/devTools-branches-auto/MATLAB_VER=R2015b/)| [![codecov](https://codecov.io/gh/opencobra/MATLAB.devTools/branch/master/graph/badge.svg)](https://codecov.io/gh/opencobra/MATLAB.devTools/branch/master) | ![Code grade](https://prince.lcsb.uni.lu/jenkins/userContent/codegrade-MATLABdevTools.svg?maxAge=0 "Ratio of the number of inefficient code lines and the total number of lines of code (in percent). A: 0-3%, B: 3-6%, C: 6-9%, D: 9-12%, E: 12-15%, F: > 15%.")

# MATLAB.devTools - Contribute the smart way

# Pre-requisites

Please follow the [configuration instructions](https://github.com/opencobra/MATLAB.devTools/blob/master/PREREQUISITES.md) carefully. You may skip this if your system is already set up and you have `git` configured.

<img src="https://prince.lcsb.uni.lu/jenkins/userContent/warning.png" height="20px" alt="warning"> **IMPORTANT**: Please make sure that you have configured your SSH key in Github as explained [here](https://github.com/opencobra/MATLAB.devTools/blob/master/PREREQUISITES.md).

# Installation

Download this repository (the folder `./MATLAB.devTools/` will be created). You can clone the repository using:
 ````bash
$ git clone git@github.com:opencobra/MATLAB.devTools.git MATLAB.devTools
````
<img src="https://prince.lcsb.uni.lu/jenkins/userContent/warning.png" height="20px" alt="warning"> Run this command in `Terminal` (on <img src="https://prince.lcsb.uni.lu/jenkins/userContent/apple.png" height="20px" alt="macOS"> and <img src="https://prince.lcsb.uni.lu/jenkins/userContent/linux.png" height="20px" alt="Linux">) or in `Git Bash` (on <img src="https://prince.lcsb.uni.lu/jenkins/userContent/windows.png" height="20px" alt="Windows">) - **not** in <img src="https://prince.lcsb.uni.lu/jenkins/userContent/matlab.png" height="20px" alt="Matlab">.


## Do you want to contribute to The COBRA Toolbox?

Please follow the [installation and contributing instructions](https://github.com/opencobra/cobratoolbox/blob/master/README.md).

[![asciicast](https://asciinema.org/a/7zg2ce5gfth7ruywptgc3i3yy.png)](https://asciinema.org/a/7zg2ce5gfth7ruywptgc3i3yy)

## How do I use the  `MATLAB.devTools`?

Making a contribution to any `git` repository from <img src="https://prince.lcsb.uni.lu/jenkins/userContent/matlab.png" height="20px" alt="Matlab"> is straightforward. Type in <img src="https://prince.lcsb.uni.lu/jenkins/userContent/matlab.png" height="20px" alt="Matlab"> within the `MATLAB.devTools` folder:
```
>> contribute
```

You will then be presented by a menu:
```
   [1] Start a new feature (branch).
   [2] Select an existing feature (branch) to work on.
   [3] Publish a feature (branch).
   [4] Delete a feature (branch).
   [5] Update the fork.

-> Please select what you want to do (enter the number):
```

The original repository will be downloaded (cloned) the first time to a folder named `fork-gitRepoName`. **Only files in the `fork-gitRepoName` folder** will be considered for contribution (any changes made to a downloaded official `git` repository will be ignored).

<img src="https://prince.lcsb.uni.lu/jenkins/userContent/warning.png" height="20px" alt="warning"> If you get stuck or are faced with an system error message, please read the [FAQ](https://github.com/opencobra/MATLAB.devTools/blob/master/FAQ.md).

## How can I update my fork without contributing?

In order to only update your fork, run `>> contribute` and select menu item `[5]` in order to update the fork.

## Configure the `MATLAB.devTools` for another repository

<img src="https://prince.lcsb.uni.lu/jenkins/userContent/warning.png" height="20px" alt="warning"> The `MATLAB.devTools` can only be used with publicly accessible repositories.

If you want to use the `MATLAB.devTools` with a repository other than the default repository, you must set the following variables:

```Matlab
  launcher = '\n\n       ~~~ MATLAB.devTools ~~~\n\n'; % a message for the repository (any string)
  remoteRepoURL = 'https://server.com/repositoryName.git'; % the remote url
  nickName = 'repoNickName'; % a nickName of the repository (any string)
  verbose = false;  % turn the verbose mode on (true) or off (false)
```
and run:
```Matlab
% set the configuration
confDevTools(launcher, remoteRepoURL, nickName, verbose);
```

If you want to reset the configuration, you can type:
```Matlab
>> resetDevTools();
```
If you want your changes to permanent, you can set the above mentioned variables in `./assets/confDevTools.m`.
