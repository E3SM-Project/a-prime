#!/bin/csh -f

#Checking if required mapping files exist, exiting otherwise
if (! -d $remap_files_dir) then
        echo remap_files_dir $remap_files_dir does not exist! Please check. 
	echo Exiting atmospheric diagnostics ...
	echo 
	echo
        exit 1
endif

if (! -f $GPCP_regrid_wgt_file) then
        echo GPCP_regrid_wgt_file $GPCP_regrid_wgt_file does not exist! Please check.
	echo Exiting atmospheric diagnostics ...
	echo
	echo
        exit 1
endif

if (! -f $CERES_EBAF_regrid_wgt_file) then
        echo CERES_EBAF_regid_wgt_file $CERES_EBAF_regrid_wgt_file does not exist! Please check.
	echo Exiting atmospheric diagnostics ...
	echo 
	echo
        exit 1
endif

if (! -f $ERS_regrid_wgt_file) then
        echo ERS_regrid_wgt_file $ERS_regrid_wgt_file does not exist! Please check.
	echo Exiting atmospheric diagnostics ...
	echo 
	echo
        exit 1
endif



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



#CLIMATOLOGY

#Ensuring a unique set of fields to compute climatology to reduce redundancy in climatology computations
if ($ref_case == obs) then
        set var_list_file = var_list_climo_model_vs_obs.csh
else
        set var_list_file = var_list_climo_model_vs_model.csh
endif

set compute_climo_var_list_file = $log_dir/var_list_compute_climo.csh

csh_scripts/generate_unique_field_list.csh $var_list_file \
					   $compute_climo_var_list_file



# Condense climatology fields into individual files
foreach j (`seq 1 $n_cases`)
	set casename 		= $case_set[$j]
	set archive_dir 	= $archive_dir_set[$j]
	set scratch_dir 	= $scratch_dir_set[$j]
	set short_term_archive 	= $short_term_archive_set[$j]
	set begin_yr_climo 	= $begin_yr_climo_set[$j]
	set end_yr_climo   	= $end_yr_climo_set[$j]

	set condense_field_climo      	= $condense_field_climo_set[$j]
	set compute_climo       	= $compute_climo_set[$j]

	set archive_dir_atm = $archive_dir/$casename/run

	if ($short_term_archive == 1) then
		echo Using ACME short term archiving directory structure!
		set archive_dir_atm = $archive_dir/$casename/atm
	endif

	if ($casename == obs) then
		set archive_dir_atm = $archive_dir
	endif

	if (! -d $archive_dir_atm) then
		echo $archive_dir_atm for $casename does not exist! Please check.
		echo Exiting atmospheric diagnostics...
		echo 
		echo
        	exit 1
	endif

	if ($condense_field_climo == 1 && $compute_climo == 1) then
		csh_scripts/condense_field_bundle.csh	$archive_dir_atm \
							$scratch_dir \
							$casename \
							$begin_yr_climo \
							$end_yr_climo \
							$compute_climo_var_list_file
	else

		echo condense_field set to 0 or casename is obs and compute_climo set to 0. 
		echo Not condensing for climo variables for $casename!

	endif
end



#Compute climatology
foreach j (`seq 1 $n_cases`)
	set casename       = $case_set[$j]
	set scratch_dir    = $scratch_dir_set[$j]
	set compute_climo  = $compute_climo_set[$j]
	set begin_yr_climo = $begin_yr_climo_set[$j]
	set end_yr_climo   = $end_yr_climo_set[$j]

	if ($compute_climo == 1) then
		echo
		echo Submitting jobs to compute seasonal climatology for $casename
		echo Log files in $log_dir/climo_$casename...
		echo
		csh_scripts/compute_climo.csh 	$scratch_dir \
						$casename \
						$compute_climo_var_list_file \
						$begin_yr_climo \
						$end_yr_climo
	else
		echo compute_climo set to $compute_climo or casename is obs. Not computing climatology for $casename!
	endif
end
	
echo


