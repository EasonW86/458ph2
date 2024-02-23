#!/bin/sh

compile_test() {
    ptc -o2 -L ../lib/pt "$1"
}

run_ssltrace() {
    ssltrace "ptc -o2 -t2 -L ../lib/pt $1" ../lib/pt/parser.def -e | tr -d ' ' | grep -e '^\.' -e '^#'
}
