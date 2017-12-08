#!/bin/bash
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

#PBS -q acme 
#PBS -l nodes=1
#PBS -l walltime=00:20:00
#PBS -A ACME
#PBS -N aprime_update_wwwdir
#PBS -o aprime_update_wwwdir.o$PBS_JOBID
#PBS -e aprime_update_wwwdir.e$PBS_JOBID
#PBS -V

# Update www/plots directory with newly generated plots
cp -u $plots_dir/* $www_dir/$plots_dir_name
chmod -R ga+rX $www_dir/$plots_dir_name
echo
echo "Updated atm plots in website directory: $www_dir/$plots_dir_name"
echo
