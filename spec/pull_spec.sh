Describe 'Pull without directory param'
  Include ./atlas

  git() {
    echo "git $@"
  }

  cp() {
    echo "cp $@"
  }

  setup() { pull_repository="pull_repository" pull_branch="pull_branch"; }
  BeforeEach 'setup'

  It 'calls everything properly'
    When call pull_translations
    The lines of output should equal 4
    The line 1 of output should equal 'git init -b main'
    The line 2 of output should equal 'git remote add -f origin https://github.com/pull_repository.git'
    The line 3 of output should equal 'git pull origin pull_branch'
    The line 4 of output should equal 'cp -r translations_TEMP/* ./'
  End
End

Describe 'Pull with directory param'
  Include ./atlas

  git() {
    echo "git $@"
  }

  cp() {
    echo "cp $@"
  }


  setup() { pull_directory="pull_directory" pull_repository="pull_repository" pull_branch="pull_branch"; }
  BeforeEach 'setup'

  It 'calls everything properly'
    When call pull_translations
    The lines of output should equal 7
    The line 1 of output should equal 'git init -b main'
    The line 2 of output should equal 'git remote add -f origin https://github.com/pull_repository.git'
    The line 3 of output should equal 'git config core.sparseCheckout true'
    The line 4 of output should equal 'git sparse-checkout init'
    The line 5 of output should equal 'git sparse-checkout set pull_directory'
    The line 6 of output should equal 'git pull origin pull_branch'
    The line 7 of output should equal 'cp -r translations_TEMP/pull_directory/* ./'
  End
End
