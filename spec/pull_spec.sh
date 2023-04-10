Describe 'Pull without directory mapping param'
  Include ./atlas

  git() {
    echo "git $@"
  }

  cp() {
    echo "cp $@"
  }

  setup() { pull_repository="pull_repository" pull_branch="pull_branch"; VERBOSE=1; }
  BeforeEach 'setup'

  It 'Fails and require a directory mapping positional parameter'
    When call pull_translations
    The status should be failure
    The error should equal 'Missing positional argument:
  At least one DIRECTORY map is required as a positional argument:
  $ atlas pull DIRECTORY_FROM1:DIRECTORY_TO1 DIRECTORY_FROM2:DIRECTORY_TO2 ...'

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


  setup() { pull_directory="pull_directory:local_dir" pull_repository="pull_repository" pull_branch="pull_branch"; VERBOSE=1; }
  BeforeEach 'setup'

  It 'calls everything properly'
    When call pull_translations
    The lines of output should equal 18
    The output should equal 'Creating a temporary Git repository to pull translations into "./translations_TEMP"...
git init -b main
git remote add -f origin https://github.com/pull_repository.git
Done.
Setting git sparse-checkout rules...
git sparse-checkout set !*
git sparse-checkout add pull_directory/**
Done.
Pulling translation files from the repository...
git pull origin pull_branch
Done.
Copying translations from "./translations_TEMP/pull_directory" to "./local_dir"...
cp -r ./translations_TEMP/pull_directory/* local_dir/
Done.
Removing temporary directory...
Done.

Translations pulled successfully!'
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
