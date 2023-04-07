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
      find translations_TEMP/conf -type f | LC_ALL=C sort -n -k1,1 >&2 # Allow checking tree content.
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
    When run source $PREVIOUS_PWD/atlas pull -r openedx/edx-platform -b open-release/nutmeg.1 -f ar,fr conf/locale:messages
    Assert check_call_time "Pull edX Platform" $TEST_START_TIME 10  # Allow a maximum of 10 seconds

    The output should equal 'Pulling translation files
 - directory: conf/locale:messages
 - repository: openedx/edx-platform
 - branch: open-release/nutmeg.1
 - filter: ar fr
Creating a temporary Git repository to pull translations into "./translations_TEMP"...
Done.
Setting git sparse-checkout rules...
Done.
Pulling translation files from the repository...
Done.
Copying translations from "./translations_TEMP/conf/locale" to "./messages"...
/usr/bin/env cp -r ./translations_TEMP/conf/locale/ar ./translations_TEMP/conf/locale/fr messages/
Done.
Removing temporary directory...
Done.

Translations pulled successfully!'

    # Checks the results of `find`
    The error should equal "translations_TEMP/conf/locale/ar/LC_MESSAGES/django.mo
translations_TEMP/conf/locale/ar/LC_MESSAGES/django.po
translations_TEMP/conf/locale/ar/LC_MESSAGES/djangojs.mo
translations_TEMP/conf/locale/ar/LC_MESSAGES/djangojs.po
translations_TEMP/conf/locale/fr/LC_MESSAGES/django.mo
translations_TEMP/conf/locale/fr/LC_MESSAGES/django.po
translations_TEMP/conf/locale/fr/LC_MESSAGES/djangojs.mo
translations_TEMP/conf/locale/fr/LC_MESSAGES/djangojs.po"
  End
End
