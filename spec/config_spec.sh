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
    The lines of output should equal 6
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: Not Specified'
    The line 3 of output should equal ' - repository: openedx/openedx-translations'
    The line 4 of output should equal ' - revision: main'
    The line 5 of output should equal ' - filter: Not Specified'
    The line 6 of output should equal ' - expand-glob: Not Specified'
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
    The lines of output should equal 6
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: example_directory'
    The line 3 of output should equal ' - repository: example_repository'
    The line 4 of output should equal ' - revision: example_branch'
    The line 5 of output should equal ' - filter: example_filter'
    The line 6 of output should equal ' - expand-glob: 1'
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
    The lines of output should equal 6
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: example_directory'
    The line 3 of output should equal ' - repository: example_repository'
    The line 4 of output should equal ' - revision: example_branch'
    The line 5 of output should equal ' - filter: example_filter'
    The line 6 of output should equal ' - expand-glob: 1'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End

Describe 'Test flags'
  Parameters
    # Long flags with the --revision
    "#1" "--repository custom_repository --revision my_revision --expand-glob --filter ar,es_419 positional_arg_directory:mapped_to_dir"
    # Long flags with the deprecated --branch flag
    "#2" "--repository custom_repository --branch my_revision --expand-glob --filter ar,es_419 positional_arg_directory:mapped_to_dir"
    # Short flags with the -n (revision) flag
    "#3" "-r custom_repository -n my_revision -g -f ar,es_419 positional_arg_directory:mapped_to_dir"
    # Short flags with the deprecated -b (branch) flag
    "#4" "-r custom_repository -b my_revision -g -f ar,es_419 positional_arg_directory:mapped_to_dir"
  End

  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    pull_translations() {
      PULL_TRANSLATIONS_CALLED=true
      %preserve PULL_TRANSLATIONS_CALLED
    }
  }

  It "correctly reads command line flag params test case $1"
    When run source ./atlas pull $2  # $2 is set by the Parameters block
    The lines of output should equal 6
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: positional_arg_directory:mapped_to_dir'
    The line 3 of output should equal ' - repository: custom_repository'
    The line 4 of output should equal ' - revision: my_revision'
    The line 5 of output should equal ' - filter: ar es_419'
    The line 6 of output should equal ' - expand-glob: 1'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End

Describe 'Test flags'
  Parameters
    # Long flags with the --revision
    "#1" "--repository custom_repository --revision my_revision --expand-glob --filter ar,es_419 positional_arg_directory:mapped_to_dir"
    # Long flags with the deprecated --branch flag
    "#2" "--repository custom_repository --branch my_revision --expand-glob --filter ar,es_419 positional_arg_directory:mapped_to_dir"
    # Short flags with the -n (revision) flag
    "#3" "-r custom_repository -n my_revision -g -f ar,es_419 positional_arg_directory:mapped_to_dir"
    # Short flags with the deprecated -b (branch) flag
    "#4" "-r custom_repository -b my_revision -g -f ar,es_419 positional_arg_directory:mapped_to_dir"
  End

  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    pull_translations() {
      PULL_TRANSLATIONS_CALLED=true
      %preserve PULL_TRANSLATIONS_CALLED
    }
  }

  It "correctly reads command line flag params test case $1"
    When run source ./atlas pull $2  # $2 is set by the Parameters block
    The lines of output should equal 6
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: positional_arg_directory:mapped_to_dir'
    The line 3 of output should equal ' - repository: custom_repository'
    The line 4 of output should equal ' - revision: my_revision'
    The line 5 of output should equal ' - filter: ar es_419'
    The line 6 of output should equal ' - expand-glob: 1'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End


Describe 'Test multiple directories and comma separated filters'
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
    The lines of output should equal 6
    The line 1 of output should equal 'Pulling translation files'
    The line 2 of output should equal ' - directory: orange_dir:foo_local_dir blue_dir:bazz_local_dir'
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End


  It 'correctly reads multiple directories and separate them in spaces'
    When run source ./atlas pull -r short_flag_repository -f ar,de_DE orange_dir:foo_local_dir
    The lines of output should equal 6
    The line 5 of output should equal ' - filter: ar de_DE'  # Convert comma separated into space-separated shell array
    The variable PULL_TRANSLATIONS_CALLED should equal true
  End
End
