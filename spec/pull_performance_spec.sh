check_call_time() {
  # Custom ShellSpec assert for call time.
  local test_name="$1"
  local test_start_time=$2
  local max_allowed_sec=$3
  local current_time=$(date +%s)
  local test_elapsed_time=$(($current_time-$test_start_time))

  if [ "$test_elapsed_time" -gt "$max_allowed_sec" ];
  then
    echo "'$test_name' test case took $test_elapsed_time seconds which exceeded the allowed max of $max_allowed_sec seconds" >&2
    exit 1
  fi
}

check_bandwidth_usage() {
  # Custom ShellSpec assert for bandwidth usage.
  local test_name="$1"
  local bytes_before=$2
  local bytes_after=$3
  local max_allowed_bytes=$4
  local test_total_bytes=$((bytes_after - bytes_before))

  if [ "$test_total_bytes" -gt "$max_allowed_bytes" ];
  then
    echo "'$test_name' test case used $test_total_bytes bytes of bandwidth which exceeded the allowed max of $max_allowed_bytes bytes" >&2
    echo "WARNING: This could be a flaky test, because it measures the system's global bandwidth during the "atlas pull" run" >&2
    echo "         If this fails unexpectidely, please turn off any download or running sites so it succeeds" >&2
    exit 1
  fi
}

check_disk_usage() {
  # Custom ShellSpec assert for git disk usage.
  local test_name="$1"
  local test_total_bytes=$2
  local max_allowed_bytes=$3

  if [ "$test_total_bytes" -gt "$max_allowed_bytes" ];
  then
    echo "'$test_name' test case used $test_total_bytes bytes of disk space which exceeded the allowed max of $max_allowed_bytes bytes" >&2
    exit 1
  fi
}

get_bandwidth_usage() {
  # Function to get total network stats (RX + TX)
  if [ "$(uname)" = "Linux" ];
  then
    # Get the network interface used to reach 8.8.8.8
    local IFACE=$(ip route get 8.8.8.8 | awk '{print $5}')

    ip -s link show dev "$IFACE" | awk '
      /RX:/ { getline; rx=$1 }
      /TX:/ { getline; tx=$1 }
      END { print rx + tx }
    ';
  else
    # Bandwidth calculations is linux-specific and not supported on Mac OS
    echo 0
  fi
}


Describe 'Pull performance on edX Platform Arabic translations'
  Parameters
    "#1 pull by git tag" open-release/nutmeg.1
    "#2 pull by git sha commit for nutmeg.2" 1d618055dc5a44b94a1da63ef4017a2015aad018
  End

  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    cp() {
      echo /usr/bin/env cp $@  # Run cp, but intercept with `find`

      # The output is sorted to ensure cross-platform consistent output
      find translations_TEMP/conf -type f | LC_ALL=C sort -n -k1,1 >&2 # Allow checking tree content.
    }

    git_disk_usage() {
      # Intercept to capture disk usage for testing purposes
      DISK_USAGE=$(du -s . | grep -o '[0-9]*');

      %preserve DISK_USAGE
      echo "$DISK_USAGE"
    }
  }

  setup() {
    TEST_START_TIME=$(date +%s)  # Time the bash script
    PREVIOUS_PWD="$PWD";
    TEMP_DIRECTORY="$(mktemp -d)" || exit # Run in a temp. directory
    cd "$TEMP_DIRECTORY" || exit 1
  }
  tearDown() {
    cd "$PREVIOUS_PWD" || exit 1
  }
  BeforeEach 'setup'
  AfterEach 'tearDown'

  Example "'$1' performs well"
    TEST_START_TIME=$(date +%s)  # Time the bash script
    BANDWIDTH_USE_BEFORE=$(get_bandwidth_usage)
    When run source $PREVIOUS_PWD/atlas pull -r openedx/edx-platform -n $2 -f ar,fr conf/locale:messages non-existent-dir:no-files-here
    BANDWIDTH_USE_AFTER=$(get_bandwidth_usage)

    The output should equal "Pulling translation files
 - directory: conf/locale:messages non-existent-dir:no-files-here
 - repository: openedx/edx-platform
 - revision: $2
 - filter: ar fr
 - expand-glob: Not Specified
Creating a temporary Git repository to pull translations into \"./translations_TEMP\"...
Done.
Setting git sparse-checkout rules...
Done.
Pulling translation files from the repository...
Done.
Copying translations from \"./translations_TEMP/conf/locale\" to \"./messages\"...
/usr/bin/env cp -r ./translations_TEMP/conf/locale/ar ./translations_TEMP/conf/locale/fr messages/
Done.
Copying translations from \"./translations_TEMP/non-existent-dir\" to \"./no-files-here\"...
Skipped copying \"./translations_TEMP/non-existent-dir\" because it was not found in the repository.
Done.
Removing temporary directory...
Done.

Translations pulled successfully!"

    # Checks the results of `find`
    The error should equal "translations_TEMP/conf/locale/ar/LC_MESSAGES/django.mo
translations_TEMP/conf/locale/ar/LC_MESSAGES/django.po
translations_TEMP/conf/locale/ar/LC_MESSAGES/djangojs.mo
translations_TEMP/conf/locale/ar/LC_MESSAGES/djangojs.po
translations_TEMP/conf/locale/fr/LC_MESSAGES/django.mo
translations_TEMP/conf/locale/fr/LC_MESSAGES/django.po
translations_TEMP/conf/locale/fr/LC_MESSAGES/djangojs.mo
translations_TEMP/conf/locale/fr/LC_MESSAGES/djangojs.po"

    # It downloads fast
    #
    # Download speed of 10 seconds is the maximum allowed for this test to ensure it doesn't 
    # take a minute or more. An ineffiecnt implementation will actually stuck of
    # about 15 minutes due to the size of the edx-platform repository. 
    # Actual run time differs based on the connection, but it's usually less than 5 seconds.
    Assert check_call_time "Pull edX Platform" $TEST_START_TIME 10  # 10 seconds

    # It uses moderate amout of disk space for the git-fetch
    #
    # Disk usage should be very low and could vary depending on how the system 
    # calculates it but it's less than 10 kilobytes since the git tag is frozen
    Assert check_disk_usage "Pull edX Platform" $DISK_USAGE 8500  # 8.5 Kilobytes


    # It uses little as less bandwidth as possible during git-fetch
    #
    # Note: Bandwidth calculations is linux-specific and not supported on Mac OS
    # When measured locally, it takes less than 2.5 megabytes
    # An inefficient git-fetch would take about a Gigabyte because of the size of the edx-platform repository.
    # Assert check_bandwidth_usage "Pull edX Platform" $BANDWIDTH_USE_BEFORE $BANDWIDTH_USE_AFTER 6000000  # 6 Megabytes
  End
End
