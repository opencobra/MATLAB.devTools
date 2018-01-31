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

.. |branchModel| image:: https://prince.lcsb.uni.lu/img/figure6.png

