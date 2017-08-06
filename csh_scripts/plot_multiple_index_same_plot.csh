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

set index_set_name = SOI_Nino

set index_names = ('EQSOI' 'Nino3.4')
set field_names = ('PSL' 'TS')

set scratch_dir_index = ($scratch_dir $scratch_dir)
set casename_index = ($casename $casename)

set ref_scratch_dir_index = ($ref_scratch_dir $ref_scratch_dir)
set ref_case_index = ($ref_case $ref_case)

set interp_grid = (0 0)
set interp_method = (0 0)

set ref_casename = (0 0)
set ref_interp_grid = (0 0)
set ref_interp_method = (0 0)

set n_index = $#index_names

# Get grid information about the indices
foreach i (`seq 1 $n_index`)
	foreach k (`seq 1 $n_var`)
		if ($field_names[$i] == $var_set[$k]) then
			set interp_grid[$i] = $interp_grid_set[$k]
			set interp_method[$i] = $interp_method_set[$k]

			if ($ref_case != obs) then
				set ref_interp_grid[$i] = $interp_grid_set[$k]
				set ref_interp_method[$i] = $interp_method_set[$k]
			else
				set ref_case_index[$i] = $interp_grid_set[$k]
			endif

		endif
	end
end

echo $interp_grid
echo $interp_method
echo $ref_interp_grid
echo $ref_interp_method


# Generate plots for each field

python python/plot_multiple_index_same_plot.py -d True --indir $scratch_dir_index \
						-c $casename_index \
						-f $field_names \
						--begin_yr $begin_yr \
						--end_yr $end_yr \
						--interp_grid $interp_grid \
						--interp_method $interp_method \
						--ref_begin_yr $ref_begin_yr \
						--ref_end_yr $ref_end_yr \
						--ref_case_dir $ref_scratch_dir_index \
						--ref_case $ref_case_index \
						--ref_interp_grid $ref_interp_grid \
						--ref_interp_method $ref_interp_method \
						--begin_month 0 \
						--end_month 11 \
						--aggregate 0 0\
						--index_names $index_names \
						--no_ann 1 1\
						--stdize 0 0\
						--plots_dir $plots_dir >& $log_dir/plot_time_series_${casename}_$index_set_name.log &



echo
echo Waiting for jobs to complete ...
echo

wait

 	


