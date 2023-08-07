openedx-atlas
#############

An Open edX CLI tool for moving translation files from openedx-translations.

Overview
--------

OEP-58 proposes changes to the way the Open edX Organization organizes and maintains
translation files. Atlas is an Open edX CLI tool that uses git's sparse-checkout to
download directories with the repository openedx-translations. These directories
correspond to repositories within the GitHub openedx organization. They contain
translation files downloaded from Transifex that have been translated by the Open edX
Translations Working Group.

Atlas is intended for both development and deployment, and is meant to be used after
cloning a repository with translation files kept in openedx-translations. For instance,
when building a docker image or testing localization strings locally. It should not be
necessary to run any application in English.

Installing Locally
------------------

* Ensure ``git`` is installed and in your ``PATH``
* Download ``atlas`` from the `latest release <https://github.com/openedx/openedx-atlas/releases/latest/>`_, or from the `main branch <https://github.com/openedx/openedx-atlas/blob/main/atlas>`_:

.. code:: sh

    curl -L https://github.com/openedx/openedx-atlas/releases/latest/download/atlas -o atlas

* Allow execution ``chmod +x atlas``
* Either add ``atlas`` to your ``PATH``, or run using ``./atlas``

Usage
-----

Atlas is a CLI tool that has essentially one command: ``atlas pull``

Atlas defaults to using a configuration file named ``atlas.yml`` placed
in the root directory. Configuration file:

.. code:: yaml

    pull:
      branch: <branch-name>
      directory: <directory-name>
      repository: <organization-name>/<repository-name>

Atlas can also use a configuration file in a different path using the ``--config`` flag
after ``atlas``: ``atlas pull --config config.yml``.

Atlas can also be used without a configuration file by using the flags below after
``atlas pull``.

``-b`` or ``--branch``
``-r`` or ``--repository``
``-d`` or ``--directory``

Running Automated Tests Locally
-------------------------------

**Install**

* `ShellSpec <https://github.com/shellspec/shellspec#installation>`_
* `ShellCheck <https://github.com/koalaman/shellcheck#installing>`_
* `getoptions <https://github.com/ko1nksm/getoptions#installation>`_

**Run**

* ``make test``:  run all tests
* ``make performance_tests``:  run performance tests which pulls from GitHub.com/openedx
* ``make unit_tests``:  run fast unit tests without external dependency

Documentation
-------------

TODO

Releasing a New Version
-----------------------
This repository uses `semantic versioning <https://semver.org/>`_ with the aid of
`semantic release <https://github.com/semantic-release/semantic-release/>`_ to automate the process.

To release a new version, use the `conventional commits <https://open-edx-proposals.readthedocs.io/en/latest/oep-0051-bp-conventional-commits.html>`_ and the ``release.yml`` GitHub action will
automatically create a new release and upload the ``atlas`` executable.

Note: The ``atlas --version`` command only outputs the version if it's downloaded from a GitHub release. Otherwise, it
will output ``unreleased``.

License
-------

The code in this repository is licensed under the AGPL 3.0 unless otherwise noted.

Please see ``LICENSE`` for details.

How To Contribute
-----------------

Contributions are very welcome.

Please read
`How To Contribute <https://openedx.atlassian.net/wiki/spaces/COMM/pages/941457737/How+to+start+contributing+to+the+Open+edX+code+base>`_
for details.

Getting Help
------------

Have a question about this repository, or about Open edX in general? Please refer to this
`list of resources`_ if you need any assistance.

.. _list of resources: https://open.edx.org/getting-help
