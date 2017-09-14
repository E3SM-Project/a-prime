#!/bin/csh -f
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#
#GENERATE OCEAN DIAGNOSTICS

# initialize MPAS-Analysis code
setenv GIT_DISCOVERY_ACROSS_FILESYSTEM true
setenv tmp_currentdir "`pwd`"
setenv tmp_gittopdir "`git rev-parse --show-toplevel`"
cd $tmp_gittopdir
git submodule update --init
echo 'MPAS-Analysis submodule: '`git submodule status`
cd $tmp_currentdir
unsetenv tmp_currentdir, tmp_gittopdir

rm -f config.ocnice

python python/setup_ocnice_config.py
if ( $? != 0 ) then
    echo "Failed to build config.ocnice"
    exit 1
endif

python python/MPAS-Analysis/run_analysis.py config.ocnice
