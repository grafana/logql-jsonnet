#!/usr/bin/env bash

source "$(pwd)/tools/includes/utils.sh"

source "./tools/includes/logging.sh"

# output the heading
heading "LogQL Jsonnet" "Performing Setup Checks"

# make sure go exists
info "Checking to see if go is installed"
if [[ "$(command -v go)" = "" ]]; then
  emergency "go command is required, see: (https://go.dev) or run: brew install go";
else
  success "go is installed"
fi

# make sure jsonnet exists
info "Checking to see if jsonnet is installed"
if [[ "$(command -v jsonnet)" = "" ]]; then
  emergency "jsonnet command is required, see: (https://github.com/google/go-jsonnet) or run: go install github.com/google/go-jsonnet/cmd/jsonnet@latest";
else
  success "jsonnet is installed"
fi

# make sure jsonnet-linter exists
info "Checking to see if jsonnet-lint is installed"
if [[ "$(command -v jsonnet-lint)" = "" ]]; then
  emergency "jsonnet-lint command is required, see: (https://github.com/google/go-jsonnet/blob/master/linter/README.md) or run: go install github.com/google/go-jsonnet/cmd/jsonnet-lint@latest";
else
  success "jsonnet-lint is installed"
fi

# make sure Node exists
info "Checking to see if Node is installed"
if [[ "$(command -v node)" = "" ]]; then
  warning "node is required if running lint locally, see: (https://nodejs.org) or run: brew install nvm && nvm install 18";
else
  success "node is installed"
fi

# make sure jb exists
info "Checking to see if jb is installed"
if [[ "$(command -v jb)" = "" ]]; then
  emergency "jb command is required, see: (https://github.com/jsonnet-bundler/jsonnet-bundler) or run: go install -a github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest";
else
  success "jb is installed"
fi


# make sure yarn exists
info "Checking to see if yarn is installed"
if [[ "$(command -v yarn)" = "" ]]; then
  warning "yarn is required if running lint locally, see: (https://yarnpkg.com) or run: brew install yarn";
else
  success "yarn is installed"
fi

# make sure pipenv exists
info "Checking to see if pipenv is installed"
if [[ "$(command -v pipenv)" = "" ]]; then
  warning "pipenv is required if running lint locally, see: (https://pipenv.pypa.io/en/latest/) or run: brew install pipenv";
else
  success "pipenv is installed"
fi

# make sure shellcheck exists
info "Checking to see if shellcheck is installed"
if [[ "$(command -v shellcheck)" = "" ]]; then
  warning "shellcheck is required if running lint locally, see: (https://shellcheck.net) or run: brew install shellcheck";
else
  success "shellcheck is installed"
fi

# make sure pre-commit exists
info "Checking to see if shellcheck is installed"
if [[ "$(command -v pre-commit)" = "" ]]; then
  warning "pre-commit is required, see: (https://pre-commit.com) or run: brew install pre-commit";
else
  success "pre-commit is installed"
fi
