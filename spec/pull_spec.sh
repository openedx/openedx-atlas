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
    The lines of output should equal 16
    The line 1 of output should equal 'Creating a temporary Git repository to pull translations into "./translations_TEMP"...'
    The line 2 of output should equal 'git init -b main'
    The line 3 of output should equal 'git remote add -f origin https://github.com/pull_repository.git'
    The line 4 of output should equal 'Done.'
    The line 5 of output should equal 'Pulling translations into "./translations_TEMP/pull_directory"...'
    The line 6 of output should equal 'git sparse-checkout set !*'
    The line 7 of output should equal 'git sparse-checkout add pull_directory/'
    The line 8 of output should equal 'git pull origin pull_branch'
    The line 9 of output should equal 'Done.'
    The line 10 of output should equal 'Copying translations from "./translations_TEMP/pull_directory" to "./pull_directory"...'
    The line 11 of output should equal 'cp -r translations_TEMP/pull_directory/* ./'
    The line 12 of output should equal 'Done.'
    The line 13 of output should equal 'Removing temporary directory...'
    The line 14 of output should equal 'Done.'
    The line 15 of output should equal ''
    The line 16 of output should equal 'Translations pulled successfully!'
  End
End

Describe 'Pull filters'
  Include ./atlas

  git() {
    echo "git $@"
  }

  cp() {
    # Omit output
    true
  }


  setup() {
      pull_directory="pull_directory"
      pull_repository="pull_repository"
      pull_branch="pull_branch"
      pull_filter="ar es_419 fr_CA"
      VERBOSE=0
      SILENT=1
  }
  BeforeEach 'setup'

  It 'sets correct sparse-checkout rules'
    When call pull_translations
    The lines of output should equal 10
    The output should equal 'git init -b main
git remote add -f origin https://github.com/pull_repository.git
git sparse-checkout set !*
git sparse-checkout add pull_directory/**/ar/**
git sparse-checkout add pull_directory/**/ar.*
git sparse-checkout add pull_directory/**/es_419/**
git sparse-checkout add pull_directory/**/es_419.*
git sparse-checkout add pull_directory/**/fr_CA/**
git sparse-checkout add pull_directory/**/fr_CA.*
git pull origin pull_branch'
  End
End

Describe 'Pull with dry-run flag'
  Include ./atlas

  git() {
      echo "git $@"
  }

  cp() {
    echo "cp $@"
  }

  tree() {
    echo "tree"
  }


  setup() { pull_directory="pull_directory" pull_repository="pull_repository" pull_branch="pull_branch"; DRY_RUN=1; VERBOSE=1; }
  BeforeEach 'setup'

  It 'print file trees'
    When call pull_translations
    The lines of output should equal 27
    The output should eq "Creating a temporary Git repository to pull translations into \"./translations_TEMP\"...
git init -b main
git remote add -f origin https://github.com/pull_repository.git
Done.
Pulling translations into \"./translations_TEMP/pull_directory\"...
git sparse-checkout set !*
git sparse-checkout add pull_directory/
git pull origin pull_branch
Done.
Printing all 'git sparse-checkout' rules:
git sparse-checkout list
Done.
Listing the sparse-checkout file tree from the checked-out repository:
tree
Done.
Copying translations from \"./translations_TEMP/pull_directory\" to \"./pull_directory\"...
cp -r translations_TEMP/pull_directory/* translations_traget_TEMP/
Done.
Listing the copied files tree in the local file system:
tree
Done.
Removing temporary translations_traget_TEMP directory...
Done.
Removing temporary directory...
Done.

Translations pulled successfully in dry-run mode without copying!"
  End
End
