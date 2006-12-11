all:
	@echo "Use make install to install."

install:
	mkdir $(HOME)/bin
	install gtk-osx-build $(HOME)/bin
