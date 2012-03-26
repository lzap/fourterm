#!/bin/bash
ROOT=~/rpmbuild
mkdir -p $ROOT/SOURCES 2>/dev/null
waf distclean dist
mv fourterm-*.tar.bz2 $ROOT/SOURCES
rpmbuild -ba fourterm.spec --clean --rmsource
mkdir -p dist 2>/dev/null
mv $ROOT/SRPMS/fourterm*rpm $ROOT/RPMS/x86_64/fourterm*rpm dist
#rm -rf $ROOT
