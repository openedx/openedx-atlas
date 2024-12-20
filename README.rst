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

Installation
------------

Atlas itself is a bash script. It is recommended to install it as a package
to avoid unintentionally installing breaking changes,
while also simplifying the updating process.

Atlas prerequisites are ``git>=2.20.1`` and ``bash``.

**Install as a ``pip`` package**

Install from `PyPI <https://pypi.org/project/openedx-atlas/>`_

.. code:: sh

    pip install openedx-atlas  # or add the package to your requirements.txt

Verify that it is installed via ``atlas --help``.


**Install as an ``npm`` package**

Install from `npm <https://www.npmjs.com/package/@edx/openedx-atlas>`_.

.. code:: sh

    npm install @edx/openedx-atlas

Then add ``node_modules/.bin`` to your ``PATH``.

Verify that it is installed via ``atlas --help``.


**Install manually from GitHub releases**

This is considered a last resort because of the manual burden of updating
the ``atlas`` executable version or risking introducing breaking
changes to your code.

* Download ``atlas`` from the `latest release <https://github.com/openedx/openedx-atlas/releases/latest/>`_ or from the `main branch <https://github.com/openedx/openedx-atlas/blob/main/atlas>`_:

.. code:: sh

    curl -L https://github.com/openedx/openedx-atlas/releases/latest/download/atlas -o atlas

* Allow execution with ``chmod +x atlas``
* Either add ``atlas`` to your ``PATH`` or run it using ``./atlas``

Usage
-----

The help message below is copied from both ``atlas --help``. It's updated
regularly and useful to understand ``atlas`` at a glance.

.. code::

    Atlas is a CLI tool that has essentially one command: `atlas pull`

    Configuration file:

        Atlas defaults to using a configuration file named `atlas.yml` placed
        in the root directory. Configuration file:

        pull:
          repository: <organization-name>/<repository-name>
          revision: <git-revision>
          directory: <repo-directory-name>:<local-dir-name> ...
          filter: <pattern> ...
          expand_glob: 0

        Atlas can also use a configuration file in a different path using the `--config` flag
        after `atlas`: `atlas pull --config config.yml`.

        Atlas can also be used without a configuration file by using the flags below after
        `atlas pull`.

    Positional arguments DIRECTORY MAPPINGS ...

       One or more directory map pair separated by a colon (:) e.g. FROM_DIR:TO_DIR.

       The first directory (FROM_DIR) represents a directory in the git repository.
       The second directory (TO_DIR) represents a local directory to copy files to.

       At least one directory pair is required:

         $ atlas pull frontend-app-learning/messages:learning-app frontend-lib-test/messages:test-lib

       This syntax is inspired by the `docker --volume from_dir:to_dir` mounting syntax.

    Options:

        `-r` or `--repository`:
            slug of the GitHub repository to pull from. Defaults 'openedx/openedx-translations'.

        `-n` or `--revision`:
            Git revision to pull from. Support branches, tags, and commits hashes. Defaults to 'main'.

            This option name used to be `-b` or `--branch`. The deprecated name will be removed in a future release.

        `-f` or `--filter`:
           A comma-separated (or space-separated) list of patterns match files and sub-directories.
           This is mainly useful to filter specific languages to download.

           The same filter is applied to all DIRECTORY MAPPINGS arguments.

           `--filter=fr_CA,ar,es_419` will match both directories named 'es_419' and
           files named 'es_419.json' among others

       `-g` or `--expand-glob`:
           Expand glob pattern e.g. 'atlas pull translations/*/done' to 'atlas pull translations/DoneXBlock/done'
           if it exists.

    Example:

        $ cd frontend-app-learning/src/i18n/messages
        $ atlas pull --filter=fr_CA,ar,es_419 \
                translations/frontend-app-learning/src/i18n/messages:frontend-app-learning \
                translations/frontend-component-header/src/i18n/messages:frontend-component-header

        Will result in the following tree:

          ├── frontend-app-learning
          │   ├── ar.json
          │   ├── es_419.json
          │   └── fr_CA.json
          └── frontend-component-header
              ├── ar.json
              ├── es_419.json
              └── fr_CA.json



    Commands:
      pull      pull
      -h, --help
          --version


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

Usage Examples
--------------

There's a couple of patterns that are useful to imitate when using Atlas
depending on the use case. ``atlas pull`` is most commonly implemented in
``Makefile``, however it can be also used in ``Dockerfile`` builds or any
other automation tool.

Python Applications
*******************

TBD


Micro-frontends
***************

TBD


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
