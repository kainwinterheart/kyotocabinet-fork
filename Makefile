# Makefile for Kyoto Cabinet



#================================================================
# Setting Variables
#================================================================


# Generic settings
SHELL = /bin/sh

# Package information
PACKAGE = kyotocabinet
PACKAGE_TARNAME = kyotocabinet
VERSION = 1.2.76
PACKAGEDIR = $(PACKAGE)-$(VERSION)
PACKAGETGZ = $(PACKAGE)-$(VERSION).tar.gz
LIBVER = 16
LIBREV = 13
FORMATVER = 5

# Targets
HEADERFILES = kccommon.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h kcmap.h kcregex.h kcdb.h kcplantdb.h kcprotodb.h kcstashdb.h kccachedb.h kchashdb.h kcdirdb.h kctextdb.h kcpolydb.h kcdbext.h kclangc.h
LIBRARYFILES = libkyotocabinet.a libkyotocabinet.16.13.0.dylib libkyotocabinet.16.dylib libkyotocabinet.dylib
LIBOBJFILES = kcutil.o kcthread.o kcfile.o kccompress.o kccompare.o kcmap.o kcregex.o kcdb.o kcplantdb.o kcprotodb.o kcstashdb.o kccachedb.o kchashdb.o kcdirdb.o kctextdb.o kcpolydb.o kcdbext.o kclangc.o
COMMANDFILES = kcutiltest kcutilmgr kcprototest kcstashtest kccachetest kcgrasstest kchashtest kchashmgr kctreetest kctreemgr kcdirtest kcdirmgr kcforesttest kcforestmgr kcpolytest kcpolymgr kclangctest
MAN1FILES = kcutiltest.1 kcutilmgr.1 kcprototest.1 kcstashtest.1 kccachetest.1 kcgrasstest.1 kchashtest.1 kchashmgr.1 kctreetest.1 kctreemgr.1 kcdirtest.1 kcdirmgr.1 kcforesttest.1 kcforestmgr.1 kcpolytest.1 kcpolymgr.1 kclangctest.1
DOCUMENTFILES = COPYING FOSSEXCEPTION ChangeLog doc kyotocabinet.idl
PCFILES = kyotocabinet.pc

# Install destinations
prefix = /usr/local
exec_prefix = ${prefix}
datarootdir = ${prefix}/share
INCLUDEDIR = ${prefix}/include
LIBDIR = ${exec_prefix}/lib
BINDIR = ${exec_prefix}/bin
LIBEXECDIR = ${exec_prefix}/libexec
DATADIR = ${datarootdir}/$(PACKAGE)
MAN1DIR = ${datarootdir}/man/man1
DOCDIR = ${datarootdir}/doc/${PACKAGE_TARNAME}
PCDIR = ${exec_prefix}/lib/pkgconfig
DESTDIR =

# Building configuration
CC = gcc
CXX = g++
CPPFLAGS = -I. -I$(INCLUDEDIR) -I/usr/local/include -DNDEBUG -D_GNU_SOURCE=1 -D_FILE_OFFSET_BITS=64 -D_REENTRANT -D__EXTENSIONS__ -D_MYZLIB \
  -D_KC_PREFIX="\"$(prefix)\"" -D_KC_INCLUDEDIR="\"$(INCLUDEDIR)\"" \
  -D_KC_LIBDIR="\"$(LIBDIR)\"" -D_KC_BINDIR="\"$(BINDIR)\"" -D_KC_LIBEXECDIR="\"$(LIBEXECDIR)\"" \
  -D_KC_APPINC="\"-I$(INCLUDEDIR)\"" -D_KC_APPLIBS="\"-L$(LIBDIR) -lkyotocabinet -lz -lstdc++ -lpthread -lm -lc \""
CFLAGS = -march=native -m64 -g -O2 -Wall -ansi -pedantic -fPIC -fsigned-char -g0 -O2 -Wno-unused-but-set-variable -Wno-unused-but-set-parameter -Os
CXXFLAGS = -march=native -m64 -g -O2 -Wall -fPIC -fsigned-char -g0 -O2 -Wno-unused-but-set-variable -Wno-unused-but-set-parameter -Os
LDFLAGS = -L. -L$(LIBDIR) -L/usr/local/lib
CMDLDFLAGS = 
CMDLIBS =  -lz -lstdc++ -lpthread -lm -lc 
LIBS = -lz -lstdc++ -lpthread -lm -lc 
RUNENV = DYLD_LIBRARY_PATH=.:/usr/local/lib:
POSTCMD = true



#================================================================
# Suffix rules
#================================================================


.SUFFIXES :
.SUFFIXES : .c .cc .o

.c.o :
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $<

.cc.o :
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) $<



#================================================================
# Actions
#================================================================


all : $(LIBRARYFILES) $(COMMANDFILES)
	@$(POSTCMD)
	@printf '\n'
	@printf '#================================================================\n'
	@printf '# Ready to install.\n'
	@printf '#================================================================\n'


clean :
	rm -rf $(LIBRARYFILES) $(LIBOBJFILES) $(COMMANDFILES) $(CGIFILES) \
	  *.o *.gch a.out check.in check.out gmon.out *.log *.vlog words.tsv \
	  casket* *.kch *.kct *.kcd *.kcf *.wal *.tmpkc* *.kcss *~ hoge moge tako ika


version :
	sed -e 's/_KC_VERSION.*/_KC_VERSION    "$(VERSION)"/' \
	  -e "s/_KC_LIBVER.*/_KC_LIBVER     $(LIBVER)/" \
	  -e "s/_KC_LIBREV.*/_KC_LIBREV     $(LIBREV)/" \
	  -e 's/_KC_FMTVER.*/_KC_FMTVER     $(FORMATVER)/' myconf.h > myconf.h~
	[ -f myconf.h~ ] && mv -f myconf.h~ myconf.h


untabify :
	ls *.cc *.h *.idl | while read name ; \
	  do \
	    sed -e 's/\t/        /g' -e 's/ *$$//' $$name > $$name~; \
	    [ -f $$name~ ] && mv -f $$name~ $$name ; \
	  done


install :
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -Rf $(HEADERFILES) $(DESTDIR)$(INCLUDEDIR)
	mkdir -p $(DESTDIR)$(LIBDIR)
	cp -Rf $(LIBRARYFILES) $(DESTDIR)$(LIBDIR)
	mkdir -p $(DESTDIR)$(BINDIR)
	cp -Rf $(COMMANDFILES) $(DESTDIR)$(BINDIR)
	mkdir -p $(DESTDIR)$(MAN1DIR)
	cd man && cp -Rf $(MAN1FILES) $(DESTDIR)$(MAN1DIR)
	mkdir -p $(DESTDIR)$(DOCDIR)
	cp -Rf $(DOCUMENTFILES) $(DESTDIR)$(DOCDIR)
	mkdir -p $(DESTDIR)$(PCDIR)
	cp -Rf $(PCFILES) $(DESTDIR)$(PCDIR)
	@printf '\n'
	@printf '#================================================================\n'
	@printf '# Thanks for using Kyoto Cabinet.\n'
	@printf '#================================================================\n'


install-strip :
	$(MAKE) DESTDIR=$(DESTDIR) install
	cd $(DESTDIR)$(BINDIR) && strip $(COMMANDFILES)


uninstall :
	-cd $(DESTDIR)$(INCLUDEDIR) && rm -f $(HEADERFILES)
	-cd $(DESTDIR)$(LIBDIR) && rm -f $(LIBRARYFILES)
	-cd $(DESTDIR)$(BINDIR) && rm -f $(COMMANDFILES)
	-cd $(DESTDIR)$(MAN1DIR) && rm -f $(MAN1FILES)
	-cd $(DESTDIR)$(DOCDIR) && rm -rf $(DOCUMENTFILES) && rmdir $(DOCDIR)
	-cd $(DESTDIR)$(PCDIR) && rm -f $(PCFILES)


dist :
	$(MAKE) version
	$(MAKE) untabify
	$(MAKE) distclean
	cd .. && tar cvf - $(PACKAGEDIR) | gzip -c > $(PACKAGETGZ)
	sync ; sync


