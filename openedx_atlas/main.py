"""
Pull translation files from a repository:branch:directory.

Run atlas pull
It should also allow for all configuration parameters to be done from the CLI
Configuration:
    - branch
    - repository

"""
import os

import click
from yaml import Loader, load

from openedx_atlas.sparse_checkout import sparse_checkout


@click.group(
    context_settings={"auto_envvar_prefix": "ATLAS"}
)  # this allows for environment variables
@click.option(
    "--config", default="atlas.yml", type=click.Path()
)  # this allows us to change config path
@click.pass_context
def atlas(ctx, config):
    """
    Atlas configuration.
    """
    if os.path.exists(config):
        with open(config, "r", encoding="utf-8") as opened_config:
            config = load(opened_config.read(), Loader=Loader)
        ctx.default_map = config


@atlas.command()
@click.option("--branch", "-b", default="main", help="A branch of translation files")
@click.option(
    "--directory",
    "-d",
    required=False,
    help="Directory (name of the repository) containing translations to be downloaded",
)
@click.option(
    "--repository",
    "-r",
    default="openedx/openedx-translations",
    help="The repository containing translation files",
)
def pull(branch, directory, repository):
    """
    Download the translation files from a repository branch.
    """
    click.echo(
        "Pulling translation files"
        f"\n - directory: {directory if directory else 'Not Specified'}"
        f"\n - repository: {repository}"
        f"\n - branch: {branch}"
    )
    sparse_checkout(directory, repository, branch)
