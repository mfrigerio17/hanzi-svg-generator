#!/bin/sh

CH=$1
OUTDIR="out/$CH"
mkdir -p $OUTDIR

#
# Output SVG files
#
OUTF_GUIDES="guidepaths.svg"
OUTF_PATHS="paths.svg"
OUTF_ANIM="animated.svg"
OUTF_STROKES_SEQ="sequence.svg"
OUTF_STANDALONE="standalone.svg"
OUTF_STANDALONE_SEQ="standalone-sequence.svg"

#
# SVG templates
#
TMPLF_GUIDES=etc/svgtpl-guidepaths
TMPLF_PATHS=etc/svgtpl-paths
TMPLF_ANIM=etc/svgtpl-animated
TMPLF_STANDALONE=etc/svgtpl-standalone-basic
TMPLF_STROKES_SEQ=etc/svgtpl-strokes-sequence

#
# Fetch the source data from the database file ( $2 )
#
LINE=`grep $CH $2`

# These 'sed' commands capture the strokes and medians data by matching the unique
# delimiters of such data, and returning only the text between the two. For
# example, in the DB, the stroke coordinates appear between 'strokes":[' and
# '],"medians"' .
STROKES=`echo $LINE | sed -e 's#.*strokes":\[\(.*\)\],"medians".*#\1#'`
MEDIANS=`echo $LINE | sed -e 's#.*medians":\[\(.*\)\]}#\1#'`

#
# With a slight massage, the text with median data becomes valid Octave code
#
echo 'mediansdata = {' > mediansdata.m
echo $MEDIANS | sed -r 's#([0-9])\],\[([0-9])#\1\];\[\2#g' >> mediansdata.m
echo '};' >> mediansdata.m


#
# Generate temporary files with the right SVG code snippets
#
TMPF_STROKES=_tmp_strokes
TMPF_MEDIANS=_tmp_medians
TMPF_GUIDES=_tmp_guidepaths
TMPF_SSEQ=_tmp_sequence
TMPF_ALONE_SSEQ=_tmp_alone_seq

bin/main.m "`echo $STROKES`" $TMPF_STROKES $TMPF_MEDIANS $TMPF_GUIDES $TMPF_SSEQ $TMPF_ALONE_SSEQ




#
# Use the character-specific data with the SVG templates, to generate the final
# SVGs
#


#
# The SVG with the common geometrical data for the brush strokes and the medians
#
sed -e "/«strokes-paths»/ {
    s/«strokes-paths»//
    r $TMPF_STROKES
}" \
-e "/«median-paths»/ {
    s/«median-paths»//
    r $TMPF_MEDIANS
}" $TMPLF_PATHS | xmllint --format - > "$OUTDIR/$OUTF_PATHS"


#
# The SVG with the clipped paths required to simulate the painting of the strokes
#
sed -e "/«content»/ {
    s/«content»//
    r $TMPF_GUIDES
}" $TMPLF_GUIDES | xmllint --format - > "$OUTDIR/$OUTF_GUIDES"



#
# The SVG that makes use of the other files to display an animated chinese character
#
TMPF_ANIM=_tmp_animation
COUNT=`wc -l $TMPF_STROKES | awk '{ print $1 }'`
for i in `seq 1 $COUNT`; do
    echo '<use href="'$OUTF_GUIDES'#paint'$i'" class="anim-stroke-group-'$i'"/>' >> $TMPF_ANIM
done
sed -e "/«clipped-paths»/ {
    s/«clipped-paths»//
    r $TMPF_ANIM
}" $TMPLF_ANIM | xmllint --format - > "$OUTDIR/$OUTF_ANIM"

rm $TMPF_ANIM


#
# The SVG showing statically the strokes sequence of the character
#
viewbox=`head -n 1 $TMPF_SSEQ`             # get the viebox attribute, written in the first line of the file
tail --lines=+2 $TMPF_SSEQ > "$TMPF_SSEQ-2" # now strip the first line
rm $TMPF_SSEQ
mv "$TMPF_SSEQ-2" $TMPF_SSEQ

sed -e "s/«viewBox»/$viewbox/"\
 -e "/«content»/ {
    s/«content»//
    r $TMPF_SSEQ
}" $TMPLF_STROKES_SEQ | xmllint --format - > "$OUTDIR/$OUTF_STROKES_SEQ"




#
# Standalone SVG with the character, no refs to other sources
#
sed -e "/«strokes-paths»/ {
       s/«strokes-paths»//
       r $TMPF_STROKES
}" $TMPLF_STANDALONE | xmllint --format - > "$OUTDIR/$OUTF_STANDALONE"

viewbox=`head -n 1 $TMPF_ALONE_SSEQ`             # get the viebox attribute, written in the first line of the file
tail --lines=+2 $TMPF_ALONE_SSEQ > "$TMPF_ALONE_SSEQ-2" # now strip the first line
rm $TMPF_ALONE_SSEQ
mv "$TMPF_ALONE_SSEQ-2" $TMPF_ALONE_SSEQ

sed -e "s/«viewBox»/$viewbox/"\
 -e "/«content»/ {
    s/«content»//
    r $TMPF_ALONE_SSEQ
}" $TMPLF_STROKES_SEQ | xmllint --format - > "$OUTDIR/$OUTF_STANDALONE_SEQ"







rm mediansdata.m $TMPF_STROKES $TMPF_MEDIANS $TMPF_GUIDES $TMPF_SSEQ $TMPF_ALONE_SSEQ




