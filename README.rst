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

Usage
-----

Atlas is a CLI tool that has essentially one command: `atlas pull`

Atlas defaults to using a configuration file named `atlas.yaml` placed
in the root directory. Configuration file:

pull:
  branch: <branch-name>
  directory: <directory-name>
  repository: <organization-name>/<repository-name>

Atlas can also use a configuration file in a different path using the `--config` flag
after `atlas`: `atlas --config pull`.

Atlas can also be used without a configuration file by using the flags below after
`atlas pull`.

`-b` or `--branch`
`-r` or `--repository`
`-d` or `--directory`

Documentation
-------------

TODO

License
-------

The code in this repository is licensed under the AGPL 3.0 unless otherwise noted.

Please see ``LICENSE`` for details.

How To Contribute
-----------------

Contributions are very welcome.

Please read
`How To Contribute <https://github.com/openedx/edx-platform/blob/master/CONTRIBUTING.rst>`_
for details.

Even though they were written with ``edx-platform`` in mind, the guidelines should be
followed for Open edX code in general.

PR description template should be automatically applied if you are sending PR from github
interface; otherwise you can find it it at
`PULL_REQUEST_TEMPLATE.md <https://github.com/openedx/code-annotations/blob/master/.github/PULL_REQUEST_TEMPLATE.md>`_

Issue report template should be automatically applied if you are sending it from github UI
as well; otherwise you can find it at
`ISSUE_TEMPLATE.md <https://github.com/openedx/code-annotations/blob/master/.github/ISSUE_TEMPLATE.md>`_

Getting Help
------------

Have a question about this repository, or about Open edX in general? Please refer to this
`list of resources`_ if you need any assistance.

.. _list of resources: https://open.edx.org/getting-help
