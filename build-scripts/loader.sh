#!/bin/sh

dt="`eval date +%Y%m%d`"
tm="`eval date +%R`"
echo "|____________________________Building DX Loader_______________________________|"
echo "Using build date $dt.$tm"
/Users/mikewilcox/scripts/flex/bin/mxmlc -compiler.debug -compiler.verbose-stacktraces -default-background-color=0xFFFFFF -default-frame-rate=10 -define+=NAMES::buildDate,"'$dt.$tm'" -source-path=../ ../dx/Loader.as -output="../../dx-media/resources/loader.swf"
echo "loader built"
