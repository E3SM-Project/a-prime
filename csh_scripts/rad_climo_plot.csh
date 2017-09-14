#!/bin/csh -f
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

# Usage: csh_scripts/rad_climo_plot.csh scratch_dir casename begin_month end_month CERES_EBAF_regrid_wgt_file CERES_EBAF_data_dir plots_dir

set scratch_dir = $argv[1]
set casename = $argv[2]
set begin_month = $argv[3]
set end_month = $argv[4]
set CERES_EBAF_regrid_wgt_file = $argv[5]
set CERES_EBAF_data_dir = $argv[6]
set plots_dir = $argv[7]


# Read in variable list for radiation diagnostics e.g FLUT, FSNT etc.
source $log_dir/var_list_rad.temp

# Create Climatology of radiation fields

foreach var ($var_set)
	python python/create_climatology.py 	--indir $scratch_dir \
						-c $casename \
						-f $var \
						--begin_month $begin_month \
						--end_month $end_month
end


# Interpolate climatology to CERES-EBAF grid



foreach var ($var_set)
	ncl 	indir=\"{$scratch_dir}\" \
		field_name=\"{$var}\" \
		casename=\"{$casename}\" \
		wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" \
		begin_month=$begin_month  \
		end_month=$end_month \
		ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
end


# plot climatology plots for different seasons

set var_set = (FSNTOA FLUT SWCF LWCF)

foreach var ($var_set)
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py \
		--indir $scratch_dir \
		-c $casename \
		-f $var \
		--begin_month $begin_month \
		--end_month $end_month \
		--CERES_EBAF_dir $CERES_EBAF_data_dir \
		--plots_dir $plots_dir

end



