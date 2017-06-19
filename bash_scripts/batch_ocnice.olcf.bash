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
#PBS -V

cd $PBS_O_WORKDIR

# prefix to run a serial job on a single node on edison
export command_prefix="aprun -b -N 1 -n 1"

./bash_scripts/aprime_ocnice_diags.bash

batch_script="$log_dir/batch_update_wwwdir.$machname.$uniqueID.bash"
sed 's@PBS -o .*@PBS -o '$log_dir'/aprime_update_wwwdir.o'$uniqueID'@' ./bash_scripts/batch_update_wwwdir.$machname.bash > $batch_script
sed -i 's@PBS -e .*@PBS -e '$log_dir'/aprime_update_wwwdir.e'$uniqueID'@' $batch_script

qsub -W depend=afterok:$PBS_JOBID $batch_script
