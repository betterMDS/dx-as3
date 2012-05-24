#!/bin/sh

dt="`eval date +%Y%m%d`"
tm="`eval date +%R`"
echo "|____________________________Building DX Video_______________________________|"
echo "Using build date $dt.$tm"
/Users/mikewilcox/scripts/flex/bin/mxmlc -compiler.debug -compiler.verbose-stacktraces  -default-frame-rate=10 -define+=NAMES::buildDate,"'$dt.$tm'" -source-path=../ ../dx/Video.as -output="../../dx-media/resources/video.swf"
echo "DX Video built"
