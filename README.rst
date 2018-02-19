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

.. begin-description-marker

All repositories on Github are version controlled using `git
<https://git-scm.com>`__, a free and open-source distributed, version control
system, which tracks changes in computer files and is used for coordinating
work on those files by multiple people.

In order to lower the technological barrier to the use of the popular software
development tool `git <https://git-scm.com>`__, we have developed
`MATLAB.devTools`, a new user-friendly software extension that enables
submission of new COBRA software and tutorials, in particular for `The COBRA
Toolbox <https://www.github.com/opencobra/cobratoolbox>`__ and the
`COBRA.tutorials <https://www.github.com/opencobra/COBRA.tutorials>`__.

The `MATLAB.devTools <https://github.com/opencobra/MATLAB.devTools>`__ are
highly recommended for contributing code (in particular `MATLAB` code) to
existing repositories in a user-friendly and convenient way, even for those
without basic knowledge of `git`.

.. end-description-marker


Pre-requisites
--------------

.. begin-prerequisites-marker

Please follow the `configuration
instructions <https://github.com/opencobra/MATLAB.devTools/blob/master/docs/source/prerequisites.rst>`__
carefully. You may skip this if your system is already set up and you
have ``git`` configured.

|important| **IMPORTANT**: Please make sure that you have configured your SSH key
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

|important| Run this command in ``Terminal`` (on |macOS| and |linux|) or in ``Git Bash`` (on |windows|) -
**not** in |matlab|.

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

Making a contribution to any ``git`` repository from |matlab| is straightforward.
Type in |matlab| within the ``MATLAB.devTools`` folder:

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

|important| If you get stuck or are faced with an system error message, please read
the `FAQ <https://opencobra.github.io/MATLAB.devTools/stable/faq.html>`__.

.. end-getstarted-marker

How can I update my fork without contributing?
----------------------------------------------

In order to only update your fork, run ``>> contribute`` and select menu
item ``[5]``.

Configure the ``MATLAB.devTools`` for another repository
--------------------------------------------------------

.. begin-contribute-other-repo-marker

|important| The ``MATLAB.devTools`` can only be used with **publicly accessible** repositories.

If you want to use the ``MATLAB.devTools`` when contributing to the
`COBRA.tutorials <https://github.com/opencobra/COBRA.tutorials>`__, you can simply configure
the ``MATLAB.devTools`` on-the-fly by typing:

.. code:: matlab

    >> contribute('opencobra/COBRA.tutorials')

If you want to use the ``MATLAB.devTools`` with a repository other than
the default repository, you may run:

.. code:: matlab

    >> contribute('userName/repositoryName')

Please note that this command looks for a repository on `github.com <https://www.github.com>`__.

In order to reset the configuration, type:

.. code:: matlab

    >> resetDevTools();

.. end-contribute-other-repo-marker


How to cite the ``MATLAB.devTools``
-----------------------------------

.. begin-how-to-cite-marker

As the  ``MATLAB.devTools`` have first been developed for the COBRA Toolbox, the
paper of The COBRA Toolbox shall we cited when referring to the ``MATLAB.devTools``.

    Laurent Heirendt & Sylvain Arreckx, Thomas Pfau, Sebastian N.
    Mendoza, Anne Richelle, Almut Heinken, Hulda S. Haraldsdottir, Jacek
    Wachowiak, Sarah M. Keating, Vanja Vlasov, Stefania Magnusdottir,
    Chiam Yu Ng, German Preciat, Alise Zagare, Siu H.J. Chan, Maike K.
    Aurich, Catherine M. Clancy, Jennifer Modamio, John T. Sauls,
    Alberto Noronha, Aarash Bordbar, Benjamin Cousins, Diana C. El
    Assal, Luis V. Valcarcel, Inigo Apaolaza, Susan Ghaderi, Masoud
    Ahookhosh, Marouen Ben Guebila, Andrejs Kostromins, Nicolas
    Sompairac, Hoai M. Le, Ding Ma, Yuekai Sun, Lin Wang, James T.
    Yurkovich, Miguel A.P. Oliveira, Phan T. Vuong, Lemmer P. El Assal,
    Inna Kuperstein, Andrei Zinovyev, H. Scott Hinton, William A.
    Bryant, Francisco J. Aragon Artacho, Francisco J. Planes, Egils
    Stalidzans, Alejandro Maass, Santosh Vempala, Michael Hucka, Michael
    A. Saunders, Costas D. Maranas, Nathan E. Lewis, Thomas Sauter,
    Bernhard Ø. Palsson, Ines Thiele, Ronan M.T. Fleming, **Creation and
    analysis of biochemical constraint-based models: the COBRA Toolbox
    v3.0** (submitted), 2017,
    `arXiv:1710.04038 <https://arxiv.org/abs/1710.04038>`__.

.. end-how-to-cite-marker


.. |Build Status| image:: https://prince.lcsb.uni.lu/jenkins/buildStatus/icon?job=devTools-branches-auto/MATLAB_VER=R2016b
   :target: https://prince.lcsb.uni.lu/jenkins/job/devTools-branches-auto/MATLAB_VER=R2016b/
.. |Build Status| image:: https://prince.lcsb.uni.lu/jenkins/buildStatus/icon?job=devTools-branches-auto/MATLAB_VER=R2015b
   :target: https://prince.lcsb.uni.lu/jenkins/job/devTools-branches-auto/MATLAB_VER=R2015b/
.. |codecov| image:: https://codecov.io/gh/opencobra/MATLAB.devTools/branch/master/graph/badge.svg
   :target: https://codecov.io/gh/opencobra/MATLAB.devTools/branch/master
.. |Code grade| image:: https://prince.lcsb.uni.lu/jenkins/userContent/codegrade-MATLABdevTools.svg?maxAge=0


.. begin-screencast-marker

.. |asciicast| image:: https://asciinema.org/a/7zg2ce5gfth7ruywptgc3i3yy.png
   :target: https://asciinema.org/a/7zg2ce5gfth7ruywptgc3i3yy

.. end-screencast-marker


.. begin-icon-marker
.. |macos| raw:: html

   <img src="https://prince.lcsb.uni.lu/jenkins/userContent/apple.png" height="20px" width="20px" alt="macOS">

.. |linux| raw:: html

   <img src="https://prince.lcsb.uni.lu/jenkins/userContent/linux.png" height="20px" width="20px" alt="linux">

.. |windows| raw:: html

   <img src="https://prince.lcsb.uni.lu/jenkins/userContent/windows.png" height="20px" width="20px" alt="windows">

.. |matlab| raw:: html

   <img src="https://prince.lcsb.uni.lu/jenkins/userContent/matlab.png" height="20px" width="20px" alt="matlab">

.. |important| raw:: html

   <img src="https://prince.lcsb.uni.lu/jenkins/userContent/warning.png" height="20px" width="20px" alt="bulb">

.. |warning| raw:: html

   <img src="https://prince.lcsb.uni.lu/jenkins/userContent/warning.png" height="20px" width="20px" alt="warning">

.. end-icon-marker
