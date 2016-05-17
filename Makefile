
APPNAME=brsHamcrest


#########################################################################
# app.mk: common include file for application Makefiles.
#
# Makefile common usage:
# > make
# > make run
# > make install
# > make remove
# > make test
#
# Makefile less common usage:
# > make art-opt
# > make pkg
# > make install_native
# > make remove_native
# > make tr
#
# Important Notes:
# To use the "run", "install" and "remove" targets to install your
# application directly from the shell, you must do the following:
#
# 1) Make sure that you have the curl command line executable in your path.
# 2) Set the variable ROKU_DEV_TARGET in your environment to the IP
#    address of your Roku box, e.g.
#      export ROKU_DEV_TARGET=192.168.1.1
# 3) Set the variable DEVPASSWORD in your environment with the developer
#    password that you have set for your Roku box, e.g.
#      export DEVPASSWORD=mypassword
#    (If you don't set this, you will be prompted for every install command.)
##########################################################################

##########################################################################
# Specifying application files to be packaged:
#
# By default, ZIP_EXCLUDE will exclude well-known source directories and
# files that should typically not be included in the application
# distribution.
#
# If you want to entirely override the default settings, you can put your
# own definition of ZIP_EXCLUDE in your Makefile.
#
# Example:
#   ZIP_EXCLUDE= -x keys\*
# will exclude all files from the keys directory (and only those files).
#
# To exclude using more than one pattern, use additional '-x <pattern>'
# arguments, e.g.
#   ZIP_EXCLUDE= -x \*.pkg -x storeassets\*
#
# If you just need to add additional files to the ZIP_EXCLUDE list, you can
# define ZIP_EXCLUDE_LOCAL in your Makefile.  This pattern will be appended
# to the default ZIP_EXCLUDE pattern.
#
# Example:
#   ZIP_EXCLUDE_LOCAL= -x goldens\*
##########################################################################

# improve performance and simplify Makefile debugging by omitting
# default language rules that don't apply to this environment.
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

HOST_OS := unknown
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	HOST_OS := macos
else ifeq ($(UNAME_S),Linux)
	HOST_OS := linux
else ifneq (,$(findstring CYGWIN,$(UNAME_S)))
	HOST_OS := cygwin
endif

IS_TEAMCITY_BUILD ?=
ifneq ($(TEAMCITY_BUILDCONF_NAME),)
IS_TEAMCITY_BUILD := true
endif

# We want to be able to use escape sequences with echo
ifeq ($(HOST_OS),macos)
ECHO := echo
else
ECHO := echo -e
endif

# get the root directory in absolute form, so that current directory
# can be changed during the make if needed.
APPS_ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# the current directory is the app root directory
SOURCEDIR := .

DISTREL := $(APPS_ROOT_DIR)/dist
COMMONREL := $(APPS_ROOT_DIR)/common

ZIPREL := $(DISTREL)/apps
PKGREL := $(DISTREL)/packages
TESTREL := $(DISTREL)/tests
CHECK_TMP_DIR := $(DISTREL)/tmp-check

ifdef BUILD_NUMBER
	APP_ZIP_FILE := $(ZIPREL)/$(APPNAME)_$(PLATFORM)_$(AUDIENCE)_$(MAJOR_VERSION).$(MINOR_VERSION).$(BUILD_NUMBER).zip
	APP_PKG_FILE := $(PKGREL)/$(APPNAME)_$(PLATFORM)_$(AUDIENCE)_$(MAJOR_VERSION).$(MINOR_VERSION).$(BUILD_NUMBER).pkg
	APP_TEST_RESULTS_FILE := $(TESTREL)/$(APPNAME)_$(MAJOR_VERSION).$(MINOR_VERSION).$(BUILD_NUMBER).xml
	APP_VERSION := $(MAJOR_VERSION).$(MINOR_VERSION).$(BUILD_NUMBER)
else
	APP_ZIP_FILE := $(ZIPREL)/$(APPNAME).zip
	APP_PKG_FILE := $(PKGREL)/$(APPNAME).pkg
	APP_TEST_RESULTS_FILE := $(TESTREL)/$(APPNAME).xml
endif

# these variables are only used for the .pkg file version tagging.
APP_NAME := $(APPNAME)
ifeq ($(IS_TEAMCITY_BUILD),true)
APP_NAME    := $(subst /,-,$(TEAMCITY_BUILDCONF_NAME))
APP_VERSION := $(BUILD_NUMBER)
endif

APP_BUILD_DIR := $(SOURCEDIR)/build
APP_TEST_DIR := $(SOURCEDIR)/tests

