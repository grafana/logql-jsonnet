#!/usr/bin/env bash

source "$(pwd)/tools/includes/utils.sh"

source "./tools/includes/logging.sh"

# output the heading
heading "LogQL Jsonnet" "Performing Text Linting using textlint"

# check to see if remark is installed
if [[ ! -f "$(pwd)"/node_modules/.bin/textlint ]]; then
  emergency "textlint node module is not installed, please run: make install";
fi

# determine whether or not the script is called directly or sourced
(return 0 2>/dev/null) && sourced=1 || sourced=0

statusCode=0

if [[ -n "$CI_MODE" ]] && [[ "$CI_MODE" == "true" ]]; then
  while read -r file; do
    "$(pwd)"/node_modules/.bin/textlint --config "$(pwd)/.textlintrc" "$file"
    currentCode="$?"
    # if the current code is 0, output the file name for logging purposes
    if [[ "$currentCode" == 0 ]]; then
      echo -e "\\x1b[32m$file\\x1b[0m: no issues found"
    fi
    # only override the statusCode if it is 0
    if [[ "$statusCode" == 0 ]]; then
      statusCode="$currentCode"
    fi
  done < <(git log --pretty="%H" --since="midnight" --merges --author-date-order --format="%H" | \
    xargs -L1 git diff-tree -r --name-only -m | \
    grep "guides" | grep -E ".+\.md$")
else
  while read -r file; do
    "$(pwd)"/node_modules/.bin/textlint --config "$(pwd)/.textlintrc" "$file"
    currentCode="$?"
    # if the current code is 0, output the file name for logging purposes
    if [[ "$currentCode" == 0 ]]; then
      echo -e "\\x1b[32m$file\\x1b[0m: no issues found"
    fi
    # only override the statusCode if it is 0
    if [[ "$statusCode" == 0 ]]; then
      statusCode="$currentCode"
    fi
  done < <(find . -type f -name "*.md" -not -path "./node_modules/*" -not -path "./.git/*")
fi
echo ""
echo ""

# if the script was called by another, send a valid exit code
if [[ "$sourced" == "1" ]]; then
  return "$statusCode"
else
  exit "$statusCode"
fi
