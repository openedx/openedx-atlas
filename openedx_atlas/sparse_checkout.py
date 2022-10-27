"""
Performs sparse-checkout of subdirectories for a given <repository>:<branch>.

Contains one function: sparse_checkout.
"""
import os
import tempfile
from shutil import copytree, ignore_patterns
from subprocess import call


def sparse_checkout(directory, repository, branch, output_path=os.getcwd()):
    """
    Run a git sparse-checkout for a given repository, branch, and directory.
    """
    # Make a temporary directory
    with tempfile.TemporaryDirectory() as tmp_dir_name:
        # set temporary directory as current directory
        os.chdir(tmp_dir_name)
        # initialize directory as git repo
        call("git init", shell=True)
        # Add remote url
        remote_url = f"https://github.com/{repository}.git"
        call(f"git remote add -f origin {remote_url}", shell=True)
        if directory:
            # configure sparseCheckout as true
            call("git config core.sparseCheckout true", shell=True)
            # initialize sparse-checkout
            call("git sparse-checkout init", shell=True)
            # set the subdirectories for sparse-checkout
            call(f"git sparse-checkout set {directory}", shell=True)
        # perform git pull - either sparse or full depending on
        call(f"git pull origin {branch}", shell=True)
        # move the directory to the output_path
        copytree(
            f"{tmp_dir_name}/{directory if directory else ''}",
            output_path,
            dirs_exist_ok=True,
            ignore=ignore_patterns(".git"),
        )
