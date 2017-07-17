#!/bin/csh -f 

set scratch_dir = $argv[1]
set casename = $argv[2]
set reg = $argv[3]
set begin_yr = $argv[4]
set end_yr = $argv[5]
set ref_scratch_dir = $argv[6]
set ref_case = $argv[7]
set ref_begin_yr = $argv[8]
set ref_end_yr = $argv[9]
set var_list_file = $argv[10]

# Read in variable list for plotting climatologies  diagnostics

source $var_list_file

set n_var = $#var_set

# Read in list of seasons for which diagnostics are being computed
source $log_dir/season_info.temp
set n_seasons = $#begin_month_set

# Generate plots for each field and season


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

	foreach i (`seq 1 $n_seasons`)
		set begin_month = $begin_month_set[$i]
		set end_month   = $end_month_set[$i]
		set season_name = $season_name_set[$i]

		python python/plot_stddev.py \
			--indir $scratch_dir \
			-c $casename \
			-f $var \
			--reg $reg \
			--begin_month $begin_month \
			--end_month $end_month \
			--begin_yr $begin_yr \
			--end_yr $end_yr \
			--interp_grid $interp_grid \
			--interp_method $interp_method \
			--ref_case_dir $ref_scratch_dir \
			--ref_case $ref_casename \
			--ref_begin_yr $ref_begin_yr \
			--ref_end_yr $ref_end_yr \
			--ref_interp_grid $ref_interp_grid \
			--ref_interp_method $ref_interp_method \
			--plots_dir $plots_dir >& $log_dir/plot_stddev_${reg}_$casename-$ref_casename.$var.$season_name.log &

	end
end


echo
echo Waiting for jobs to complete ...
echo

wait

 	


