#!/bin/bash
#COBALT -t 2:00:00
#COBALT -n 1
#COBALT -A OceanClimate_2
#COBALT -O aprime_atm_diags
##COBALT -A ClimateEnergy_2
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

#cd $PBS_O_WORKDIR

#runjob --np 1 -p 1 ./bash_scripts/aprime_atm_diags.bash
#mpirun -f $COBALT_NODEFILE -n 1 ./bash_scripts/aprime_atm_diags.bash
./bash_scripts/aprime_atm_diags.bash

echo
echo "**** The following batch job will be submitted to cp files to www_dir *if* the atm diags are completed"
echo "**** jobID:"
batch_script="./bash_scripts/batch_update_wwwdir.$machname.bash"
qsub -dependencies $COBALT_JOBID $batch_script sargs
