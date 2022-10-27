"""
Test configuration file loading and overrides
"""
from unittest.mock import patch

from click.testing import CliRunner

from openedx_atlas.main import atlas


# Mock sparse_checkout so it doesn't actually do any work
@patch("openedx_atlas.main.sparse_checkout")
def test_defaults(mock_sparse_checkout):
    """Tests the default options without a configuration file"""
    # This is a way to run Click commands inside Python
    runner = CliRunner()

    # Actually invoke "pull"
    result = runner.invoke(atlas, ["pull"])

    # Assert that atlas pull was called
    assert mock_sparse_checkout.called

    # Assert that no errors happened
    assert result.exit_code == 0

    # Check that it's outputting the default values without a yaml
    default_output = (
        "Pulling translation files"
        "\n - directory: Not Specified"
        "\n - repository: openedx/openedx-translations"
        "\n - branch: main"
    )
    assert default_output in result.output


@patch("openedx_atlas.main.sparse_checkout")
def test_config_file(mock_sparse_checkout):
    """Tests the options with a configuration file"""
    # This is a way to run Click commands inside Python
    runner = CliRunner()

    # invoke atlas with a configuration file
    result = runner.invoke(atlas, ["--config", "tests/test_config.yml", "pull"])

    # Assert that atlas pull was called
    assert mock_sparse_checkout.called

    # Assert that no errors happened
    assert result.exit_code == 0

    # Check that it's outputting the values we expect when yaml is overriding
    config_file_output = (
        "Pulling translation files"
        "\n - directory: example_directory"
        "\n - repository: example_repository"
        "\n - branch: example_branch"
    )
    assert config_file_output in result.output


@patch("openedx_atlas.main.sparse_checkout")
def test_full_flags(mock_sparse_checkout):
    """Tests the options with configuration full flags"""
    # This is a way to run Click commands inside Python
    runner = CliRunner()

    # invoke atlas with a configuration file
    result = runner.invoke(
        atlas,
        [
            "pull",
            "--directory",
            "full_flag_directory",
            "--repository",
            "full_flag_repository",
            "--branch",
            "full_flag_branch",
        ],
    )

    # Assert that atlas pull was called
    assert mock_sparse_checkout.called

    # Assert that no errors happened
    assert result.exit_code == 0

    # Check that it's outputting the values we expect when yaml is overriding
    full_flags_output = (
        "Pulling translation files"
        "\n - directory: full_flag_directory"
        "\n - repository: full_flag_repository"
        "\n - branch: full_flag_branch"
    )
    assert full_flags_output in result.output


@patch("openedx_atlas.main.sparse_checkout")
def test_short_flags(mock_sparse_checkout):
    """Tests the options with configuration short flags"""
    # This is a way to run Click commands inside Python
    runner = CliRunner()

    # invoke atlas with a configuration file
    result = runner.invoke(
        atlas,
        [
            "pull",
            "-d",
            "short_flag_directory",
            "-r",
            "short_flag_repository",
            "-b",
            "short_flag_branch",
        ],
    )

    # Assert that atlas pull was called
    assert mock_sparse_checkout.called

    # Assert that no errors happened
    assert result.exit_code == 0

    # Check that it's outputting the values we expect when yaml is overriding
    short_flags_output = (
        "Pulling translation files"
        "\n - directory: short_flag_directory"
        "\n - repository: short_flag_repository"
        "\n - branch: short_flag_branch"
    )
    assert short_flags_output in result.output
