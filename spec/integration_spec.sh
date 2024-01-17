# Integration tests to run across multiple git versions.

check_call_time() {
  # Custom ShellSpec assert for call time.
  local test_name="$1"
  local test_start_time=$2
  local max_allowed_sec=$3
  local current_time=$(date +%s)
  local test_elapsed_time=$(($current_time-$test_start_time))

  if [ $test_elapsed_time -gt $max_allowed_sec ];
  then
    echo "'$test_name' test case took $test_elapsed_time seconds which exceeded the allowed max of $max_allowed_sec seconds" >&2
    exit 1
  fi
}


Describe 'Pull performance on edX Platform Arabic translations'
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    cp() {
      echo /usr/bin/env cp $@  # Run cp, but intercept with `find`

      # The output is sorted to ensure cross-platform consistent output
      find translations_TEMP/drag_and_drop_v2/conf -type f | LC_ALL=C sort -n -k1,1 >&2 # Allow checking tree content.
    }
  }

  setup() {
    TEST_START_TIME=$(date +%s)  # Time the bash script
    PREVIOUS_PWD="$PWD";
    cd "$(mktemp -d)" || exit 1  # Run in a temp. directory
  }
  tearDown() {
    cd "$PREVIOUS_PWD" || exit 1
  }
  BeforeEach 'setup'
  AfterEach 'tearDown'

  It 'calls everything properly'
    TEST_START_TIME=$(date +%s)  # Time the bash script
    When run source $PREVIOUS_PWD/atlas pull -r openedx/xblock-drag-and-drop-v2 -n v3.2.0 -f ar,fr drag_and_drop_v2:drag_and_drop_v2 non-existent-dir:no-files-here
    Assert check_call_time "Pull xblock-drag-and-drop-v2" $TEST_START_TIME 60  # Allow a maximum of 60 seconds

    The output should equal 'Pulling translation files
 - directory: drag_and_drop_v2:drag_and_drop_v2 non-existent-dir:no-files-here
 - repository: openedx/xblock-drag-and-drop-v2
 - revision: v3.2.0
 - filter: ar fr
 - expand-glob: Not Specified
Creating a temporary Git repository to pull translations into "./translations_TEMP"...
Done.
Setting git sparse-checkout rules...
Done.
Pulling translation files from the repository...
Done.
Copying translations from "./translations_TEMP/drag_and_drop_v2" to "./drag_and_drop_v2"...
/usr/bin/env cp -r ./translations_TEMP/drag_and_drop_v2/conf ./translations_TEMP/drag_and_drop_v2/public drag_and_drop_v2/
Done.
Copying translations from "./translations_TEMP/non-existent-dir" to "./no-files-here"...
Skipped copying "./translations_TEMP/non-existent-dir" because it was not found in the repository.
Done.
Removing temporary directory...
Done.

Translations pulled successfully!'

    # Checks the results of `find`
    The error should equal "translations_TEMP/drag_and_drop_v2/conf/locale/ar/LC_MESSAGES/text.mo
translations_TEMP/drag_and_drop_v2/conf/locale/ar/LC_MESSAGES/text.po
translations_TEMP/drag_and_drop_v2/conf/locale/fr/LC_MESSAGES/text.mo
translations_TEMP/drag_and_drop_v2/conf/locale/fr/LC_MESSAGES/text.po"
  End
End



Describe 'Bash glob patterns'
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    cp() {
      echo /usr/bin/env cp $@  # Run cp, but intercept with `find`

      # The output is sorted to ensure cross-platform consistent output
      find translations_TEMP/drag_and_drop_v2/conf -type f | LC_ALL=C sort -n -k1,1 >&2 # Allow checking tree content.
    }
  }

  setup() {
    TEST_START_TIME=$(date +%s)  # Time the bash script
    PREVIOUS_PWD="$PWD";
    cd "$(mktemp -d)" || exit 1  # Run in a temp. directory
  }
  tearDown() {
    cd "$PREVIOUS_PWD" || exit 1``
  }
  BeforeEach 'setup'
  AfterEach 'tearDown'

  It 'pulls with glob patterns'
    TEST_START_TIME=$(date +%s)  # Time the bash script
    When run source $PREVIOUS_PWD/atlas pull -r openedx/xblock-drag-and-drop-v2 -n v3.2.0 --expand-glob -f ar 'drag_and_drop_v2/*/locale:drag_and_drop_v2'
    Assert check_call_time "Pull xblock-drag-and-drop-v2" $TEST_START_TIME 60  # Allow a maximum of 60 seconds

    The output should equal 'Pulling translation files
 - directory: drag_and_drop_v2/*/locale:drag_and_drop_v2
 - repository: openedx/xblock-drag-and-drop-v2
 - revision: v3.2.0
 - filter: ar
 - expand-glob: 1
Creating a temporary Git repository to pull translations into "./translations_TEMP"...
Done.
Setting git sparse-checkout rules...
Done.
Pulling translation files from the repository...
Done.
Copying translations from "./translations_TEMP/drag_and_drop_v2/conf/locale" to "./drag_and_drop_v2"...
/usr/bin/env cp -r ./translations_TEMP/drag_and_drop_v2/conf/locale/ar drag_and_drop_v2/
Done.
Removing temporary directory...
Done.

Translations pulled successfully!'

    # Checks the results of `find`
    The error should equal "translations_TEMP/drag_and_drop_v2/conf/locale/ar/LC_MESSAGES/text.mo
translations_TEMP/drag_and_drop_v2/conf/locale/ar/LC_MESSAGES/text.po"
  End


  It 'will not expand glob pattern unless specified'
    When run source $PREVIOUS_PWD/atlas pull -r openedx/xblock-drag-and-drop-v2 -b v3.2.0 -f ar 'drag_and_drop_v2/*/locale:drag_and_drop_v2'

    The output should include 'Skipped copying "./translations_TEMP/drag_and_drop_v2/*/locale" because it was not found in the repository.'
  End
End
