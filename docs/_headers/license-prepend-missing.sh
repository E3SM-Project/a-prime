#!/usr/bin/env bash
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
#
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#
# Get the source dir and ignore variables
source license-setup.sh

echo "--------------------------------------------------------------------------------"
echo "    PREPENDING A LICENSE HEADER ONTO THESE FILES:"
echo "--------------------------------------------------------------------------------"
find $SOURCE_DIR -type f "${ALWAYS_IGNORE[@]}" \
    "${FILE_IGNORE[@]}" \
    "${PYTHON_IGNORE[@]}" \
    "${CSS_IGNORE[@]}" \
    | xargs grep -L "$CURRENT" \
    | sort

echo "--------------------------------------------------------------------------------"
echo "    BEGIN PREPENDING:"
echo "--------------------------------------------------------------------------------"
############################################################
# Prepend license header to python files without a shebang.
# Will ignore files with a current license header.
############################################################
GET=( -iname "*.py" )

find $SOURCE_DIR -type f \( "${GET[@]}" \) "${ALWAYS_IGNORE[@]}" "${PYTHON_IGNORE[@]}" \
    | xargs grep -L "#!" \
    | xargs grep -L "$CURRENT" \
    | while read SRC
do
    BN=`basename ${SRC}`
    echo HEADING ${SRC}
    cp aprimeHeader-py /tmp/licHead
    cat ${SRC} >> /tmp/licHead
    chmod --reference=${SRC} /tmp/licHead
    mv /tmp/licHead ${SRC}
done

#######################################################################
# Prepend license header to python, bash, and sh files with a shebang.
# Will ignore files with a current license header.
#######################################################################
GET=( -iname "*.py" -or -iname "*.sh" -or -iname "*.bash" -or -iname "*.csh" -or -iname "*.pbs")

find $SOURCE_DIR -type f \( "${GET[@]}" \) "${ALWAYS_IGNORE[@]}" "${PYTHON_IGNORE[@]}" \
    | xargs grep -l --max-count=1 "#!" \
    | xargs grep -L "$CURRENT" \
    | while read SRC
do
    BN=`basename ${SRC}`
    echo HEADING ${SRC}
    cat ${SRC} | head -1 > /tmp/licHead
    cat aprimeHeader-py >> /tmp/licHead
    cat ${SRC} | tail -n +2 >> /tmp/licHead
    chmod --reference=${SRC} /tmp/licHead
    mv /tmp/licHead ${SRC}
done


####################################################
# Prepend license header to html files.
# Will ignore files with a current license header.
####################################################
GET=( -iname "*.html")

find $SOURCE_DIR -type f \( "${GET[@]}" \) "${ALWAYS_IGNORE[@]}" \
    | xargs grep -L "$CURRENT" \
    | while read SRC
do
    BN=`basename ${SRC}`
    echo HEADING ${SRC}
    cp aprimeHeader-html /tmp/licHead
    cat ${SRC} >> /tmp/licHead
    chmod --reference=${SRC} /tmp/licHead
    mv /tmp/licHead ${SRC}
done

####################################################
# Prepend license header to css and js files.
# Will ignore files with a current license header.
####################################################
GET=( -iname "*.css" -or -iname "*.js" )

find $SOURCE_DIR -type f \( "${GET[@]}" \) "${ALWAYS_IGNORE[@]}" "${CSS_IGNORE[@]}" \
    | xargs grep -L "$CURRENT" \
    | while read SRC
do
    BN=`basename ${SRC}`
    echo HEADING ${SRC}
    cp aprimeHeader-css /tmp/licHead
    cat ${SRC} >> /tmp/licHead
    chmod --reference=${SRC} /tmp/licHead
    mv /tmp/licHead ${SRC}
done

####################################################
# Prepend license header to css files.
# Will ignore files with a current license header.
####################################################
GET=( -iname "*.ncl" )

find $SOURCE_DIR -type f \( "${GET[@]}" \) "${ALWAYS_IGNORE[@]}" \
    | xargs grep -L "$CURRENT" \
    | while read SRC
do
    BN=`basename ${SRC}`
    echo HEADING ${SRC}
    cp aprimeHeader-ncl /tmp/licHead
    cat ${SRC} >> /tmp/licHead
    chmod --reference=${SRC} /tmp/licHead
    mv /tmp/licHead ${SRC}
done


echo "--------------------------------------------------------------------------------"
echo "    DONE PREPENDING!"
echo "--------------------------------------------------------------------------------"

