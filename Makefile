all:
	@echo "Use make install to install."

install:
	mkdir -p $(HOME)/bin
	install gtk-osx-build $(HOME)/bin
