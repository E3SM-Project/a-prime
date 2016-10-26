#!/bin/bash -l
#SBATCH -p regular
#SBATCH -N 1
#SBATCH -t 02:00:00
#SBATCH -J run_EDISON
#SBATCH -o run_EDISON.o%j
#SBATCH -L SCRATCH,project


srun -n 1 ./run_EDISON.csh
