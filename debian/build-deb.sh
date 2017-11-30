#!/bin/bash
#
# package/build-deb.sh - build the debian package

set -e
set -x

pkgname=mumlib
upstream_major=$(perl -ne 'm{mumlib_VERSION_MAJOR\s+(\d+)} && print $1' CMakeLists.txt)
upstream_minor=$(perl -ne 'm{mumlib_VERSION_MINOR\s+(\d+)} && print $1' CMakeLists.txt)
upstream_version=$upstream_major.$upstream_minor
buildname=$pkgname-$upstream_version
builddir=~/build-$buildname

source_package=$pkgname
downstream_version=1
downstream_arch=amd64

origname=${source_package}_${upstream_version}
origtarball=$origname.orig.tar.gz

rm -rf $builddir
mkdir -p $builddir/$buildname
git archive --output=$builddir/$origtarball HEAD
(cd $builddir/$buildname && tar xzf $builddir/$origtarball)
(cd $builddir/$buildname && dpkg-buildpackage -us -uc)

DEB_PKG=$builddir/mumlib_${upstream_version}-${downstream_version}_$downstream_arch.deb \
    prove debian/t/*.t



