ifndef TOPDIR
TOPDIR=..
endif
include $(TOPDIR)/Makefile.global

OBJECTS = $(addsuffix $(OBJEXT),lib.error lib.misc)

build: $(OBJECTS)

$(OBJECTS): %$(OBJEXT): %.c %.h

clean-l:
	rm -f $(OBJECTS)

install-judgehost:
	$(INSTALL_DATA) -t $(DESTDIR)$(judgehost_libdir)    *.php *.sh
	$(INSTALL_PROG) -t $(DESTDIR)$(judgehost_libdir)    alert