distclean : clean
	cd example && $(MAKE) clean
	rm -rf Makefile kyotocabinet.pc \
	  config.cache config.log config.status config.tmp autom4te.cache


check :
	$(MAKE) check-util
	$(MAKE) check-proto
	$(MAKE) check-stash
	$(MAKE) check-cache
	$(MAKE) check-grass
	$(MAKE) check-hash
	$(MAKE) check-tree
	$(MAKE) check-dir
	$(MAKE) check-forest
	$(MAKE) check-poly
	$(MAKE) check-langc
	rm -rf casket*
	@printf '\n'
	@printf '#================================================================\n'
	@printf '# Checking completed.\n'
	@printf '#================================================================\n'


check-util :
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcutilmgr version
	$(RUNENV) $(RUNCMD) ./kcutilmgr hex Makefile > check.in
	$(RUNENV) $(RUNCMD) ./kcutilmgr hex -d check.in > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr enc Makefile > check.in
	$(RUNENV) $(RUNCMD) ./kcutilmgr enc -d check.in > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr enc -hex Makefile > check.in
	$(RUNENV) $(RUNCMD) ./kcutilmgr enc -hex -d check.in > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr enc -url Makefile > check.in
	$(RUNENV) $(RUNCMD) ./kcutilmgr enc -url -d check.in > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr enc -quote Makefile > check.in
	$(RUNENV) $(RUNCMD) ./kcutilmgr enc -quote -d check.in > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr ciph -key "hoge" Makefile > check.in
	$(RUNENV) $(RUNCMD) ./kcutilmgr ciph -key "hoge" check.in > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr comp -gz Makefile > check.in
	$(RUNENV) $(RUNCMD) ./kcutilmgr comp -gz -d check.in > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr comp -lzo Makefile > check.in
	$(RUNENV) $(RUNCMD) ./kcutilmgr comp -lzo -d check.in > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr comp -lzma Makefile > check.in
	$(RUNENV) $(RUNCMD) ./kcutilmgr comp -lzma -d check.in > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr hash Makefile > check.in
	$(RUNENV) $(RUNCMD) ./kcutilmgr hash -fnv Makefile > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr hash -path Makefile > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr regex mikio Makefile > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr regex -alt "hirarin" mikio Makefile > check.out
	$(RUNENV) $(RUNCMD) ./kcutilmgr conf
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcutiltest mutex -th 4 -iv -1 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest cond -th 4 -iv -1 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest para -th 4 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest para -th 4 -iv -1 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest file -th 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest file -th 4 -rnd -msiz 1m casket 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest lhmap -bnum 1000 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest lhmap -rnd -bnum 1000 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest thmap -bnum 1000 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest thmap -rnd -bnum 1000 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest talist 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest talist -rnd 10000
	$(RUNENV) $(RUNCMD) ./kcutiltest misc 10000


check-proto :
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcprototest order -etc 10000
	$(RUNENV) $(RUNCMD) ./kcprototest order -th 4 10000
	$(RUNENV) $(RUNCMD) ./kcprototest order -th 4 -rnd -etc 10000
	$(RUNENV) $(RUNCMD) ./kcprototest order -th 4 -rnd -etc -tran 10000
	$(RUNENV) $(RUNCMD) ./kcprototest wicked 10000
	$(RUNENV) $(RUNCMD) ./kcprototest wicked -th 4 -it 4 10000
	$(RUNENV) $(RUNCMD) ./kcprototest tran 10000
	$(RUNENV) $(RUNCMD) ./kcprototest tran -th 2 -it 4 10000
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcprototest order -tree -etc 10000
	$(RUNENV) $(RUNCMD) ./kcprototest order -tree -th 4 10000
	$(RUNENV) $(RUNCMD) ./kcprototest order -tree -th 4 -rnd -etc 10000
	$(RUNENV) $(RUNCMD) ./kcprototest order -tree -th 4 -rnd -etc -tran 10000
	$(RUNENV) $(RUNCMD) ./kcprototest wicked -tree 10000
	$(RUNENV) $(RUNCMD) ./kcprototest wicked -tree -th 4 -it 4 10000
	$(RUNENV) $(RUNCMD) ./kcprototest tran -tree 10000
	$(RUNENV) $(RUNCMD) ./kcprototest tran -tree -th 2 -it 4 10000


check-stash :
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcstashtest order -etc -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcstashtest order -th 4 -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcstashtest order -th 4 -rnd -etc -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcstashtest order -th 4 -rnd -etc -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcstashtest order -th 4 -rnd -etc -tran \
	  -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcstashtest wicked -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcstashtest wicked -th 4 -it 4 -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcstashtest tran -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcstashtest tran -th 2 -it 4 -bnum 5000 10000


check-cache :
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kccachetest order -etc -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kccachetest order -th 4 -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kccachetest order -th 4 -rnd -etc -bnum 5000 -capcnt 10000 10000
	$(RUNENV) $(RUNCMD) ./kccachetest order -th 4 -rnd -etc -bnum 5000 -capsiz 10000 10000
	$(RUNENV) $(RUNCMD) ./kccachetest order -th 4 -rnd -etc -tran \
	  -tc -bnum 5000 -capcnt 10000 10000
	$(RUNENV) $(RUNCMD) ./kccachetest wicked -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kccachetest wicked -th 4 -it 4 -tc -bnum 5000 -capcnt 10000 10000
	$(RUNENV) $(RUNCMD) ./kccachetest tran -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kccachetest tran -th 2 -it 4 -tc -bnum 5000 10000


check-grass :
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcgrasstest order -etc -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcgrasstest order -th 4 -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcgrasstest order -th 4 -rnd -etc -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcgrasstest order -th 4 -rnd -etc -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcgrasstest order -th 4 -rnd -etc -tran \
	  -tc -bnum 5000 -pccap 10k -rcd 500
	$(RUNENV) $(RUNCMD) ./kcgrasstest wicked -bnum 5000 10000
	$(RUNENV) $(RUNCMD) ./kcgrasstest wicked -th 4 -it 4 -tc -bnum 5000 -pccap 10k -rcd 1000
	$(RUNENV) $(RUNCMD) ./kcgrasstest tran -bnum 500 10000
	$(RUNENV) $(RUNCMD) ./kcgrasstest tran -th 2 -it 4 -tc -bnum 5000 -pccap 10k -rcd 5000


