.. raw:: html

   <p align="center">
     <img class="readme_logo" src="docs/source/_static/img/logo_devTools.png" height="160px"/>
   </p>

   <h1 align="center">
     MATLAB.devTools - Contribute the smart way
   </h1>

+----------------+----------------+---------------+--------------+
| MATLAB R2016b  | MATLAB R2015b  | Code Coverage | Code Grade   |
+================+================+===============+==============+
| |Build Status| | |Build Status| | |codecov|     | |Code grade| |
+----------------+----------------+---------------+--------------+


Pre-requisites
--------------

.. begin-prerequisites-marker

Please follow the `configuration
instructions <https://github.com/opencobra/MATLAB.devTools/blob/master/docs/source/prerequisites.rst>`__
carefully. You may skip this if your system is already set up and you
have ``git`` configured.

**IMPORTANT**: Please make sure that you have configured your SSH key
in Github as explained
`here <https://github.com/opencobra/MATLAB.devTools/blob/master/docs/source/prerequisites.rst>`__.

.. end-prerequisites-marker

Installation
------------

.. begin-installation-marker

Download this repository (the folder ``./MATLAB.devTools/`` will be
created). You can clone the repository using:

.. code:: bash

    $ git clone git@github.com:opencobra/MATLAB.devTools.git MATLAB.devTools

Run this command in ``Terminal`` (on and ) or in ``Git Bash`` (on ) -
**not** in .

Some issues that can arise during installation are addressed in the
`FAQ <https://github.com/opencobra/MATLAB.devTools/blob/master/docs/source/faq.rst>`__.

.. end-installation-marker

Do you want to contribute to The COBRA Toolbox?
-----------------------------------------------

Please follow the `installation and contributing
instructions <https://github.com/opencobra/cobratoolbox/blob/master/README.rst>`__.

|asciicast|

How do I use the ``MATLAB.devTools``?
-------------------------------------

.. begin-getstarted-marker

Making a contribution to any ``git`` repository from is straightforward.
Type in within the ``MATLAB.devTools`` folder:

.. code:: matlab

    >> contribute

You will then be presented by a menu:

::

       [1] Start a new feature (branch).
       [2] Select an existing feature (branch) to work on.
       [3] Publish a feature (branch).
       [4] Delete a feature (branch).
       [5] Update the fork.

    -> Please select what you want to do (enter the number):

The original repository will be downloaded (cloned) the first time to a
folder named ``fork-gitRepoName``. **Only files in the
fork-gitRepoName folder** will be considered for contribution (any
changes made to a downloaded official ``git`` repository will be
ignored).

If you get stuck or are faced with an system error message, please read
the
`FAQ <https://github.com/opencobra/MATLAB.devTools/blob/master/docs/source/faq.rst>`__.

.. end-getstarted-marker

How can I update my fork without contributing?
----------------------------------------------

In order to only update your fork, run ``>> contribute`` and select menu
item ``[5]``.

Configure the ``MATLAB.devTools`` for another repository
--------------------------------------------------------

The ``MATLAB.devTools`` can only be used with **publicly accessible**
repositories.

If you want to use the ``MATLAB.devTools`` with a repository other than
the default repository, you must set the following variables:

.. code:: matlab

    launcher = '\n\n       ~~~ MATLAB.devTools ~~~\n\n'; % a message for the repository (any string)
    remoteRepoURL = 'https://server.com/repositoryName.git'; % the remote url
    nickName = 'repoNickName'; % a nickName of the repository (any string)
    printLevel = 0;  % set the printLevel mode

and run:

.. code:: matlab

    >> confDevTools(launcher, remoteRepoURL, nickName, printLevel);  % sets the configuration

In order to reset the configuration, type:

.. code:: matlab

    >> resetDevTools();

If you want your changes to be permanent, you can set the above
mentioned variables in ``./assets/confDevTools.m``.

.. |Build Status| image:: https://prince.lcsb.uni.lu/jenkins/buildStatus/icon?job=devTools-branches-auto/MATLAB_VER=R2016b
   :target: https://prince.lcsb.uni.lu/jenkins/job/devTools-branches-auto/MATLAB_VER=R2016b/
.. |Build Status| image:: https://prince.lcsb.uni.lu/jenkins/buildStatus/icon?job=devTools-branches-auto/MATLAB_VER=R2015b
   :target: https://prince.lcsb.uni.lu/jenkins/job/devTools-branches-auto/MATLAB_VER=R2015b/
.. |codecov| image:: https://codecov.io/gh/opencobra/MATLAB.devTools/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/opencobra/MATLAB.devTools/branch/master
.. |Code grade| image:: https://prince.lcsb.uni.lu/jenkins/userContent/codegrade-MATLABdevTools.svg?maxAge=0
.. |asciicast| image:: https://asciinema.org/a/7zg2ce5gfth7ruywptgc3i3yy.png
   :target: https://asciinema.org/a/7zg2ce5gfth7ruywptgc3i3yy
