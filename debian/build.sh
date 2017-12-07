#!/bin/bash
#
# package/build-deb.sh - build the debian package

set -e
set -x

echo "DEBUG: PWD=$PWD" >&2
echo "DEBUG: ls -la - $(ls -la)" >&2

pkgname=mumlib
upstream_major=$(perl -ne 'm{mumlib_VERSION_MAJOR\s+(\d+)} && print $1' CMakeLists.txt)
upstream_minor=$(perl -ne 'm{mumlib_VERSION_MINOR\s+(\d+)} && print $1' CMakeLists.txt)
upstream_version=${upstream_major}.${upstream_minor}
buildname=${pkgname}-${upstream_version}
builddir=~/build-$buildname

source_package=$pkgname
downstream_version=1
downstream_arch=amd64

origname=${source_package}_${upstream_version}
origtarball=$origname.orig.tar.gz

rm -rf $builddir
mkdir -p $builddir/$buildname

# When using TeamCity and a vagrant instance, the internal git data is not
# resolvable :-(
#git archive --output=$builddir/$origtarball HEAD
tar czf $builddir/$origtarball --exclude .gitignore --exclude .git --exclude Vagrantfile .

(cd $builddir/$buildname && tar xzf $builddir/$origtarball)
(cd $builddir/$buildname && dpkg-buildpackage -us -uc)

DEB_PKG=$builddir/mumlib_${upstream_version}-${downstream_version}_$downstream_arch.deb \
    prove debian/t/*.t

mv $builddir/mumlib_${upstream_version}-${downstream_version}_$downstream_arch.deb .

echo "DEBUG: find . -name \*.deb"
find . -name \*.deb


