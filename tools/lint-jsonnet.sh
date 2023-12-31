#!/usr/bin/env bash

source "$(pwd)/tools/includes/utils.sh"

source "./tools/includes/logging.sh"

# output the heading
heading "LogQL Jsonnet" "Performing Jsonnet Linting using jsonnet-lint"

# check to see if remark is installed
if [[ "$(command -v shellcheck)" = "" ]]; then
  emergency "jsonnet-lint command is required, see: (https://github.com/google/go-jsonnet/blob/master/linter/README.md) or run: go install github.com/google/go-jsonnet/cmd/jsonnet-lint@latest";
fi

# determine whether or not the script is called directly or sourced
(return 0 2>/dev/null) && sourced=1 || sourced=0

statusCode=0

while read -r file; do
    jsonnet-lint "$file"
    currentCode="$?"
    # if the current code is 0, output the file name for logging purposes
    if [[ "$currentCode" == 0 ]]; then
      echo -e "\\x1b[32m$file\\x1b[0m: no issues found"
    else
      echo ""
    fi
    # only override the statusCode if it is 0
    if [[ "$statusCode" == 0 ]]; then
      statusCode="$currentCode"
    fi
  done < <(find . -type f \( -name "*.jsonnet" -o -name "*.libsonnet" \) -not -path "./node_modules/*" -not -path "./.git/*")

echo ""
echo ""

# if the script was called by another, send a valid exit code
if [[ "$sourced" == "1" ]]; then
  return "$statusCode"
else
  exit "$statusCode"
fi
