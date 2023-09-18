Support Glob Patterns in ``atlas pull``
#######################################

Description
***********
Glob pattern support has been added to ``atlas``.

Example
*******

``atlas pull --expand-glob translations/*/done`` pulls
``atlas pull translations/DoneXBlock/done`` if it exists.

This is useful for instance to pull XBlocks in which the directory name
isn't known but the module name is.

This is an alternative to the `edx-platform-links`_ strategy because
``git sparse-checkout --no-cone`` don't support glob patterns across links.


Dismissed alternatives
**********************

1. Support links again:
-----------------------

Previous tests on unknown git version showed to support links in April 2023,
but it had no automated tests and broke somewhere during the
`git v2.25.1 version support`_ we've added.

The sparse-checkout part is already complex, so we'll not touch it.

2. Make complete copies of the translations in `edx-platform-links`_
---------------------------------------------------------------------

The `edx-platform-links`_ directory is comprised of symbolic
links to the XBlock and plugins directories. This option would be to
replace the symbolic links with full copies of the XBlock and plugins
translations in a way that ``edx-platform-links/done`` is effectively
recreated with ``cp -r translations/DoneXBlock/done edx-platform-links/done``
every time there's a update to the translations.

Consequently, the `edx-platform-links`_ directory would be renamed to
``edx-platform-modules`` because it no longer contains links.

This is the a viable and simple alternative to glob patterns, but _may_
complicate the GitHub Transifex App sync process.

3. Use the `edx-platform-links`_ to store the original files
------------------------------------------------------------

In this option, instead of storing symbolic links in the
`edx-platform-links`_ directory, we would store the original files and
setup Transifex to sync XBlocks and plugins to this directory.

Consequently, the `edx-platform-links`_ directory would be renamed to
``edx-platform-modules`` because it no longer contains links.

This would remove the symbolic links altogether resulting in
two translation root directories:

- ``translations/``: contains the original files for all micro-frontends and
  microservices by their GitHub repository name.
- ``translations/edx-platform-modules/``: contains the translations for
  the edx-platform plugins and XBlocks by their Python module name.

This is a viable option as well, but needs to refactor the Transifex
configuration which could reset the translations.

.. _edx-platform-links: https://github.com/openedx/openedx-translations/blob/8a01424fd8f42e9e76aed34e235c82ab654cdfc5/translations/edx-platform-links/README.rst
.. _git v2.25.1 version support: https://github.com/openedx/openedx-atlas/pull/23
