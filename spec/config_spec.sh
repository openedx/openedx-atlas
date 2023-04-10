Describe 'Test Invalid Config'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    pull_translations() {
      PULL_TRANSLATIONS_CALLED=true
      %preserve PULL_TRANSLATIONS_CALLED
    }
  }

  It 'recognizes the config file does not exist'
    When run source ./atlas pull --config config-that-does-not-exist.yml
    The lines of output should equal 1
    The line 1 of output should equal 'config-that-does-not-exist.yml does not exist.'
    The variable PULL_TRANSLATIONS_CALLED should not equal true
  End
End

Describe 'Test Default Config'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    pull_translations() {
      PULL_TRANSLATIONS_CALLED=true
      %preserve PULL_TRANSLATIONS_CALLED
    }
  }

  It 'sets the default values correctly when no config param is passed and atlas.yml does not exist'
    When run source ./atlas pull
    The lines of output should equal 5
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: Not Specified'
    The line 3 of output should equal ' - repository: openedx/openedx-translations'
    The line 4 of output should equal ' - branch: main'
    The line 5 of output should equal ' - filter: Not Specified'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End

Describe 'Test example atlas.yml'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    pull_translations() {
      PULL_TRANSLATIONS_CALLED=true
      %preserve PULL_TRANSLATIONS_CALLED
    }
  }

  setup() { cp example.atlas.yml atlas.yml; }
  cleanup() { rm atlas.yml; }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  It 'reads atlas.yml correctly when no config param is passed'
    When run source ./atlas pull
    The lines of output should equal 5
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: example_directory'
    The line 3 of output should equal ' - repository: example_repository'
    The line 4 of output should equal ' - branch: example_branch'
    The line 5 of output should equal ' - filter: example_filter'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End

Describe 'Test example.atlas.yml'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    pull_translations() {
      PULL_TRANSLATIONS_CALLED=true
      %preserve PULL_TRANSLATIONS_CALLED
    }
  }

  It 'reads example.atlas.yml correctly when passed as config param'
    When run source ./atlas pull --config example.atlas.yml
    The lines of output should equal 5
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: example_directory'
    The line 3 of output should equal ' - repository: example_repository'
    The line 4 of output should equal ' - branch: example_branch'
    The line 5 of output should equal ' - filter: example_filter'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End

Describe 'Test full flags'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    pull_translations() {
      PULL_TRANSLATIONS_CALLED=true
      %preserve PULL_TRANSLATIONS_CALLED
    }
  }

  It 'correctly reads full flag params'
    When run source ./atlas pull --repository full_flag_repository --branch full_flag_branch --filter ar,es_419 positional_arg_directory:to_dir
    The lines of output should equal 5
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: positional_arg_directory:to_dir'
    The line 3 of output should equal ' - repository: full_flag_repository'
    The line 4 of output should equal ' - branch: full_flag_branch'
    The line 5 of output should equal ' - filter: ar es_419'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End

Describe 'Test short flags'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    pull_translations() {
      PULL_TRANSLATIONS_CALLED=true
      %preserve PULL_TRANSLATIONS_CALLED
    }
  }

  It 'correctly reads short flag params'
    When run source ./atlas pull -r short_flag_repository -b short_flag_branch -f 'ar es_419' positional_arg_directory:mapped_to_dir
    The lines of output should equal 5
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: positional_arg_directory:mapped_to_dir'
    The line 3 of output should equal ' - repository: short_flag_repository'
    The line 4 of output should equal ' - branch: short_flag_branch'
    The line 5 of output should equal ' - filter: ar es_419'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End


Describe 'Test short flags'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    pull_translations() {
      PULL_TRANSLATIONS_CALLED=true
      %preserve PULL_TRANSLATIONS_CALLED
    }
  }

  It 'correctly reads multiple directories and separate them in spaces'
    When run source ./atlas pull -r short_flag_repository  \
                            orange_dir:foo_local_dir \
                            blue_dir:bazz_local_dir
    The lines of output should equal 5
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: orange_dir:foo_local_dir blue_dir:bazz_local_dir'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End