check-hash :
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kchashmgr create -otr -apow 1 -fpow 2 -bnum 3 casket
	$(RUNENV) $(RUNCMD) ./kchashmgr inform -st casket
	$(RUNENV) $(RUNCMD) ./kchashmgr set -add casket duffy 1231
	$(RUNENV) $(RUNCMD) ./kchashmgr set -add casket micky 0101
	$(RUNENV) $(RUNCMD) ./kchashmgr set casket fal 1007
	$(RUNENV) $(RUNCMD) ./kchashmgr set casket mikio 0211
	$(RUNENV) $(RUNCMD) ./kchashmgr set casket natsuki 0810
	$(RUNENV) $(RUNCMD) ./kchashmgr set casket micky ""
	$(RUNENV) $(RUNCMD) ./kchashmgr set -app casket duffy kukuku
	$(RUNENV) $(RUNCMD) ./kchashmgr remove casket micky
	$(RUNENV) $(RUNCMD) ./kchashmgr list -pv casket > check.out
	$(RUNENV) $(RUNCMD) ./kchashmgr set casket ryu 1
	$(RUNENV) $(RUNCMD) ./kchashmgr set casket ken 2
	$(RUNENV) $(RUNCMD) ./kchashmgr remove casket duffy
	$(RUNENV) $(RUNCMD) ./kchashmgr set casket ryu syo-ryu-ken
	$(RUNENV) $(RUNCMD) ./kchashmgr set casket ken tatsumaki-senpu-kyaku
	$(RUNENV) $(RUNCMD) ./kchashmgr set -inci casket int 1234
	$(RUNENV) $(RUNCMD) ./kchashmgr set -inci casket int 5678
	$(RUNENV) $(RUNCMD) ./kchashmgr set -incd casket double 1234.5678
	$(RUNENV) $(RUNCMD) ./kchashmgr set -incd casket double 8765.4321
	$(RUNENV) $(RUNCMD) ./kchashmgr get casket mikio
	$(RUNENV) $(RUNCMD) ./kchashmgr get casket ryu
	$(RUNENV) $(RUNCMD) ./kchashmgr import casket lab/numbers.tsv
	$(RUNENV) $(RUNCMD) ./kchashmgr list -pv -px casket > check.out
	$(RUNENV) $(RUNCMD) ./kchashmgr copy casket casket-para
	$(RUNENV) $(RUNCMD) ./kchashmgr dump casket check.out
	$(RUNENV) $(RUNCMD) ./kchashmgr load -otr casket check.out
	$(RUNENV) $(RUNCMD) ./kchashmgr defrag -onl casket
	$(RUNENV) $(RUNCMD) ./kchashmgr setbulk casket aa aaa bb bbb cc ccc dd ddd
	$(RUNENV) $(RUNCMD) ./kchashmgr removebulk casket aa bb zz
	$(RUNENV) $(RUNCMD) ./kchashmgr getbulk casket aa bb cc dd
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashmgr inform -st casket
	$(RUNENV) $(RUNCMD) ./kchashmgr create -otr -otl -onr -apow 1 -fpow 3 \
	  -ts -tl -tc -bnum 1 casket
	$(RUNENV) $(RUNCMD) ./kchashmgr import casket < lab/numbers.tsv
	$(RUNENV) $(RUNCMD) ./kchashmgr set casket mikio kyotocabinet
	$(RUNENV) $(RUNCMD) ./kchashmgr set -app casket tako ikaunini
	$(RUNENV) $(RUNCMD) ./kchashmgr set -app casket mikio kyototyrant
	$(RUNENV) $(RUNCMD) ./kchashmgr set -app casket mikio kyotodystopia
	$(RUNENV) $(RUNCMD) ./kchashmgr get -px casket mikio > check.out
	$(RUNENV) $(RUNCMD) ./kchashmgr list casket > check.out
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashmgr clear casket
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kchashtest order -set -bnum 5000 -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashtest order -get -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashtest order -getw -msiz 5000 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashtest order -rem -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashtest order -bnum 5000 -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashtest order -etc \
	  -bnum 5000 -msiz 50000 -dfunit 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashtest order -th 4 \
	  -bnum 5000 -msiz 50000 -dfunit 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashtest order -th 4 -rnd -etc \
	  -bnum 5000 -msiz 50000 -dfunit 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest order -th 4 -rnd -etc -tran \
	  -bnum 5000 -msiz 50000 -dfunit 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest order -th 4 -rnd -etc -oat \
	  -bnum 5000 -msiz 50000 -dfunit 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest order -th 4 -rnd -etc \
	  -apow 2 -fpow 3 -ts -tl -tc -bnum 5000 -msiz 50000 -dfunit 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest queue \
	  -bnum 5000 -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest queue -rnd \
	  -bnum 5000 -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest queue -th 4 -it 4 \
	  -bnum 5000 -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest queue -th 4 -it 4 -rnd \
	  -bnum 5000 -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest wicked -bnum 5000 -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest wicked -th 4 -it 4 \
	  -bnum 5000 -msiz 50000 -dfunit 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest wicked -th 4 -it 4 -oat \
	  -bnum 5000 -msiz 50000 -dfunit 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest wicked -th 4 -it 4 \
	  -apow 2 -fpow 3 -ts -tl -tc -bnum 10000 -msiz 50000 -dfunit 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kchashtest tran casket 10000
	$(RUNENV) $(RUNCMD) ./kchashtest tran -th 2 -it 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kchashtest tran -th 2 -it 4 \
	  -apow 2 -fpow 3 -ts -tl -tc -bnum 10000 -msiz 50000 -dfunit 4 casket 10000


check-tree :
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kctreemgr create -otr -apow 1 -fpow 2 -bnum 3 casket
	$(RUNENV) $(RUNCMD) ./kctreemgr inform -st casket
	$(RUNENV) $(RUNCMD) ./kctreemgr set -add casket duffy 1231
	$(RUNENV) $(RUNCMD) ./kctreemgr set -add casket micky 0101
	$(RUNENV) $(RUNCMD) ./kctreemgr set casket fal 1007
	$(RUNENV) $(RUNCMD) ./kctreemgr set casket mikio 0211
	$(RUNENV) $(RUNCMD) ./kctreemgr set casket natsuki 0810
	$(RUNENV) $(RUNCMD) ./kctreemgr set casket micky ""
	$(RUNENV) $(RUNCMD) ./kctreemgr set -app casket duffy kukuku
	$(RUNENV) $(RUNCMD) ./kctreemgr remove casket micky
	$(RUNENV) $(RUNCMD) ./kctreemgr list -pv casket > check.out
	$(RUNENV) $(RUNCMD) ./kctreemgr set casket ryu 1
	$(RUNENV) $(RUNCMD) ./kctreemgr set casket ken 2
	$(RUNENV) $(RUNCMD) ./kctreemgr remove casket duffy
	$(RUNENV) $(RUNCMD) ./kctreemgr set casket ryu syo-ryu-ken
	$(RUNENV) $(RUNCMD) ./kctreemgr set casket ken tatsumaki-senpu-kyaku
	$(RUNENV) $(RUNCMD) ./kctreemgr set -inci casket int 1234
	$(RUNENV) $(RUNCMD) ./kctreemgr set -inci casket int 5678
	$(RUNENV) $(RUNCMD) ./kctreemgr set -incd casket double 1234.5678
	$(RUNENV) $(RUNCMD) ./kctreemgr set -incd casket double 8765.4321
	$(RUNENV) $(RUNCMD) ./kctreemgr get casket mikio
	$(RUNENV) $(RUNCMD) ./kctreemgr get casket ryu
	$(RUNENV) $(RUNCMD) ./kctreemgr import casket lab/numbers.tsv
	$(RUNENV) $(RUNCMD) ./kctreemgr list -des -pv -px casket > check.out
	$(RUNENV) $(RUNCMD) ./kctreemgr copy casket casket-para
	$(RUNENV) $(RUNCMD) ./kctreemgr dump casket check.out
	$(RUNENV) $(RUNCMD) ./kctreemgr load -otr casket check.out
	$(RUNENV) $(RUNCMD) ./kctreemgr defrag -onl casket
	$(RUNENV) $(RUNCMD) ./kctreemgr setbulk casket aa aaa bb bbb cc ccc dd ddd
	$(RUNENV) $(RUNCMD) ./kctreemgr removebulk casket aa bb zz
	$(RUNENV) $(RUNCMD) ./kctreemgr getbulk casket aa bb cc dd
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreemgr inform -st casket
	$(RUNENV) $(RUNCMD) ./kctreemgr create -otr -otl -onr -apow 1 -fpow 3 \
	  -ts -tl -tc -bnum 1 casket
	$(RUNENV) $(RUNCMD) ./kctreemgr import casket < lab/numbers.tsv
	$(RUNENV) $(RUNCMD) ./kctreemgr set casket mikio kyotocabinet
	$(RUNENV) $(RUNCMD) ./kctreemgr set -app casket tako ikaunini
	$(RUNENV) $(RUNCMD) ./kctreemgr set -app casket mikio kyototyrant
	$(RUNENV) $(RUNCMD) ./kctreemgr set -app casket mikio kyotodystopia
	$(RUNENV) $(RUNCMD) ./kctreemgr get -px casket mikio > check.out
	$(RUNENV) $(RUNCMD) ./kctreemgr list casket > check.out
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreemgr clear casket
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kctreetest order -set \
	  -psiz 100 -bnum 5000 -msiz 50000 -pccap 100k casket 10000
	$(RUNENV) $(RUNCMD) ./kctreetest order -get \
	  -msiz 50000 -pccap 100k casket 10000
	$(RUNENV) $(RUNCMD) ./kctreetest order -getw \
	  -msiz 5000 -pccap 100k casket 10000
	$(RUNENV) $(RUNCMD) ./kctreetest order -rem \
	  -msiz 50000 -pccap 100k casket 10000
	$(RUNENV) $(RUNCMD) ./kctreetest order \
	  -bnum 5000 -psiz 100 -msiz 50000 -pccap 100k casket 10000
	$(RUNENV) $(RUNCMD) ./kctreetest order -etc \
	  -bnum 5000 -psiz 1000 -msiz 50000 -dfunit 4 -pccap 100k casket 10000
	$(RUNENV) $(RUNCMD) ./kctreetest order -th 4 \
	  -bnum 5000 -psiz 1000 -msiz 50000 -dfunit 4 -pccap 100k casket 10000
	$(RUNENV) $(RUNCMD) ./kctreetest order -th 4 -pccap 100k -rnd -etc \
	  -bnum 5000 -psiz 1000 -msiz 50000 -dfunit 4 -pccap 100k -rcd casket 10000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest order -th 4 -rnd -etc -tran \
	  -bnum 5000 -psiz 1000 -msiz 50000 -dfunit 4 -pccap 100k casket 1000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest order -th 4 -rnd -etc -oat \
	  -bnum 5000 -psiz 1000 -msiz 50000 -dfunit 4 -pccap 100k casket 1000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest order -th 4 -rnd -etc \
	  -apow 2 -fpow 3 -ts -tl -tc -bnum 5000 -psiz 1000 -msiz 50000 -dfunit 4 casket 10000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest queue \
	  -bnum 5000 -psiz 500 -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest queue -rnd \
	  -bnum 5000 -psiz 500 -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest queue -th 4 -it 4 \
	  -bnum 5000 -psiz 500 -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest queue -th 4 -it 4 -rnd \
	  -bnum 5000 -psiz 500 -msiz 50000 casket 10000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest wicked \
	  -bnum 5000 -psiz 1000 -msiz 50000 -pccap 100k casket 10000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest wicked -th 4 -it 4 \
	  -bnum 5000 -msiz 50000 -dfunit 4 -pccap 100k -rcd casket 10000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest wicked -th 4 -it 4 -oat \
	  -bnum 5000 -msiz 50000 -dfunit 4 -pccap 100k casket 1000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest wicked -th 4 -it 4 \
	  -apow 2 -fpow 3 -ts -tl -tc -bnum 10000 -msiz 50000 -dfunit 4 casket 1000
	$(RUNENV) $(RUNCMD) ./kctreemgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kctreetest tran casket 10000
	$(RUNENV) $(RUNCMD) ./kctreetest tran -th 2 -it 4 -pccap 100k casket 10000
	$(RUNENV) $(RUNCMD) ./kctreetest tran -th 2 -it 4 \
	  -apow 2 -fpow 3 -ts -tl -tc -bnum 10000 -msiz 50000 -dfunit 4 -rcd casket 10000


