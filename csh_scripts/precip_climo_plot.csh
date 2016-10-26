#!/bin/csh -f

# Usage: csh_scripts/precip_climo_plot.csh scratch_dir casename begin_month end_month GPCP_regrid_wgt_file GPCP_data_dir plots_dir

set scratch_dir = $argv[1]
set casename = $argv[2]
set begin_month = $argv[3]
set end_month = $argv[4]
set GPCP_regrid_wgt_file = $argv[5]
set GPCP_data_dir = $argv[6]
set plots_dir = $argv[7]

# Create Climatology of precipitation fields

python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECC --begin_month $begin_month --end_month $end_month
python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECL --begin_month $begin_month --end_month $end_month

# Interpolate climatology to GPCP grid

ncl indir=\"{$scratch_dir}\" field_name=\"PRECC\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=$begin_month  end_month=$end_month ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl
ncl indir=\"{$scratch_dir}\" field_name=\"PRECL\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=$begin_month  end_month=$end_month ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl


# plot climatology plots for different seasons

python python/plot_climo_PRECT_vs_GPCP.py --indir $scratch_dir -c $casename -f PRECT --begin_month $begin_month --end_month $end_month --GPCP_dir $GPCP_data_dir --plots_dir $plots_dir
