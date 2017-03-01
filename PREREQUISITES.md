# Pre-requisites

## System configuration

You must have `git` and `curl` installed. In addition, please ensure that you have `MATLAB` [installed](https://nl.mathworks.com/help/install/).

**Linux (Ubuntu or Debian)**

```bash
$ sudo apt-get install git-all curl
```

**macOS**

In order to install `git`, install the [Xcode Command Line Tools](http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/). For `curl`, follow the instructions [here](http://macappstore.org/curl/).

**Windows**

Please download the `git` tools for Windows from [here](https://git-scm.com/download). During the installation process, please ensure that you select **Use Git from the Windows Command Prompt**. In addition, please make sure that you select **Checkout as-is, commit Unix-style line endings**.

<div align="center">
<img src="assets/installation_git_windows_0.png" height="280px">&nbsp;&nbsp;&nbsp;<img src="assets/installation_git_windows_1.png" height="280px">.
</div>

## Github and local `git` configuration

If you don't have a GitHub account, please sign up [here](https://github.com/join). For the very first time, you must **fork** the repository of The COBRA Toolbox. Browse to the [original repository](https://github.com/opencobra/cobratoolbox) and click on the button
<img src="https://upload.wikimedia.org/wikipedia/commons/3/38/GitHub_Fork_Button.png" height="20px">.

On **Linux (Ubuntu)** or **macOS**, start the terminal (or any other shell). On **Windows**, start `GUI Bash`. Then type
```bash
$ git config --global user.name "yourGitHubUsername"
$ git config --global user.email "first.last@server.com"
```
Please replace `"yourGitHubUsername"` and `"first.last@server.com"` with your respective credentials.

## Can I check if everything is properly set up before I start?

Please ensure that you have a working `MATLAB` installation.

You can check if you have a working installation of `git` by typing in the terminal (or GUI Bash):
```bash
$ git --version
```
This will return `git version 2.10.1 [...]` or similar with another version number.

You can then check if your `git` is properly configured by typing in the terminal (or GUI Bash):
```bash
$ git config --get user.name
```
which will return your Github username if everything is properly set up. Similarly, check the configured email by typing in the terminal (or GUI Bash):
```bash
$ git config --get user.email
```

You can check if you have a working installation of `curl` by typing in the terminal (or GUI Bash):
```bash
$ curl --version
```
which will return `curl 7.51.0 [...]` or similar with another version number.
