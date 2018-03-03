#!/bin/bash
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
#
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

# GENERATE OCEAN DIAGNOSTICS

export config_file="$log_dir/config.ocnice.$uniqueID"
python python/setup_ocnice_config.py
exstatus=$?
if [ $exstatus -ne 0 ]; then
  echo
  echo "Failed to build config.ocnice"
  exit 1
fi

python python/MPAS-Analysis/run_mpas_analysis.py $config_file
exstatus=$?
if [ $exstatus -ne 0 ]; then
  echo
  echo "Failed some ocean/ice diagnostic tasks"
  exit 1
fi
