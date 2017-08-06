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

set index_set_name = Nino

set index_names = ('Nino3' 'Nino3.4' 'Nino4')
set field_names = ('TS' 'TS' 'TS')
set regs = ('Nino3' 'Nino3.4' 'Nino4') 

set interp_grid_temp = (0 0 0)
set interp_method_temp = (0 0 0)

set n_index = $#index_names

# Get grid information about the indices


foreach i (`seq 1 $n_index`)
	foreach k (`seq 1 $n_var`)
		if ($field_names[$i] == $var_set[$k]) then
			set interp_grid_temp[$i] = $interp_grid_set[$k]
			set interp_method_temp[$i] = $interp_method_set[$k]

		endif
	end
end

echo $index_names
echo $interp_grid_temp
echo $interp_method_temp

# Generate plots for each field
foreach i (`seq 1 $n_index`)

	set case = $casename
	set field_name = $field_names[$i]
	set interp_grid = $interp_grid_temp[$i]
	set interp_method = $interp_method_temp[$i]
	set reg = $regs[$i]
	set index_name = $index_names[$i]

	if ($casename == obs) then
		set case = $interp_grid_temp[$i]
		set interp_grid   = 0
                set interp_method = 0
	endif

	python python/compute_index.py -d True --archive_dir $archive_dir \
							--indir $scratch_dir \
							-c $case \
							-f $field_name \
							--begin_yr $begin_yr \
							--end_yr $end_yr \
							--interp_grid $interp_grid \
							--interp_method $interp_method \
							--begin_month 0 \
							--end_month 11 \
							--aggregate 0 \
							--reg $reg \
							--index_name $index_name \
							--no_ann 1 \
							--stdize 0 \
							--write_netcdf 1 >& $log_dir/compute_index_${case}_$index_name.log &

end



echo
echo Waiting for jobs to complete ...
echo

wait

 	


