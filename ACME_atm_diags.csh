#!/bin/csh -f

#GENERATE ATMOSPHERIC DIAGNOSTICS

#Reading case info
source $log_dir/case_info.temp
set n_cases = $#case_set

set ref_case        = $case_set[$n_cases]
set ref_scratch_dir = $scratch_dir_set[$n_cases]

#Reading seasonal info 
source $log_dir/season_info.temp
set n_seasons = $#begin_month_set



echo
echo Generating atmospheric climatology diagnostics...
echo


# Condense fields into individual files

foreach j (`seq 1 $n_cases`)
	set casename 		= $case_set[$j]
	set archive_dir 	= $archive_dir_set[$j]
	set scratch_dir 	= $scratch_dir_set[$j]
	set short_term_archive 	= $short_term_archive_set[$j]
	set begin_yr 		= $begin_yr_set[$j]
	set end_yr   		= $end_yr_set[$j]

	set condense_field_ts      	= $condense_field_ts_set[$j]
	set condense_field_climo      	= $condense_field_climo_set[$j]
	set compute_climo       	= $compute_climo_set[$j]

	csh_scripts/condense_field_bundle.csh	$archive_dir \
						$scratch_dir \
						$short_term_archive \
						$casename \
						$begin_yr \
						$end_yr \
						$condense_field_ts \
						$condense_field_climo \
						$compute_climo \
						$ref_case

end



#Compute climatology

#Ensuring a unique set of fields to compute climatology to reduce redundancy in climatology computations
if ($ref_case == obs) then
        set var_list_file = var_list_climo_model_vs_obs.csh
else
        set var_list_file = var_list_climo_model_vs_model.csh
endif

set compute_climo_var_list_file = $log_dir/var_list_compute_climo.csh

csh_scripts/generate_unique_field_list.csh $var_list_file \
					   $compute_climo_var_list_file


foreach j (`seq 1 $n_cases`)
	set casename      = $case_set[$j]
	set scratch_dir   = $scratch_dir_set[$j]
	set compute_climo = $compute_climo_set[$j]

	if ($compute_climo == 1) then
		echo
		echo Submitting jobs to compute seasonal climatology for $casename
		echo Log files in $log_dir/climo_$casename...
		echo
		csh_scripts/compute_climo.csh 	$scratch_dir \
						$casename \
<<<<<<< HEAD
						$compute_climo_var_list_file
	else
		echo compute_climo set to $compute_climo or casename is obs. Not computing climatology for $casename!
	endif
end
	
echo
=======
						$var >& $log_dir/condense_field_$var.log; \
		echo "set condense_status = $status" > $log_dir/condense_status_$var.temp &
	end

	wait

	foreach var ($var_set)
		source $log_dir/condense_status_$var.temp

		if ($condense_status != 0) then
			echo
			echo "Could not condense $var into one file. Exiting"
			echo "Check log files at $log_dir/condense_field_$var.log"
			exit
		endif
	end



	#Generate climatology and plots
>>>>>>> 73c4e5c... adding capability to generate webpages on NERSC for coupled diags and a minor bug fix


#Remap climatology

foreach j (`seq 1 $n_cases`)
	set casename    = $case_set[$j]
	set scratch_dir = $scratch_dir_set[$j]
	set native_res  = $native_res_set[$j]
	set remap_climo = $remap_climo_set[$j]

	if ($remap_climo == 1) then
		echo
		echo Submitting jobs to remap seasonal climatology files for $casename 
		echo Log files in $log_dir/remap_climo_$casename...
		echo
		csh_scripts/remap_climo_nco.csh $scratch_dir \
						$casename \
						$native_res \
						$compute_climo_var_list_file 
	else
		echo remap_climo set to $remap_climo or casename is obs. Not remapping climatology for $casename!
	endif
end

echo


#Plot climatologies and differences

echo
echo Submitting jobs to plot seasonal climatology and differences
echo Log files in $log_dir/plot_climo...
echo

set ref_case        = $case_set[$n_cases]
set ref_scratch_dir = $scratch_dir_set[$n_cases]

echo Reference Case: $ref_case
echo

@ n_test_cases = $n_cases - 1

foreach j (`seq 1 $n_test_cases`)
	set casename   = $case_set[$j]
	set scratch_dir = $scratch_dir_set[$j]

	csh_scripts/plot_climo.csh $scratch_dir \
				   $casename \
				   $ref_scratch_dir \
				   $ref_case
end



# TIME TRENDS        

# Interpolate time series of fields

#Ensuring a unique set of fields to remap

if ($ref_case == obs) then
        set var_list_file = var_list_time_series_model_vs_obs.csh
else
        set var_list_file = var_list_time_series_model_vs_model.csh
endif

set ts_remap_var_list_file = $log_dir/ts_remap_var_list.csh

csh_scripts/generate_unique_field_list.csh $var_list_file \
					   $ts_remap_var_list_file


foreach j (`seq 1 $n_cases`)
	set casename    = $case_set[$j]
	set scratch_dir = $scratch_dir_set[$j]
	set native_res  = $native_res_set[$j]
	set remap_ts    = $remap_ts_set[$j]

	if ($remap_ts == 1) then
		echo
		echo Submitting jobs to interpolate time series files for $casename
		echo Log files in $log_dir/remap_time_series_${casename}...
		echo
		csh_scripts/remap_time_series_nco.csh 	$scratch_dir \
							$casename \
							$native_res \
							$ts_remap_var_list_file 
	endif
end


# Plot trends for different regions
echo
echo Submitting jobs to plot time series
echo Log files in $log_dir/
echo

set ref_case        = $case_set[$n_cases]
set ref_scratch_dir = $scratch_dir_set[$n_cases]

echo Reference Case: $ref_case
echo

@ n_test_cases = $n_cases - 1

foreach j (`seq 1 $n_test_cases`)
	set casename    = $case_set[$j]
	set scratch_dir = $scratch_dir_set[$j]

	csh_scripts/plot_time_series.csh $scratch_dir \
					 $casename \
					 $ref_scratch_dir \
					 $ref_case
end

echo
echo Completed atmosphere diagnostics! 
echo
echo Plots in $plots_dir
echo



if ($generate_html == 1) then
<<<<<<< HEAD
	csh csh_scripts/generate_html_index_file.csh $case_set[1] $plots_dir $www_dir
=======
	if ( ! -d $www_dir ) mkdir $www_dir
	csh csh_scripts/generate_html_index_file.csh $casename $plots_dir $www_dir
>>>>>>> e7754e1... Added ocean and sea-ice diagnostic scripts.
endif