# Checks if a specific folder of tests has been set - if empty, run all tests
ifeq ($(TEST_FOLDER), )
	TEST_SUITES := source/*
else
	TEST_SUITES := $(TEST_FOLDER)
endif

IMPORTFILES := $(foreach f,$(IMPORTS),$(COMMONREL)/$f.brs)

APP_LIBSTUB_DIR := $(SOURCEDIR)/libstub

# ROKU_NATIVE_DEV must be set in the calling environment to
# the firmware native-build source directory
NATIVE_DIST_DIR := $(ROKU_NATIVE_DEV)/dist
#
NATIVE_DEV_REL  := $(NATIVE_DIST_DIR)/rootfs/Linux86_dev.OBJ/root/nvram/incoming
NATIVE_DEV_PKG  := $(NATIVE_DEV_REL)/dev.zip
NATIVE_PLETHORA := $(NATIVE_DIST_DIR)/application/Linux86_dev.OBJ/root/bin/plethora
NATIVE_TICKLER  := $(NATIVE_PLETHORA) tickle-plugin-installer

# only Linux host is supported for these tools currently
APPS_TOOLS_DIR    := $(APPS_ROOT_DIR)/tools/$(HOST_OS)/bin

APP_PACKAGE_TOOL  ?= $(APPS_TOOLS_DIR)/app-package
MAKE_TR_TOOL      ?= $(APPS_TOOLS_DIR)/maketr
BRIGHTSCRIPT_TOOL ?= $(APPS_TOOLS_DIR)/brightscript

# if building from a firmware tree, use the BrightScript libraries from there
ifneq (,$(wildcard $(APPS_ROOT_DIR)/../3rdParty/brightscript/Scripts/LibCore/.))
BRIGHTSCRIPT_LIBS_DIR ?= $(APPS_ROOT_DIR)/../3rdParty/brightscript/Scripts/LibCore
endif
# else use the reference libraries from the tools directory.
BRIGHTSCRIPT_LIBS_DIR ?= $(APPS_ROOT_DIR)/tools/brightscript/Scripts/LibCore

APP_KEY_PASS_TMP := /tmp/app_key_pass
DEV_SERVER_TMP_FILE := /tmp/dev_server_out

# The developer password that was set on the player is required for
# plugin_install operations on modern versions of firmware.
# It may be pre-specified in the DEVPASSWORD environment variable on entry,
# otherwise the make will stop and prompt the user to enter it when needed.
ifdef DEVPASSWORD
	USERPASS := rokudev:$(DEVPASSWORD)
else
	USERPASS := rokudev
endif

ifeq ($(HOST_OS),macos)
	# Mac doesn't support these args
	CP_ARGS =
else
	CP_ARGS = --preserve=ownership,timestamps --no-preserve=mode
endif

# For a quick ping, we want the command to return success as soon as possible,
# and a timeout failure in no more than a second or two.
ifeq ($(HOST_OS),cygwin)
	# This assumes that the Windows ping command is used, not cygwin's.
	QUICK_PING_ARGS = -n 1 -w 1000
else ifeq ($(HOST_OS),macos)
	QUICK_PING_ARGS = -c 1 -t 1
else # Linux
	QUICK_PING_ARGS = -c 1 -w 1
endif

ifndef ZIP_EXCLUDE
	ZIP_EXCLUDE =
	# exclude hidden files (name starting with .)
	ZIP_EXCLUDE += -x .\*
	# exclude files with name ending with ~
	ZIP_EXCLUDE += -x \*~
	ZIP_EXCLUDE += -x \*.pkg
	ZIP_EXCLUDE += -x Makefile
	ZIP_EXCLUDE += -x tests\*
	ZIP_EXCLUDE += -x keys\*
	ZIP_EXCLUDE += -x libapi\*
	ZIP_EXCLUDE += -x libstub\*
	ZIP_EXCLUDE += -x storeassets\*
	ZIP_EXCLUDE += -x *.DS_Store*
	ZIP_EXCLUDE += -x *.git*
endif

ZIP_EXCLUDE_PATTERN = $(ZIP_EXCLUDE)
ZIP_EXCLUDE_PATTERN += $(ZIP_EXCLUDE_LOCAL)

# Folders/files to be included in app zip
APP_INCLUDES := source

# Unit test folder and test runner script
UNIT_TEST_FOLDER := $(APPS_ROOT_DIR)/tests/testrunner
TEST_RUNNER_SCRIPT := $(UNIT_TEST_FOLDER)/brstestrunner.py

# -------------------------------------------------------------------------
# Colorized output support.
# If you don't want it, do 'export APP_MK_COLOR=false' in your env.
# -------------------------------------------------------------------------
ifndef APP_MK_COLOR
APP_MK_COLOR := false
ifeq ($(TERM),$(filter $(TERM),xterm xterm-color xterm-256color))
	APP_MK_COLOR := true
endif
endif

COLOR_START  :=
COLOR_INFO   :=
COLOR_PROMPT :=
COLOR_DONE   :=
COLOR_ERR    :=
COLOR_OFF    :=

ifeq ($(APP_MK_COLOR),true)
	# ANSI color escape codes:

	#	\e[0;30m	black
	#	\e[0;31m	red
	#	\e[0;32m	green
	#	\e[0;33m	yellow
	#	\e[0;34m	blue
	#	\e[0;35m	magenta
	#	\e[0;36m	cyan
	#	\e[0;37m	light gray

	#	\e[1;30m	gray
	#	\e[1;31m	light red
	#	\e[1;32m	light green
	#	\e[1;33m	light yellow
	#	\e[1;34m	light blue
	#	\e[1;35m	light purple
	#	\e[1;36m	light cyan
	#	\e[1;37m	white

	COLOR_START  := \033[1;36m
	COLOR_INFO   := \033[1;35m
	COLOR_PROMPT := \033[0;31m
	COLOR_DONE   := \033[1;32m
	COLOR_ERROR  := \033[1;31m
	COLOR_OFF    := \033[0m
endif

# -------------------------------------------------------------------------
# $(APPNAME): the default target is to create the zip file for the app.
# This contains the set of files that are to be deployed on a Roku.
# -------------------------------------------------------------------------
.PHONY: $(APPNAME)
$(APPNAME): build zip cleanup
	@$(ECHO) "$(COLOR_DONE)*** packaging $(APPNAME) complete ***$(COLOR_OFF)"

# -------------------------------------------------------------------------
# build: gather app files into $(APP_BUILD_DIR) folder.
# This contains the set of files to be included in the app zip file.
# -------------------------------------------------------------------------
.PHONY: build
build:
	@$(ECHO) "$(COLOR_START)*** Building $(APPNAME) ***$(COLOR_OFF)"

	@if [ -e "$(APP_ZIP_FILE)" ]; then \
		$(ECHO) "  >> removing old application zip $(APP_ZIP_FILE)"; \
		rm $(APP_ZIP_FILE); \
	fi

	@if [ ! -d $(ZIPREL) ]; then \
		$(ECHO) "  >> creating destination directory $(ZIPREL)"; \
		mkdir -p $(ZIPREL); \
	fi

	@if [ ! -w $(ZIPREL) ]; then \
		$(ECHO) "  >> setting directory permissions for $(ZIPREL)"; \
		chmod 755 $(ZIPREL); \
	fi

	@if [ -d $(APP_BUILD_DIR) ]; then \
		$(ECHO) "  >> removing old build directory $(APP_BUILD_DIR)"; \
		rm -rf $(APP_BUILD_DIR); \
	fi

	@if [ ! -d $(APP_BUILD_DIR) ]; then \
		$(ECHO) "  >> creating build directory $(APP_BUILD_DIR)"; \
		mkdir -p $(APP_BUILD_DIR); \
	fi

	@if [ ! -w $(APP_BUILD_DIR) ]; then \
		$(ECHO) "  >> setting directory permissions for $(APP_BUILD_DIR)"; \
		chmod 755 $(APP_BUILD_DIR); \
	fi

	@if [ "$(IMPORTFILES)" ]; then \
		$(ECHO) "  >> copying imports"; \
		mkdir $(APP_BUILD_DIR)/common; \
		cp -f $(CP_ARGS) -v $(IMPORTFILES) $(APP_BUILD_DIR)/common/; \
	fi

	@$(ECHO) "  >> copying $(APP_INCLUDES) into $(APP_BUILD_DIR)"
	cp -r $(APP_INCLUDES) $(APP_BUILD_DIR)/

# -------------------------------------------------------------------------
# zip: create the zip file for the app.
# This contains the set of files that are to be deployed on a Roku.
# -------------------------------------------------------------------------
.PHONY: zip
zip:
	@$(ECHO) "$(COLOR_START)*** Creating $(APP_ZIP_FILE) ***$(COLOR_OFF)"

# Note: zip .png files without compression
# FIXME: shouldn't it exclude .jpg too?
# FIXME: if no .png files are found, outputs bogus "zip warning: zip file empty"
	@$(ECHO) "  >> creating application zip $(APP_ZIP_FILE)"
	@if [ -d $(APP_BUILD_DIR) ]; then \
		pushd $(APP_BUILD_DIR)/; \
		zip -0 -r "$(APP_ZIP_FILE)" . -i \*.png $(ZIP_EXCLUDE_PATTERN); \
		zip -9 -r "$(APP_ZIP_FILE)" . -x \*.png $(ZIP_EXCLUDE_PATTERN); \
		popd; \
	else \
		$(ECHO) "$(COLOR_ERROR)Source for $(APPNAME) not found at $(SOURCEDIR)$(COLOR_OFF)"; \
	fi

# -------------------------------------------------------------------------
# cleanup: remove build folder.
# -------------------------------------------------------------------------
.PHONY: cleanup
cleanup:
	@$(ECHO) "$(COLOR_START)*** Cleaning-up $(APP_BUILD_DIR) ***$(COLOR_OFF)"

	@if [ -d $(APP_BUILD_DIR) ]; then \
		$(ECHO) "  >> cleaning build folder"; \
		rm -rf $(APP_BUILD_DIR); \
	fi

# -------------------------------------------------------------------------
# clean: remove any build output for the app.
# -------------------------------------------------------------------------
.PHONY: clean
clean:
	rm -f $(ZIPREL)/$(APPNAME)*.zip
	rm -f $(PKGREL)/$(APPNAME)*.pkg
	rm -f $(TESTREL)/*$(APPNAME)*.xml
	rm -rf $(APP_BUILD_DIR)

# -------------------------------------------------------------------------
# clobber: remove any build output for the app.
# -------------------------------------------------------------------------
.PHONY: clobber
clobber: clean

# -------------------------------------------------------------------------
# dist-clean: remove the dist directory for the sandbox.
# -------------------------------------------------------------------------
.PHONY: dist-clean
dist-clean:
	rm -rf $(DISTREL)/*

# -------------------------------------------------------------------------
# CHECK_OPTIONS: this is used to specify configurable options, such
# as which version of the BrightScript library sources should be used
# to compile the app.
# -------------------------------------------------------------------------
CHECK_OPTIONS =

ifneq (,$(wildcard $(BRIGHTSCRIPT_LIBS_DIR)/.))
CHECK_OPTIONS += -lib $(BRIGHTSCRIPT_LIBS_DIR)
endif

# if the app uses BS libraries, it can provide stub libraries to compile with.
ifneq (,$(wildcard $(APP_LIBSTUB_DIR)/.))
CHECK_OPTIONS += -applib $(APP_LIBSTUB_DIR)
endif

# -------------------------------------------------------------------------
# check: run the desktop BrightScript compiler/check tool on the
# application.
# You can bypass checking on the application by setting
# APP_CHECK_DISABLED=true in the app's Makefile or in the environment.
# -------------------------------------------------------------------------
.PHONY: check
check: $(APPNAME)
ifeq ($(APP_CHECK_DISABLED),true)
ifeq ($(IS_TEAMCITY_BUILD),true)
	@$(ECHO) "*** Warning: application check skipped ***"
endif
else
ifeq ($(wildcard $(BRIGHTSCRIPT_TOOL)),)
	@$(ECHO) "*** Note: application check not available ***"
else
	@$(ECHO) "$(COLOR_START)*** Checking application ***$(COLOR_OFF)"
	@rm -rf $(CHECK_TMP_DIR)
	@mkdir -p $(CHECK_TMP_DIR)
	@unzip -q $(APP_ZIP_FILE) -d $(CHECK_TMP_DIR)
	@$(BRIGHTSCRIPT_TOOL) check \
		$(CHECK_OPTIONS) \
		$(CHECK_TMP_DIR)
	@rm -rf $(CHECK_TMP_DIR)
	@$(ECHO) "$(COLOR_DONE)*** Checking complete ***$(COLOR_OFF)"
endif
endif

# -------------------------------------------------------------------------
# check-strict: run the desktop BrightScript compiler/check tool on the
# application using strict mode.
# -------------------------------------------------------------------------
.PHONY: check-strict
check-strict: $(APPNAME)
	@$(ECHO) "$(COLOR_START)*** Checking application (strict) ***$(COLOR_OFF)"
	@rm -rf $(CHECK_TMP_DIR)
	@mkdir -p $(CHECK_TMP_DIR)
	@unzip -q $(APP_ZIP_FILE) -d $(CHECK_TMP_DIR)
	@$(BRIGHTSCRIPT_TOOL) check -strict \
		$(CHECK_OPTIONS) \
		$(CHECK_TMP_DIR)
	@rm -rf $(CHECK_TMP_DIR)
	@$(ECHO) "$(COLOR_DONE)*** Checking complete ***$(COLOR_OFF)"

# -------------------------------------------------------------------------
# GET_FRIENDLY_NAME_FROM_DD is used to extract the Roku device ID
# from the ECP device description XML response.
# -------------------------------------------------------------------------
define GET_FRIENDLY_NAME_FROM_DD
	cat $(DEV_SERVER_TMP_FILE) | \
		grep -o "<friendlyName>.*</friendlyName>" | \
		sed "s|<friendlyName>||" | \
		sed "s|</friendlyName>||"
endef

# -------------------------------------------------------------------------
# CHECK_ROKU_DEV_TARGET is used to check if ROKU_DEV_TARGET refers a
# Roku device on the network that has an enabled developer web server.
# If the target doesn't exist or doesn't have an enabled web server
# the connection should fail.
# -------------------------------------------------------------------------
define CHECK_ROKU_DEV_TARGET
	if [ -z "$(ROKU_DEV_TARGET)" ]; then \
		$(ECHO) "$(COLOR_ERROR)ERROR: ROKU_DEV_TARGET is not set.$(COLOR_OFF)"; \
		exit 1; \
	fi
	$(ECHO) "$(COLOR_START)Checking dev server at $(ROKU_DEV_TARGET)...$(COLOR_OFF)"

	# first check if the device is on the network via a quick ping
	ping $(QUICK_PING_ARGS) $(ROKU_DEV_TARGET) &> $(DEV_SERVER_TMP_FILE) || \
		( \
			$(ECHO) "$(COLOR_ERROR)ERROR: Device is not responding to ping.$(COLOR_OFF)"; \
			exit 1 \
		)

	# second check ECP, to verify we are talking to a Roku
	rm -f $(DEV_SERVER_TMP_FILE)
	curl --connect-timeout 2 --silent --output $(DEV_SERVER_TMP_FILE) \
		http://$(ROKU_DEV_TARGET):8060 || \
		( \
			$(ECHO) "$(COLOR_ERROR)ERROR: Device is not responding to ECP...is it a Roku?$(COLOR_OFF)"; \
			exit 1 \
		)

	# print the device friendly name to let us know what we are talking to
	ROKU_DEV_NAME=`$(GET_FRIENDLY_NAME_FROM_DD)`; \
	$(ECHO) "$(COLOR_INFO)Device reports as \"$$ROKU_DEV_NAME\".$(COLOR_OFF)"

	# third check dev web server.
	# Note, it should return 401 Unauthorized since we aren't passing the password.
	rm -f $(DEV_SERVER_TMP_FILE)
	HTTP_STATUS=`curl --connect-timeout 2 --silent --output $(DEV_SERVER_TMP_FILE) \
		http://$(ROKU_DEV_TARGET)` || \
		( \
			$(ECHO) "$(COLOR_ERROR)ERROR: Device server is not responding...$(COLOR_OFF)"; \
			$(ECHO) "$(COLOR_ERROR)is the developer installer enabled?$(COLOR_OFF)"; \
			exit 1 \
		)

	$(ECHO) "$(COLOR_DONE)Dev server is ready.$(COLOR_OFF)"
endef

# -------------------------------------------------------------------------
# CHECK_ROKU_DEV_PASSWORD is used to let the user know they might want to set
# their DEVPASSWORD environment variable.
# -------------------------------------------------------------------------
define CHECK_ROKU_DEV_PASSWORD
	if [ -z "$(DEVPASSWORD)" ]; then \
		$(ECHO) "Note: DEVPASSWORD is not set."; \
	fi
endef

# -------------------------------------------------------------------------
# CHECK_DEVICE_HTTP_STATUS is used to that the last curl command
# to the dev web server returned HTTP 200 OK.
# -------------------------------------------------------------------------
define CHECK_DEVICE_HTTP_STATUS
	if [ "$$HTTP_STATUS" != "200" ]; then \
		$(ECHO) "$(COLOR_ERROR)ERROR: Device returned HTTP $$HTTP_STATUS$(COLOR_OFF)"; \
		exit 1; \
	fi
endef

# -------------------------------------------------------------------------
# GET_PLUGIN_PAGE_RESULT_STATUS is used to extract the status message
# (e.g. Success/Failed) from the dev server plugin_* web page response.
# (Note that the plugin_install web page has two fields, whereas the
# plugin_package web page just has one).
# -------------------------------------------------------------------------
define GET_PLUGIN_PAGE_RESULT_STATUS
	cat $(DEV_SERVER_TMP_FILE) | \
		grep -o "<font color=\"red\">.*" | \
		sed "s|<font color=\"red\">||" | \
		sed "s|</font>||"
endef

# -------------------------------------------------------------------------
# GET_PLUGIN_PAGE_PACKAGE_LINK is used to extract the installed package
# URL from the dev server plugin_package web page response.
# -------------------------------------------------------------------------
define GET_PLUGIN_PAGE_PACKAGE_LINK
	cat $(DEV_SERVER_TMP_FILE) | \
		grep -o "<a href=\"pkgs//[^\"]*\"" | \
		sed "s|<a href=\"pkgs//||" | \
		sed "s|\"||"
endef

# -------------------------------------------------------------------------
# install: install the app as the dev channel on the Roku target device.
# -------------------------------------------------------------------------
.PHONY: install
install: $(APPNAME) check deploy
	@$(ECHO) "$(COLOR_DONE)*** install complete ***$(COLOR_OFF)"

# -------------------------------------------------------------------------
# deploy: deploy the app on the Roku target device.
# -------------------------------------------------------------------------
.PHONY: deploy
deploy:
	@$(CHECK_ROKU_DEV_TARGET)

	@$(ECHO) "$(COLOR_START)Deploying $(APPNAME)...$(COLOR_OFF)"
	@rm -f $(DEV_SERVER_TMP_FILE)
	@$(CHECK_ROKU_DEV_PASSWORD)
	@HTTP_STATUS=`curl --user $(USERPASS) --digest --silent --show-error \
		-F "mysubmit=Install" -F "archive=@$(APP_ZIP_FILE)" \
		--output $(DEV_SERVER_TMP_FILE) \
		--write-out "%{http_code}" \
		http://$(ROKU_DEV_TARGET)/plugin_install`; \
	$(CHECK_DEVICE_HTTP_STATUS)

	@MSG=`$(GET_PLUGIN_PAGE_RESULT_STATUS)`; \
	$(ECHO) "$(COLOR_DONE)Result: $$MSG$(COLOR_OFF)";\
	SUCCESS=`echo $$MSG | grep -c -i success`; \
	if [ "$$SUCCESS" != "1" ]; then \
		$(ECHO) "$(COLOR_ERROR)ERROR: Deployment failed!$(COLOR_OFF)"; \
		exit 1; \
	fi

# -------------------------------------------------------------------------
# remove: uninstall the dev channel from the Roku target device.
# -------------------------------------------------------------------------
.PHONY: remove
remove:
	@$(CHECK_ROKU_DEV_TARGET)

	@$(ECHO) "$(COLOR_START)Removing dev app...$(COLOR_OFF)"
	@rm -f $(DEV_SERVER_TMP_FILE)
	@$(CHECK_ROKU_DEV_PASSWORD)
	@HTTP_STATUS=`curl --user $(USERPASS) --digest --silent --show-error \
		-F "mysubmit=Delete" -F "archive=" \
		--output $(DEV_SERVER_TMP_FILE) \
		--write-out "%{http_code}" \
		http://$(ROKU_DEV_TARGET)/plugin_install`; \
	$(CHECK_DEVICE_HTTP_STATUS)

	@MSG=`$(GET_PLUGIN_PAGE_RESULT_STATUS)`; \
	$(ECHO) "$(COLOR_DONE)Result: $$MSG$(COLOR_OFF)"

# -------------------------------------------------------------------------
# check-roku-dev-target: check the status of the Roku target device.
# -------------------------------------------------------------------------
.PHONY: check-roku-dev-target
check-roku-dev-target:
	@$(CHECK_ROKU_DEV_TARGET)

# -------------------------------------------------------------------------
# run: the install target is 'smart' and doesn't do anything if the package
# didn't change.
# But usually I want to run it even if it didn't change, so force a fresh
# install by doing a remove first.
# Some day we should look at doing the force run via a plugin_install flag,
# but for now just brute force it.
# -------------------------------------------------------------------------
.PHONY: run
run: remove install

# -------------------------------------------------------------------------
# pkg: use to create a pkg file from the application sources.
#
# Usage:
# The application name should be specified via $APPNAME.
# The application version should be specified via $VERSION.
# The developer's signing password (from genkey) should be passed via
# $APP_KEY_PASS, or via stdin, otherwise the script will prompt for it.
# -------------------------------------------------------------------------
.PHONY: pkg
pkg: install
	@$(ECHO) "$(COLOR_START)*** Creating Package ***$(COLOR_OFF)"

	@if [ -e "$(APP_PKG_FILE)" ]; then \
		$(ECHO) "  >> removing old application pkg $(APP_PKG_FILE)"; \
		rm $(APP_PKG_FILE); \
	fi

	@if [ ! -d $(PKGREL) ]; then \
		$(ECHO) "  >> creating destination directory $(PKGREL)"; \
		mkdir -p $(PKGREL); \
	fi

	@if [ ! -w $(PKGREL) ]; then \
		$(ECHO) "  >> setting directory permissions for $(PKGREL)"; \
		chmod 755 $(PKGREL); \
	fi

	@$(CHECK_ROKU_DEV_TARGET)

	@$(ECHO) "Packaging $(APP_NAME)/$(APP_VERSION) to $(APP_PKG_FILE)"

	@if [ -z "$(APP_KEY_PASS)" ]; then \
		read -r -p "Password: " REPLY; \
		echo "$$REPLY" > $(APP_KEY_PASS_TMP); \
	else \
		echo "$(APP_KEY_PASS)" > $(APP_KEY_PASS_TMP); \
	fi

	@rm -f $(DEV_SERVER_TMP_FILE)
	@$(CHECK_ROKU_DEV_PASSWORD)
	@PASSWD=`cat $(APP_KEY_PASS_TMP)`; \
	PKG_TIME=`expr \`date +%s\` \* 1000`; \
	HTTP_STATUS=`curl --user $(USERPASS) --digest --silent --show-error \
		-F "mysubmit=Package" -F "app_name=$(APP_NAME)/$(APP_VERSION)" \
		-F "passwd=$$PASSWD" -F "pkg_time=$$PKG_TIME" \
		--output $(DEV_SERVER_TMP_FILE) \
		--write-out "%{http_code}" \
		http://$(ROKU_DEV_TARGET)/plugin_package`; \
	$(CHECK_DEVICE_HTTP_STATUS)

	@MSG=`$(GET_PLUGIN_PAGE_RESULT_STATUS)`; \
	case "$$MSG" in \
		*Success*) \
			;; \
		*)	$(ECHO) "$(COLOR_ERROR)Result: $$MSG$(COLOR_OFF)"; \
			exit 1 \
			;; \
	esac

	@$(CHECK_ROKU_DEV_PASSWORD)
	@PKG_LINK=`$(GET_PLUGIN_PAGE_PACKAGE_LINK)`; \
	HTTP_STATUS=`curl --user $(USERPASS) --digest --silent --show-error \
		--output $(APP_PKG_FILE) \
		--write-out "%{http_code}" \
		http://$(ROKU_DEV_TARGET)/pkgs/$$PKG_LINK`; \
	$(CHECK_DEVICE_HTTP_STATUS)

	@$(ECHO) "$(COLOR_DONE)*** Package $(APPNAME) complete ***$(COLOR_OFF)"

# -------------------------------------------------------------------------
# app-pkg: use to create a pkg file from the application sources.
# Similar to the pkg target, but does not require a player to do the signing.
# Instead it requires the developer key file and signing password to be
# specified, which are then passed to the app-package desktop tool to create
# the package file.
#
# Usage:
# The application name should be specified via $APPNAME.
# The application version should be specified via $VERSION.
# The developer's key file (.pkg file) should be specified via $APP_KEY_FILE.
# The developer's signing password (from genkey) should be passed via
# $APP_KEY_PASS, or via stdin, otherwise the script will prompt for it.
# -------------------------------------------------------------------------
.PHONY: app-pkg
app-pkg: $(APPNAME) check
	@$(ECHO) "$(COLOR_START)*** Creating package ***$(COLOR_OFF)"

	@$(ECHO) "  >> creating destination directory $(PKGREL)"
	@mkdir -p $(PKGREL) && chmod 755 $(PKGREL)

	@if [ -z "$(APP_KEY_FILE)" ]; then \
		$(ECHO) "$(COLOR_ERROR)ERROR: APP_KEY_FILE not defined$(COLOR_OFF)"; \
		exit 1; \
	fi
	@if [ ! -f "$(APP_KEY_FILE)" ]; then \
		$(ECHO) "$(COLOR_ERROR)ERROR: key file not found: $(APP_KEY_FILE)$(COLOR_OFF)"; \
		exit 1; \
	fi

	@if [ -z "$(APP_KEY_PASS)" ]; then \
		read -r -p "Password: " REPLY; \
		echo "$$REPLY" > $(APP_KEY_PASS_TMP); \
	else \
		echo "$(APP_KEY_PASS)" > $(APP_KEY_PASS_TMP); \
	fi

	@$(ECHO) "Packaging $(APP_NAME)/$(APP_VERSION) to $(APP_PKG_FILE)"

	@if [ -z "$(APP_VERSION)" ]; then \
		$(ECHO) "WARNING: VERSION is not set."; \
	fi

	@PASSWD=`cat $(APP_KEY_PASS_TMP)`; \
	$(APP_PACKAGE_TOOL) package $(APP_ZIP_FILE) \
		-n $(APP_NAME)/$(APP_VERSION) \
		-k $(APP_KEY_FILE) \
		-p "$$PASSWD" \
		-o $(APP_PKG_FILE)

	@rm $(APP_KEY_PASS_TMP)

	@$(ECHO) "$(COLOR_DONE)*** Package $(APPNAME) complete ***$(COLOR_OFF)"

# -------------------------------------------------------------------------
# teamcity: used to build .zip and .pkg file on TeamCity.
# See app-pkg target for info on options for specifying the signing password.
# -------------------------------------------------------------------------
.PHONY: teamcity
teamcity: app-pkg
ifeq ($(IS_TEAMCITY_BUILD),true)
	@$(ECHO) "Adding TeamCity artifacts..."

	sudo rm -rf /tmp/artifacts
	sudo mkdir -p /tmp/artifacts

	cp $(APP_ZIP_FILE) /tmp/artifacts/$(APP_NAME)-$(APP_VERSION).zip
	@$(ECHO) "##teamcity[publishArtifacts '/tmp/artifacts/$(APP_NAME)-$(APP_VERSION).zip']"

	cp $(APP_PKG_FILE) /tmp/artifacts/$(APP_NAME)-$(APP_VERSION).pkg
	@$(ECHO) "##teamcity[publishArtifacts '/tmp/artifacts/$(APP_NAME)-$(APP_VERSION).pkg']"

	@$(ECHO) "TeamCity artifacts complete."
else
	@$(ECHO) "Not running on TeamCity, skipping artifacts."
endif

##########################################################################

# -------------------------------------------------------------------------
# CHECK_NATIVE_TARGET is used to check if the Roku simulator is
# configured.
# -------------------------------------------------------------------------
define CHECK_NATIVE_TARGET
	if [ -z "$(ROKU_NATIVE_DEV)" ]; then \
		$(ECHO) "$(COLOR_ERROR)ERROR: ROKU_NATIVE_DEV not defined$(COLOR_OFF)"; \
		exit 1; \
	i
	if [ ! -d "$(ROKU_NATIVE_DEV)" ]; then \
		$(ECHO) "$(COLOR_ERROR)ERROR: native dev dir not found: $(ROKU_NATIVE_DEV)$(COLOR_OFF)"; \
		exit 1; \
	fi
	if [ ! -d "$(NATIVE_DIST_DIR)" ]; then \
		$(ECHO) "$(COLOR_ERROR)ERROR: native build dir not found: $(NATIVE_DIST_DIR)$(COLOR_OFF)"; \
		exit 1; \
	fi
endef

# -------------------------------------------------------------------------
# install-native: install the app as the dev channel on the Roku simulator.
# -------------------------------------------------------------------------
.PHONY: install-native
install-native: $(APPNAME) check
	@$(CHECK_NATIVE_TARGET)
	@$(ECHO) "$(COLOR_START)Installing $(APPNAME) to native.$(COLOR_OFF)"
	@if [ ! -d "$(NATIVE_DEV_REL)" ]; then \
		mkdir "$(NATIVE_DEV_REL)"; \
	fi
	@$(ECHO) "Source is $(APP_ZIP_FILE)"
	@$(ECHO) "Target is $(NATIVE_DEV_PKG)"
	@cp $(APP_ZIP_FILE) $(NATIVE_DEV_PKG)
	@$(NATIVE_TICKLER)

# -------------------------------------------------------------------------
# remove-native: uninstall the dev channel from the Roku simulator.
# -------------------------------------------------------------------------
.PHONY: remove-native
remove-native:
	@$(CHECK_NATIVE_TARGET)
	@$(ECHO) "$(COLOR_START)Removing $(APPNAME) from native.$(COLOR_OFF)"
	@rm $(NATIVE_DEV_PKG)
	@$(NATIVE_TICKLER)

##########################################################################

# -------------------------------------------------------------------------
# art-jpg-opt: compress any jpg files in the source tree.
# Used by the art-opt target.
# -------------------------------------------------------------------------
APPS_JPG_ART=`\find . -name "*.jpg"`

.PHONY: art-jpg-opt
art-jpg-opt:
	p4 edit $(APPS_JPG_ART)
	for i in $(APPS_JPG_ART); \
	do \
		TMPJ=`mktemp` || return 1; \
		$(ECHO) "optimizing $$i"; \
		(jpegtran -copy none -optimize -outfile $$TMPJ $$i && mv -f $$TMPJ $$i &); \
	done
	wait
	p4 revert -a $(APPS_JPG_ART)

# -------------------------------------------------------------------------
# art-png-opt: compress any png files in the source tree.
# Used by the art-opt target.
# -------------------------------------------------------------------------
APPS_PNG_ART=`\find . -name "*.png"`

.PHONY: art-png-opt
art-png-opt:
	p4 edit $(APPS_PNG_ART)
	for i in $(APPS_PNG_ART); \
	do \
		(optipng -o7 $$i &); \
	done
	wait
	p4 revert -a $(APPS_PNG_ART)

# -------------------------------------------------------------------------
# art-opt: compress any png and jpg files in the source tree using
# lossless compression options.
# This assumes a Perforce client/workspace is configured.
# Modified files are opened for edit in the default changelist.
# -------------------------------------------------------------------------
.PHONY: art-opt
art-opt: art-png-opt art-jpg-opt

##########################################################################

# -------------------------------------------------------------------------
# tr: this target is used to update translation files for an application
#
# Preconditions: 'locale' subdirectory must be present
# Also there must be a locale subdirectory for each desired locale to be output,
# e.g. en_US, fr_CA, es_ES, de_DE, ...
#
# MAKE_TR_OPTIONS may be set to [-t] [-d] etc. in the external environment,
# if needed.
#
# -n => don't add fake translation placeholders, e.g. 'esES: OK'.
# Instead, leave the translation empty so it will only get used when
# an actual translation is provided.
# -------------------------------------------------------------------------
MAKE_TR_OPTIONS ?= -n
.PHONY: tr
tr:
	@if [ ! -d locale ]; then \
		echo "Creating locale directory"; \
		mkdir locale; \
	fi
	@if [ ! -d locale/en_US ]; then \
		echo "Creating locale/en_US directory"; \
		mkdir locale/en_US; \
	fi
ifneq ($(P4CLIENT),)
	@-p4 edit locale/.../translations.xml > /dev/null 2>&1
endif
	@echo "========================================"
	@$(MAKE_TR_TOOL) $(MAKE_TR_OPTIONS)
	@echo "========================================"
ifneq ($(P4CLIENT),)
	@-p4 add locale/*/translations.xml > /dev/null 2>&1
	@-p4 revert locale/en_US/translations.xml > /dev/null 2>&1
	@-p4 revert -a locale/.../translations.xml > /dev/null 2>&1
	@-p4 opened -c default