check-dir :
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcdirmgr create -otr casket
	$(RUNENV) $(RUNCMD) ./kcdirmgr inform -st casket
	$(RUNENV) $(RUNCMD) ./kcdirmgr set -add casket duffy 1231
	$(RUNENV) $(RUNCMD) ./kcdirmgr set -add casket micky 0101
	$(RUNENV) $(RUNCMD) ./kcdirmgr set casket fal 1007
	$(RUNENV) $(RUNCMD) ./kcdirmgr set casket mikio 0211
	$(RUNENV) $(RUNCMD) ./kcdirmgr set casket natsuki 0810
	$(RUNENV) $(RUNCMD) ./kcdirmgr set casket micky ""
	$(RUNENV) $(RUNCMD) ./kcdirmgr set -app casket duffy kukuku
	$(RUNENV) $(RUNCMD) ./kcdirmgr remove casket micky
	$(RUNENV) $(RUNCMD) ./kcdirmgr list -pv casket > check.out
	$(RUNENV) $(RUNCMD) ./kcdirmgr set casket ryu 1
	$(RUNENV) $(RUNCMD) ./kcdirmgr set casket ken 2
	$(RUNENV) $(RUNCMD) ./kcdirmgr remove casket duffy
	$(RUNENV) $(RUNCMD) ./kcdirmgr set casket ryu syo-ryu-ken
	$(RUNENV) $(RUNCMD) ./kcdirmgr set casket ken tatsumaki-senpu-kyaku
	$(RUNENV) $(RUNCMD) ./kcdirmgr set -inci casket int 1234
	$(RUNENV) $(RUNCMD) ./kcdirmgr set -inci casket int 5678
	$(RUNENV) $(RUNCMD) ./kcdirmgr set -incd casket double 1234.5678
	$(RUNENV) $(RUNCMD) ./kcdirmgr set -incd casket double 8765.4321
	$(RUNENV) $(RUNCMD) ./kcdirmgr get casket mikio
	$(RUNENV) $(RUNCMD) ./kcdirmgr get casket ryu
	$(RUNENV) $(RUNCMD) ./kcdirmgr import casket lab/numbers.tsv
	$(RUNENV) $(RUNCMD) ./kcdirmgr list -pv -px casket > check.out
	$(RUNENV) $(RUNCMD) ./kcdirmgr copy casket casket-para
	$(RUNENV) $(RUNCMD) ./kcdirmgr dump casket check.out
	$(RUNENV) $(RUNCMD) ./kcdirmgr load -otr casket check.out
	$(RUNENV) $(RUNCMD) ./kcdirmgr setbulk casket aa aaa bb bbb cc ccc dd ddd
	$(RUNENV) $(RUNCMD) ./kcdirmgr removebulk casket aa bb zz
	$(RUNENV) $(RUNCMD) ./kcdirmgr getbulk casket aa bb cc dd
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirmgr inform -st casket
	$(RUNENV) $(RUNCMD) ./kcdirmgr create -otr -otl -onr -tc casket
	$(RUNENV) $(RUNCMD) ./kcdirmgr import casket < lab/numbers.tsv
	$(RUNENV) $(RUNCMD) ./kcdirmgr set casket mikio kyotocabinet
	$(RUNENV) $(RUNCMD) ./kcdirmgr set -app casket tako ikaunini
	$(RUNENV) $(RUNCMD) ./kcdirmgr set -app casket mikio kyototyrant
	$(RUNENV) $(RUNCMD) ./kcdirmgr set -app casket mikio kyotodystopia
	$(RUNENV) $(RUNCMD) ./kcdirmgr get -px casket mikio > check.out
	$(RUNENV) $(RUNCMD) ./kcdirmgr list casket > check.out
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirmgr clear casket
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcdirtest order -set casket 500
	$(RUNENV) $(RUNCMD) ./kcdirtest order -get casket 500
	$(RUNENV) $(RUNCMD) ./kcdirtest order -getw casket 500
	$(RUNENV) $(RUNCMD) ./kcdirtest order -rem casket 500
	$(RUNENV) $(RUNCMD) ./kcdirtest order casket 500
	$(RUNENV) $(RUNCMD) ./kcdirtest order -etc casket 500
	$(RUNENV) $(RUNCMD) ./kcdirtest order -th 4 casket 500
	$(RUNENV) $(RUNCMD) ./kcdirtest order -th 4 -rnd -etc casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest order -th 4 -rnd -etc -tran casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest order -th 4 -rnd -etc -oat casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest order -th 4 -rnd -etc -tc casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest queue casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest queue -rnd casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest queue -th 4 -it 4 casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest queue -th 4 -it 4 -rnd casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest wicked casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest wicked -th 4 -it 4 casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest wicked -th 4 -it 4 -oat casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest wicked -th 4 -it 4 -tc casket 500
	$(RUNENV) $(RUNCMD) ./kcdirmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcdirtest tran casket 500
	$(RUNENV) $(RUNCMD) ./kcdirtest tran -th 2 -it 4 casket 500
	$(RUNENV) $(RUNCMD) ./kcdirtest tran -th 2 -it 4 -tc casket 500


