SHELL := /bin/bash

#########################################################################
# common include file for application Makefiles
#
# Makefile Usage:
# > make
# > make install
# > make remove
# > make pkg
# > make clean
# > make test
#
# to exclude certain files from being added to the zipfile during packaging
# include a line like this:ZIP_EXCLUDE= -x keys\*
# that will exclude any file who's name begins with 'keys'
# to exclude using more than one pattern use additional '-x <pattern>' arguments
# ZIP_EXCLUDE= -x \*.pkg -x storeassets\*
#
# Important Notes:
# To use the "install" and "remove" targets to install your
# application directly from the shell, you must do the following:
#
# 1) Make sure that you have the curl command line executable in your path
# 2) Set the variable ROKU_DEV_TARGET in your environment to the IP
#    address of your Roku box. (e.g. export ROKU_DEV_TARGET=192.168.1.1.
#    Set in your this variable in your shell startup (e.g. .bashrc)
##########################################################################
APPNAME = "brsHamcrest"

PKGREL = out
ZIPREL = out
TSTREL = tst
SOURCEREL = source
TESTREL = tests
ZIP_EXCLUDE = -x *.DS_Store
TEST_RUNNER_SCRIPT = tests/testrunner/brstestrunner.py
APP_TEST_RESULTS_FILE = $(TSTREL)/$(APPNAME).xml

ROKU_DEV_USERNAME ?= rokudev
ROKU_DEV_PASSWORD ?= abcd123
CURL = curl --anyauth -u $(ROKU_DEV_USERNAME):$(ROKU_DEV_PASSWORD)


.PHONY: all $(APPNAME)

$(APPNAME): $(APPDEPS)
	@echo "*** Creating $(APPNAME).zip ***"

	@echo "  >> removing old application zip $(ZIPREL)/$(APPNAME).zip"
	@if [ -e "$(ZIPREL)/$(APPNAME).zip" ]; \
	then \
		rm  $(ZIPREL)/$(APPNAME).zip; \
	fi

	@echo "  >> creating destination directory $(ZIPREL)"
	@if [ ! -d $(ZIPREL) ]; \
	then \
		mkdir -p $(ZIPREL); \
	fi

	@echo "  >> setting directory permissions for $(ZIPREL)"
	@if [ ! -w $(ZIPREL) ]; \
	then \
		chmod 755 $(ZIPREL); \
	fi

# zip .png files without compression
# do not zip up Makefiles, or any files ending with '~'
	@echo "  >> creating application zip $(ZIPREL)/$(APPNAME).zip"
	@if [ -d $(SOURCEREL) ]; \
	then \
		(zip -0 -r "$(ZIPREL)/$(APPNAME).zip" $(SOURCEREL) -i \*.png $(ZIP_EXCLUDE)); \
		(zip -9 -r "$(ZIPREL)/$(APPNAME).zip" $(SOURCEREL) -x \*~ -x \*.png -x Makefile $(ZIP_EXCLUDE)); \
	else \
		echo "Source for $(APPNAME) not found at $(SOURCEREL)"; \
	fi

	@echo "*** developer zip  $(APPNAME) complete ***"

addtests:
	@echo "Adding tests to zip"
	@if [ -d $(TESTREL) ]; \
		then \
		cd tests; \
		zip -9 -r ../$(ZIPREL)/$(APPNAME).zip $(SOURCEREL) -x \*~ $(ZIP_EXCLUDE); \
		zip -9 -r ../$(ZIPREL)/$(APPNAME).zip manifest; \
		cd ..; \
	fi

install: $(APPNAME)
	@echo "Installing $(APPNAME) to device"
	@$(CURL) -s -S -F "mysubmit=Install" -F "archive=@$(ZIPREL)/$(APPNAME).zip" -F "passwd=" http://$(ROKU_DEV_TARGET)/plugin_install | grep "<font color" | sed "s/<font color=\"red\">//"

test: $(APPNAME) addtests install
	@echo "Running tests"
	@sleep 1
	@curl -d "" http://$(ROKU_DEV_TARGET):8060/keypress/home
	@sleep 1
	@python -u $(TEST_RUNNER_SCRIPT) --ip $(ROKU_DEV_TARGET) --output $(APP_TEST_RESULTS_FILE)

pkg: ROKU_PKG_PASSWORD ?= "$(shell read -p "Roku packaging password: " REPLY; echo $$REPLY)"
pkg: install
	@echo "*** Creating Package ***"

	@echo "  >> creating destination directory $(PKGREL)"
	@if [ ! -d $(PKGREL) ]; \
	then \
		mkdir -p $(PKGREL); \
	fi

	@echo "  >> setting directory permissions for $(PKGREL)"
	@if [ ! -w $(PKGREL) ]; \
	then \
		chmod 755 $(PKGREL); \
	fi

	@echo "Packaging  $(APPNAME) to device"

	$(eval PKGFILE := $(shell $(CURL) -s -S -Fmysubmit=Package -Fapp_name=$(APPNAME)/$(VERSION) -Fpasswd=$(ROKU_PKG_PASSWORD) -Fpkg_time=`date +%s` "http://$(ROKU_DEV_TARGET)/plugin_package" | grep 'pkgs' | sed 's/.*href=\"\([^\"]*\)\".*/\1/' | sed 's#pkgs//##'))
	@echo $(PKGFILE)

	@if [ -z $(PKGFILE) ]; \
	then \
		echo "Package createion failed! Have you rekeyed your Roku?"; \
		exit 1; \
	fi

	$(eval PKGFULLPATH := $(PKGREL)/$(APPTITLE)_$(PKGFILE))
	@echo "Downloading package to " $(PKGFULLPATH)
	http -v --auth-type digest --auth $(ROKU_DEV_USERNAME):$(ROKU_DEV_PASSWORD) -o $(PKGFULLPATH) -d http://$(ROKU_DEV_TARGET)/pkgs/$(PKGFILE)

	@if [ ! -f ""$(PKGFULLPATH)"" ]; \
	then \
		echo "Package download failed! File does not exist: " $(PKGFULLPATH); \
		exit 2; \
	fi

	@echo "*** Package $(APPTITLE) complete ***"

remove:
	@echo "Removing $(APPNAME) from device"
	@$(CURL) -s -S -F "mysubmit=Delete" -F "archive=" -F "passwd=" http://$(ROKU_DEV_TARGET)/plugin_install | grep "<font color" | sed "s/<font color=\"red\">//"

clean:
	@echo "Cleaning $(APPNAME) zip and package directories"
	@rm -rf $(ZIPREL)
	@rm -rf $(PKGREL)
	@rm -rf $(TSTREL)
