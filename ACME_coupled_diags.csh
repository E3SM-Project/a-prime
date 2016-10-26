#!/bin/csh
# this version is deprecated. Use the run_$MACHINE file 

module load nco
module load ncl

module unload PE-intel
module load PE-gnu

module load python
module load python_numpy
module load python_scipy
module load python_matplotlib
module load python_netcdf4

# variables to specify
set casename 			= famipc5_ne120_v0.3_00005
set archive_dir 		= /lustre/atlas1/cli106/proj-shared/salil/archive  
set scratch_dir 		= $PROJWORK/cli106/$USER/$casename.test.pp
set GPCP_regrid_wgt_file 	= $WORLDWORK/cli121/4ue/grids/ne120_to_GPCP.conservative.wgts.nc
set CERES_EBAF_regrid_wgt_file 	= $WORLDWORK/cli121/4ue/grids/ne120_to_CERES-EBAF.conservative.wgts.nc
set data_dir 		= $WORLDWORK/csc121/obs_data
set plots_dir 			= $PROJWORK/cli106/$USER/coupled_diagnostics_$casename

#select sets of diagnostics to generate (False = 0, True = 1)
set generate_prect = 1
set generate_rad = 1

echo

if (! -d $scratch_dir) mkdir $scratch_dir
if (! -d $plots_dir)   mkdir $plots_dir

echo
echo casename: $casename 
echo archive_dir: $archive_dir

#GENERATE ATMOSPHERIC DIAGNOSTICS

if ($generate_prect == 1) then

	# PRECT

	# Condense precipitation fields

	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename PRECC
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename PRECL

	# Create Climatology of precipitation fields

	echo Generating Climatology ...
	echo

	python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECC --begin_month 0 --end_month 11
	python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECC --begin_month 2 --end_month 4
	python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECC --begin_month 5 --end_month 7
	python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECC --begin_month 8 --end_month 10
	python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECC --begin_month 11 --end_month 1

	python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECL --begin_month 0 --end_month 11
	python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECL --begin_month 2 --end_month 4
	python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECL --begin_month 5 --end_month 7
	python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECL --begin_month 8 --end_month 10
	python python/create_climatology.py --indir $scratch_dir -c $casename -f PRECL --begin_month 11 --end_month 1


	# Interpolate climatology to GPCP grid

	echo
	echo Interpolating precipitation climatology to GPCP grid ...

	ncl indir=\"{$scratch_dir}\" field_name=\"PRECC\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=0  end_month=11 ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"PRECC\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=2  end_month=4  ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"PRECC\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=5  end_month=7  ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"PRECC\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=8  end_month=10 ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"PRECC\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=11 end_month=1  ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl

	ncl indir=\"{$scratch_dir}\" field_name=\"PRECL\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=0  end_month=11 ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"PRECL\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=2  end_month=4  ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"PRECL\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=5  end_month=7  ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"PRECL\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=8  end_month=10 ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"PRECL\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" begin_month=11 end_month=1  ncl/esmf_regrid_ne120_GPCP_conservative_mapping_climo.ncl


	# plot climatology plots for different seasons

	python python/plot_climo_PRECT_vs_GPCP.py --indir $scratch_dir -c $casename -f PRECT --begin_month 0 --end_month 11 --GPCP_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_PRECT_vs_GPCP.py --indir $scratch_dir -c $casename -f PRECT --begin_month 2 --end_month 4  --GPCP_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_PRECT_vs_GPCP.py --indir $scratch_dir -c $casename -f PRECT --begin_month 5 --end_month 7  --GPCP_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_PRECT_vs_GPCP.py --indir $scratch_dir -c $casename -f PRECT --begin_month 8 --end_month 10 --GPCP_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_PRECT_vs_GPCP.py --indir $scratch_dir -c $casename -f PRECT --begin_month 11 --end_month 1 --GPCP_dir $data_dir --plots_dir $plots_dir


	#PRECIPITATION TRENDS

	#Interpolate PRECC and PRECL time series to GPCP grid

	echo
	echo Interpolating time series to GPCP grid ...

	ncl indir=\"{$scratch_dir}\" field_name=\"PRECC\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" ncl/esmf_regrid_ne120_GPCP_conservative_mapping.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"PRECL\" casename=\"{$casename}\" wgt_file=\"{$GPCP_regrid_wgt_file}\" ncl/esmf_regrid_ne120_GPCP_conservative_mapping.ncl

	#plot trend plots for different regions

	python python/plot_multiple_reg_seasonal_avg.py --indir $scratch_dir -c $casename -f PRECT --interp_grid GPCP_conservative_mapping --begin_month 0 --end_month 11 --plots_dir $plots_dir


endif


