# The COBRA Toolbox - Developer Tools

Making a contribution to The COBRA Toolbox is straightforward. Let me see this [**in action**](https://)!

![video](assets/video.gif)

## Pre-requisites

Please follow the system configuration instructions for the first time. You may skip this if your system is already set up and you have `git` configured.

## How can I contribute?

In order to start contributing, follow the [installation instructions](https://github.com/opencobra/cobratoolbox/) of The COBRA Toolbox. Type, after you have installed The COBRA Toolbox with all its submodules, in `MATLAB`:
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

The first time, the original repository will be downloaded (cloned), and you will be asked to specify a folder in which this copy will be downloaded to. The folder will be named `fork-cobratoolbox`.

Please note that **only files that are in the `fork-cobratoolbox` folder** will be considered for contribution. Any changes made to a downloaded official version of The COBRA Toolbox will be ignored by the system.

Once you submit your contribution (menu item 3), you will be presented with a link that leads you directly to the pull request (PR). You may then fill out the form and submit the PR.

**Note:** In order to speed up the review process, please initiate a contribution per theme/topic/feature/bug fix that you work on. Please don't mix features and think of an explicit name for your contribution, i.e. `bug-fix-solveCobraLP` or `add-tests-FBA`. Avoid generic names, such as `my-great-feature` or `fix` or `contribution-myName`.

## I need more guidance

If you don't want to get your hands dirty right away, start-off by reading the [Contributing Guide](https://).