check-forest :
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcforestmgr create -otr -bnum 3 casket
	$(RUNENV) $(RUNCMD) ./kcforestmgr inform -st casket
	$(RUNENV) $(RUNCMD) ./kcforestmgr set -add casket duffy 1231
	$(RUNENV) $(RUNCMD) ./kcforestmgr set -add casket micky 0101
	$(RUNENV) $(RUNCMD) ./kcforestmgr set casket fal 1007
	$(RUNENV) $(RUNCMD) ./kcforestmgr set casket mikio 0211
	$(RUNENV) $(RUNCMD) ./kcforestmgr set casket natsuki 0810
	$(RUNENV) $(RUNCMD) ./kcforestmgr set casket micky ""
	$(RUNENV) $(RUNCMD) ./kcforestmgr set -app casket duffy kukuku
	$(RUNENV) $(RUNCMD) ./kcforestmgr remove casket micky
	$(RUNENV) $(RUNCMD) ./kcforestmgr list -pv casket > check.out
	$(RUNENV) $(RUNCMD) ./kcforestmgr set casket ryu 1
	$(RUNENV) $(RUNCMD) ./kcforestmgr set casket ken 2
	$(RUNENV) $(RUNCMD) ./kcforestmgr remove casket duffy
	$(RUNENV) $(RUNCMD) ./kcforestmgr set casket ryu syo-ryu-ken
	$(RUNENV) $(RUNCMD) ./kcforestmgr set casket ken tatsumaki-senpu-kyaku
	$(RUNENV) $(RUNCMD) ./kcforestmgr set -inci casket int 1234
	$(RUNENV) $(RUNCMD) ./kcforestmgr set -inci casket int 5678
	$(RUNENV) $(RUNCMD) ./kcforestmgr set -incd casket double 1234.5678
	$(RUNENV) $(RUNCMD) ./kcforestmgr set -incd casket double 8765.4321
	$(RUNENV) $(RUNCMD) ./kcforestmgr get casket mikio
	$(RUNENV) $(RUNCMD) ./kcforestmgr get casket ryu
	$(RUNENV) $(RUNCMD) ./kcforestmgr import casket lab/numbers.tsv
	$(RUNENV) $(RUNCMD) ./kcforestmgr list -des -pv -px casket > check.out
	$(RUNENV) $(RUNCMD) ./kcforestmgr copy casket casket-para
	$(RUNENV) $(RUNCMD) ./kcforestmgr dump casket check.out
	$(RUNENV) $(RUNCMD) ./kcforestmgr load -otr casket check.out
	$(RUNENV) $(RUNCMD) ./kcforestmgr setbulk casket aa aaa bb bbb cc ccc dd ddd
	$(RUNENV) $(RUNCMD) ./kcforestmgr removebulk casket aa bb zz
	$(RUNENV) $(RUNCMD) ./kcforestmgr getbulk casket aa bb cc dd
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforestmgr inform -st casket
	$(RUNENV) $(RUNCMD) ./kcforestmgr create -otr -otl -onr \
	  -tc -bnum 1 casket
	$(RUNENV) $(RUNCMD) ./kcforestmgr import casket < lab/numbers.tsv
	$(RUNENV) $(RUNCMD) ./kcforestmgr set casket mikio kyotocabinet
	$(RUNENV) $(RUNCMD) ./kcforestmgr set -app casket tako ikaunini
	$(RUNENV) $(RUNCMD) ./kcforestmgr set -app casket mikio kyototyrant
	$(RUNENV) $(RUNCMD) ./kcforestmgr set -app casket mikio kyotodystopia
	$(RUNENV) $(RUNCMD) ./kcforestmgr get -px casket mikio > check.out
	$(RUNENV) $(RUNCMD) ./kcforestmgr list casket > check.out
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforestmgr clear casket
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcforesttest order -set \
	  -psiz 100 -bnum 5000 -pccap 100k casket 5000
	$(RUNENV) $(RUNCMD) ./kcforesttest order -get \
	  -pccap 100k casket 5000
	$(RUNENV) $(RUNCMD) ./kcforesttest order -getw \
	  -pccap 100k casket 5000
	$(RUNENV) $(RUNCMD) ./kcforesttest order -rem \
	  -pccap 100k casket 5000
	$(RUNENV) $(RUNCMD) ./kcforesttest order \
	  -bnum 5000 -psiz 100 -pccap 100k casket 5000
	$(RUNENV) $(RUNCMD) ./kcforesttest order -etc \
	  -bnum 5000 -psiz 1000 -pccap 100k casket 5000
	$(RUNENV) $(RUNCMD) ./kcforesttest order -th 4 \
	  -bnum 5000 -psiz 1000 -pccap 100k casket 5000
	$(RUNENV) $(RUNCMD) ./kcforesttest order -th 4 -pccap 100k -rnd -etc \
	  -bnum 5000 -psiz 1000 -pccap 100k -rcd casket 5000
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest order -th 4 -rnd -etc -tran \
	  -bnum 500 -psiz 1000 -pccap 100k casket 500
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest order -th 4 -rnd -etc -oat \
	  -bnum 500 -psiz 1000 -pccap 100k casket 500
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest order -th 4 -rnd -etc \
	  -tc -bnum 5000 -psiz 1000 casket 5000
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest queue \
	  -bnum 5000 -psiz 500 casket 5000
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest queue -rnd \
	  -bnum 5000 -psiz 500 casket 5000
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest queue -th 4 -it 4 \
	  -bnum 5000 -psiz 500 casket 5000
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest queue -th 4 -it 4 -rnd \
	  -bnum 5000 -psiz 500 casket 5000
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest wicked \
	  -bnum 5000 -psiz 1000 -pccap 100k casket 5000
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest wicked -th 4 -it 4 \
	  -bnum 5000 -pccap 100k -rcd casket 5000
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest wicked -th 4 -it 4 -oat \
	  -bnum 500 -pccap 100k casket 500
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest wicked -th 4 -it 4 \
	  -tc -bnum 500 casket 500
	$(RUNENV) $(RUNCMD) ./kcforestmgr check -onr casket
	$(RUNENV) $(RUNCMD) ./kcforesttest tran casket 5000
	$(RUNENV) $(RUNCMD) ./kcforesttest tran -th 2 -it 4 -pccap 100k casket 5000
	$(RUNENV) $(RUNCMD) ./kcforesttest tran -th 2 -it 4 \
	  -tc -bnum 5000 -rcd casket 5000


