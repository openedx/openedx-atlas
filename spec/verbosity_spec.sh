Describe 'Test default verbosity'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    check_git_version() {
      true  # skip the git version check
    }

    git_sparse_checkout_set() {
      true  # skip the sparse-checkout rules
    }

    git() {
      if [ "$quiet" ];
      then
        GIT_CALLED_QUIETLY=true
      else
        GIT_CALLED_NOT_QUIETLY=true
      fi

      if [ "$VERBOSE" ];
      then
        GIT_CALLED_VERBOSELY=true
      else
        GIT_CALLED_NOT_VERBOSELY=true
      fi

      %preserve GIT_CALLED_QUIETLY
      %preserve GIT_CALLED_NOT_QUIETLY
      %preserve GIT_CALLED_VERBOSELY
      %preserve GIT_CALLED_NOT_VERBOSELY
    }

    directory_exists() {
      true  # Mock directory checks so they're copied and `CP_CALLED` is set to true.
    }

    cp() {
      CP_CALLED=true
      %preserve CP_CALLED
    }

    cd() {
      CD_CALLED=true
      %preserve CD_CALLED
    }

    rm() {
      RM_CALLED=true
      %preserve RM_CALLED
    }
  }

  It 'pulls translations with user friendly output'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    GIT_CALLED_VERBOSELY=false
    GIT_CALLED_NOT_VERBOSELY=false
    CP_CALLED=false
    CD_CALLED=false
    RM_CALLED=false
    When run source ./atlas pull dir_from:dir_to
    The lines of output should equal 18
    The line 18 of output should equal 'Translations pulled successfully!'
    The variable GIT_CALLED_QUIETLY should equal true
    The variable GIT_CALLED_NOT_QUIETLY should equal false
    The variable GIT_CALLED_VERBOSELY should equal false
    The variable GIT_CALLED_NOT_VERBOSELY should equal true
    The variable CP_CALLED should equal true
    The variable CD_CALLED should equal true
    The variable RM_CALLED should equal true
  End
End

Describe 'Test silent flag'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    check_git_version() {
      true  # skip the git version check
    }

    git_sparse_checkout_set() {
      true  # skip the sparse-checkout rules
    }

    git() {
      # Don't check `git sparse-checkout` for `--quiet` because it prints no output.
      if [ "$1" != "sparse-checkout" ];
      then
        if [ "$quiet" ];
        then
          GIT_CALLED_QUIETLY=true
        else
          GIT_CALLED_NOT_QUIETLY=true
        fi
        %preserve GIT_CALLED_QUIETLY
        %preserve GIT_CALLED_NOT_QUIETLY
      fi
    }

    directory_exists() {
      true  # Mock directory checks so they're copied and `CP_CALLED` is set to true.
    }

    cp() {
      CP_CALLED=true
      %preserve CP_CALLED
    }

    cd() {
      CD_CALLED=true
      %preserve CD_CALLED
    }

    rm() {
      RM_CALLED=true
      %preserve RM_CALLED
    }
  }

  It 'pulls translations with no output (full flag)'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    CP_CALLED=false
    CD_CALLED=false
    RM_CALLED=false
    When run source ./atlas pull --silent dir_from:dir_to
    The lines of output should equal 0
    The output should equal ""
    The variable GIT_CALLED_QUIETLY should equal true
    The variable GIT_CALLED_NOT_QUIETLY should equal false
    The variable CP_CALLED should equal true
    The variable CD_CALLED should equal true
    The variable RM_CALLED should equal true
  End

  It 'pulls translations with no output (short flag)'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    CP_CALLED=false
    CD_CALLED=false
    RM_CALLED=false
    When run source ./atlas pull -s dir_from:dir_to
    The lines of output should equal 0
    The output should equal ""
    The variable GIT_CALLED_QUIETLY should equal true
    The variable GIT_CALLED_NOT_QUIETLY should equal false
    The variable CP_CALLED should equal true
    The variable CD_CALLED should equal true
    The variable RM_CALLED should equal true
  End
End

Describe 'Test verbose flag'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    check_git_version() {
      true  # skip the git version check
    }

    git_sparse_checkout_set() {
      true  # skip the sparse-checkout rules
    }

    git() {
      if [ "$quiet" ];
      then
        GIT_CALLED_QUIETLY=true
      else
        GIT_CALLED_NOT_QUIETLY=true
      fi

      if [ "$VERBOSE" ];
      then
        GIT_CALLED_VERBOSELY=true
      else
        GIT_CALLED_NOT_VERBOSELY=true
      fi

      %preserve GIT_CALLED_QUIETLY
      %preserve GIT_CALLED_NOT_QUIETLY
      %preserve GIT_CALLED_VERBOSELY
      %preserve GIT_CALLED_NOT_VERBOSELY
    }

    directory_exists() {
      true  # Mock directory checks so they're copied and `CP_CALLED` is set to true.
    }

    cp() {
      CP_CALLED=true
      %preserve CP_CALLED
    }

    cd() {
      CD_CALLED=true
      %preserve CD_CALLED
    }

    rm() {
      RM_CALLED=true
      %preserve RM_CALLED
    }
  }

  It 'pulls translations with verbose output (full flag)'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    GIT_CALLED_VERBOSELY=false
    GIT_CALLED_NOT_VERBOSELY=false
    CP_CALLED=false
    CD_CALLED=false
    RM_CALLED=false
    When run source ./atlas pull --verbose dir_from:dir_to
    The lines of output should equal 19
    The line 19 of output should equal 'Translations pulled successfully!'
    The variable GIT_CALLED_QUIETLY should equal false
    The variable GIT_CALLED_NOT_QUIETLY should equal true
    The variable GIT_CALLED_VERBOSELY should equal true
    The variable GIT_CALLED_NOT_VERBOSELY should equal false
    The variable CP_CALLED should equal true
    The variable CD_CALLED should equal true
    The variable RM_CALLED should equal true
  End

  It 'pulls translations with verbose output (short flag)'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    GIT_CALLED_VERBOSELY=false
    GIT_CALLED_NOT_VERBOSELY=false
    CP_CALLED=false
    CD_CALLED=false
    RM_CALLED=false
    When run source ./atlas pull -v dir_from:dir_to
    The lines of output should equal 19
    The line 19 of output should equal 'Translations pulled successfully!'
    The variable GIT_CALLED_QUIETLY should equal false
    The variable GIT_CALLED_NOT_QUIETLY should equal true
    The variable GIT_CALLED_VERBOSELY should equal true
    The variable GIT_CALLED_NOT_VERBOSELY should equal false
    The variable CP_CALLED should equal true
    The variable CD_CALLED should equal true
    The variable RM_CALLED should equal true
  End
End
