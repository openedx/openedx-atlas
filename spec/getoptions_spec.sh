# requires getoptions to be installed
# installing getoptions locally: https://github.com/ko1nksm/getoptions/#installation
verify_getoptions() {
  cp atlas atlastest
  gengetoptions embed --overwrite atlastest
  if cmp -s atlas atlastest; then
    echo "verified"
  else
    echo "not"
  fi
  rm atlastest
}

Describe 'getoptions'
  It 'matches generated getoptions'
    When call verify_getoptions
    The output should equal 'verified'
  End
End
