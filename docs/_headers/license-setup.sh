#!/usr/bin/env bash
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

SOURCE_DIR="../.."

CURRENT="Copyright (c)"

ALWAYS_IGNORE=(-not -path "*.git*" -not -path "*docs/*" -not -iname "setup_*" -not -path "*python/MPAS-Analysis/*" \
               -not -iname "MANIFEST.in")

FILE_IGNORE=(-not -iname "*.md" -not -iname "*.json" -not -iname "*.txt" \
             -not -iname "*.png" -not -iname "*.jpg" -not -iname "*.svg" \
             -not -iname "config.*" -not -iname "README" -not -iname "*.nc"\
             -not -iname "streams.*" -not -iname "*.ocean" -not -iname "*.pyc" \
             -not -iname "*.sl" -not -iname "*.ps1" -not -iname "*.yml"    )

PYTHON_IGNORE=(-not -iname "__init__.py" -not -iname "colormaps.py"  \
               -not -path "*dist/*" -not -path "*.egg-info/*") 

CSS_IGNORE=(-not -iname "jquery-ui.min.css")

