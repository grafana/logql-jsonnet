#!/usr/bin/env bash

source "$(pwd)/tools/includes/utils.sh"

source "./tools/includes/logging.sh"

# output the heading
heading "LogQL Jsonnet" "Performing YAML Linting using yamllint"

result=$(jsonnet "$(pwd)/unit-tests.jsonnet" 2>&1)

if [[ "$result" == *"TRACE"* ]]; then
  echo "${result}"
  exit 1;
else
  echo "${result//\"/}"
fi
