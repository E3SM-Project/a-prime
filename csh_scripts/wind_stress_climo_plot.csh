#!/bin/csh -f

# Usage: csh_scripts/precip_climo_plot.csh scratch_dir casename begin_month end_month ERS_regrid_wgt_file ERS_data_dir plots_dir

set scratch_dir = $argv[1]
set casename = $argv[2]
set begin_month = $argv[3]
set end_month = $argv[4]
set ERS_regrid_wgt_file = $argv[5]
set ERS_data_dir = $argv[6]
set plots_dir = $argv[7]

# Create Climatology of precipitation fields

python python/create_climatology.py 	--indir $scratch_dir \
					-c $casename \
					-f TAUX \
					--begin_month $begin_month \
					--end_month $end_month

python python/create_climatology.py 	--indir $scratch_dir \
					-c $casename \
					-f TAUY \
					--begin_month $begin_month \
					--end_month $end_month

python python/create_climatology.py 	--indir $scratch_dir \
					-c $casename \
					-f OCNFRAC \
					--begin_month $begin_month \
					--end_month $end_month

# Interpolate climatology to ERS grid

set filename = $casename.climo.{$begin_month}_$end_month.TAUX.nc
set interp_filename = $casename.climo.{$begin_month}_$end_month.ERS_conservative_mapping.TAUX.nc

ncl 	indir=\"{$scratch_dir}\" \
	filename=\"{$filename}\" \
	field_name=\"TAUX\" \
	casename=\"{$casename}\" \
	wgt_file=\"{$ERS_regrid_wgt_file}\" \
	interp_filename=\"{$interp_filename}\" \
	ncl/esmf_regrid.ncl


set filename = $casename.climo.{$begin_month}_$end_month.TAUY.nc
set interp_filename = $casename.climo.{$begin_month}_$end_month.ERS_conservative_mapping.TAUY.nc

ncl 	indir=\"{$scratch_dir}\" \
	filename=\"{$filename}\" \
	field_name=\"TAUY\" \
	casename=\"{$casename}\" \
	wgt_file=\"{$ERS_regrid_wgt_file}\" \
	interp_filename=\"{$interp_filename}\" \
	ncl/esmf_regrid.ncl


set filename = $casename.climo.{$begin_month}_$end_month.OCNFRAC.nc
set interp_filename = $casename.climo.{$begin_month}_$end_month.ERS_conservative_mapping.OCNFRAC.nc

ncl 	indir=\"{$scratch_dir}\" \
	filename=\"{$filename}\" \
	field_name=\"OCNFRAC\" \
	casename=\"{$casename}\" \
	wgt_file=\"{$ERS_regrid_wgt_file}\" \
	interp_filename=\"{$interp_filename}\" \
	ncl/esmf_regrid.ncl

# plot climatology plots for different seasons

python python/plot_climo_wind_stress_vs_ERS.py 	--indir $scratch_dir \
						-c $casename \
						-f wind_stress \
						--begin_month $begin_month \
						--end_month $end_month \
						--ERS_dir $ERS_data_dir \
						--plots_dir $plots_dir