check-poly :
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcpolymgr create -otr "casket.kch#apow=1#fpow=2#bnum=3"
	$(RUNENV) $(RUNCMD) ./kcpolymgr inform -st casket.kch
	$(RUNENV) $(RUNCMD) ./kcpolymgr set -add casket.kch duffy 1231
	$(RUNENV) $(RUNCMD) ./kcpolymgr set -add casket.kch micky 0101
	$(RUNENV) $(RUNCMD) ./kcpolymgr set casket.kch fal 1007
	$(RUNENV) $(RUNCMD) ./kcpolymgr set casket.kch mikio 0211
	$(RUNENV) $(RUNCMD) ./kcpolymgr set casket.kch natsuki 0810
	$(RUNENV) $(RUNCMD) ./kcpolymgr set casket.kch micky ""
	$(RUNENV) $(RUNCMD) ./kcpolymgr set -app casket.kch duffy kukuku
	$(RUNENV) $(RUNCMD) ./kcpolymgr remove casket.kch micky
	$(RUNENV) $(RUNCMD) ./kcpolymgr list -pv casket.kch > check.out
	$(RUNENV) $(RUNCMD) ./kcpolymgr copy casket.kch casket-para
	$(RUNENV) $(RUNCMD) ./kcpolymgr dump casket.kch check.out
	$(RUNENV) $(RUNCMD) ./kcpolymgr load -otr casket.kch check.out
	$(RUNENV) $(RUNCMD) ./kcpolymgr set casket.kch ryu 1
	$(RUNENV) $(RUNCMD) ./kcpolymgr set casket.kch ken 2
	$(RUNENV) $(RUNCMD) ./kcpolymgr remove casket.kch duffy
	$(RUNENV) $(RUNCMD) ./kcpolymgr set casket.kch ryu syo-ryu-ken
	$(RUNENV) $(RUNCMD) ./kcpolymgr set casket.kch ken tatsumaki-senpu-kyaku
	$(RUNENV) $(RUNCMD) ./kcpolymgr set -inci casket.kch int 1234
	$(RUNENV) $(RUNCMD) ./kcpolymgr set -inci casket.kch int 5678
	$(RUNENV) $(RUNCMD) ./kcpolymgr set -incd casket.kch double 1234.5678
	$(RUNENV) $(RUNCMD) ./kcpolymgr set -incd casket.kch double 8765.4321
	$(RUNENV) $(RUNCMD) ./kcpolymgr get "casket.kch" mikio
	$(RUNENV) $(RUNCMD) ./kcpolymgr get "casket.kch" ryu
	$(RUNENV) $(RUNCMD) ./kcpolymgr import casket.kch lab/numbers.tsv
	$(RUNENV) $(RUNCMD) ./kcpolymgr list -pv -px "casket.kch#mode=r" > check.out
	$(RUNENV) $(RUNCMD) ./kcpolymgr setbulk casket.kch aa aaa bb bbb cc ccc dd ddd
	$(RUNENV) $(RUNCMD) ./kcpolymgr removebulk casket.kch aa bb zz
	$(RUNENV) $(RUNCMD) ./kcpolymgr getbulk casket.kch aa bb cc dd
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kch
	$(RUNENV) $(RUNCMD) ./kcpolymgr inform -st casket.kch
	$(RUNENV) $(RUNCMD) ./kcpolymgr create -otr -otl -onr \
	  "casket.kct#apow=1#fpow=3#opts=slc#bnum=1"
	$(RUNENV) $(RUNCMD) ./kcpolymgr import casket.kct < lab/numbers.tsv
	$(RUNENV) $(RUNCMD) ./kcpolymgr set casket.kct mikio kyotocabinet
	$(RUNENV) $(RUNCMD) ./kcpolymgr set -app casket.kct tako ikaunini
	$(RUNENV) $(RUNCMD) ./kcpolymgr set -app casket.kct mikio kyototyrant
	$(RUNENV) $(RUNCMD) ./kcpolymgr set -app casket.kct mikio kyotodystopia
	$(RUNENV) $(RUNCMD) ./kcpolymgr get -px casket.kct mikio > check.out
	$(RUNENV) $(RUNCMD) ./kcpolymgr list casket.kct > check.out
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolymgr clear casket.kct
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcpolytest order -set "casket.kct#bnum=5000#msiz=50000" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest order -get "casket.kct#msiz=50000" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest order -getw "casket.kct#msiz=5000" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest order -rem "casket.kct#msiz=50000" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest order "casket.kct#bnum=5000#msiz=50000" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest order -etc \
	  "casket.kct#bnum=5000#msiz=50000#dfunit=4" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest order -th 4 \
	  "casket.kct#bnum=5000#msiz=50000#dfunit=4" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest order -th 4 -rnd -etc \
	  "casket.kct#bnum=5000#msiz=0#dfunit=1" 1000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest order -th 4 -rnd -etc -tran \
	  "casket.kct#bnum=5000#msiz=0#dfunit=2" 1000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest order -th 4 -rnd -etc -oat \
	  "casket.kct#bnum=5000#msiz=0#dfunit=3" 1000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest order -th 4 -rnd -etc \
	  "casket.kct#apow=2#fpow=3#opts=slc#bnum=5000#msiz=0#dfunit=4" 1000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest queue \
	  "casket.kct#bnum=5000#msiz=0" 10000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest queue -rnd \
	  "casket.kct#bnum=5000#msiz=0" 10000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest queue -th 4 -it 4 \
	  "casket.kct#bnum=5000#msiz=0" 10000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest queue -th 4 -it 4 -rnd \
	  "casket.kct#bnum=5000#msiz=0" 10000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest wicked "casket.kct#bnum=5000#msiz=0" 1000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest wicked -th 4 -it 4 \
	  "casket.kct#bnum=5000#msiz=0#dfunit=1" 1000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest wicked -th 4 -it 4 -oat \
	  "casket.kct#bnum=5000#msiz=0#dfunit=1" 1000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest wicked -th 4 -it 4 \
	  "casket.kct#apow=2#fpow=3#opts=slc#bnum=10000#msiz=0#dfunit=1" 10000
	$(RUNENV) $(RUNCMD) ./kcpolymgr check -onr casket.kct
	$(RUNENV) $(RUNCMD) ./kcpolytest tran casket.kct 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest tran -th 2 -it 4 casket.kct 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest tran -th 2 -it 4 \
	  "casket.kct#apow=2#fpow=3#opts=slc#bnum=10000#msiz=0#dfunit=1" 1000
	$(RUNENV) $(RUNCMD) ./kcpolytest mapred -dbnum 2 -clim 10k casket.kct 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest mapred -tmp . -dbnum 2 -clim 10k -xnl -xnc \
	  casket.kct 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest mapred -tmp . -dbnum 2 -clim 10k -xpm -xpr -xpf -xnc \
	  casket.kct 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest mapred -rnd -dbnum 2 -clim 10k casket.kct 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest index -set "casket.kct#idxclim=32k" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest index -get "casket.kct" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest index -rem "casket.kct" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest index -etc "casket.kct#idxclim=32k" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest index -th 4 -rnd -set \
	  "casket.kct#idxclim=32k#idxdbnum=4" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest index -th 4 -rnd -get "casket.kct" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest index -th 4 -rnd -rem "casket.kct" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest index -th 4 -rnd -etc \
	  "casket.kct#idxclim=32k#idxdbnum=4" 10000
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcpolytest order -rnd "casket.kcx" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest order -th 4 -rnd "casket.kcx" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest wicked "casket.kcx" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest wicked -th 4 "casket.kcx" 10000
	$(RUNENV) $(RUNCMD) ./kcpolymgr list -pv "casket.kcx" > check.out
	$(RUNENV) $(RUNCMD) ./kcpolymgr list -max 1000 -pv "casket.kcx" > check.out
	$(RUNENV) $(RUNCMD) ./kcpolytest mapred "casket.kcx" 10000
	$(RUNENV) $(RUNCMD) ./kcpolytest mapred -xpm -xpr -xpf "casket.kcx" 10000
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcpolytest order -rnd "casket.kch#opts=s#bnum=256" 1000
	$(RUNENV) $(RUNCMD) ./kcpolytest order -rnd "casket.kct#opts=l#psiz=256" 1000
	$(RUNENV) $(RUNCMD) ./kcpolytest order -rnd "casket.kcd#opts=c#bnum=256" 500
	$(RUNENV) $(RUNCMD) ./kcpolytest order -rnd "casket.kcf#opts=c#psiz=256" 500
	$(RUNENV) $(RUNCMD) ./kcpolytest order -rnd "casket.kcx" 500
	$(RUNENV) $(RUNCMD) ./kcpolymgr merge -add "casket#type=kct" \
	  casket.kch casket.kct casket.kcd casket.kcf casket.kcx
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcpolytest misc "casket#type=-"
	$(RUNENV) $(RUNCMD) ./kcpolytest misc "casket#type=+"
	$(RUNENV) $(RUNCMD) ./kcpolytest misc "casket#type=:"
	$(RUNENV) $(RUNCMD) ./kcpolytest misc "casket#type=*#zcomp=def"
	$(RUNENV) $(RUNCMD) ./kcpolytest misc "casket#type=%#zcomp=gz"
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcpolytest misc \
	  "casket#type=kch#log=-#logkinds=debug#mtrg=-#zcomp=lzocrc"
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcpolytest misc \
	  "casket#type=kct#log=-#logkinds=debug#mtrg=-#zcomp=lzmacrc"
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcpolytest misc \
	  "casket#type=kcd#zcomp=arc#zkey=mikio"
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kcpolytest misc \
	  "casket#type=kcf#zcomp=arc#zkey=mikio"


