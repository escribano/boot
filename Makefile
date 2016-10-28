# variable definitions
PROJECT := github.com/escribano/boot
PROJECT_DIR := $(shell go list -e -f '{{.Dir}}' $(PROJECT))
NAME := boot
DESC := a nice toolkit of helpful things
PREFIX ?= usr/local
VERSION := $(shell git describe --tags --always --dirty)
GOVERSION := $(shell go version)
BUILDTIME := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
BUILDDATE := $(shell date -u +"%B %d, %Y")
BUILDER := $(shell echo "`git config user.name` <`git config user.email`>")
PKG_RELEASE ?= 1
PROJECT_URL := "https://github.com/escribano/$(NAME)"
LDFLAGS := -X 'main.version=$(VERSION)' \
           -X 'main.buildTime=$(BUILDTIME)' \
           -X 'main.builder=$(BUILDER)' \
           -X 'main.goversion=$(GOVERSION)'
CMD_SOURCES := $(shell find cmd -name main.go)
TARGETS := $(patsubst cmd/%/main.go,%,$(CMD_SOURCES))
MAN_SOURCES := $(shell find man -name "*.md")
MAN_TARGETS := $(patsubst man/man1/%.md,%,$(MAN_SOURCES))
INSTALLED_TARGETS = $(addprefix $(PREFIX)/bin/, $(TARGETS))
INSTALLED_MAN_TARGETS = $(addprefix $(PREFIX)/share/man/man1/, $(MAN_TARGETS))

.DEFAULT_GOAL := help
.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Possible targets:"
	@echo
#	@echo "- user               Build the app with user specific configuration"
	@echo "- all                Build the app with current environment"
	@echo "- release            Build app for release (/prd)"
	@echo "- debug              Build app for debug (/src)"
	@echo "- lint               Run the linter"
#	@echo "- testdebug          Run the JavaScript tests in debug mode"
#	#@echo "- testrelease        Run the JavaScript tests in release mode"
#	#@echo "- apache             Configure Apache (restart required)"
#	#@echo "- fixrights          Fix rights in common folder"
	@echo "- clean              Remove generated files"
	@echo "- cleanall           Remove all the build artefacts"
#	#@echo "- deploydev          Deploys current github master to dev. Specify SNAPSHOT=true to create snapshot as well."
#	#@echo "- deployint          Deploys snapshot specified with SNAPSHOT=xxx to int."
#	#@echo "- deployprod         Deploys snapshot specified with SNAPSHOT=xxx to prod."
#	#@echo "- deploydemo         Deploys snapshot specified with SNAPSHOT=xxx to demo."
#	#@echo "- deletebranch       List deployed branches or delete a deployed branch (BRANCH_TO_DELETE=...)"
#	#@echo "- deploybranch       Deploys current branch to test (note: takes code from github)"
#	#@echo "- deploybranchint    Deploys current branch to test and int (note: takes code from github)"
#	#@echo "- deploybranchdemo   Deploys current branch to test and demo (note: takes code from github)"
#	#@echo "- ol3cesium          Update ol3cesium.js, ol3cesium-debug.js, Cesium.min.js and Cesium folder"
	@echo "- libs               Update js librairies used in index.html, see npm packages defined in section 'dependencies' of package.json"
	@echo "- translate          Generate the translation files (requires db user pwd in ~/.pgpass: dbServer:dbPort:*:dbUser:dbUserPwd)"
	@echo "- help               Display this help"
	@echo
	@echo "Variables:"
	@echo
#	#@echo "- DEPLOY_TARGET Deploy target (build with: $(LAST_DEPLOY_TARGET), current value: $(DEPLOY_TARGET))"
	@echo "- API_URL Service URL         (build with: $(LAST_API_URL), current value: $(API_URL))"
#	#@echo "- MAPPROXY_URL Service URL    (build with: $(LAST_MAPPROXY_URL), current value: $(MAPPROXY_URL))"
#	#@echo "- SHOP_URL Service URL        (build with: $(LAST_SHOP_URL), current value: $(SHOP_URL))"
#	#@echo "- APACHE_BASE_PATH Base path  (build with: $(LAST_APACHE_BASE_PATH), current value: $(APACHE_BASE_PATH))"
#	#@echo "- APACHE_BASE_DIRECTORY       (build with: $(LAST_APACHE_BASE_DIRECTORY), current value: $(APACHE_BASE_DIRECTORY))"
	@echo "- TARGETS : $(TARGETS)"
	@echo "- MAN_TARGETS : $(MAN_TARGETS)"
	@echo "- DEPDIR : $(DEPDIR)"
	@echo "- INSTALLED_TARGETS : $(INSTALLED_TARGETS)"
	@echo "- INSTALLED_MAN_TARGETS : $(INSTALLED_MAN_TARGETS)"
	@echo "- PREFIX : $(PREFIX)"

	@echo

.PHONY: deps
deps:

get.errors:
	cd ~/code/go/src/github.com/escribano
	git clone https://github.com/escribano/errors.git
	cd errors
	git remote add upstream https://github.com/pkg/errors.git
	git fetch upstream
	git difftool master upstream/master
	git merge upstream/master
	git push origin master

get.flags:
	cd ~/code/go/src/github.com/escribano
	git clone https://github.com/escribano/go-flags.git

.PHONY: %
%: cmd/%
	go install -ldflags "$(LDFLAGS)" $(PROJECT)/$<

.PHONY: release
release:
	mkdir -p prd/{bin,share}
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags "$(LDFLAGS)" -o prd/bin/hs $(PROJECT)/cmd/hs
