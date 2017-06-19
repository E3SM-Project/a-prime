#!/bin/bash

#PBS -q batch
# change number of nodes to change the number of parallel tasks
# (anything between 1 and the total number of tasks to run)
#PBS -l nodes=10
#PBS -l walltime=01:00:00
#PBS -A cli115
#PBS -N aprime_ocnice_diags
#PBS -o aprime_ocnice_diags.o$PBS_JOBID
#PBS -e aprime_ocnice_diags.e$PBS_JOBID

cd $PBS_O_WORKDIR

# prefix to run a serial job on a single node on edison
export command_prefix="aprun -b -N 1 -n 1"

./bash_scripts/aprime_ocnice_diags.bash

exitCode=`qstat -f $PBS_JOBID | grep "exit_status" | grep -Eo '\<[0-9]{1,}\>'`
if [ $exitCode -eq 0 ]; then
  # Update www/plots directory with newly generated plots
  rsync -augltq $plots_dir/* $www_dir/$plots_dir_name
  chmod a+r $www_dir/$plots_dir_name/*

  echo
  echo "Updated ocn/ice plots in website directory: $www_dir/$plots_dir_name"
  echo
else
  echo
  echo "Something went wrong with the ocn/ice diagnostics: website plots NOT updated!"
  echo
fi
