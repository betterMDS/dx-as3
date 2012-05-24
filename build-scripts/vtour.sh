echo "Build BV VTour"
cid="BV/code"
dt="`eval date +%Y%m%d`"
#/Users/mikewilcox/scripts/flex/bin/mxmlc -compiler.debug -default-size 640 480 -compiler.verbose-stacktraces  -define+=NAMES::buildDate,"'$dt'" -source-path=../ ../code/VTour.as -output=../../player_docs/HTM/code/vtour.swf
/Users/mikewilcox/scripts/flex/bin/mxmlc -compiler.debug -compiler.verbose-stacktraces  -define+=NAMES::buildDate,"'$dt'" -source-path=../ ../bv/VTour.as -output="../../player_docs/$cid/bv_vtour.swf"
cp ../../player_docs/$cid/bv_vtour.swf ../../player_docs/FR/code/bv_vtour.swf
echo "Copied to FR"
echo "done."
