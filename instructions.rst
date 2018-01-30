Contribute a new tutorial or make change to an existing one
===========================================================

Fork and checkout your branch
-----------------------------

1. Fork the repository `https://www.github.com/opencobra/COBRA.tutorials`_ on Github
2. Clone the forked repository to a directory of your choice:
```bash
$ git clone git@github.com:<userName>/COBRA.tutorials.git fork-COBRA.tutorials.git
```
3. Change to the directory:
```bash
$ cd fork-COBRA.tutorials.git/
```
4. Set the upstream to the `opencobra/COBRA.tutorials` repository:
```bash
$ git remote add upstream git@github.com:opencobra/COBRA.tutorials.git
```
5. Fetch from the upstream repository
```bash
$ git fetch upstream
```
6. Checkout a new branch from `develop`:
```bash
$ git checkout -b <yourBranch> upstream/develop
```
7. Now, make your changes in the tutorial in MATLAB.

Submit your changes and open a pull request
-------------------------------------------
Once you are done making changes, add the files to your branch:
```bash
$ git add tutorial_<yourFile>.m
$ git add tutorial_<yourFile>.mlx
$ git commit -m "Changes to tutorial_<yourFile>"
```
where `tutorial_<yourFile>` is the name of the tutorial. Make sure to add the `.m` and the `.mlx` files.
8. Push your commits on `<yourBranch>` to your fork:
```bash
$ git push origin <yourBranch>
```
9. Browse to your fork on `https://www.github.com/<yourUserName>/COBRA.tutorials`_, where `<yourUserName>` is your Github username.
10. Click on `Compare & Pull Request`
11. Change the target branch `develop`
11. Submit your pull request
12. Wait until your pull request is accepted
