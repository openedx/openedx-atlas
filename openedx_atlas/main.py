"""
This tool has one function:
pull stuff from openedx-translations based on a yaml configuration file
Should look like:
    atlas pull
It should also allow for all configuration parameters to be done from the CLI
Configuration:
    - language
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
    Atlas configuration
    """
    if os.path.exists(config):
        with open(config, "r", encoding="utf-8") as opened_config:
            config = load(opened_config.read(), Loader=Loader)
        ctx.default_map = config


@atlas.command()
@click.option("--branch", "-b", help="A branch of translation files")
@click.option(
    "--directory",
    "-d",
    required=False,
    help="Directory (name of the repository) containing translations to be downloaded",
)
@click.option(
    "--language",
    "-l",
    required=False,
    multiple=True,
    help="A language of translation file",
)
@click.option("--repository", "-r", help="The repository containing translation files")
def pull(branch, directory, language, repository):
    """
    Downloads translation files for languages from a repository branch.
    """
    click.echo(
        "Pulling translation files"
        f"\n - directory: {', '.join(directory)}"
        f"\n - language(s): {', '.join(language)}."
        f"\n - repository: {repository}:{branch}"
    )
    sparse_checkout(directory, repository, branch)


if __name__ == "__main__":
    atlas()  # pylint: disable=no-value-for-parameter