if ($generate_rad == 1) then

	# RADIATION

	# Condense radiation fields

	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename FSNTOA
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename FLUT
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename FSNT
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename FLNT
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename SWCF
	csh_scripts/condense_field.csh $archive_dir $scratch_dir $casename LWCF

	# Generate Climatology of radiation fields

	python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month 0 --end_month 11
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month 2 --end_month 4
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month 5 --end_month 7
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month 8 --end_month 10
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month 11 --end_month 1

	python python/create_climatology.py --indir $scratch_dir -c $casename -f FLUT --begin_month 0 --end_month 11
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FLUT --begin_month 2 --end_month 4
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FLUT --begin_month 5 --end_month 7
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FLUT --begin_month 8 --end_month 10
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FLUT --begin_month 11 --end_month 1

	python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNT --begin_month 0 --end_month 11
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNT --begin_month 2 --end_month 4
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNT --begin_month 5 --end_month 7
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNT --begin_month 8 --end_month 10
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FSNT --begin_month 11 --end_month 1

	python python/create_climatology.py --indir $scratch_dir -c $casename -f FLNT --begin_month 0 --end_month 11
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FLNT --begin_month 2 --end_month 4
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FLNT --begin_month 5 --end_month 7
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FLNT --begin_month 8 --end_month 10
	python python/create_climatology.py --indir $scratch_dir -c $casename -f FLNT --begin_month 11 --end_month 1

	python python/create_climatology.py --indir $scratch_dir -c $casename -f SWCF --begin_month 0 --end_month 11
	python python/create_climatology.py --indir $scratch_dir -c $casename -f SWCF --begin_month 2 --end_month 4
	python python/create_climatology.py --indir $scratch_dir -c $casename -f SWCF --begin_month 5 --end_month 7
	python python/create_climatology.py --indir $scratch_dir -c $casename -f SWCF --begin_month 8 --end_month 10
	python python/create_climatology.py --indir $scratch_dir -c $casename -f SWCF --begin_month 11 --end_month 1

	python python/create_climatology.py --indir $scratch_dir -c $casename -f LWCF --begin_month 0 --end_month 11
	python python/create_climatology.py --indir $scratch_dir -c $casename -f LWCF --begin_month 2 --end_month 4
	python python/create_climatology.py --indir $scratch_dir -c $casename -f LWCF --begin_month 5 --end_month 7
	python python/create_climatology.py --indir $scratch_dir -c $casename -f LWCF --begin_month 8 --end_month 10
	python python/create_climatology.py --indir $scratch_dir -c $casename -f LWCF --begin_month 11 --end_month 1

	# Interpolate radiation climatology to CERES-EBAF grid

	ncl indir=\"{$scratch_dir}\" field_name=\"FSNTOA\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=0  end_month=11 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FSNTOA\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=2  end_month=4  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FSNTOA\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=5  end_month=7  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FSNTOA\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=8  end_month=10 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FSNTOA\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=11 end_month=1  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl

	ncl indir=\"{$scratch_dir}\" field_name=\"FLUT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=0  end_month=11 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FLUT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=2  end_month=4  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FLUT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=5  end_month=7  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FLUT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=8  end_month=10 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FLUT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=11 end_month=1  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl

	ncl indir=\"{$scratch_dir}\" field_name=\"FSNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=0  end_month=11 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FSNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=2  end_month=4  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FSNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=5  end_month=7  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FSNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=8  end_month=10 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FSNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=11 end_month=1  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl

	ncl indir=\"{$scratch_dir}\" field_name=\"FLNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=0  end_month=11 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FLNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=2  end_month=4  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FLNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=5  end_month=7  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FLNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=8  end_month=10 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FLNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=11 end_month=1  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl

	ncl indir=\"{$scratch_dir}\" field_name=\"SWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=0  end_month=11 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"SWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=2  end_month=4  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"SWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=5  end_month=7  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"SWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=8  end_month=10 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"SWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=11 end_month=1  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl

	ncl indir=\"{$scratch_dir}\" field_name=\"LWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=0  end_month=11 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"LWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=2  end_month=4  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"LWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=5  end_month=7  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"LWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=8  end_month=10 ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"LWCF\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" begin_month=11 end_month=1  ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping_climo.ncl

	# Plot climatology for different seasons

	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month 0 --end_month 11 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month 2 --end_month 4  --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month 5 --end_month 7  --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month 8 --end_month 10 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FSNTOA --begin_month 11 --end_month 1 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir

	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FLUT --begin_month 0 --end_month 11 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FLUT --begin_month 2 --end_month 4  --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FLUT --begin_month 5 --end_month 7  --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FLUT --begin_month 8 --end_month 10 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f FLUT --begin_month 11 --end_month 1 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir

	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f SWCF --begin_month 0 --end_month 11 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f SWCF --begin_month 2 --end_month 4  --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f SWCF --begin_month 5 --end_month 7  --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f SWCF --begin_month 8 --end_month 10 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f SWCF --begin_month 11 --end_month 1 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir

	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f LWCF --begin_month 0 --end_month 11 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f LWCF --begin_month 2 --end_month 4  --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f LWCF --begin_month 5 --end_month 7  --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f LWCF --begin_month 8 --end_month 10 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir
	python python/plot_climo_RADIATION_vs_CERES-EBAF.py --indir $scratch_dir -c $casename -f LWCF --begin_month 11 --end_month 1 --CERES_EBAF_dir $data_dir --plots_dir $plots_dir

	# RADIATION TRENDS
	# Interpolate time series of radiation fields

	echo
	echo Interpolating FSNT and FLNT time series to CERES-EBAF grid ...

	ncl indir=\"{$scratch_dir}\" field_name=\"FSNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping.ncl
	ncl indir=\"{$scratch_dir}\" field_name=\"FLNT\" casename=\"{$casename}\" wgt_file=\"{$CERES_EBAF_regrid_wgt_file}\" ncl/esmf_regrid_ne120_CERES-EBAF_conservative_mapping.ncl


	# Plot trends for different regions

	python python/plot_multiple_reg_seasonal_avg.py --indir $scratch_dir -c $casename -f FSNT   --interp_grid CERES-EBAF_conservative_mapping --begin_month 0 --end_month 11 --plots_dir $plots_dir
	python python/plot_multiple_reg_seasonal_avg.py --indir $scratch_dir -c $casename -f FLNT   --interp_grid CERES-EBAF_conservative_mapping --begin_month 0 --end_month 11 --plots_dir $plots_dir
	python python/plot_multiple_reg_seasonal_avg.py --indir $scratch_dir -c $casename -f RESTOM --interp_grid CERES-EBAF_conservative_mapping --begin_month 0 --end_month 11 --plots_dir $plots_dir


endif


#GENERATE OCEAN DIAGNOSTICS


