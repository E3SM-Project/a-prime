#!/bin/csh

module load nco
module load ncl

module unload PE-intel
module load PE-gnu

module load python
module load python_numpy
module load python_scipy
module load python_matplotlib
module load python_netcdf4
module load geos
module load python_matplotlib_basemap_toolkit

# variables to specify
setenv casename 		 20160401.A_WCYCL2000.ne30_oEC.edison.alpha4_00H
setenv archive_dir 		 /lustre/atlas1/cli115/proj-shared/mbranst  
setenv scratch_dir 		 $PROJWORK/cli106/$USER/$casename.test.pp
setenv GPCP_regrid_wgt_file 	 $WORLDWORK/csc121/4ue/grids/ne30-to-GPCP.conservative.wgts.nc
setenv CERES_EBAF_regrid_wgt_file $WORLDWORK/csc121/4ue/grids/ne30-to-CERES-EBAF.conservative.wgts.nc
setenv data_dir 		 $WORLDWORK/csc121/obs_data
setenv plots_dir 		 $PROJWORK/cli106/$USER/coupled_diagnostics_$casename
setenv log_dir 			 $PROJWORK/cli106/$USER/$casename.test.pp/logs

#select sets of diagnostics to generate (False = 0, True = 1)
setenv generate_prect 1
setenv generate_rad 1

echo

if (! -d $scratch_dir) mkdir $scratch_dir
if (! -d $plots_dir)   mkdir $plots_dir
if (! -d $log_dir)     mkdir $log_dir


echo
echo casename: $casename 
echo archive_dir: $archive_dir

./ACME_atm_diags.csh
./ACME_ocn_diags.csh

