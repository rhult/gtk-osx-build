#!/bin/sh
#
# Script that sets up jhbuild for GTK+ OS X building. Run this to
# checkout jhbuild and the required configuration.
#
# Copyright 2007, 2008 Imendio AB
#

SOURCE=$HOME/Source

if test x`which svn` == x; then
    echo "Svn (subversion) isn't available, please install it and try again."
    exit 1
fi

mkdir -p $SOURCE
cd $SOURCE

echo "Checking out jhbuild from subversion..."
if ! test -d $SOURCE/jhbuild; then
    svn co http://svn.gnome.org/svn/jhbuild/trunk jhbuild >/dev/null
else
    (cd jhbuild && svn up >/dev/null)
fi

echo "Installing jhbuild..."
(cd jhbuild && make -f Makefile.plain DISABLE_GETTEXT=1 install >/dev/null)

echo "Installing jhbuild configuration..."
curl http://people.imendio.com/richard/gtk-osx-build/jhbuildrc-gtk-osx -o $HOME/.jhbuildrc
curl http://people.imendio.com/richard/gtk-osx-build/jhbuildrc-gtk-osx-fw-10.4 -o $HOME/.jhbuildrc-fw-10.4
if [ ! -f $HOME/.jhbuildrc-custom ]; then
    curl http://people.imendio.com/richard/gtk-osx-build/jhbuildrc-gtk-osx-custom-example -o $HOME/.jhbuildrc-custom
fi

# FIXME: Check if $HOME/bin is in the path and warn if not.

echo "Done."
