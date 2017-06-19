#!/bin/bash

#PBS -q batch
#PBS -l nodes=1
#PBS -l walltime=01:00:00
#PBS -A cli115
#PBS -N aprime_atm_diags
#PBS -o aprime_atm_diags.o$PBS_JOBID
#PBS -e aprime_atm_diags.e$PBS_JOBID

cd $PBS_O_WORKDIR

./bash_scripts/aprime_atm_diags.bash

exitCode=`qstat -f $PBS_JOBID | grep "exit_status" | grep -Eo '\<[0-9]{1,}\>'`
if [ $exitCode -eq 0 ]; then
  # Update www/plots directory with newly generated plots
  rsync -augltq $plots_dir/* $www_dir/$plots_dir_name
  chmod a+r $www_dir/$plots_dir_name/*

  echo
  echo "Updated atm plots in website directory: $www_dir/$plots_dir_name"
  echo
else
  echo
  echo "Something went wrong with the atm diagnostics: website plots NOT updated!"
  echo
fi
