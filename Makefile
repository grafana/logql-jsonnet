.DEFAULT_GOAL:= lint
PATH := ./node_modules/.bin:$(PATH)
SHELL := /bin/bash
args = $(filter-out $@, $(MAKECMDGOALS))
.PHONY: all setup install clean reinstall build lint lint-sh lint-shell lint-md lint-markdown lint-txt lint-text lint-yaml lint-yml lint-editorconfig lint-ec lint-jsonnet ci-lint ci-lint-shell ci-lint-markdown ci-lint-text ci-lint-yaml ci-lint-editorconfig ci-build

default: all

all: install

####################################################################
#                   Installation / Setup                           #
####################################################################
setup:
	@./tools/setup.sh

install:
	yarn install
	pipenv install

# remove the build and log folders
clean:
	rm -rf build node_modules

# reinstall the node_modules and start with a fresh node build
reinstall: clean install

####################################################################
#                           Linting                                #
####################################################################
lint: lint-shell lint-markdown lint-text lint-yaml lint-editorconfig lint-jsonnet

# Note "|| true" is added to locally make lint can be ran and all linting is preformed, regardless of exit code

# Shell Linting
lint-sh lint-shell:
	@./tools/lint-shell.sh || true

# Markdown Linting
lint-md lint-markdown:
	@./tools/lint-markdown.sh || true

# Text Linting
lint-txt lint-text:
	@./tools/lint-text.sh || true

# Yaml Linting
lint-yml lint-yaml:
	@./tools/lint-yaml.sh || true

# Editorconfig Linting
lint-ec lint-editorconfig:
	@./tools/lint-editorconfig.sh || true

# Jsonnet Linting
lint-jsonnet:
	@./tools/lint-jsonnet.sh || true


####################################################################
#                              CI                                  #
####################################################################
ci-lint: ci-lint-shell ci-lint-markdown ci-lint-text ci-lint-yaml ci-lint-editorconfig

# Shell Linting
ci-lint-shell:
	@./tools/lint-shell.sh

# Markdown Linting
ci-lint-markdown:
	@./tools/lint-markdown.sh

# Text Linting
ci-lint-text:
	@./tools/lint-text.sh

# Yaml Linting
ci-lint-yaml:
	@./tools/lint-yaml.sh

# Editorconfig Linting
ci-lint-editorconfig:
	@./tools/lint-editorconfig.sh

# Jsonnet Linting
ci-lint-jsonnet:
	@./tools/lint-jsonnet.sh
