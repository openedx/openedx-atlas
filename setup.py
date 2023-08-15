#!/usr/bin/env python

import os

from setuptools import setup

README = open(os.path.join(os.path.dirname(__file__), 'README.rst')).read()

setup(
    name='openedx-atlas',
    version='0.0.dev1',
    description='An Open edX CLI tool for moving translation files from openedx-translations.',
    long_description=README,
    author='Open edX project',
    author_email='oscm@axim.org',
    url='https://github.com/openedx/openedx-atlas',
    packages=['openedx_atlas'],
    scripts=['atlas'],
    license='AGPL 3.0',
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU Affero General Public License v3 or later (AGPLv3+)',
        'Natural Language :: English',
    ],
)
