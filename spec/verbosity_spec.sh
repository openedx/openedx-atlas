Describe 'Test default verbosity'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
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

    cp() {
      CP_CALLED=true
      %preserve CP_CALLED
    }
  }

  It 'pulls translations with user friendly output'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    GIT_CALLED_VERBOSELY=false
    GIT_CALLED_NOT_VERBOSELY=false
    CP_CALLED=false
    When run source ./atlas pull
    The lines of output should equal 14
    The line 14 of output should equal 'Translations pulled successfully!'
    The variable GIT_CALLED_QUIETLY should equal true
    The variable GIT_CALLED_NOT_QUIETLY should equal false
    The variable GIT_CALLED_VERBOSELY should equal false
    The variable GIT_CALLED_NOT_VERBOSELY should equal true
    The variable CP_CALLED should equal true
  End
End

Describe 'Test silent flag'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
    git() {
      if [ "$quiet" ];
      then
        GIT_CALLED_QUIETLY=true
      else
        GIT_CALLED_NOT_QUIETLY=true
      fi
      %preserve GIT_CALLED_QUIETLY
      %preserve GIT_CALLED_NOT_QUIETLY
    }

    cp() {
      CP_CALLED=true
      %preserve CP_CALLED
    }
  }

  It 'pulls translations with no output (full flag)'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    CP_CALLED=false
    When run source ./atlas pull --silent
    The lines of output should equal 0
    The variable GIT_CALLED_QUIETLY should equal true
    The variable GIT_CALLED_NOT_QUIETLY should equal false
    The variable CP_CALLED should equal true
  End

  It 'pulls translations with no output (short flag)'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    CP_CALLED=false
    When run source ./atlas pull -s
    The lines of output should equal 0
    The variable GIT_CALLED_QUIETLY should equal true
    The variable GIT_CALLED_NOT_QUIETLY should equal false
    The variable CP_CALLED should equal true
  End
End

Describe 'Test verbose flag'
  # mock pull translations
  Intercept begin_pull_translations_mock
  __begin_pull_translations_mock__() {
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

    cp() {
      CP_CALLED=true
      %preserve CP_CALLED
    }
  }

  It 'pulls translations with verbose output (full flag)'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    GIT_CALLED_VERBOSELY=false
    GIT_CALLED_NOT_VERBOSELY=false
    CP_CALLED=false
    When run source ./atlas pull --verbose
    The lines of output should equal 14
    The line 14 of output should equal 'Translations pulled successfully!'
    The variable GIT_CALLED_QUIETLY should equal false
    The variable GIT_CALLED_NOT_QUIETLY should equal true
    The variable GIT_CALLED_VERBOSELY should equal true
    The variable GIT_CALLED_NOT_VERBOSELY should equal false
    The variable CP_CALLED should equal true
  End

  It 'pulls translations with verbose output (short flag)'
    GIT_CALLED_QUIETLY=false
    GIT_CALLED_NOT_QUIETLY=false
    GIT_CALLED_VERBOSELY=false
    GIT_CALLED_NOT_VERBOSELY=false
    CP_CALLED=false
    When run source ./atlas pull -v
    The lines of output should equal 14
    The line 14 of output should equal 'Translations pulled successfully!'
    The variable GIT_CALLED_QUIETLY should equal false
    The variable GIT_CALLED_NOT_QUIETLY should equal true
    The variable GIT_CALLED_VERBOSELY should equal true
    The variable GIT_CALLED_NOT_VERBOSELY should equal false
    The variable CP_CALLED should equal true
  End
End
