The COBRA Toolbox
^^^^^^^^^^^^^^^^^

|asciicast|

.. include:: ../../README.rst
   :start-after: begin-screencast-marker
   :end-before: end-screencast-marker

Introduction
------------

A comprehensive code base such as the COBRA Toolbox evolves constantly. The
open-source community is very active, and collaborators submit their
contributions frequently. The more a new feature or bug fix is interlinked with
existing functions, the higher the risk of a new addition breaking instantly
code that is heavily used on a daily basis. In order to decrease this risk, a
continuous integration setup interlinked with the version control system git
has been set up. A git-tracked repository is essentially a folder with code or
other documents of which all incremental changes are tracked by date and user.

Any incremental changes to the code are called commits. The main advantage of
git over other version control systems is the availability of branches. In
simple terms, a branch contains a sequence of incremental changes to the code.
A branch is also commonly referred to as a feature. Consequently, a
contribution generally consists of several commits on a branch.

Contributing to the COBRA Toolbox is straightforward. As a contributor to the
COBRA Toolbox is likely more familiar with MATLAB than with the internal
mechanics of git, the `MATLAB.devTools` have been developed specifically
to contribute to a git-tracked repository located on the Github server. In
Figure 6, an overview of the two online repositories as well as their local
copies is given.  There are two ways of using the COBRA Toolbox, which depends
on the type of user. A regular user might only want to use the opencobra
repository and enjoy stability (option A), whereas more advanced users might
want to develop their own features and actively make contributions to the
opencobra repository (option B).

|branchModel|

  - **Option A** The `opencobra/cobratoolbox <https://github.com/opencobra/cobratoolbox>`_ repository is a
    public repository that is read-only. Once the opencobra repository has been
    installed in the folder `cobratoolbox`, all branches
    (including ``master`` and ``develop``) are available locally. In the local directory
    `cobratoolbox` folder, the user has read and write access, but cannot push eventual
    changes back to the opencobra repository. It is the default and stable ``master``
    branch only that should be used. The local copy located in the cobratoolbox
    directory can be updated (both branches).

  - **Option B** In order to make changes to the
    opencobra repository, or, in other words, contribute, you must obtain your own
    personal copy first. You must register on the `Github website <https://github.com>`_ in order to obtain a username. First, click on the button FORK at the top
    right corner of the official `opencobra/cobratoolbox <https://github.com/opencobra/cobratoolbox>`_ repository website
    in order to create a personal copy
    (or fork) with write and read access of the opencobra repository. This copy is
    accessible under `https://github.com/<username>/cobratoolbox`, where `<username>` is
    your Github username. In the
    `fork-cobratoolbox` folder, other user specific branches may exist in addition to
    the ``master`` and ``develop`` branches.

After initialisation of the MATLAB.devTools, the user and developer may have two
folders: a ``cobratoolbox`` folder with the stable ``master`` branch checked out, and a
``fork-cobratoolbox`` folder with the ``develop`` branch checked out. Detailed
instructions for troubleshooting and/or contributing to the COBRA Toolbox using
the terminal (or shell) are provided :ref:`here <troubleshooting>`.

After the official opencobra version of the COBRA Toolbox has been installed,
it is possible to install the MATLAB.devTools from within MATLAB:

.. code:: console

    >> installDevTools

With this command, the directory MATLAB.devTools is created next to the
cobratoolbox installation directory. The MATLAB.devTools can also be installed
from the terminal (or shell):

.. code:: console

    $ git clone git@github.com:opencobra/MATLAB.devTools

|warning| A working internet connection is required and git and curl must be
installed. Installation instructions are provided on the main repository page
of the MATLAB.devTools. A valid passphrase-less SSH key must be set in the
Github account settings in order to contribute without entering a password
while securely communicating with the Github server.

Start a new contribution
------------------------

