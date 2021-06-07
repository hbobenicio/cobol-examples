BUILDDIR = ./build
BINDIR = ./bin
SRCDIR = ./src

CFLAGS = -Wall -g -DDEBUG -I $(SRCDIR)
COB_CFLAGS = -Wall -fixed -std=default -g -debug

OBJ = $(BUILDDIR)/ffi/posix.o $(BUILDDIR)/redis-client.o
BIN = $(BINDIR)/redis-client

.PHONY: all run clean distclean

all: $(BIN)

$(BIN): $(BINDIR) $(OBJ)
	$(COBC) $(COB_CFLAGS) -x -o $(BIN) src/redis-client.cbl $(OBJ)

$(BUILDDIR)/ffi/posix.o: $(BUILDDIR) src/ffi/posix.c
	$(CC) $(CFLAGS) -c -o $(BUILDDIR)/ffi/posix.o src/ffi/posix.c

$(BUILDDIR)/redis-client.o: $(BUILDDIR) src/redis-client.cbl
	$(COBC) $(COB_CFLAGS) -c -o $(BUILDDIR)/redis-client.o src/redis-client.cbl

$(BUILDDIR):
	mkdir -p $@ $@/ffi

$(BINDIR):
	mkdir -p $@

run: $(BIN)
	LD_LIBRARY_PATH="$(HOME)/bin/gnucobol/gnucobol-3.1-rc1/lib" $(BIN)

clean:
	rm -rfv *.c *.h *.i $(BUILDDIR)

distclean: clean
	rm -rfv $(BINDIR) $(BUILDDIR)
