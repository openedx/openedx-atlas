
PATH := $(PATH):.bin/:.bin/shellspec_repo
GETOPTIONS_RELEASE := v3.3.0
SHELLSPEC_RELEASE := 0.28.1  # CI uses latest version. If CI fails, bump up this version.
SHELLCHECK_RELEASE := v0.9.0  # CI uses latest version. If CI fails, bump up this version.

UNAME := $(shell uname -is)

all: gengetoptions

help: ## display this help message
	@echo "Please use \`make <target>' where <target> is one of"
	@awk -F ':.*?## ' '/^[a-zA-Z]/ && NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

gengetoptions: .bin/.bin_is_ready ## use getoptions to generate argument parsing
	gengetoptions embed --overwrite atlas

test: .bin/.bin_is_ready ## automated testing using shellspec
	shellspec

unzip_shellcheck:  # utility to unzip shellcheck into .bin
	cd .bin && tar -xf shellcheck.tar.xz shellcheck-$(SHELLCHECK_RELEASE)/shellcheck
	mv .bin/shellcheck-$(SHELLCHECK_RELEASE)/shellcheck .bin/shellcheck


.bin/.bin_is_ready:  ## install required binaries for testing and development
	rm -rf .bin
	mkdir .bin
	# Install getoptions according to https://github.com/ko1nksm/getoptions/#installation
	wget https://github.com/ko1nksm/getoptions/releases/download/$(GETOPTIONS_RELEASE)/getoptions -O ./.bin/getoptions
	wget https://github.com/ko1nksm/getoptions/releases/download/$(GETOPTIONS_RELEASE)/gengetoptions -O .bin/gengetoptions

	git -c advice.detachedHead=false \
	    clone https://github.com/shellspec/shellspec.git --depth=1 --branch=$(SHELLSPEC_RELEASE) .bin/shellspec_repo

ifeq ($(UNAME), Linux x86_64)
	# install shellcheck on Linux x86_64
	wget https://github.com/koalaman/shellcheck/releases/download/$(SHELLCHECK_RELEASE)/shellcheck-$(SHELLCHECK_RELEASE).linux.x86_64.tar.xz -O .bin/shellcheck.tar.xz
	make unzip_shellcheck
else ifeq ($(UNAME), Darwin x86_64)
	# install shellcheck on MacOSX
	wget https://github.com/koalaman/shellcheck/releases/download/$(SHELLCHECK_RELEASE)/shellcheck-$(SHELLCHECK_RELEASE).darwin.x86_64.tar.xz -O .bin/shellcheck.tar.xz
	make unzip_shellcheck
else
	@echo "WARNING: Makefile don't know hot to install shellcheck on $(UNAME)."
	@echo "         Please install it manually from https://github.com/koalaman/shellcheck#installing"
	@echo "         If you run into this, please consider fixing Makefile for your Operating System"
endif

	chmod +x .bin/getoptions .bin/gengetoptions
	touch .bin/.bin_is_ready
