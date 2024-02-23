# Testsuite
You should put all your tests under the [tests](tests) subdirectory. Your tests should cover all modified paths in the S/SL code. We have provided a framework to automatically run all your tests and report the results using the shell unit testing framework [shellspec](https://github.com/shellspec/shellspec).

### Installing shellspec
You need to install shellspec to run the tests. You can do so simply by running:
```
curl -fsSL https://git.io/shellspec | sh
```

Add `$HOME/.local/bin` to your `PATH` variable by appending the line below to `$HOME/.bashrc` 
```
echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
```

Restart your terminal or simple source `$HOME/.bashrc`
```
source $HOME/.bashrc
```

### Running the tests
Run the command below from the `testsuite` subdirectory:
```
shellspec -f d
```

Obviously, expect the (example) tests to fail until you implement the missing features.

### Adding more tests
1. add your `.pt` file under the [tests](tests) subdirectory.
2. create a file under the [tests](tests) subdirectory that contains the output expected from running `ssltrace -e` on your `.pt` file.
3. edit [spec/tests_spec.sh](spec/tests_spec.sh) and add a new line
under [`Parameters`](spec/tests_spec.sh#L3).

You **do not** need to worry about spacing and any token that is not an output/error tokens when creating the expected output file (step 2). The verifier will ignore any lines that do not start with an output token (i.e., starting with a dot) or error token (i.e., starting with a hash). If interested, you can check [test_utils.sh](test_utils.sh#L8) to see how the `ssltrace` output is filtered before verification.