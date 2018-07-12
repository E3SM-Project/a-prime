#!/bin/bash
#COBALT -t 2:00:00
#COBALT -n 1
#COBALT -A ClimateEnergy_2
#COBALT -O aprime_ocnice_diags
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

source $log_dir/env4cooley

export command_prefix=""

./bash_scripts/aprime_ocnice_diags.bash

if [ $? -eq 0 ]; then
  # Update www/plots directory with newly generated plots
  cp -u $plots_dir/* $www_dir/$plots_dir_name
  chmod -R ga+rX $www_dir/$plots_dir_name

  echo
  echo "Updated ocn/ice plots in website directory: $www_dir/$plots_dir_name"
  echo
else
  echo
  echo "Something went wrong with the ocn/ice diagnostics: website plots NOT updated!"
  echo
fi