#Remap climatology
foreach j (`seq 1 $n_cases`)
	set casename    = $case_set[$j]
	set scratch_dir = $scratch_dir_set[$j]
	set native_res  = $native_res_set[$j]
	set remap_climo = $remap_climo_set[$j]
	set begin_yr_climo = $begin_yr_climo_set[$j]
	set end_yr_climo = $end_yr_climo_set[$j]

	if ($remap_climo == 1) then
		echo
		echo Submitting jobs to remap seasonal climatology files for $casename 
		echo Log files in $log_dir/remap_climo_$casename...
		echo
		csh_scripts/remap_climo_nco.csh $scratch_dir \
						$casename \
						$begin_yr_climo \
						$end_yr_climo \
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
set ref_begin_yr_climo = $begin_yr_climo_set[$j]
set ref_end_yr_climo   = $end_yr_climo_set[$j]

echo Reference Case: $ref_case
echo

if $ref_case == obs then
	set ref_scratch_dir = $archive_dir_set[$n_cases]
endif

@ n_test_cases = $n_cases - 1

foreach j (`seq 1 $n_test_cases`)
	set casename   = $case_set[$j]
	set scratch_dir = $scratch_dir_set[$j]
        set begin_yr_climo = $begin_yr_climo_set[$j]
        set end_yr_climo = $end_yr_climo_set[$j]

	csh_scripts/plot_climo.csh $scratch_dir \
				   $casename \
				   $begin_yr_climo \
				   $end_yr_climo \
				   $ref_scratch_dir \
				   $ref_case \
				   $ref_begin_yr_climo \
				   $ref_end_yr_climo \
end





# TIME TRENDS        

#Ensuring a unique set of fields to condense for time series
if ($ref_case == obs) then
        set var_list_file = var_list_time_series_model_vs_obs.csh
else
        set var_list_file = var_list_time_series_model_vs_model.csh
endif

set ts_var_list_file = $log_dir/ts_var_list.csh

csh_scripts/generate_unique_field_list.csh $var_list_file \
					   $ts_var_list_file



#Condense time series variables into individual files
foreach j (`seq 1 $n_cases`)
	set casename 		= $case_set[$j]
	set archive_dir 	= $archive_dir_set[$j]
	set scratch_dir 	= $scratch_dir_set[$j]
	set short_term_archive 	= $short_term_archive_set[$j]
	set begin_yr_ts 	= $begin_yr_ts_set[$j]
	set end_yr_ts   	= $end_yr_ts_set[$j]

	set condense_field_ts      	= $condense_field_ts_set[$j]

	set archive_dir_atm = $archive_dir/$casename/run

	if ($short_term_archive == 1) then
		echo Using ACME short term archiving directory structure!
		set archive_dir_atm = $archive_dir/$casename/atm
	endif

	if ($condense_field_ts == 1) then
		csh_scripts/condense_field_bundle.csh	$archive_dir_atm \
							$scratch_dir \
							$casename \
							$begin_yr_ts \
							$end_yr_ts \
							$ts_var_list_file
	else
		echo condense_field_ts set to 0 or casename is obs. 
		echo Not condensing for time series variables for $casename!

	endif

end



# Interpolate time series of fields to obs grids
foreach j (`seq 1 $n_cases`)
	set casename    = $case_set[$j]
	set scratch_dir = $scratch_dir_set[$j]
	set begin_yr_ts = $begin_yr_ts_set[$j]
	set end_yr_ts	= $end_yr_ts_set[$j]
	set native_res  = $native_res_set[$j]
	set remap_ts    = $remap_ts_set[$j]

	if ($remap_ts == 1) then
		echo
		echo Submitting jobs to interpolate time series files for $casename
		echo Log files in $log_dir/remap_time_series_${casename}...
		echo
		csh_scripts/remap_time_series_nco.csh 	$scratch_dir \
							$casename \
							$begin_yr_ts \
							$end_yr_ts \
							$native_res \
							$ts_var_list_file 
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

if $ref_case == obs then
	set ref_scratch_dir = $archive_dir_set[$n_cases]
endif

@ n_test_cases = $n_cases - 1

foreach j (`seq 1 $n_test_cases`)
	set casename    = $case_set[$j]
	set scratch_dir = $scratch_dir_set[$j]
	set begin_yr_ts = $begin_yr_ts_set[$j]
	set end_yr_ts   = $end_yr_ts_set[$j]

	csh_scripts/plot_time_series.csh $scratch_dir \
					 $casename \
					 $begin_yr_ts \
					 $end_yr_ts \
					 $ref_scratch_dir \
					 $ref_case