endif

##########################################################################

# -------------------------------------------------------------------------
# test: this target is used to run tests for an application
# -------------------------------------------------------------------------
.PHONY: test
test: build addtests zip cleanup deploy runtests
	@$(ECHO) "$(COLOR_DONE)*** running tests complete ***$(COLOR_OFF)"

# -------------------------------------------------------------------------
# addtests: add $(APP_TEST_DIR) content into $(APP_BUILD_DIR)
# -------------------------------------------------------------------------
.PHONY: addtests
addtests:
	@$(ECHO) "$(COLOR_START)*** Adding tests to $(APP_BUILD_DIR) ***$(COLOR_OFF)"

	@if [ ! -d $(APP_TEST_DIR) ]; then \
		$(ECHO) "$(COLOR_ERROR)ERROR: $(APP_TEST_DIR) does not exist$(COLOR_OFF)"; \
		exit 1; \
	fi

	mv $(APP_BUILD_DIR)/source/* $(APP_BUILD_DIR)/source
	# rm -rf $(APP_BUILD_DIR)/src $(APP_BUILD_DIR)/components
	cp -r $(APP_TEST_DIR)/$(TEST_SUITES) $(APP_BUILD_DIR)/source
	cp $(APP_TEST_DIR)/source/brstest.brs $(APP_TEST_DIR)/source/Main.brs $(APP_BUILD_DIR)/source
	cp $(APP_TEST_DIR)/manifest $(APP_BUILD_DIR)

# -------------------------------------------------------------------------
# runtests: run tests
# -------------------------------------------------------------------------
.PHONY: runtests
runtests:
	@$(ECHO) "$(COLOR_START)*** Running tests ***$(COLOR_OFF)"

	@if [ ! -f $(TEST_RUNNER_SCRIPT) ]; then \
		$(ECHO) "$(COLOR_ERROR)ERROR: $(TEST_RUNNER_SCRIPT) does not exist$(COLOR_OFF)"; \
		exit 1; \
	fi

	@if [ -e "$(APP_TEST_RESULTS_FILE)" ]; then \
		$(ECHO) "  >> removing old application test results file $(APP_TEST_RESULTS_FILE)"; \
		rm $(APP_TEST_RESULTS_FILE); \
	fi

	@if [ ! -d $(TESTREL) ]; then \
		$(ECHO) "  >> creating destination directory $(TESTREL)"; \
		mkdir -p $(TESTREL); \
	fi

	@if [ ! -w $(TESTREL) ]; then \
		$(ECHO) "  >> setting directory permissions for $(TESTREL)"; \
		chmod 755 $(TESTREL); \
	fi

	curl -d "" http://$(ROKU_DEV_TARGET):8060/keypress/home
	sleep 1
	python -u $(TEST_RUNNER_SCRIPT) -v --ip $(ROKU_DEV_TARGET) --output $(APP_TEST_RESULTS_FILE)

##########################################################################
