#!/bin/csh -f

#GENERATE ATMOSPHERIC DIAGNOSTICS

if ($generate_prect == 1) then

	# PRECT

	# Condense precipitation fields

	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename PRECC &
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename PRECL &

	#wait

	#Generate climatology and plots
	csh_scripts/precip_climo_plot.csh $scratch_dir $casename 0 11 $GPCP_regrid_wgt_file $data_dir $plots_dir  &
	csh_scripts/precip_climo_plot.csh $scratch_dir $casename 2 4  $GPCP_regrid_wgt_file $data_dir $plots_dir  &
	csh_scripts/precip_climo_plot.csh $scratch_dir $casename 5 7  $GPCP_regrid_wgt_file $data_dir $plots_dir  &
	csh_scripts/precip_climo_plot.csh $scratch_dir $casename 8 10 $GPCP_regrid_wgt_file $data_dir $plots_dir  &
	csh_scripts/precip_climo_plot.csh $scratch_dir $casename 11 1 $GPCP_regrid_wgt_file $data_dir $plots_dir  &


	#PRECIPITATION TRENDS

	#Interpolate PRECC and PRECL time series to GPCP grid

	echo
	echo Interpolating time series to GPCP grid ...

	ncl indir=\"{$scratch_dir}\" field_name=\"PRECC\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" ncl/esmf_regrid_ne120_GPCP_conservative_mapping.ncl &
	ncl indir=\"{$scratch_dir}\" field_name=\"PRECL\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" ncl/esmf_regrid_ne120_GPCP_conservative_mapping.ncl &

	wait

	#plot trend plots for different regions

	python python/plot_multiple_reg_seasonal_avg.py --indir $scratch_dir -c $casename -f PRECT --interp_grid GPCP_conservative_mapping --begin_month 0 --end_month 11 --aggregate 1 --plots_dir $plots_dir --debug False &

	wait

endif


if ($generate_rad == 1) then

	# RADIATION

	# Condense radiation fields

	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename FSNTOA &
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename FLUT &
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename FSNT &
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename FLNT &
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename SWCF &
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename LWCF &

	wait

	#Generate climatology and plots

	csh_scripts/rad_climo_plot.csh $scratch_dir $casename 0 11 $CERES_EBAF_regrid_wgt_file $data_dir $plots_dir &
	csh_scripts/rad_climo_plot.csh $scratch_dir $casename 2 4 $CERES_EBAF_regrid_wgt_file $data_dir $plots_dir &
	csh_scripts/rad_climo_plot.csh $scratch_dir $casename 5 7 $CERES_EBAF_regrid_wgt_file $data_dir $plots_dir &
	csh_scripts/rad_climo_plot.csh $scratch_dir $casename 8 10 $CERES_EBAF_regrid_wgt_file $data_dir $plots_dir &
	csh_scripts/rad_climo_plot.csh $scratch_dir $casename 11 1 $CERES_EBAF_regrid_wgt_file $data_dir $plots_dir &

	# RADIATION TRENDS        

	# Interpolate time series of radiation fields

	echo
	echo Interpolating FSNT and FLNT time series to CERES-EBAF grid ...

	ncl indir=\"{$scratch_dir}\" field_name=\"FSNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping.ncl &
	ncl indir=\"{$scratch_dir}\" field_name=\"FLNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping.ncl &

	wait

	# Plot trends for different regions

	python python/plot_multiple_reg_seasonal_avg.py --indir $scratch_dir -c $casename -f FSNT   --interp_grid CERES-EBAF_conservative_mapping --begin_month 0 --end_month 11 --plots_dir $plots_dir &
	python python/plot_multiple_reg_seasonal_avg.py --indir $scratch_dir -c $casename -f FLNT   --interp_grid CERES-EBAF_conservative_mapping --begin_month 0 --end_month 11 --plots_dir $plots_dir &
	python python/plot_multiple_reg_seasonal_avg.py --indir $scratch_dir -c $casename -f RESTOM --interp_grid CERES-EBAF_conservative_mapping --begin_month 0 --end_month 11 --plots_dir $plots_dir &


	wait


endif

	#wind stress

