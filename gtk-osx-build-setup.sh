#!/bin/sh

SOURCE=$HOME/Source
mkdir -p $SOURCE

cd $SOURCE

echo "Checking out jhbuild from subversion..."
if ! test -d $SOURCE/jhbuild; then
    svn co http://svn.gnome.org/svn/jhbuild/trunk jhbuild >/dev/null
else
    (cd jhbuild && svn up >/dev/null)
fi

echo "Installing jhbuild..."
(cd jhbuild && make -f Makefile.plain install >/dev/null)

echo "Checking out gtk-osx build setup from subversion..."
if ! test -d $SOURCE/gtk-osx-build; then
    svn co http://developer.imendio.com/svn/gtk-osx-build >/dev/null
else
    (cd gtk-osx-build && svn up >/dev/null)
fi

echo "Installing gtk-osx build setup..."
(cd gtk-osx-build; ln -sfh `pwd`/jhbuildrc-gtk-osx $HOME/.jhbuildrc)
(cd gtk-osx-build; ln -sfh `pwd`/jhbuildrc-gtk-osx-fw-10.4 $HOME/.jhbuildrc-fw-10.4)
(cd gtk-osx-build; cp jhbuildrc-gtk-osx-custom-example $HOME/.jhbuildrc-custom)

if test "x$1" == "xmaintainer-mode"; then
    echo "Setting up extra modulesets for maintainer mode..."
    cd gtk-osx-build
    for f in `ls *modules`; do
        ln -sfh `pwd`/$f $SOURCE/jhbuild/modulesets/
    done
    cd ..
fi

echo "Done."
