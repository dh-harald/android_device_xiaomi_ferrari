#!/bin/sh

VENDOR=xiaomi
DEVICE=ferrari
INDIR=/opt/ferrari/system
OUTDIR=../../../vendor/$VENDOR/$DEVICE/proprietary

COUNT=`cat proprietary-files.txt | grep -v ^# | grep -v ^$ | wc -l | awk {'print $1'}`
for FILE in `cat proprietary-files.txt | grep -v ^# | grep -v ^$`; do
#    COUNT=`expr $COUNT - 1`
    NEWFILE=`echo ${FILE}|sed 's/^\-//g;'`
    mkdir -p `dirname $OUTDIR/$NEWFILE` 2>/dev/null
    cp $INDIR/$NEWFILE $OUTDIR/$NEWFILE
done
