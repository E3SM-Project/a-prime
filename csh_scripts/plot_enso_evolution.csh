#!/bin/csh -f 

set scratch_dir = $argv[1]
set casename = $argv[2]
set begin_yr = $argv[3]
set end_yr = $argv[4]
set index_field = $argv[5]
set index_reg = $argv[6]
set index_reg_name = $argv[7]
set field_reg = $argv[8]
set field_reg_name = $argv[9]
set ref_scratch_dir = $argv[10]
set ref_case = $argv[11]
set var_list_file = $argv[12]

# Read in variable list for plotting climatologies  diagnostics
source $var_list_file

set n_var = $#var_set

set reg = ($field_reg $index_reg)
set reg_name = ($field_reg_name $index_reg_name)

# Read in list of seasons for which diagnostics are being computed
source $log_dir/season_info.temp
set n_seasons = $#begin_month_set

# Get grid information about the index field
foreach k (`seq 1 $n_var`)
	if ($var_set[$k] == $index_field) then
		set interp_grid_index = $interp_grid_set[$k]
		set interp_method_index = $interp_method_set[$k]
	endif	
end

# Generate regression plots for each field against the index 
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

	set begin_month = 0
	set end_month   = 11
	set season_name = ANN

	python python/plot_regress_lead_lag_index_field.py -d True --indir $scratch_dir \
							-c $casename \
							-f $var $index_field\
							--begin_yr $begin_yr \
							--end_yr $end_yr \
							--interp_grid $interp_grid $interp_grid_index\
							--interp_method $interp_method $interp_method_index\
							--ref_case_dir $ref_scratch_dir \
							--ref_case $ref_casename \
							--ref_interp_grid $ref_interp_grid \
							--ref_interp_method $ref_interp_method \
							--begin_month $begin_month $begin_month\
							--end_month $end_month $end_month\
							--aggregate 1 \
							--stdize 1 \
							--reg $reg \
							--reg_name $reg_name \
							--plots_dir $plots_dir >& $log_dir/plot_regr_lead_lag_${casename}_${var}_vs_${index_reg_name}_$season_name.log &
end


echo
echo Waiting for jobs to complete ...
echo

wait

 	


