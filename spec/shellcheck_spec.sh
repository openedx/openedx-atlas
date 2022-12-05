# requires shellcheck to be installed
# installing shellcheck locally: https://github.com/koalaman/shellcheck#installing
verify_shellcheck() {
  shellcheck atlas
}

Describe 'shellcheck'
  It 'passes shellcheck static analysis'
    When call verify_shellcheck
    The status should be success
  End
End
