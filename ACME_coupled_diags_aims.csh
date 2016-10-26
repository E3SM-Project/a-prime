#!/bin/csh
# first execute "source /usr/local/uvcdat/latest/bin/setup_runtime.sh"
setenv NCARG_ROOT /usr/local/src/NCL-6.3.0

set casename 			= b1850c5_t1a
set archive_dir 		= /space
set scratch_dir 		= /export/evans99/diags_out/$casename.test.pp
set data_dir	 		= /space2/ACME_obs_data
set GPCP_regrid_wgt_file        = /space2/ACME_grids/ne30-to-GPCP.conservative.wgts.nc
set CERES_EBAF_regrid_wgt_file  = /space2/ACME_grids/ne30-to-CERES-EBAF.conservative.wgts.nc
set plots_dir 			= /export/evans99/diags_out/coupled_diagnostics_$casename
set log_dir 			= /export/evans99/diags_out/$casename.test.pp/logs


#select sets of diagnostics to generate (False = 0, True = 1)
set generate_prect = 1
set generate_rad = 1

echo

if (! -d $scratch_dir) mkdir $scratch_dir
if (! -d $plots_dir)   mkdir $plots_dir
if (! -d $log_dir)     mkdir $log_dir


echo
echo casename: $casename 
echo archive_dir: $archive_dir

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

#GENERATE OCEAN DIAGNOSTICS

# OHC TRENDS
#
python python/ohc.py --indir ${ocndir} -c ${casename} --gridfile ${gridfile} --plots_dir ${plots_dir} --compare_with_model "true" --indir_model_tocompare ${ocndir_model_tocompare} --casename_model_tocompare ${casename_model_tocompare} --compare_with_obs "false"
#
# # SST TRENDS
#
# # SST CLIMATOLOGIES
#
# # SEA ICE CONCENTRATION AND THICKNESS TIME SERIES
#
# # SEA ICE CONCENTRATION AND THICKNESS CLIMATOLOGIES
#
# # MERIDIONAL HEAT TRANSPORT AND MOC
#
# # NINO3.4 TIME SERIES
