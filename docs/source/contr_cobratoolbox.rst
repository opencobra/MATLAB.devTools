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

    $ git clone git@github.com:openCOBRA/MATLAB.devTools

.. |branchModel| image:: https://prince.lcsb.uni.lu/img/figure6.png

