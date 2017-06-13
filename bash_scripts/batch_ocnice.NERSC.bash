#!/bin/bash -l

#SBATCH --partition=regular
# change number of nodes to change the number of parallel tasks
# (anything between 1 and the total number of tasks to run)
#SBATCH --nodes=10
#SBATCH --time=01:00:00
#SBATCH --account=acme
#SBATCH --job-name=aprime_ocnice_diags
#SBATCH --output=aprime_ocnice_diags.o%j
#SBATCH --error=aprime_ocnice_diags.e%j
#SBATCH -L cscratch1,SCRATCH,project

cd $SLURM_SUBMIT_DIR

export OMP_NUM_THREADS=1

# prefix to run a serial job on a single node on edison
export command_prefix="srun -N 1 -n 1"

./bash_scripts/aprime_ocnice_diags.bash
