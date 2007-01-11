CC = gcc
CFLAGS = -Wall -O2

bindir=$(HOME)/bin

all: install-check

install-check: install-check.c
	$(CC) $(CFLAGS) -o install-check install-check.c

install: all
	@mkdir -p $(bindir)
	@install -m755 gtk-osx-build $(bindir)/gtk-osx-build	
	@install -m755 install-check $(bindir)/install-check

clean:
	@rm -f install-check