check-langc :
	rm -rf casket*
	$(RUNENV) $(RUNCMD) ./kclangctest order "casket.kch#bnum=5000#msiz=50000" 10000
	$(RUNENV) $(RUNCMD) ./kclangctest order -etc \
	  "casket.kch#bnum=5000#msiz=50000#dfunit=2" 10000
	$(RUNENV) $(RUNCMD) ./kclangctest order -rnd -etc \
	  "casket.kch#bnum=5000#msiz=50000#dfunit=2" 10000
	$(RUNENV) $(RUNCMD) ./kclangctest order -rnd -etc -oat -tran \
	  "casket.kch#bnum=5000#msiz=50000#dfunit=2#zcomp=arcz" 10000
	$(RUNENV) $(RUNCMD) ./kclangctest index "casket.kct#bnum=5000#msiz=50000" 10000
	$(RUNENV) $(RUNCMD) ./kclangctest index -etc \
	  "casket.kct#bnum=5000#msiz=50000#dfunit=2" 10000
	$(RUNENV) $(RUNCMD) ./kclangctest index -rnd -etc \
	  "casket.kct#bnum=5000#msiz=50000#dfunit=2" 10000
	$(RUNENV) $(RUNCMD) ./kclangctest index -rnd -etc -oat \
	  "casket.kct#bnum=5000#msiz=50000#dfunit=2#zcomp=arcz" 10000
	$(RUNENV) $(RUNCMD) ./kclangctest map 10000
	$(RUNENV) $(RUNCMD) ./kclangctest map -etc -bnum 1000 10000
	$(RUNENV) $(RUNCMD) ./kclangctest map -etc -rnd -bnum 1000 10000
	$(RUNENV) $(RUNCMD) ./kclangctest list 10000
	$(RUNENV) $(RUNCMD) ./kclangctest list -etc 10000
	$(RUNENV) $(RUNCMD) ./kclangctest list -etc -rnd 10000


check-valgrind :
	$(MAKE) RUNCMD="valgrind --tool=memcheck --log-file=%p.vlog" check
	grep ERROR *.vlog | grep -v ' 0 errors' ; true
	grep 'at exit' *.vlog | grep -v ' 0 bytes' ; true


check-heavy :
	$(MAKE) check-hash-heavy
	$(MAKE) check-tree-heavy


check-hash-heavy :
	$(RUNENV) ./kchashtest order -th 4 \
	  -apow 2 -fpow 2 -bnum 500000 -msiz 50m -dfunit 2 casket 250000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest order -th 4 -rnd \
	  -apow 2 -fpow 2 -bnum 500000 -msiz 50m -dfunit 2 casket 250000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest order -th 4 -etc \
	  -apow 2 -fpow 2 -bnum 500000 -msiz 50m -dfunit 2 casket 250000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest order -th 4 -etc -rnd \
	  -apow 2 -fpow 2 -bnum 500000 -msiz 50m -dfunit 2 casket 250000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest order -th 4 -etc -rnd \
	  -ts -tl -tc -dfunit 2 casket 25000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest queue -th 4 -it 10 \
	  -bnum 1000000 -apow 4 -fpow 12 -msiz 100m -dfunit 2 casket 250000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest queue -th 4 -it 5 -rnd \
	  -ts -tl -tc -dfunit 2 casket 25000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest queue -th 4 -it 2 -oat -rnd \
	  -bnum 1000 -dfunit 8 casket 25000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest queue -th 4 -it 2 -oas -rnd \
	  -bnum 1000 -dfunit 8 casket 2500
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest wicked -th 4 -it 10 \
	  -bnum 1000000 -apow 4 -fpow 12 -msiz 100m -dfunit 2 casket 250000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest wicked -th 4 -it 5 \
	  -ts -tl -tc -dfunit 2 casket 25000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest wicked -th 4 -it 2 -oat \
	  -bnum 1000 -dfunit 8 casket 25000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest wicked -th 4 -it 2 -oas \
	  -bnum 1000 -dfunit 8 casket 2500
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest tran -th 4 -it 10 \
	  -apow 2 -fpow 2 -bnum 500000 -msiz 50m -dfunit 2 casket 250000
	$(RUNENV) ./kchashmgr check -onr casket
	$(RUNENV) ./kchashtest tran -th 4 -it 5 \
	  -ts -tl -tc -dfunit 2 casket 250000
	$(RUNENV) ./kchashmgr check -onr casket


check-tree-heavy :
	$(RUNENV) ./kctreetest order -th 4 \
	  -apow 2 -fpow 2 -bnum 50000 -psiz 1000 -msiz 50m -dfunit 2 -pccap 10m casket 250000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest order -th 4 -rnd \
	  -apow 2 -fpow 2 -bnum 50000 -psiz 1000 -msiz 50m -dfunit 2 -pccap 10m casket 250000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest order -th 4 -etc \
	  -apow 2 -fpow 2 -bnum 50000 -psiz 1000 -msiz 50m -dfunit 2 -pccap 10m casket 250000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest order -th 4 -etc -rnd \
	  -apow 2 -fpow 2 -bnum 50000 -psiz 1000 -msiz 50m -dfunit 2 -pccap 10m casket 250000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest order -th 4 -etc -rnd \
	  -ts -tl -tc -dfunit 2 casket 25000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest queue -th 4 -it 10 \
	  -bnum 1000000 -apow 4 -fpow 12 -msiz 100m -dfunit 2 -pccap 10m casket 250000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest queue -th 4 -it 5 -rnd \
	  -ts -tl -tc -dfunit 2 -pccap 10m casket 25000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest queue -th 4 -it 2 -oat -rnd \
	  -bnum 1000 -dfunit 8 -pccap 10m casket 25000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest queue -th 4 -it 2 -oas -rnd \
	  -bnum 1000 -dfunit 8 -pccap 10m casket 2500
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest wicked -th 4 -it 5 \
	  -bnum 100000 -apow 4 -fpow 12 -msiz 100m -dfunit 2 -pccap 10m casket 250000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest wicked -th 4 -it 2 \
	  -ts -tl -tc -dfunit 2 -pccap 10m casket 25000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest wicked -th 4 -it 2 -oat \
	  -bnum 1000 -dfunit 8 -pccap 10m casket 25000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest wicked -th 4 -it 2 -oas \
	  -bnum 1000 -dfunit 8 -pccap 10m casket 2500
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest tran -th 4 -it 5 \
	  -apow 2 -fpow 2 -bnum 50000 -msiz 50m -dfunit 2 -pccap 10m casket 250000
	$(RUNENV) ./kctreemgr check -onr casket
	$(RUNENV) ./kctreetest tran -th 4 -it 2 \
	  -ts -tl -tc -dfunit 2 -pccap 10m casket 250000
	$(RUNENV) ./kctreemgr check -onr casket


check-segv :
	$(RUNENV) ./lab/segvtest hash "0.5" 100
	$(RUNENV) ./lab/segvtest hash "" 10
	$(RUNENV) ./lab/segvtest hash "100" 1
	$(RUNENV) ./lab/segvtest hash -oat "0.5" 100
	$(RUNENV) ./lab/segvtest hash -oat "" 10
	$(RUNENV) ./lab/segvtest hash -oat "100" 1
	$(RUNENV) ./lab/segvtest hash -tran "" 10
	$(RUNENV) ./lab/segvtest hash -wicked "" 10
	$(RUNENV) ./lab/segvtest hash -wicked -oat "" 10
	$(RUNENV) ./lab/segvtest tree "0.5" 100
	$(RUNENV) ./lab/segvtest tree "" 10
	$(RUNENV) ./lab/segvtest tree "100" 1
	$(RUNENV) ./lab/segvtest tree -oat "0.5" 100
	$(RUNENV) ./lab/segvtest tree -oat "" 10
	$(RUNENV) ./lab/segvtest tree -oat "100" 1
	$(RUNENV) ./lab/segvtest tree -tran "" 10
	$(RUNENV) ./lab/segvtest tree -wicked "" 10
	$(RUNENV) ./lab/segvtest tree -wicked -oat "" 10
	$(RUNENV) ./lab/segvtest dir -oat "" 10
	$(RUNENV) ./lab/segvtest dir -oat "0.5" 100
	$(RUNENV) ./lab/segvtest dir -oat "" 10
	$(RUNENV) ./lab/segvtest dir -oat "100" 1
	$(RUNENV) ./lab/segvtest dir -tran "" 10
	$(RUNENV) ./lab/segvtest dir -wicked "" 10
	$(RUNENV) ./lab/segvtest dir -wicked -oat "" 10
	$(RUNENV) ./lab/segvtest forest "" 10
	$(RUNENV) ./lab/segvtest forest -oat "0.5" 100
	$(RUNENV) ./lab/segvtest forest -oat "" 10
	$(RUNENV) ./lab/segvtest forest -oat "100" 1
	$(RUNENV) ./lab/segvtest forest -tran "" 10
	$(RUNENV) ./lab/segvtest forest -wicked "" 10
	$(RUNENV) ./lab/segvtest forest -wicked -oat "" 10


