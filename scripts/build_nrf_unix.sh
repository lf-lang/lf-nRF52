#!/usr/bin/env bash

# Project root is one up from the bin directory.
PROJECT_ROOT=$LF_BIN_DIRECTORY/..


echo "starting NRF generation script into $LF_SOURCE_GEN_DIRECTORY"
echo "pwd is $(pwd)"

# Copy the lib directory.
cp -r $PROJECT_ROOT/lib/* $LF_SOURCE_GEN_DIRECTORY/lib

# Remove any previous Makefile
rm -f $LF_SOURCE_GEN_DIRECTORY/Makefile

printf '
# Makefile
PROJECT_ROOT = %s
############
' $PROJECT_ROOT >> $LF_SOURCE_GEN_DIRECTORY/Makefile
cat $PROJECT_ROOT/platform/Makefile >> $LF_SOURCE_GEN_DIRECTORY/Makefile

echo "Makefile Generated"

cd $LF_SOURCE_GEN_DIRECTORY
make flash

echo ""
echo "**** To get printf outputs:"
echo "cd $LF_SOURCE_GEN_DIRECTORY; make rtt"
echo ""
