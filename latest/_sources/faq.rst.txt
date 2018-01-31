.. _faq:

Frequently Asked Questions (FAQ)
================================

General questions
-----------------

How should I name my contribution?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Initiate a contribution per theme/topic/feature/bug fix that you work
on. Don’t mix features and think of an explicit name, i.e.
``bug-fix-function1`` or ``add-tests-function2``. Avoid generic names,
such as ``my-great-feature`` or ``fix`` or ``contribution-myName``.

How can I check the history of a file?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can check the history of a file by typing in MATLAB:

.. code:: matlab

    >> history('fileName.m')

How do I submit a Pull Request (PR)?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Once you submit your contribution (menu option [3]), you will be
presented with a link that leads you directly to the pull request (PR).

Print more detailed debugging information (verbose)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you encounter a problem, or suspect that something is not behaving
properly, please run:

.. code:: matlab

    >> contribute(1)

and follow the process as normally. This will set ``printLevel = 1``.
You can also set permanently ``gitConf.printLevel = 1;`` in
``assets/confDevTools.m``.


Technical questions
-------------------

I receive a ``Permission denied`` error. What can I do?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You may encounter the following error:

::

    Permission denied (publickey)
    fatal: could not read from the repository.

    Please make sure you have the correct access rights
    and the repository exists.

This error can have multiple reasons, but most likely, the SSH key is
not configured properly. Please follow the `configuration
instructions <https://github.com/opencobra/MATLAB.devTools/blob/master/PREREQUISITES.md>`__
carefully.

Another source of this error may be that you have set a passphrase when
generating the SSH key. Please leave the passphrase empty when
generating the SSH key.

Mismatch of the version of ``openSSL`` (Linux)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You might be in the situation that you receive the following error:

::

    OpenSSL version mismatch. Built against 1000207f, you have 100010bf

In that case, you should run the following command:

::

    sudo mv <MATLAB_INSTALLATION_PATH>/bin/glnxa64/libcrypto.so.1.0.0 <MATLAB_INSTALLATION_PATH>/bin/glnxa64/libcrypto.so.1.0.0_bk

where ``<MATLAB_INSTALLATION_PATH>`` corresponds to the installation of
``MATLAB``, e.g., ``/usr/local/MATLAB/R2016b``

Resolve unexpected behavior - reset
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you encounter unexpected behavior, please try to reset the
``MATLAB.devTools`` with:

.. code:: matlab

    >> resetDevTools

If you have files or changes that appear and would like to reset your
local fork (without re-cloning) again, type:

.. code:: matlab

    >> resetLocalFork

How can I abort a process?
^^^^^^^^^^^^^^^^^^^^^^^^^^

You can abort any process using ``CTRL-C`` (hit ``CTRL`` and ``C`` on
your keyboard).


