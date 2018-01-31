The COBRA Toolbox
^^^^^^^^^^^^^^^^^

|warning| This section is tailored to users who feel comfortable using
the terminal (or shell). It is recommended for other users
to follow `these instructions`__.

|warning| A Github account is required and `git` must be installed. You also
must already have forked the `opencobra/cobratoolbox
<https://www.github.com/opencobra/cobratoolbox>`__ repository by clicking on
the fork button on the main `opencobra/cobratoolbox
<https://www.github.com/opencobra/cobratoolbox>`__ repository page.

The repository of the COBRA Toolbox is version controlled with the open-source
standard `git` on the public code development site `github.com
<https://github.com>`__. Any incremental change to the code is wrapped in a
commit, tagged with a specific tag (called SHA1), a commit message, and author
information, such as the email address and the user name. Contributions to the
COBRA Toolbox are consequently commits that are made on branches.

The development scheme adopted in the repository of the COBRA Toolbox has two
branches: a `master` and a `develop` branch. The stable branch is the `master`
branch, while it is the `develop` branch that includes all new features and to
which new contributions are merged. Contributions are submitted for review and
testing through pull requests, the `git` standard. The `develop` branch is
regularly merged into the `master` branch once testing is concluded. 

The development scheme has been adopted for obvious reasons: the COBRA Toolbox
is heavily used on a daily basis, while the development community is active.
The key advantage of this setup is that developers can work on the next stable
release, while users can enjoy a stable version. Developers and users are
consequently working on the same code base without interfering. Understanding
the concept of branches is key to submitting hassle-free pull requests and
starting to contribute using `git`.

|warning|
 - The following commands should only be run from the terminal (or the shell).
 - An SSH key must be set in your Github account settings.

 In order to get started, clone the forked repository:

.. code:: console

    $ git clone git@github.com:<username>/cobratoolbox.git fork-cobratoolbox

This will create a folder called fork-cobratoolbox. Make sure to replace
`<username>` with your Github username. Any of the following commands are meant
to be run from within the folder of the fork called `fork-cobratoolbox`.

.. code:: console
    
    $ cd fork-cobratoolbox
