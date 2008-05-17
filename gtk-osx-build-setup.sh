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
(cd jhbuild && make -f Makefile.plain DISABLE_GETTEXT=1 install >/dev/null)

echo "Downloading and installing gtk-osx jhbuild setup..."
#curl -O ... test
#(cd gtk-osx-build; ln -sfh `pwd`/jhbuildrc-gtk-osx $HOME/.jhbuildrc)
(#cd gtk-osx-build; ln -sfh `pwd`/jhbuildrc-gtk-osx-fw-10.4 $HOME/.jhbuildrc-fw-10.4)
#if [ ! -f $HOME/.jhbuildrc-custom ]; then
#    (cd gtk-osx-build; cp jhbuildrc-gtk-osx-custom-example $HOME/.jhbuildrc-custom)
#fi

echo "Done."

