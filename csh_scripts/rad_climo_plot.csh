#!/bin/csh -f

# Usage: csh_scripts/rad_climo_plot.csh scratch_dir casename begin_month end_month CERES_EBAF_regrid_wgt_file CERES_EBAF_data_dir plots_dir

set scratch_dir = $argv[1]
set casename = $argv[2]
set begin_month = $argv[3]
set end_month = $argv[4]
set CERES_EBAF_regrid_wgt_file = $argv[5]
set CERES_EBAF_data_dir = $argv[6]
set plots_dir = $argv[7]

# Create Climatology of radiation fields

python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month $begin_month --end_month $end_month
python python/create_climatology.py --indir $scratch_dir -c $casename -f FLUT --begin_month $begin_month --end_month $end_month
python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNT --begin_month $begin_month --end_month $end_month
python python/create_climatology.py --indir $scratch_dir -c $casename -f FLNT --begin_month $begin_month --end_month $end_month
python python/create_climatology.py --indir $scratch_dir -c $casename -f SWCF --begin_month $begin_month --end_month $end_month
python python/create_climatology.py --indir $scratch_dir -c $casename -f LWCF --begin_month $begin_month --end_month $end_month


# Interpolate climatology to CERES-EBAF grid

ncl indir=\"{$scratch_dir}\" field_name=\"FSNTOA\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=$begin_month  end_month=$end_month ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
ncl indir=\"{$scratch_dir}\" field_name=\"FLUT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=$begin_month  end_month=$end_month ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
ncl indir=\"{$scratch_dir}\" field_name=\"FSNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=$begin_month  end_month=$end_month ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
ncl indir=\"{$scratch_dir}\" field_name=\"FLNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=$begin_month  end_month=$end_month ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
ncl indir=\"{$scratch_dir}\" field_name=\"SWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=$begin_month  end_month=$end_month ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
ncl indir=\"{$scratch_dir}\" field_name=\"LWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=$begin_month  end_month=$end_month ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl

# plot climatology plots for different seasons

python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month $begin_month --end_month $end_month --CERES_EBAF_dir $CERES_EBAF_data_dir --plots_dir $plots_dir
python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FLUT --begin_month $begin_month --end_month $end_month --CERES_EBAF_dir $CERES_EBAF_data_dir --plots_dir $plots_dir
python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f SWCF --begin_month $begin_month --end_month $end_month --CERES_EBAF_dir $CERES_EBAF_data_dir --plots_dir $plots_dir
python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f LWCF --begin_month $begin_month --end_month $end_month --CERES_EBAF_dir $CERES_EBAF_data_dir --plots_dir $plots_dir


