"""
Test sparse_checkout functionality
"""
from unittest.mock import patch

from openedx_atlas.sparse_checkout import sparse_checkout


@patch("openedx_atlas.sparse_checkout.call")
@patch("openedx_atlas.sparse_checkout.copytree")
def test_without_directory_parameter(mock_copytree, mock_call):
    """Tests sparse_checkout without setting the directory parameter"""

    directory = ""
    repository = "openedx/openedx-translations"
    branch = "main"
    output_path = "test_directory"

    sparse_checkout(directory, repository, branch, output_path)

    # call() is used 3 times if a directory is not set
    assert mock_call.call_count == 3
    # copytree is called once at the end
    assert mock_copytree.called_once()


@patch("openedx_atlas.sparse_checkout.call")
@patch("openedx_atlas.sparse_checkout.copytree")
def test_with_directory_parameter(mock_copytree, mock_call):
    """Tests sparse_checkout without setting the directory parameter"""

    directory = "directory_set"
    repository = "openedx/openedx-translations"
    branch = "main"
    output_path = "test_directory"

    sparse_checkout(directory, repository, branch, output_path)

    # call() is used 6 times if a directory is set
    assert mock_call.call_count == 6
    # copytree is called once at the end
    assert mock_copytree.called_once()
