#!/bin/bash
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

#COBALT -t 0:20:00
#COBALT -n 1
#COBALT -A ClimateEnergy_2
#PBS -A ACME

# Update www/plots directory with newly generated plots
cp -u $plots_dir/* $www_dir/$plots_dir_name
chmod -R ga+rX $www_dir/$plots_dir_name
echo
echo "Updated atm plots in website directory: $www_dir/$plots_dir_name"
echo
