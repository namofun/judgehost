ifndef TOPDIR
TOPDIR=..
endif
include $(TOPDIR)/Makefile.global

# Note:
# Although the *.secret files are generated during
# building/installing, we only remove them with 'distclean', for in
# maintainer-install mode it's inconvenient to have these regenerated
# with different passwords from those in the database.
#
# These files should probably not be generated in the source tree
# anyway, but it is more convenient to be able to share the passwords
# between domserver and judgehost installs.

SUBST_CONFIGS = judgehost-static.php runguard-config.h sudoers-domjudge

$(SUBST_CONFIGS): %: %.in $(TOPDIR)/paths.mk
	$(substconfigvars)

config: $(SUBST_CONFIGS)

judgehost:

install-judgehost:
	$(INSTALL_DATA) -t $(DESTDIR)$(judgehost_etcdir) \
		judgehost-static.php sudoers-domjudge
	$(INSTALL_DATA) -t $(DESTDIR)$(judgehost_etcdir) \
		judgehost-config.php common-config.php
# Password files are installed from root Makefile.

distclean-l:
	-rm -f $(SUBST_CONFIGS) config.h

maintainer-clean-l:
	-rm -f config.h.in
