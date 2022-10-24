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
from yaml import load

try:
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Loader


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
@click.option(
    "--language",
    "-l",
    required=False,
    multiple=True,
    help="A language of translation file",
)
@click.option("--branch", "-b", help="A branch of translation files")
@click.option("--repository", "-r", help="The repository containing translation files")
def pull(language, branch, repository):
    """
    Downloads translation files for languages from a repository branch.
    """
    click.echo(
        f"Pulling translation files from {repository}:{branch} for language(s): "
        f"{', '.join(language)}."
    )


if __name__ == "__main__":
    atlas()  # pylint: disable=no-value-for-parameter
