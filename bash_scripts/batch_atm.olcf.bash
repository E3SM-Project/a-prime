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

echo
echo "**** The following batch job will be submitted to cp files to www_dir *if* the atm diags are completed"
echo "**** jobID:"
batch_script="./bash_scripts/batch_update_wwwdir.$machname.bash"
qsub -W depend=afterok:$PBS_JOBID $batch_script
