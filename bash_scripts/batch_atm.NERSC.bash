#!/bin/bash -l
#SBATCH --partition=regular
#SBATCH --nodes=1
#SBATCH --time=01:00:00
#SBATCH --account=acme
#SBATCH --job-name=aprime_atm_diags
#SBATCH --output=aprime_atm_diags.o%j
#SBATCH --error=aprime_atm_diags.e%j
#SBATCH -L cscratch1,SCRATCH,project

cd $SLURM_SUBMIT_DIR

export OMP_NUM_THREADS=1

srun -N 1 -n 1 ./bash_scripts/aprime_atm_diags.bash
