#!/bin/bash

#PBS -q batch
#PBS -l nodes=1
#PBS -l walltime=01:00:00
#PBS -A cli115
#PBS -N aprime_atm_diags
#PBS -o aprime_atm_diags.o$PBS_JOBID
#PBS -e aprime_atm_diags.e$PBS_JOBID
#PBS -V

cd $PBS_O_WORKDIR

./bash_scripts/aprime_atm_diags.bash

batch_script="$log_dir/batch_update_wwwdir.$machname.$uniqueID.bash"
sed 's@PBS -o .*@PBS -o '$log_dir'/aprime_update_wwwdir.o'$uniqueID'@' ./bash_scripts/batch_update_wwwdir.$machname.bash > $batch_script
sed -i 's@PBS -e .*@PBS -e '$log_dir'/aprime_update_wwwdir.e'$uniqueID'@' $batch_script

qsub -W depend=afterok:$PBS_JOBID $batch_script
