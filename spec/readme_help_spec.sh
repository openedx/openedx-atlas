# requires getoptions to be installed
# installing getoptions locally: https://github.com/ko1nksm/getoptions/#installation
verify_help_section() {
  cp README.rst README.rst.backup
  make -s atlas_help_to_readme
  diff --report-identical-files README.rst README.rst.backup
  rm README.rst
  mv README.rst.backup README.rst
}

Describe 'atlas help section'
  It 'has run "make atlas_help_to_readme"'
    When call verify_help_section
    The output should equal "Files README.rst and README.rst.backup are identical"
  End
End
