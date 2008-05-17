#!/bin/sh
#
# Script that sets up jhbuild, and the jhbuildrc files and moduleset
# files as symlinks from the git repository.  This version is for
# maintainers of the setup. If you are a user, just run the
# gtk-osx-build-setup.sh script.
#
# Copyright 2007, 2008 Imendio AB
#

SOURCE=$HOME/Source

if test x`which svn` == x; then
    echo "Svn (subversion) isn't available, please install it and try again."
    exit 1
fi

if test ! -d $SOURCE; then
    echo "The directory $SOURCE does not exist, please create it and try again."
    exit 1
fi

if test ! -d $SOURCE/gtk-osx-build; then
    echo "The directory $SOURCE/gtk-osx-build does not exist, please check it out from git and try again."
    exit 1
fi

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
cd gtk-osx-build
ln -sfh `pwd`/jhbuildrc-gtk-osx $HOME/.jhbuildrc
ln -sfh `pwd`/jhbuildrc-gtk-osx-fw-10.4 $HOME/.jhbuildrc-fw-10.4
ln -sfh `pwd`/jhbuildrc-gtk-osx-cfw-10.4 $HOME/.jhbuildrc-cfw-10.4
if [ ! -f $HOME/.jhbuildrc-custom ]; then
    cp jhbuildrc-gtk-osx-custom-example $HOME/.jhbuildrc-custom
fi

echo "Setting up modulesets..."
cd modulesets
for f in `ls *modules`; do
    ln -sfh `pwd`/$f $SOURCE/jhbuild/modulesets/
done

echo "Done."
