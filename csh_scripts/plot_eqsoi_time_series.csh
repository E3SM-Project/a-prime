#!/bin/csh -f 

set scratch_dir = $argv[1]
set casename = $argv[2]
set begin_yr = $argv[3]
set end_yr = $argv[4]
set ref_scratch_dir = $argv[5]
set ref_case = $argv[6]
set ref_begin_yr = $argv[7]
set ref_end_yr = $argv[8]
set var_list_file = $argv[9]

# Read in variable list for plotting climatologies  diagnostics
source $var_list_file

set n_var = $#var_set

set regs = ('EPAC' 'INDO')
set names = ('EPAC' 'INDO')

set index_set_name = EQSOI

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

	python python/plot_diff_index.py -d True --indir $scratch_dir \
							-c $casename \
							-f $var \
							--begin_yr $begin_yr \
							--end_yr $end_yr \
							--interp_grid $interp_grid \
							--interp_method $interp_method \
							--ref_begin_yr $ref_begin_yr \
							--ref_end_yr $ref_end_yr \
							--ref_case_dir $ref_scratch_dir \
							--ref_case $ref_casename \
							--ref_interp_grid $ref_interp_grid \
							--ref_interp_method $ref_interp_method \
							--begin_month 0 \
							--end_month 11 \
							--regs $regs \
							--names $names \
							--index_set_name $index_set_name \
							--aggregate 0 \
							--no_ann 1 \
							--stdize 1 \
							--plots_dir $plots_dir >& $log_dir/plot_time_series_${casename}_${var}_$index_set_name.log &

end


echo
echo Waiting for jobs to complete ...
echo

wait

 	


