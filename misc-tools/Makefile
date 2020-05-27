ifndef TOPDIR
TOPDIR=..
endif
include $(TOPDIR)/Makefile.global

TARGETS =
OBJECTS =

SUBST_JUDGEHOST = create_cgroups dj_make_chroot dj_run_chroot dj_make_chroot_docker

SUBST_FILES = $(SUBST_JUDGEHOST) create-cgroups.service

build: $(TARGETS) $(SUBST_FILES)

judgehost: $(SUBST_JUDGEHOST) create-cgroups.service

$(SUBST_FILES): %: %.in $(TOPDIR)/paths.mk
	$(substconfigvars)

install-judgehost:
	$(INSTALL_PROG) -t $(DESTDIR)$(judgehost_bindir) $(SUBST_JUDGEHOST) \
		dj_make_ubuntu_java_chroot
	mkdir -p $(DESTDIR)$(libdir)/systemd/system/
	$(INSTALL_DATA) -t $(DESTDIR)$(libdir)/systemd/system/ create-cgroups.service

maintainer-install:
	for i in $(SUBST_JUDGEHOST) dj_make_ubuntu_java_chroot ; do \
		ln -sf $(CURDIR)/$$i $(judgehost_bindir) ; \
	done

clean-l:
	-rm -f $(TARGETS) $(OBJECTS)

distclean-l:
	-rm -f $(SUBST_FILES)
