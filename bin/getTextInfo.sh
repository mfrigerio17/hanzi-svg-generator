#!/bin/sh

# This script fetches some information about a character from the database, and
# saves it in a separate text file. Currently, it writes the character itself,
# the pinyin pronunciation, and the translation, all as they appear in the
# make-me-a-hanzi database.

CH=$1   # the chinese character
DB=$2   # the textual database file

 OUTDIR="out/$CH"
OUTFILE="info"
mkdir -p $OUTDIR


#
# Fetch the source data from the database file
#
LINE=`grep '"character":"'$CH $DB`

PINYIN=`echo $LINE | sed -e 's#.*"pinyin":\["\(.*\)"\],"decomposition".*#\1#'`
DEF=`echo $LINE | sed -e 's#.*"definition":"\(.*\)","pinyin".*#\1#'`

#
# Write a text file with the character, the pinyin, and the translation,
# respectively on line 1, 2 and 3.
#
echo $1 > "$OUTDIR/$OUTFILE"
echo $PINYIN >> "$OUTDIR/$OUTFILE"
echo $DEF >> "$OUTDIR/$OUTFILE"