end


# ENSO DIAGS

if ($generate_atm_enso_diags == 1) then 

	# ENSO DIAGS: Climatology related diags (meridional avg. over the Tropical Pacific)       
	echo
	echo Computing ENSO diagnostics ...
	echo

	#Ensuring a unique set of fields to condense for enso diags related to climatology
	echo
	echo Computing climatology based ENSO diagnostics - meridional avg. over the Tropical Pacific - ...
	echo
	set var_list_file = var_list_enso_diags_climo.csh

	set ts_var_list_file = $log_dir/ts_var_list.csh

	csh_scripts/generate_unique_field_list.csh $var_list_file \
						   $ts_var_list_file


	#Condense enso diags climo variables into individual files
	foreach j (`seq 1 $n_cases`)
		set casename 		= $case_set[$j]
		set archive_dir 	= $archive_dir_set[$j]
		set scratch_dir 	= $scratch_dir_set[$j]
		set short_term_archive 	= $short_term_archive_set[$j]
		set begin_yr_climo 	= $begin_yr_enso_atm_set[$j]
		set end_yr_climo   	= $end_yr_enso_atm_set[$j]

		set condense_field_climo   = $condense_field_enso_atm_set[$j]

		set archive_dir_atm = $archive_dir/$casename/run

		if ($short_term_archive == 1) then
			echo Using ACME short term archiving directory structure!
			set archive_dir_atm = $archive_dir/$casename/atm
		endif

		if ($condense_field_climo == 1) then
			csh_scripts/condense_field_bundle.csh	$archive_dir_atm \
								$scratch_dir \
								$casename \
								$begin_yr_climo \
								$end_yr_climo \
								$ts_var_list_file
		else
			echo condense_field_ts set to 0 or casename is obs. 
			echo Not condensing for ENSO diags climo variables for $casename!

		endif

	end

	#Compute climatology
	foreach j (`seq 1 $n_cases`)
		set casename       = $case_set[$j]
		set scratch_dir    = $scratch_dir_set[$j]
		set compute_climo  = $compute_climo_enso_atm_set[$j]
		set begin_yr_climo = $begin_yr_enso_atm_set[$j]
		set end_yr_climo   = $end_yr_enso_atm_set[$j]


		if ($compute_climo == 1) then
			echo
			echo Submitting jobs to compute seasonal climatology for $casename
			echo Log files in $log_dir/climo_$casename...
			echo
			csh_scripts/compute_climo.csh 	$scratch_dir \
							$casename \
							$ts_var_list_file \
							$begin_yr_climo \
							$end_yr_climo
		else
			echo compute_climo set to $compute_climo or casename is obs. Not computing climatology for $casename!
		endif
	end
		
	echo


	#Remap climatology
	foreach j (`seq 1 $n_cases`)
		set casename    = $case_set[$j]
		set scratch_dir = $scratch_dir_set[$j]
		set native_res  = $native_res_set[$j]
		set remap_climo = $remap_climo_enso_atm_set[$j]
		set begin_yr_climo = $begin_yr_enso_atm_set[$j]
		set end_yr_climo = $end_yr_enso_atm_set[$j]

		if ($remap_climo == 1) then
			echo
			echo Submitting jobs to remap seasonal climatology files for $casename 
			echo Log files in $log_dir/remap_climo_$casename...
			echo
			csh_scripts/remap_climo_nco.csh $scratch_dir \
							$casename \
							$begin_yr_climo \
							$end_yr_climo \
							$native_res \
							$ts_var_list_file
		else
			echo remap_climo set to $remap_climo or casename is obs. Not remapping climatology for $casename!
		endif
	end

	# ENSO Diags: Plot Meridional Average over the Tropical Pacific
	echo
	echo
	echo Submitting jobs to plot meridional average over the Tropical Pacific
	echo Log files in $log_dir/
	echo

	set ref_case        = $case_set[$n_cases]
	set ref_scratch_dir = $scratch_dir_set[$n_cases]

	echo Reference Case: $ref_case
	echo

	if $ref_case == obs then
		set ref_scratch_dir = $archive_dir_set[$n_cases]
	endif

	@ n_test_cases = $n_cases - 1

	foreach j (`seq 1 $n_test_cases`)
		set casename    = $case_set[$j]
		set scratch_dir = $scratch_dir_set[$j]
		set begin_yr_climo = $begin_yr_enso_atm_set[$j]
		set end_yr_climo = $end_yr_enso_atm_set[$j]

		csh_scripts/plot_tropical_pacific_meridional_avg.csh $scratch_dir \
						 $casename \
						 $begin_yr_climo \
						 $end_yr_climo \
						 $ref_scratch_dir \
						 $ref_case \
						 $var_list_file
	end





	#ENSO Diags: Time Series related diags (Nino index, regression, std. dev. and lead-lag regression)
	echo
	echo Computing time series based ENSO diagnostics ...
	echo

	#Ensuring a unique set of fields to condense for time series analysis
	set var_list_file = var_list_enso_diags_time_series.csh

	set ts_var_list_file = $log_dir/ts_var_list.csh

	csh_scripts/generate_unique_field_list.csh $var_list_file \
						   $ts_var_list_file


	#Condense time series variables into individual files
	foreach j (`seq 1 $n_cases`)
		set casename 		= $case_set[$j]
		set archive_dir 	= $archive_dir_set[$j]
		set scratch_dir 	= $scratch_dir_set[$j]
		set short_term_archive 	= $short_term_archive_set[$j]
		set begin_yr_ts 	= $begin_yr_enso_atm_set[$j]
		set end_yr_ts   	= $end_yr_enso_atm_set[$j]

		set condense_field_ts   = $condense_field_enso_atm_set[$j]

		set archive_dir_atm = $archive_dir/$casename/run

		if ($short_term_archive == 1) then
			echo Using ACME short term archiving directory structure!
			set archive_dir_atm = $archive_dir/$casename/atm
		endif

		if ($condense_field_ts == 1) then
			csh_scripts/condense_field_bundle.csh	$archive_dir_atm \
								$scratch_dir \
								$casename \
								$begin_yr_ts \
								$end_yr_ts \
								$ts_var_list_file
		else
			echo condense_field_ts set to 0 or casename is obs. 
			echo Not condensing for time series variables for $casename!

		endif

	end

	# ENSO Diags: Interpolate time series of fields to obs grids
	foreach j (`seq 1 $n_cases`)
		set casename    = $case_set[$j]
		set scratch_dir = $scratch_dir_set[$j]
		set begin_yr_ts = $begin_yr_enso_atm_set[$j]
		set end_yr_ts	= $end_yr_enso_atm_set[$j]
		set native_res  = $native_res_set[$j]
		set remap_ts    = $remap_ts_enso_atm_set[$j]

		if ($remap_ts == 1) then
			echo
			echo Submitting jobs to interpolate time series files for $casename
			echo Log files in $log_dir/remap_time_series_${casename}...
			echo
			csh_scripts/remap_time_series_nco.csh 	$scratch_dir \
								$casename \
								$begin_yr_ts \
								$end_yr_ts \
								$native_res \
								$ts_var_list_file 
		endif
	end

	# ENSO Diags: Compute Nino and EQSOI indices
        echo
        echo Submitting jobs to compute Nino and EQSOI index
        echo Log files in $log_dir/
        echo

        set ref_case        = $case_set[$n_cases]
        set ref_scratch_dir = $scratch_dir_set[$n_cases]

        echo Reference Case: $ref_case
        echo

        @ n_test_cases = $n_cases - 1

        set var_list_file = var_list_enso_diags_time_series.csh

        foreach j (`seq 1 $n_cases`)
                set casename    = $case_set[$j]
		set archive_dir = $archive_dir_set[$j]
                set scratch_dir = $scratch_dir_set[$j]
                set begin_yr_ts = $begin_yr_enso_atm_set[$j]
                set end_yr_ts   = $end_yr_enso_atm_set[$j]

		if ($casename != obs) then
			set archive_dir = $scratch_dir
		else
			set archive_dir = $archive_dir
		endif

                csh_scripts/compute_indices.csh $archive_dir \
						$scratch_dir \
                                                 $casename \
                                                 $begin_yr_ts \
                                                 $end_yr_ts \
                                                 $var_list_file
        end	

	set var_list_file = var_list_enso_diags_eqsoi_index.csh

        foreach j (`seq 1 $n_cases`)
                set casename    = $case_set[$j]
		set archive_dir = $archive_dir_set[$j]
                set scratch_dir = $scratch_dir_set[$j]
                set begin_yr_ts = $begin_yr_enso_atm_set[$j]
                set end_yr_ts   = $end_yr_enso_atm_set[$j]

		if ($casename != obs) then
			set archive_dir = $scratch_dir
		else
			set archive_dir = $archive_dir
		endif

                csh_scripts/compute_eqsoi_index.csh $archive_dir \
						 $scratch_dir \
                                                 $casename \
                                                 $begin_yr_ts \
                                                 $end_yr_ts \
                                                 $var_list_file
        end	


	# ENSO Diags: Plot Nino and EQSOI time series

        echo
        echo Submitting job to plot Nino and EQSOI index
        echo Log files in $log_dir/
        echo

        set var_list_file = var_list_enso_diags_time_series.csh

	foreach j (`seq 1 $n_test_cases`)
		set casename    = $case_set[$j]
		set scratch_dir = $scratch_dir_set[$j]
		set begin_yr_ts = $begin_yr_enso_atm_set[$j]
		set end_yr_ts   = $end_yr_enso_atm_set[$j]
                set ref_begin_yr_ts = $begin_yr_enso_atm_set[$n_cases]
		set ref_end_yr_ts   = $end_yr_enso_atm_set[$n_cases]

		csh_scripts/plot_multiple_index_same_plot.csh $scratch_dir \
						 $casename \
						 $begin_yr_ts \
						 $end_yr_ts \
						 $ref_scratch_dir \
						 $ref_case \
						 $ref_begin_yr_ts \
						 $ref_end_yr_ts \
						 $var_list_file
	end
	

	# ENSO Diags: Plot Equatorial SOI index time series
