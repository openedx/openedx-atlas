Describe 'Test the --version flag'
  It 'Prints the version'
    When run source ./atlas --version
    The output should equal 'unreleased'
  End
End
