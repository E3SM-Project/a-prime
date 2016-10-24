#!/bin/csh -f 

if ($#argv == 0) then
        echo Input arguments not set. Will stop!
else
        set archive_dir  		= $argv[1]
        set scratch_dir 		= $argv[2]
        set short_term_archive 		= $argv[3]
        set casename    		= $argv[4]
        set begin_yr    		= $argv[5]
        set end_yr      		= $argv[6]
	set condense_field_ts 		= $argv[7]
	set condense_field_climo 	= $argv[8]
	set compute_climo 		= $argv[9]
	set ref_case			= $argv[10]
endif


set condense_var_set_temp = ()

if ($condense_field_ts == 1) then

	if ($ref_case == obs) then
		source var_list_time_series_model_vs_obs.csh
	else
		source var_list_time_series_model_vs_model.csh
	endif

	set condense_var_set_temp = ($condense_var_set_temp $source_var_set)
endif

if ($compute_climo == 1 && $condense_field_climo == 1) then
	if ($ref_case == obs) then
		source var_list_climo_model_vs_obs.csh
	else
		source var_list_climo_model_vs_model.csh
	endif

	set condense_var_set_temp = ($condense_var_set_temp $source_var_set)
endif

# Keeping only unique variables in condense_field_var_set

set condense_var_set = ()

foreach var ($condense_var_set_temp)

	set add_var = 1

	foreach var_condense ($condense_var_set)
		if ($var =~ $var_condense) then
			set add_var = 0
		endif
	end

	if ($add_var == 1) then
		set condense_var_set = ($condense_var_set $var)
	endif
end

echo condense_var_set:
echo $condense_var_set

if ($condense_field_climo == 1 || $condense_field_ts == 1) then
	echo
	echo Submitting jobs to condense $casename fields:
	echo $condense_var_set
	echo
	echo Log files in $log_dir/condense_field_${casename}...log
	echo

	foreach var ($condense_var_set)
		echo $var
		csh_scripts/condense_field.csh  $archive_dir \
						$scratch_dir \
						$short_term_archive \
						$casename \
						$var \
						$begin_yr \
						$end_yr >& $log_dir/condense_field_${casename}_$var.log &
	end

	wait

else

	echo condense_field set to 0 or casename is obs. Not condensing for $casename!

endif

echo
