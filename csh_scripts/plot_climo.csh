#!/bin/csh -f 

set scratch_dir = $argv[1]
set casename = $argv[2]
set ref_scratch_dir = $argv[3]
set ref_case = $argv[4]

# Read in variable list for plotting climatologies  diagnostics
if ($ref_case == obs) then
	source var_list_climo_model_vs_obs.csh
else
	source var_list_climo_model_vs_model.csh
endif

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

		if $var == 'TAU' then
			python python/plot_climo_vector.py \
				--indir $scratch_dir \
				-c $casename \
				-f $var \
				--begin_month $begin_month \
				--end_month $end_month \
				--interp_grid $interp_grid \
				--interp_method $interp_method \
				--ref_case_dir $ref_scratch_dir \
				--ref_case $ref_casename \
				--ref_interp_grid $ref_interp_grid \
				--ref_interp_method $ref_interp_method \
				--plots_dir $plots_dir >& $log_dir/plot_climo_$casename-$ref_casename.$var.$season_name.log &

		else
			python python/plot_climo.py \
				--indir $scratch_dir \
				-c $casename \
				-f $var \
				--begin_month $begin_month \
				--end_month $end_month \
				--interp_grid $interp_grid \
				--interp_method $interp_method \
				--ref_case_dir $ref_scratch_dir \
				--ref_case $ref_casename \
				--ref_interp_grid $ref_interp_grid \
				--ref_interp_method $ref_interp_method \
				--plots_dir $plots_dir >& $log_dir/plot_climo_$casename-$ref_casename.$var.$season_name.log &
		endif

	end
end


echo
echo Waiting for jobs to complete ...
echo

wait

 	


