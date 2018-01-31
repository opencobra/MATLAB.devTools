Pre-requisites
--------------

GitHub SSH configuration
^^^^^^^^^^^^^^^^^^^^^^^^

You have to register the SSH key of each computer that you are planning
to use the ``MATLAB.devTools`` on.

-  **Check if you already have an SSH key:**

.. code:: console

    $ ls -al ~/.ssh

If there is a file with an extension ``.pub``, you already have an SSH
key. Now, you have to **add your SSH key to Github**. More help is
`here <https://help.github.com/articles/checking-for-existing-ssh-keys/>`__.

-  **Generate the SSH key on your computer:** If you don’t have yet an
   SSH key (see previous step), you have to generate one (more help is
   `here <https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/>`__):

.. code:: console

    $ ssh-keygen -t rsa -C "first.last@server.com"

 Leave the passphrase empty when generating the SSH key.

-  **Add the SSH** to `your Github
   account <https://github.com/settings/keys>`__ by following the steps
   `here <https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/>`__.

Can I check if everything is properly set up before I start?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please ensure that you have a working ``MATLAB`` installation.

You can check if you have a working installation of ``git`` by typing in
the ``Terminal`` (on ``linux`` and ``macOS``) or ``cmd`` (in
``Windows``, not ``Git Bash``):

.. code:: bash

    $ git --version

If installed properly, this will return ``git version 2.13.1 [...]`` or
similar with another version number.

You can then check if your ``git`` is properly configured by typing in
the terminal (or GUI Bash):

.. code:: bash

    $ git config --get user.github-username

which will return your Github username if everything is properly set up.
Similarly, check the configured email by typing in the terminal (or GUI
Bash):

.. code:: bash

    $ git config --get user.email

You can check if you have a working installation of ``curl`` by typing
in the terminal (``cmd`` on Windows, not ``Git Bash``):

.. code:: bash

    $ curl --version

which will return ``curl 7.51.0 [...]`` or similar with another version
number if installed properly.

System configuration
^^^^^^^^^^^^^^^^^^^^

You must have ``git`` and ``curl`` installed. Please also ensure that
you have ``MATLAB``
`installed <https://nl.mathworks.com/help/install/>`__.

**Windows**

Please download the ``git`` tools for Windows from
`here <https://git-scm.com/download/win>`__. During the installation
process, please ensure that you select **Use Git Bash and optional Unix
tools from the Windows Command prompt**. In addition, please make sure
that you select **Checkout as-is, commit Unix-style line endings**.

|windows0| |windows1|

**Linux (Ubuntu or Debian)**

.. code:: bash

    $ sudo apt-get install git-all curl

**macOS**

In order to install ``git``, install the `Xcode Command Line
Tools <http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/>`__.
For ``curl``, follow the instructions
`here <http://macappstore.org/curl/>`__.

Github and local ``git`` configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you don’t have a GitHub account, please sign up
`here <https://github.com/join>`__. For the very first time, you must
**fork** the repository of The COBRA Toolbox. Browse to the `original
repository <https://github.com/opencobra/cobratoolbox>`__ and click on
the button .

On **Linux (Ubuntu)** or **macOS**, start the terminal (or any other
shell). On **Windows**, start ``GUI Bash``. Then type

.. code:: bash

    $ git config --global user.github-username "yourGitHubUsername"
    $ git config --global user.email "first.last@server.com"

Please replace ``"yourGitHubUsername"`` and ``"first.last@server.com"``
with your respective credentials.

.. |windows0| image:: https://prince.lcsb.uni.lu/img/installation_git_windows_0.png
   :width: 280px

.. |windows1| image:: https://prince.lcsb.uni.lu/img/installation_git_windows_1.png
   :width: 280px