#	echo
#	echo Submitting job to plot Equatorial SOI time series
#	echo Log files in $log_dir/
#	echo
#
#	set ref_case        = $case_set[$n_cases]
#	set ref_scratch_dir = $scratch_dir_set[$n_cases]
#
#	echo Reference Case: $ref_case
#	echo
#
#	if $ref_case == obs then
#		set ref_scratch_dir = $archive_dir_set[$n_cases]
#	endif
#
#	@ n_test_cases = $n_cases - 1
#
#	set var_list_file = var_list_enso_diags_eqsoi_index.csh
#
#	foreach j (`seq 1 $n_test_cases`)
#		set casename    = $case_set[$j]
#		set scratch_dir = $scratch_dir_set[$j]
#		set begin_yr_ts = $begin_yr_enso_atm_set[$j]
#		set end_yr_ts   = $end_yr_enso_atm_set[$j]
#                set ref_begin_yr_ts = $begin_yr_enso_atm_set[$n_cases]
#		set ref_end_yr_ts   = $end_yr_enso_atm_set[$n_cases]
#
#		csh_scripts/plot_eqsoi_time_series.csh $scratch_dir \
#						 $casename \
#						 $begin_yr_ts \
#						 $end_yr_ts \
#						 $ref_scratch_dir \
#						 $ref_case \
#						 $ref_begin_yr_ts \
#						 $ref_end_yr_ts \
#						 $var_list_file
#	end



	# ENSO Diags: Plot Nino3, Nino3.4 and Nino4 index time series
	echo
	echo Submitting jobs to plot time series
	echo Log files in $log_dir/
	echo

	set ref_case        = $case_set[$n_cases]
	set ref_scratch_dir = $scratch_dir_set[$n_cases]

	echo Reference Case: $ref_case
	echo

	if $ref_case == obs then
		set ref_scratch_dir = $archive_dir_set[$n_cases]
	endif

	@ n_test_cases = $n_cases - 1

	set var_list_file = var_list_enso_diags_nino_index.csh

	foreach j (`seq 1 $n_test_cases`)
		set casename    = $case_set[$j]
		set scratch_dir = $scratch_dir_set[$j]
		set begin_yr_ts = $begin_yr_enso_atm_set[$j]
		set end_yr_ts   = $end_yr_enso_atm_set[$j]
                set ref_begin_yr_ts = $begin_yr_enso_atm_set[$n_cases]
		set ref_end_yr_ts   = $end_yr_enso_atm_set[$n_cases]

		csh_scripts/plot_enso_diags_time_series.csh $scratch_dir \
						 $casename \
						 $begin_yr_ts \
						 $end_yr_ts \
						 $ref_scratch_dir \
						 $ref_case \
						 $ref_begin_yr_ts \
						 $ref_end_yr_ts \
						 $var_list_file
	end


	# ENSO Diags: Plot Nino3, Nino3.4 and Nino4 index seasonality
	echo
	echo Submitting jobs to plot seasonality of Nino indices
	echo Log files in $log_dir/
	echo

	foreach j (`seq 1 $n_test_cases`)
		set casename    = $case_set[$j]
		set scratch_dir = $scratch_dir_set[$j]
		set begin_yr_ts = $begin_yr_enso_atm_set[$j]
		set end_yr_ts   = $end_yr_enso_atm_set[$j]
                set ref_begin_yr_ts = $begin_yr_enso_atm_set[$n_cases]
		set ref_end_yr_ts   = $end_yr_enso_atm_set[$n_cases]

		csh_scripts/plot_enso_seasonality.csh $scratch_dir \
						 $casename \
						 $begin_yr_ts \
						 $end_yr_ts \
						 $ref_scratch_dir \
						 $ref_case \
						 $ref_begin_yr_ts \
						 $ref_end_yr_ts \
						 $var_list_file
	end


	#ENSO Diags: Plot Bjerknes Feedback (Nino4 TAUX vs. Nino3 SST) 

	set index_field = 'TS'
	set index_reg = 'Nino3'
	set index_reg_name = 'Nino3'

	set field_reg = 'Nino4'
	set field_reg_name = 'Nino4'

	set split_yfit_x_0 = 0

	echo
	echo Submitting jobs to plot Bjerkenes feedback
	echo Log files in $log_dir/
	echo

	set var_list_file = var_list_enso_diags_bjerknes_feedback.csh

	foreach j (`seq 1 $n_test_cases`)
                set casename        = $case_set[$j]
                set scratch_dir     = $scratch_dir_set[$j]
                set begin_yr_ts     = $begin_yr_enso_atm_set[$j]
		set end_yr_ts	    = $end_yr_enso_atm_set[$j]
                set ref_begin_yr_ts = $begin_yr_enso_atm_set[$n_cases]
		set ref_end_yr_ts   = $end_yr_enso_atm_set[$n_cases]
        	
	        csh_scripts/plot_enso_feedbacks.csh $scratch_dir \
                                                 $casename \
                                                 $begin_yr_ts \
						 $end_yr_ts \
						 $index_field \
						 $index_reg \
						 $index_reg_name \
						 $field_reg \
						 $field_reg_name \
                                                 $ref_scratch_dir \
                                                 $ref_case \
                                                 $ref_begin_yr_ts \
						 $ref_end_yr_ts \
						 $split_yfit_x_0 \
                                                 $var_list_file
        end

	#ENSO Diags: Plot Heat Flux - SST Feedbacks 

	set index_field = 'TS'
	set index_reg = 'Nino3'
	set index_reg_name = 'Nino3'

	set field_reg = 'Nino3'
	set field_reg_name = 'Nino3'

	set split_yfit_x_0 = 1

	echo
	echo Submitting jobs to plot Nino3 heat flux-SST feedbacks
	echo Log files in $log_dir/
	echo

	set var_list_file = var_list_enso_diags_heat_flux-sst_feedbacks.csh

	foreach j (`seq 1 $n_test_cases`)
                set casename        = $case_set[$j]
                set scratch_dir     = $scratch_dir_set[$j]
                set begin_yr_ts     = $begin_yr_enso_atm_set[$j]
		set end_yr_ts	    = $end_yr_enso_atm_set[$j]
                set ref_begin_yr_ts = $begin_yr_enso_atm_set[$n_cases]
		set ref_end_yr_ts   = $end_yr_enso_atm_set[$n_cases]
        	
	        csh_scripts/plot_enso_feedbacks.csh $scratch_dir \
                                                 $casename \
                                                 $begin_yr_ts \
						 $end_yr_ts \
						 $index_field \
						 $index_reg \
						 $index_reg_name \
						 $field_reg \
						 $field_reg_name \
                                                 $ref_scratch_dir \
                                                 $ref_case \
                                                 $ref_begin_yr_ts \
						 $ref_end_yr_ts \
						 $split_yfit_x_0 \
                                                 $var_list_file
        end




	#ENSO Diags: Plot Regression 

	set index_field = 'TS'
	set index_reg = 'Nino3'
	set index_reg_name = 'Nino3'

	set field_reg = 'global'
	set field_reg_name = 'global'

	echo
	echo Submitting jobs to plot regression of variables against the $index_reg index
	echo Log files in $log_dir/
	echo

	set var_list_file = var_list_enso_diags_time_series.csh

	foreach j (`seq 1 $n_test_cases`)
                set casename        = $case_set[$j]
                set scratch_dir     = $scratch_dir_set[$j]
                set begin_yr_ts     = $begin_yr_enso_atm_set[$j]
		set end_yr_ts	    = $end_yr_enso_atm_set[$j]
                set ref_begin_yr_ts = $begin_yr_enso_atm_set[$n_cases]
		set ref_end_yr_ts   = $end_yr_enso_atm_set[$n_cases]
        	
	        csh_scripts/plot_regr_nino34_fields.csh $scratch_dir \
                                                 $casename \
                                                 $begin_yr_ts \
						 $end_yr_ts \
						 $index_field \
						 $index_reg \
						 $index_reg_name \
						 $field_reg \
						 $field_reg_name \
                                                 $ref_scratch_dir \
                                                 $ref_case \
                                                 $ref_begin_yr_ts \
						 $ref_end_yr_ts \
                                                 $var_list_file
        end


	#ENSO Diags: Plot std. dev. over the Tropical Pacific
	echo
	echo Submitting jobs to plot std. dev. of fields over the Tropical Pacific
	echo Log files in $log_dir/

	set var_list_file = var_list_enso_diags_time_series.csh
	set reg = 'Greater_Tropical_Pacific'

	foreach j (`seq 1 $n_test_cases`)
                set casename        = $case_set[$j]
                set scratch_dir     = $scratch_dir_set[$j]
                set begin_yr_ts     = $begin_yr_enso_atm_set[$j]
		set end_yr_ts	    = $end_yr_enso_atm_set[$j]
                set ref_begin_yr_ts = $begin_yr_enso_atm_set[$n_cases]
		set ref_end_yr_ts   = $end_yr_enso_atm_set[$n_cases]
        	
		csh_scripts/plot_stddev.csh $scratch_dir \
					   $casename \
					   $reg \
					   $begin_yr_ts \
					   $end_yr_ts \
					   $ref_scratch_dir \
					   $ref_case \
					   $ref_begin_yr_ts \
					   $ref_end_yr_ts \
					   $var_list_file 


	#ENSO Diags: ENSO Evolution
	set var_list_file = var_list_enso_diags_time_series.csh

	set index_field = 'TS'
	set index_reg = 'Nino3.4'
	set index_reg_name = 'Nino3.4'

	set field_reg = 'global'
	set field_reg_name = 'global'

	echo
	echo Submitting jobs to plot ENSO evolution: Lead lag regression of TAUX and TS against the Nino3.4 index
	echo Log files in $log_dir/
	echo

	foreach j (`seq 1 $n_test_cases`)
                set casename        = $case_set[$j]
                set scratch_dir     = $scratch_dir_set[$j]
                set begin_yr_ts     = $begin_yr_enso_atm_set[$j]
		set end_yr_ts	    = $end_yr_enso_atm_set[$j]
                set ref_begin_yr_ts = $begin_yr_enso_atm_set[$n_cases]
		set ref_end_yr_ts   = $end_yr_enso_atm_set[$n_cases]
        	
	        csh_scripts/plot_enso_evolution.csh $scratch_dir \
                                                 $casename \
                                                 $begin_yr_ts \
						 $end_yr_ts \
						 $index_field \
						 $index_reg \
						 $index_reg_name \
						 $field_reg \
						 $field_reg_name \
                                                $ref_scratch_dir \
                                                 $ref_case \
                                                 $ref_begin_yr_ts \
						 $ref_end_yr_ts \
                                                 $var_list_file
        end
endif

echo
echo Completed atmosphere diagnostics! 
echo
echo Plots in $plots_dir
echo

