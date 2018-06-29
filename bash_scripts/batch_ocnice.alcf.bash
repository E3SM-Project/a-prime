#!/bin/bash
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

#COBALT -t 2:00:00
#COBALT -n 1
#COBALT -A ClimateEnergy_2
#COBALT -O aprime_ocnice_diags

#cd $PBS_O_WORKDIR

export command_prefix=""

source /lus/theta-fs0/projects/ClimateEnergy_2/software/e3sm_unified/base/etc/profile.d/conda.sh
conda activate e3sm_unified_1.2.0_py2.7_nox

./bash_scripts/aprime_ocnice_diags.bash

echo
echo "**** The following batch job will be submitted to cp files to www_dir *if* the ocn/ice diags are completed"
echo "**** jobID:"
batch_script="./bash_scripts/batch_update_wwwdir.$machname.bash"
qsub -dependencies $COBALT_JOBID $batch_script
