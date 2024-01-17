Describe 'Pull without directory mapping param'
  Include ./atlas

  check_git_version() {
    true  # skip the git version check
  }

  git_sparse_checkout_set() {
    xargs echo "git sparse-checkout set"
  }

  git() {
    echo "git $@"
  }

  cp() {
    echo "cp $@"
  }

  setup() { pull_repository="pull_repository" pull_revision="pull_revision"; VERBOSE=1; }
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

  check_git_version() {
    true  # skip the git version check
  }

  git_sparse_checkout_set() {
    xargs echo "git sparse-checkout set"
  }

  git() {
    echo "git $@"
  }

  directory_exists() {
    if [ "$1" = "./translations_TEMP/missing_pull_dir" ];
    then
      return 1 # Mock as if `missing_pull_dir` is not checkedout.
    else
      return 0 # Mock other directories to exists.
    fi
  }

  cp() {
    echo "cp $@"
  }

  cd() {
      echo "cd $@"
  }

  rm() {
      echo "rm $@"
  }

  mkdir() {
    echo "mkdir $@"
  }

  cd() {
    echo "cd $@"
  }


  setup() {
      pull_directory="pull_directory:local_dir pull_dir2:new/local_dir2 missing_pull_dir:local_dir3"
      pull_repository="pull_repository"
      pull_revision="pull_revision";
      VERBOSE=1;
  }
  BeforeEach 'setup'

  It 'calls everything properly with multiple directories'
    When call pull_translations
    The output should equal 'Creating a temporary Git repository to pull translations into "./translations_TEMP"...
git clone --branch=pull_revision --filter=blob:none --no-checkout --depth=1 https://github.com/pull_repository.git translations_TEMP
cd translations_TEMP
Done.
Setting git sparse-checkout rules...
git sparse-checkout set --no-cone !* pull_directory/** pull_dir2/** missing_pull_dir/**
Done.
Pulling translation files from the repository...
git checkout HEAD
rm -rf .git
cd ..
mkdir -p local_dir
Done.
Copying translations from "./translations_TEMP/pull_directory" to "./local_dir"...
cp -r ./translations_TEMP/pull_directory/* local_dir/
mkdir -p new/local_dir2
Done.
Copying translations from "./translations_TEMP/pull_dir2" to "./new/local_dir2"...
cp -r ./translations_TEMP/pull_dir2/* new/local_dir2/
mkdir -p local_dir3
Done.
Copying translations from "./translations_TEMP/missing_pull_dir" to "./local_dir3"...
Skipped copying "./translations_TEMP/missing_pull_dir" because it was not found in the repository.
Done.
Removing temporary directory...
rm -rf translations_TEMP
Done.

Translations pulled successfully!'
  End
End

Describe 'Pull filters'
  Include ./atlas

  check_git_version() {
    true  # skip the git version check
  }

  git_sparse_checkout_set() {
    xargs echo "git sparse-checkout set"
  }

  git() {
    echo "git $@"
  }

  cp() {
    # Omit output
    true
  }

  cd() {
      echo "cd $@"
  }

  rm() {
    true # Omit output
  }

  setup() {
      pull_directory="pull_directory"
      pull_repository="pull_repository"
      pull_revision="pull_revision"
      pull_filter="ar es_419 fr_CA"
      VERBOSE=0
      SILENT=1
  }
  BeforeEach 'setup'

  It 'sets correct sparse-checkout rules'
    When call pull_translations
    The output should equal 'git clone --branch=pull_revision --filter=blob:none --no-checkout --depth=1 https://github.com/pull_repository.git translations_TEMP
cd translations_TEMP
git sparse-checkout set --no-cone !* pull_directory/**/ar/** pull_directory/**/ar.* pull_directory/**/es_419/** pull_directory/**/es_419.* pull_directory/**/fr_CA/** pull_directory/**/fr_CA.*
git checkout HEAD
cd ..'
  End
End
