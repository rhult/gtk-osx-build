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

do_exit()
{
    echo $1
    exit 1
}

if test x`which svn` == x; then
    do_exit "Svn (subversion) isn't available, please install it and try again."
fi

if test ! -d $SOURCE; then
    do_exit "The directory $SOURCE does not exist, please create it and try again."
fi

if test ! -d $SOURCE/gtk-osx-build; then
    do_exit "The directory $SOURCE/gtk-osx-build does not exist, please check it out from git and try again."
fi

cd $SOURCE

JHBUILD_REVISION=`cat $SOURCE/gtk-osx-build/jhbuild-revision 2>/dev/null`
if test x"$JHBUILD_REVISION" = x; then
    do_exit "Could not find jhbuild revision to use."
fi

JHBUILD_REVISION_OPTION="-r$JHBUILD_REVISION"

echo "Checking out jhbuild ($JHBUILD_REVISION) from subversion..."
if ! test -d $SOURCE/jhbuild; then
    svn co $JHBUILD_REVISION_OPTION http://svn.gnome.org/svn/jhbuild/trunk jhbuild >/dev/null
else
    (cd jhbuild && svn up $JHBUILD_REVISION_OPTION >/dev/null)
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
