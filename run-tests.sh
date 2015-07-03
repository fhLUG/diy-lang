#!/usr/bin/env bash

# Bash script for running the test suite every time a file is changed.
# Requires the python package `nose` to be installed, as well as the
# `inotifytools` commands.

function run_tests {
    nosetests \
              tests/test_provided_code.py \
              tests/test_1_parsing.py \
              tests/test_2_evaluating_simple_expressions.py \
              tests/test_3_evaluating_complex_expressions.py \
              tests/test_4_working_with_variables_and_environments.py \
              tests/test_5_adding_functions_to_the_mix.py \
              tests/test_6_working_with_lists.py \
              tests/test_7_using_the_language.py \
              tests/test_sanity_checks.py \
              tests/test_8_meta_circular_evaluator.py \
              --stop
}

run_tests

function log_test_run {
  msg="Prepared to run tests on new changes..."
  echo -e "\033[1;37m> $msg\033[0m"
}

if command -v inotifywait >/dev/null; then
  log_test_run
  while inotifywait -q -r -e modify . ; do
    run_tests
  done
fi

if command -v fswatch >/dev/null; then
  log_test_run
  while fswatch -1 .; do
    run_tests
  done
fi
