# The `git sparse-checkout` subcommand was introduced in 2.25.0

Describe 'Works on version 2.40.0'
  git() {
    echo "git version 2.40.0"
  }

  Include ./atlas

  It 'Works'
    When call check_git_version
    The status should be success
  End
End


Describe 'Works on version 2.25.0'
  git() {
    echo "git version 2.25.0"
  }

  Include ./atlas

  It 'No off-by-one error'
    When call check_git_version
    The status should be success
  End
End


Describe 'Require git version 2.25.0 at least'
  git() {
    echo "git version 2.20.1"
  }

  It 'Print error message'
    When run source ./atlas pull --silent test_dir:dir
    The output should equal 'Git version 2.20.1 is not supported. Please upgrade to 2.25.0 or higher.'
    The status should be failure
  End
End


Describe 'Fails at v1.x versions of git'
  git() {
    echo "git version 1.7"
  }

  It 'Print error message'
    When run source ./atlas pull --silent test_dir:dir
    The output should equal 'Git version 1.7 is not supported. Please upgrade to 2.25.0 or higher.'
    The status should be failure
  End
End


Describe 'Fails with no versions of git'
  git() {
    echo "git version "
  }

  It 'Print error message'
    When run source ./atlas pull --silent test_dir:dir
    The output should equal "Unable to determine git version. Please ensure git is installed and available on your PATH."
    The status should be failure
  End
End


Describe 'Fails at empty versions of git'
  git() {
    echo ""
  }

  It 'Print error message'
    When run source ./atlas pull --silent test_dir:dir
    The output should equal "Unable to determine git version. Please ensure git is installed and available on your PATH."
    The status should be failure
  End
End


Describe 'Fails at cryptic versions of git'
  git() {
    echo "something else"
  }

  It 'Print error message'
    When run source ./atlas pull --silent test_dir:dir
    The output should equal "Unable to determine git version. Please ensure git is installed and available on your PATH."
    The status should be failure
  End
End


Describe 'Fails at beta versions of git'
  git() {
    echo "git version beta-something"
  }

  It 'Print error message'
    When run source ./atlas pull --silent test_dir:dir
    The output should equal "Unable to determine git version. Please ensure git is installed and available on your PATH."
    The status should be failure
  End
End