check-forever :
	while true ; \
	  do \
	    $(MAKE) check || break ; \
	    $(MAKE) check || break ; \
	    $(MAKE) check || break ; \
	    $(MAKE) check || break ; \
	    $(MAKE) check-heavy || break ; \
	    $(MAKE) check-segv || break ; \
	  done


doc :
	$(MAKE) docclean
	mkdir -p doc/api
	doxygen


docclean :
	rm -rf doc/api


gch :
	$(CXX) -c $(CPPFLAGS) $(CXXFLAGS) *.h


words.tsv :
	cat /usr/share/dict/words | \
	  tr '\t\r' '  ' | grep -v '^ *$$' | cat -n | sort | \
	  LC_ALL=C sed -e 's/^ *//' -e 's/\(^[0-9]*\)\t\(.*\)/\2\t\1/' > words.tsv


def : libkyotocabinet.a
	./lab/makevcdef libkyotocabinet.a > kyotocabinet.def


.PHONY : all clean install check doc



#================================================================
# Building binaries
#================================================================


libkyotocabinet.a : $(LIBOBJFILES)
	$(AR) $(ARFLAGS) $@ $(LIBOBJFILES)


libkyotocabinet.so.$(LIBVER).$(LIBREV).0 : $(LIBOBJFILES)
	if uname -a | egrep -i 'SunOS' > /dev/null ; \
	  then \
	    $(CXX) $(CXXFLAGS) -shared -Wl,-G,-h,libkyotocabinet.so.$(LIBVER) -o $@ \
	      $(LIBOBJFILES) $(LDFLAGS) $(LIBS) ; \
	  else \
	    $(CXX) $(CXXFLAGS) -shared -Wl,-soname,libkyotocabinet.so.$(LIBVER) -o $@ \
	      $(LIBOBJFILES) $(LDFLAGS) $(LIBS) ; \
	  fi


libkyotocabinet.so.$(LIBVER) : libkyotocabinet.so.$(LIBVER).$(LIBREV).0
	ln -f -s libkyotocabinet.so.$(LIBVER).$(LIBREV).0 $@


libkyotocabinet.so : libkyotocabinet.so.$(LIBVER).$(LIBREV).0
	ln -f -s libkyotocabinet.so.$(LIBVER).$(LIBREV).0 $@


libkyotocabinet.$(LIBVER).$(LIBREV).0.dylib : $(LIBOBJFILES)
	$(CXX) $(CXXFLAGS) -dynamiclib -o $@ \
	  -install_name $(LIBDIR)/libkyotocabinet.$(LIBVER).dylib \
	  -current_version $(LIBVER).$(LIBREV).0 -compatibility_version $(LIBVER) \
	  $(LIBOBJFILES) $(LDFLAGS) $(LIBS)


libkyotocabinet.$(LIBVER).dylib : libkyotocabinet.$(LIBVER).$(LIBREV).0.dylib
	ln -f -s libkyotocabinet.$(LIBVER).$(LIBREV).0.dylib $@


libkyotocabinet.dylib : libkyotocabinet.$(LIBVER).$(LIBREV).0.dylib
	ln -f -s libkyotocabinet.$(LIBVER).$(LIBREV).0.dylib $@


kcutiltest : kcutiltest.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kcutilmgr : kcutilmgr.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kcprototest : kcprototest.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kcstashtest : kcstashtest.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kccachetest : kccachetest.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kcgrasstest : kcgrasstest.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kchashtest : kchashtest.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kchashmgr : kchashmgr.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kctreetest : kctreetest.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kctreemgr : kctreemgr.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kcdirtest : kcdirtest.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kcdirmgr : kcdirmgr.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kcforesttest : kcforesttest.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kcforestmgr : kcforestmgr.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kcpolytest : kcpolytest.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kcpolymgr : kcpolymgr.o $(LIBRARYFILES)
	$(CXX) $(CXXFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kclangctest : kclangctest.o $(LIBRARYFILES)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS) $(CMDLDFLAGS) -lkyotocabinet $(CMDLIBS)


kcutil.o : kccommon.h kcutil.h myconf.h

kcthread.o : kccommon.h kcutil.h kcthread.h myconf.h

kcfile.o : kccommon.h kcutil.h kcthread.h kcfile.h myconf.h

kccompress.o : kccommon.h kcutil.h kccompress.h myconf.h

kccompare.o : kccommon.h kcutil.h kccompare.h myconf.h

kcmap.o : kccommon.h kcutil.h kcmap.h myconf.h

kcregex.o : kccommon.h kcutil.h kcregex.h myconf.h

kcdb.o : kccommon.h kcutil.h kcdb.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h

kcplantdb.o : kccommon.h kcutil.h kcdb.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h

kcprotodb.o : kccommon.h kcutil.h kcdb.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcprotodb.h

kcstashdb.o : kccommon.h kcutil.h kcdb.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcstashdb.h

kccachedb.o : kccommon.h kcutil.h kcdb.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kccachedb.h

kchashdb.o : kccommon.h kcutil.h kcdb.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kchashdb.h

kcdirdb.o : kccommon.h kcutil.h kcdb.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcdirdb.h

kctextdb.o : kccommon.h kcutil.h kcdb.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kctextdb.h

kcpolydb.o : kccommon.h kcutil.h kcdb.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcprotodb.h kcstashdb.h kccachedb.h kchashdb.h kcdirdb.h kctextdb.h kcpolydb.h

kcdbext.o : kccommon.h kcutil.h kcdb.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcprotodb.h kcstashdb.h kccachedb.h kchashdb.h kcdirdb.h kctextdb.h \
  kcpolydb.h kcdbext.h

kclangc.o : kccommon.h kcutil.h kcdb.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcprotodb.h kcstashdb.h kccachedb.h kchashdb.h kcdirdb.h kctextdb.h \
  kcpolydb.h kcdbext.h kclangc.h

kcutiltest.o kcutilmgr.o : \
  kccommon.h kcdb.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  cmdcommon.h

kcprototest.o : \
  kccommon.h kcdb.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcprotodb.h cmdcommon.h

kcstashtest.o : \
  kccommon.h kcdb.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcstashdb.h cmdcommon.h

kccachetest.o : \
  kccommon.h kcdb.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kccachedb.h cmdcommon.h

kcgrasstest.o : \
  kccommon.h kcdb.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kccachedb.h cmdcommon.h

kchashtest.o kchashmgr.o : \
  kccommon.h kcdb.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kchashdb.h cmdcommon.h

kctreetest.o kctreemgr.o : \
  kccommon.h kcdb.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kchashdb.h cmdcommon.h

kcdirtest.o kcdirmgr.o : \
  kccommon.h kcdb.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcdirdb.h cmdcommon.h

kcforesttest.o kcforestmgr.o : \
  kccommon.h kcdb.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcdirdb.h cmdcommon.h

kcpolytest.o kcpolymgr.o : \
  kccommon.h kcdb.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcprotodb.h kcstashdb.h kccachedb.h kchashdb.h kcdirdb.h kctextdb.h \
  kcpolydb.h kcdbext.h cmdcommon.h

kclangctest.o : \
  kccommon.h kcdb.h kcutil.h kcthread.h kcfile.h kccompress.h kccompare.h \
  kcmap.h kcregex.h \
  kcplantdb.h kcprotodb.h kcstashdb.h kccachedb.h kchashdb.h kcdirdb.h kctextdb.h \
  kcpolydb.h kcdbext.h kclangc.h



# END OF FILE
