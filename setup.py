#!/usr/bin/env python
"""
Package metadata for openedx-atlas.
"""

import os
import re
import sys

from setuptools import setup


def get_version(*file_paths):
    """
    Extract the version string from the file at the given relative path fragments.
    """
    filename = os.path.join(os.path.dirname(__file__), *file_paths)
    with open(filename, encoding="utf-8") as open_version_file:
        version_file = open_version_file.read()
    version_match = re.search(r"^__version__ = ['\"]([^'\"]*)['\"]", version_file, re.M)
    print(version_match.group())
    if version_match:
        return version_match.group(1)
    raise RuntimeError("Unable to find version string.")


def load_requirements(*requirements_paths):
    """
    Load all requirements from the specified requirements files.

    Returns:
        list: Requirements file relative path strings
    """
    requirements = set()
    for path in requirements_paths:
        with open(path, encoding="utf-8") as open_path:
            requirements.update(
                line.split("#")[0].strip()
                for line in open_path.readlines()
                if is_requirement(line.strip())
            )
    return list(requirements)


def is_requirement(line):
    """
    Return True if the requirement line is a package requirement.

    Returns:
        bool: True if the line is not blank, a comment, a URL, or an included file
    """
    return not (
        line == ""
        or line.startswith("-r")
        or line.startswith("#")
        or line.startswith("-e")
        or line.startswith("git+")
        or line.startswith("-c")
    )


VERSION = get_version("openedx_atlas", "__init__.py")

if sys.argv[-1] == "tag":
    print("Tagging the version on github:")
    os.system(f"git tag -a {VERSION} -m 'version {VERSION}'")
    os.system("git push --tags")
    sys.exit()
with open(
    os.path.join(os.path.dirname(__file__), "README.rst"), encoding="utf-8"
) as open_README:
    README = open_README.read()
with open(
    os.path.join(os.path.dirname(__file__), "CHANGELOG.rst"), encoding="utf-8"
) as open_CHANGELOG:
    CHANGELOG = open_CHANGELOG.read()

setup(
    name="openedx-atlas",
    version=VERSION,
    description="""An Open edX CLI tool for moving translation files from openedx-translations""",
    long_description=README + "\n\n" + CHANGELOG,
    long_description_content_type="text/x-rst",
    author="tCRIL",
    author_email="oscm@edx.org",
    url="https://github.com/openedx/openedx-atlas",
    packages=[
        "openedx_atlas",
    ],
    entry_points={
        "console_scripts": [
            "atlas = openedx_atlas.main:atlas",
        ],
    },
    include_package_data=True,
    install_requires=load_requirements("requirements/base.in"),
    license="AGPL 3.0",
    zip_safe=False,
    keywords="translations i18n openedx",
    classifiers=[
        "Development Status :: 0 - Experimental",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: Apache Software License",
        "Natural Language :: English",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
    ],
)
