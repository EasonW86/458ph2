Describe 'Run tests'
  Parameters
    # Test description                  Test path                               Expected output from ssltrace -e
    "Empty Infero Program"              tests/infero_empty.pt                   tests/infero_empty.e
  End

  Include ./test_utils.sh
  It "$1"
    When call run_ssltrace $2                       
    The error should be present                    
    The output should eq "$(cat $3 | tr -d ' ' | grep -e '^\.' -e '^#')"
  End
End
