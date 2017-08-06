#!/bin/csh -f 

set archive_dir = $argv[1]
set scratch_dir = $argv[2]
set casename = $argv[3]
set begin_yr = $argv[4]
set end_yr = $argv[5]
set var_list_file = $argv[6]

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

	if ($casename == obs) then
		set case = $interp_grid
		set interp_grid   = 0
		set interp_method = 0
	else
		set case = $casename
		set interp_grid   = $interp_grid
		set interp_method = $interp_method
	endif

	python python/compute_diff_index.py -d True --archive_dir $archive_dir \
							--indir $scratch_dir \
							-c $case \
							-f $var \
							--begin_yr $begin_yr \
							--end_yr $end_yr \
							--interp_grid $interp_grid \
							--interp_method $interp_method \
							--begin_month 0 \
							--end_month 11 \
							--regs $regs \
							--names $names \
							--index_set_name $index_set_name \
							--aggregate 0 \
							--no_ann 1 \
							--stdize 1 \
							--write_netcdf 1 >& $log_dir/compute_index_${casename}_${var}_$index_set_name.log &

end


echo
echo Waiting for jobs to complete ...
echo

wait

 	


