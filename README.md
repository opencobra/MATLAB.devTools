<p align="center">
  <img src="assets/devTools_logo.png" height="160px"/>
</p>
<br>

|  MATLAB R2016b | MATLAB R2015b | Code Coverage | Code Grade |
|--------|--------|--------|--------|
| [![Build Status](https://prince.lcsb.uni.lu/jenkins/buildStatus/icon?job=devTools-branches-auto/MATLAB_VER=R2016b)](https://prince.lcsb.uni.lu/jenkins/job/devTools-branches-auto/MATLAB_VER=R2016b/) | [![Build Status](https://prince.lcsb.uni.lu/jenkins/buildStatus/icon?job=devTools-branches-auto/MATLAB_VER=R2015b)](https://prince.lcsb.uni.lu/jenkins/job/devTools-branches-auto/MATLAB_VER=R2015b/)| [![codecov](https://codecov.io/gh/opencobra/MATLAB.devTools/branch/master/graph/badge.svg)](https://codecov.io/gh/opencobra/MATLAB.devTools/branch/master) | ![Code grade](https://prince.lcsb.uni.lu/jenkins/userContent/codegrade-MATLABdevTools.svg?maxAge=0 "Ratio of the number of inefficient code lines and the total number of lines of code (in percent). A: 0-3%, B: 3-6%, C: 6-9%, D: 9-12%, E: 12-15%, F: > 15%.")

# MATLAB.devTools - Contribute the smart way

Making a contribution to any `git` repository from `MATLAB` is straightforward.

[![asciicast](https://asciinema.org/a/e4n0qtwmip3xfsyod97e7i16l.png)](https://asciinema.org/a/e4n0qtwmip3xfsyod97e7i16l)

## Pre-requisites

Please follow the [configuration instructions](PREREQUISITES.md) carefully. You may skip this if your system is already set up and you have `git` configured.

![#ff0000](https://placehold.it/15/ff0000/000000?text=+) **IMPORTANT**: Please make sure that you have configured your SSH key in Github as explained [here](https://github.com/laurentheirendt/devTools/blob/master/PREREQUISITES.md).

## How do I use `MATLAB.devTools`?

Type in `MATLAB` within the `devTools` folder:
```
>> contribute
```

You will then be presented by a menu:
```
   [1] Initialize a contribution.
   [2] Continue a contribution.
   [3] Submit/publish a contribution.
   [4] Delete a contribution.

-> Please select what you want to do (enter the number):
```

The original repository will be downloaded (cloned) the first time to a folder named `fork-gitRepoName`. **Only files in the `fork-gitRepoName` folder** will be considered for contribution (any changes made to a downloaded official `git` repository will be ignored).

![#ff0000](https://placehold.it/15/ff0000/000000?text=+) If you get stuck or are faced with an system error message, please read the [FAQ](FAQ.md).

## Contributing to The COBRA Toolbox

Follow the [installation instructions](https://github.com/opencobra/cobratoolbox/blob/master/README.md) of The COBRA Toolbox. If you don't want to get your hands dirty right away, start-off by reading the [Contributing Guide](https://github.com/opencobra/cobratoolbox/blob/master/.github/CONTRIBUTING.md).
