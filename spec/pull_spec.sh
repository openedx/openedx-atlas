Describe 'Pull without directory param'
  Include ./atlas

  git() {
    echo "git $@"
  }

  cp() {
    echo "cp $@"
  }

  setup() { pull_repository="pull_repository" pull_branch="pull_branch"; VERBOSE=1; }
  BeforeEach 'setup'

  It 'calls everything properly'
    When call pull_translations
    The lines of output should equal 14
    The line 1 of output should equal 'Creating a temporary Git repository to pull translations into "./translations_TEMP"...'
    The line 2 of output should equal 'git init -b main'
    The line 3 of output should equal 'git remote add -f origin https://github.com/pull_repository.git'
    The line 4 of output should equal 'Done.'
    The line 5 of output should equal 'Pulling translations into "./translations_TEMP/"...'
    The line 6 of output should equal 'git pull origin pull_branch'
    The line 7 of output should equal 'Done.'
    The line 8 of output should equal 'Copying translations from "./translations_TEMP/" to "./"...'
    The line 9 of output should equal 'cp -r translations_TEMP/* ./'
    The line 10 of output should equal 'Done.'
    The line 11 of output should equal 'Removing temporary directory...'
    The line 12 of output should equal 'Done.'
    The line 13 of output should equal ''
    The line 14 of output should equal 'Translations pulled successfully!'
    
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


  setup() { pull_directory="pull_directory" pull_repository="pull_repository" pull_branch="pull_branch"; VERBOSE=1; }
  BeforeEach 'setup'

  It 'calls everything properly'
    When call pull_translations
    The lines of output should equal 17
    The line 1 of output should equal 'Creating a temporary Git repository to pull translations into "./translations_TEMP"...'
    The line 2 of output should equal 'git init -b main'
    The line 3 of output should equal 'git remote add -f origin https://github.com/pull_repository.git'
    The line 4 of output should equal 'Done.'
    The line 5 of output should equal 'Pulling translations into "./translations_TEMP/pull_directory"...'
    The line 6 of output should equal 'git config core.sparseCheckout true'
    The line 7 of output should equal 'git sparse-checkout init'
    The line 8 of output should equal 'git sparse-checkout set pull_directory'
    The line 9 of output should equal 'git pull origin pull_branch'
    The line 10 of output should equal 'Done.'
    The line 11 of output should equal 'Copying translations from "./translations_TEMP/pull_directory" to "./pull_directory"...'
    The line 12 of output should equal 'cp -r translations_TEMP/pull_directory/* ./'
    The line 13 of output should equal 'Done.'
    The line 14 of output should equal 'Removing temporary directory...'
    The line 15 of output should equal 'Done.'
    The line 16 of output should equal ''
    The line 17 of output should equal 'Translations pulled successfully!'
  End
End
