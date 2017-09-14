#!/bin/csh -f 
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

set scratch_dir = $argv[1]
set casename = $argv[2]
set begin_yr = $argv[3]
set ref_scratch_dir = $argv[4]
set ref_case = $argv[5]

# Read in variable list for plotting climatologies  diagnostics
if ($ref_case == obs) then
	source var_list_time_series_model_vs_obs.csh
else
	source var_list_time_series_model_vs_model.csh
endif

set n_var = $#var_set


# Generate plots for each field


foreach k (`seq 1 $n_var`)

	set var           = $var_set[$k]
	set interp_grid   = $interp_grid_set[$k]
	set interp_method = $interp_method_set[$k]

	echo	
	echo $casename $var
	echo

	if ($ref_case == obs) then
		set ref_casename = $interp_grid
		set ref_interp_grid   = 0
		set ref_interp_method = 0
	else
		set ref_casename = $ref_case
		set ref_interp_grid   = $interp_grid
		set ref_interp_method = $interp_method
	endif

	python python/plot_multiple_reg_seasonal_avg.py --indir $scratch_dir \
							-c $casename \
							-f $var \
							--begin_yr $begin_yr \
							--interp_grid $interp_grid \
							--interp_method $interp_method \
							--ref_case_dir $ref_scratch_dir \
							--ref_case $ref_casename \
							--ref_interp_grid $ref_interp_grid \
							--ref_interp_method $ref_interp_method \
							--begin_month 0 \
							--end_month 11 \
							--aggregate 1 \
							--plots_dir $plots_dir >& $log_dir/plot_time_series_${casename}_$var.log &

end


echo
echo Waiting for jobs to complete ...
echo

wait

 	


