# The COBRA Toolbox - Developer Tools

## How can I contribute?

Let me see this [**live**](https://)!

*video to be recorded*

In order to start contributing, follow the [installation instructions](https://) of The COBRA Toolbox. Making a contribution to The COBRA Toolbox is a very straightforward **3-step** process.

**STEP 1** You must first *fork* the repository of The COBRA Toolbox by clicking on

*insert image here*.

**STEP 2** Think of a name for your contribution, i.e. `name-of-my-contribution`. Type (after you have installed The COBRA Toolbox) in `MATLAB`:
```
initContribution('name-of-my-contribution')
```
The first time, this call will create a folder named `fork-cobratoolbox`. You can add new files, make changes to or remove existing files in this folder **only**.

**Please note that only files that are in the folder `fork-cobratoolbox` will be considered for contribution. Any changes made to the downloaded and installed official COBRA Toolbox will be ignored by the system**.

*Note: Don't worry about having the latest version of the official COBRA Toolbox. Simply run `initContribution('name-of-my-contribution')` again!*

**STEP 3**: Once you are done with your contribution, type:
```
submitContribution('name-of-my-contribution')
```

- You will be presented with a link that leads you directly to the pull request. Fill-out the form that is presented to you by following this link, and you can submit the PR.

- If you do not want to submit a pull request (PR), you can continue your contribution and rerun
`submitContribution` at a later date.

## I want to delete my contribution

If you want to delete your contribution, you can simply type in `MATLAB`:
```
deleteContribution('name-of-my-contribution')
```

## I need more guidance

If you don't want to get your hands dirty right away, start-off by reading the [Contributing Guide](https://).
