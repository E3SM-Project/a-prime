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
echo "    THESE FILES ARE MISSING A CURRENT LICENSE HEADER:"
echo "--------------------------------------------------------------------------------"
find $SOURCE_DIR -type f "${ALWAYS_IGNORE[@]}" \
    "${FILE_IGNORE[@]}" \
    "${PYTHON_IGNORE[@]}" \
    "${CSS_IGNORE[@]}" \
    | xargs grep -L "$CURRENT" \
    | sort

