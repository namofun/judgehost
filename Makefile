# Main Makefile

# Define TOPDIR from shell command and _not_ $(PWD) because that gives
# pwd before changing to a 'make -C <dir>' <dir>:
export TOPDIR = $(shell pwd)

REC_TARGETS=build judgehost install-judgehost

# Global Makefile definitions
include $(TOPDIR)/Makefile.global

default: build
install: install-judgehost
all: build
build: judgehost

# MAIN TARGETS
judgehost: paths.mk config
install-judgehost: judgehost judgehost-create-dirs
dist: configure

# Generate configuration files from configure settings:
config:
	$(MAKE) -C etc config

# Special rule to build any compile/run/compare scripts. This is
# useful for testing, e.g. when submitting a Coverity scan.
build-scripts:
	$(MAKE) -C sql build-scripts

# List of SUBDIRS for recursive targets:
build:             SUBDIRS=    lib       misc-tools
judgehost:         SUBDIRS=etc     judge misc-tools
install-judgehost: SUBDIRS=etc lib judge misc-tools
dist:              SUBDIRS=    lib       misc-tools
clean:             SUBDIRS=etc lib judge misc-tools
distclean:         SUBDIRS=etc lib judge misc-tools
maintainer-clean:  SUBDIRS=etc lib judge misc-tools

judgehost-create-dirs:
	$(INSTALL_DIR) $(addprefix $(DESTDIR),$(judgehost_dirs))

# As final step try set ownership and permissions of a few special
# files/directories. Print a warning and fail gracefully if this
# doesn't work because we're not root.
check-root:
	@if [ `id -u` -ne 0 -a -z "$(QUIET)" ]; then \
		echo "**************************************************************" ; \
		echo "***  You do not seem to have the required root privileges. ***" ; \
		echo "***       Perform any failed commands below manually.      ***" ; \
		echo "**************************************************************" ; \
	fi

dist-l:
	$(MAKE) clean-autoconf

# Run aclocal separately from autoreconf, which doesn't pass -I option.
aclocal.m4: configure.ac $(wildcard m4/*.m4)
	aclocal -I m4

configure: configure.ac aclocal.m4
	autoheader
	autoconf

paths.mk:
	@echo "The file 'paths.mk' is not available. Probably you"
	@echo "have not run './configure' yet, aborting..."
	@exit 1

# Configure for running in source tree, not meant for normal use:
MAINT_CXFLAGS=-g -O1 -Wall -fstack-protector -D_FORTIFY_SOURCE=2 \
              -fPIE -Wformat -Wformat-security -pedantic
MAINT_LDFLAGS=-fPIE -pie -Wl,-z,relro -Wl,-z,now
maintainer-conf: dist composer-dependencies-dev
	./configure $(subst 1,-q,$(QUIET)) --prefix=$(CURDIR) \
	            --with-judgehost_root=$(CURDIR) \
	            --with-judgehost_logdir=$(CURDIR)/output/log \
	            --with-judgehost_rundir=$(CURDIR)/output/run \
	            --with-judgehost_tmpdir=$(CURDIR)/output/tmp \
	            --with-judgehost_judgedir=$(CURDIR)/output/judgings \
	            CFLAGS='$(MAINT_CXFLAGS) -std=c11' \
	            CXXFLAGS='$(MAINT_CXFLAGS) -std=c++11' \
	            LDFLAGS='$(MAINT_LDFLAGS)' \
	            $(CONFIGURE_FLAGS)

# Install the system in place: don't really copy stuff, but create
# symlinks where necessary to let it work from the source tree.
# This stuff is a hack!
maintainer-install: build judgehost-create-dirs
# Replace libjudgedir with symlink to prevent lots of symlinks:
	-rmdir $(judgehost_libjudgedir)
	-rm -f $(judgehost_libjudgedir)
	ln -sf $(CURDIR)/judge  $(judgehost_libjudgedir)
# Add symlinks to binaries:
	$(MKDIR_P) $(judgehost_bindir)
	ln -sf $(CURDIR)/judge/judgedaemon $(judgehost_bindir)
	ln -sf $(CURDIR)/judge/runguard $(judgehost_bindir)
	ln -sf $(CURDIR)/judge/runpipe  $(judgehost_bindir)
	$(MAKE) -C misc-tools maintainer-install

# Removes created symlinks; generated logs, submissions, etc. remain in output subdir.
maintainer-uninstall:
	rm -f $(judgehost_libjudgedir)
	rm -rf $(judgehost_bindir)

distclean-l: clean-autoconf
	-rm -f paths.mk

maintainer-clean-l:
	-rm -f configure aclocal.m4

clean-autoconf:
	-rm -rf config.status config.cache config.log autom4te.cache

.PHONY: $(addsuffix -create-dirs,judgehost) check-root \
        clean-autoconf $(addprefix maintainer-,conf install uninstall) \
        config
