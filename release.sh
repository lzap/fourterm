#!/bin/bash
DIR=~/work/fedorapeople/public_html/projects/fourterm/releases
tito build --srpm -o $DIR
LATESTSRPM=$(ls -ct1 $DIR/*src.rpm | head -1)
koji build --scratch --nowait dist-rawhide $LATESTSRPM
$DIR/../../../../copy-content