The MATLAB.devTools are configured on the fly or whenever the configuration
details are not present. The first time a user runs contribute, the personal
repository (fork) is downloaded (cloned) into a new folder named
`fork-cobratoolbox` at the location specified by the user. In this local folder,
both ``master`` and ``develop`` branches exist, but it is the ``develop`` branch that is
automatically selected (checked out). Any new contributions are derived from
the develop branch.  Initialising a contribution using the MATLAB.devTools is
straightforward. In MATLAB, type:

.. code:: matlab

    >> contribute % then select procedure [1]

If the MATLAB.devTools are already configured, procedure [1] updates the fork
(if necessary) and initialises a new branch with a name requested during the
process. Once the contribution is initialised, files can be added, modified or
deleted in the `fork-cobratoolbox` folder. A contribution is successfully
initialised when the user is presented with a brief summary of configuration
details. Instructions on how to proceed are also provided.

|warning| The location of the fork must be specified as the root directory.
There will be a warning issued if the path already contains another git-tracked
repository.

Continue an existing contribution
---------------------------------

An existing contribution can be continued after a while. This step is
particularly important in order to retrieve all changes that have been made to
the opencobra repository in the meantime.

.. code:: matlab

    >> contribute % then select procedure [2]

Procedure ``[2]`` pulls all changes from the opencobra repository, and rebases the
existing contribution. In other words, existing commits are shifted forward and
placed after all commits made on the develop branch of the opencobra
repository.

|warning| Before attempting to continue working on an existing
feature, make sure that you published your commits.

Publish a contribution
-----------------------

Publishing a contribution means uploading the incremental code changes to the
fork. The changes are available in public, but not yet available in the
opencobra repository. A contribution may only be accepted in the official
repository once a pull request has been submitted. It is not necessary to open
a pull request if you want to simply upload your contribution to your fork.

.. code:: matlab

    >> contribute % then select procedure [3]

When running procedure ``[3]``, you have two options:

- **Option A** Simple contribution without opening a pull request: All changes
  to the code are individually listed and the user is asked explicitly which
  changes shall be added to the commit. Once all changes have been added, a
  commit message must be entered. Upon confirmation, the changes are pushed to
  the online fork automatically.

- **Option B** Publishing and opening a pull request: The procedure for
  submitting a pull request is the same as option (A) with the difference that
  when selecting to open a pull request, a link is provided that leads to a
  pre-configured website according to the contributing guidelines. The pull
  request is then one click away.

|warning| After following procedures ``[1]`` and ``[2]``, all changes should be
published using procedure ``[3]`` before stopping to work on that contribution.
When following procedure ``[3]``, the incremental changes are uploaded to the
remote server. It is advised to publish often, and make small incremental
changes to the code. There is no need for opening a pull request immediately
(option **A**) if there are more changes to be made. A pull request may be opened
at any time, even manually directly from the Github website.

Deleting a contribution
-----------------------

If a contribution has been merged into the develop branch of the opencobra
repository (accepted pull request), the contribution (feature or branch) can be
safely deleted both locally and remotely on the fork by running contribute and
selecting procedure ``[4]``.

Note that deleting a contribution deletes all the changes that have been made
on that feature (branch). It is not possible to selectively delete a commit
using the MATLAB.devTools. Instead, create a new branch by following procedure
``[1]``, and follow the instructions to cherry-pick (see
:ref:`troubleshooting`).

|warning| Make sure that your changes are either merged or saved locally if you
need them. Once procedure ``[4]`` is concluded, all changes on the deleted
branch are removed, both locally and remotely. No commits can be recovered.

Update your fork
----------------

It is sometimes useful to simply update the fork without starting a new
contribution. The local fork can be updated using procedure ``[5]`` of the
contribute menu.

.. code:: matlab

    >> contribute % then select procedure [5]

Before updating your fork, make sure that no changes are present in the local
directory `fork-cobratoolbox`. You can do so by typing:

.. code:: matlab

    >> checkStatus

If there are changes listed, publish them by selecting procedure ``[3]`` of the
contribute menu.

.. |branchModel| image:: https://prince.lcsb.uni.lu/img/figure6.png

.. include:: ../../README.rst
   :start-after: begin-icon-marker
   :end-before: end-icon-marker

