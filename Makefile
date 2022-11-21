#
# Makefile for Asterisk voicemail application
# Copyright (C) 2015, Sipwise Development Team <support@sipwise.com>
#
# This program is free software, distributed under the terms of
# the GNU General Public License Version 2. See the COPYING file
# at the top of the source tree.

INSTALL=install
ASTLIBDIR?=/usr/lib/asterisk/modules
MODULES_DIR=$(INSTALL_PREFIX)$(ASTLIBDIR)
ASTETCDIR=$(INSTALL_PREFIX)/etc/asterisk

CC?=gcc
OPTIMIZE=-O2
DEBUG=-g

LIBS+=
CFLAGS+=-pipe -fPIC
CFLAGS+=-Wall -Wextra -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations
CFLAGS+=-D_REENTRANT -D_GNU_SOURCE -DODBC_STORAGE

all: _all
	@echo " +-------- app_voicemail Build Complete --------+"
	@echo " + app_voicemail has successfully been built,   +"
	@echo " + and can be installed by running:             +"
	@echo " +                                              +"
	@echo " +               make install                   +"
	@echo " +----------------------------------------------+"

_all: apps/app_voicemail.so apps/app_playback.so

apps/app_voicemail.o: apps/app_voicemail.c
	$(CC) $(CFLAGS) $(DEBUG) $(OPTIMIZE) -c -o $@ $<

apps/app_voicemail.so: apps/app_voicemail.o
	$(CC) -shared -Xlinker -x -o $@ $< $(LIBS)

apps/app_playback.o: apps/app_playback.c
	$(CC) $(CFLAGS) $(DEBUG) $(OPTIMIZE) -c -o $@ $<

apps/app_playback.so: apps/app_playback.o
	$(CC) -shared -Xlinker -x -o $@ $< $(LIBS)

clean:
	rm -f apps/app_voicemail.o apps/app_voicemail.so \
		  apps/app_playback.o apps/app_playback.so

install: _all
	$(INSTALL) -m 755 -d $(DESTDIR)$(MODULES_DIR)
	$(INSTALL) -m 755 apps/app_voicemail.so $(DESTDIR)$(MODULES_DIR)
	$(INSTALL) -m 755 apps/app_playback.so $(DESTDIR)$(MODULES_DIR)
	@echo " +---- apps/app_voicemail Installation Complete ------+"
	@echo " +                                                    +"
	@echo " + apps/app_voicemail has successfully been installed +"
	@echo " +----------------------------------------------------+"

