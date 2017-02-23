# Pre-requisites

## System configuration

You must have `git` and `curl` installed. In addition, please ensure that you have `MATLAB` [installed](https://nl.mathworks.com/help/install/).

**Windows**

provide the Windows instructions here

**Linux (Ubuntu)**

```bash
$ sudo apt-get install git-all curl
```

**macOS**

In order to install `git`, install the [Xcode Command Line Tools](http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/). For `curl`, follow the instructions [here](http://macappstore.org/curl/).

## Github and local `git` configuration

If you don't have a GitHub account, please sign up [here](https://github.com/join). For the very first time, you must **fork** the repository of The COBRA Toolbox. Browse to the [original repository](https://github.com/opencobra/cobratoolbox) and click on the button
<img src="https://upload.wikimedia.org/wikipedia/commons/3/38/GitHub_Fork_Button.png" height="20px">.

On **Linux (Ubuntu)** or **macOS**, start the terminal (or any other shell). On **Windows**, start `GUI Bash`. Then type
```bash
$ git config --global user.name "Firstname Lastname"
$ git config --global user.email "first.last@server.com"
```

Please replace `"Firstname Lastname"` and `"first.last@server.com"` with your respective credentials.

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
