#!/bin/csh

module load nco
module load ncl

#Load the anaconda-2.7-climate env which loads all required python modules
module unload python
module unload python_base
module use /global/project/projectdirs/acme/software/modulefiles/all
module load python/anaconda-2.7-climate

#Do the following module loads if not using anaconda-2.7-climate environment
#module load python
#module load numpy
#module load scipy
#module load matplotlib
#module load netcdf4-python
#module load basemap

# variables to specify
setenv casename 		  20160520.A_WCYCL2000.ne30_oEC.edison.alpha6_01 
setenv native_res		  ne30

setenv short_term_archive	  0

setenv archive_dir 		  /scratch1/scratchdirs/golaz/ACME_simulations  
setenv scratch_dir 		  /global/project/projectdirs/acme/$USER/$casename.test.pp
setenv GPCP_regrid_wgt_file 	  /global/project/projectdirs/acme/salil/grids/$native_res-to-GPCP.conservative.wgts.nc
setenv CERES_EBAF_regrid_wgt_file /global/project/projectdirs/acme/salil/grids/$native_res-to-CERES-EBAF.conservative.wgts.nc
setenv ERS_regrid_wgt_file        /global/project/projectdirs/acme/salil/grids/$native_res-to-ERS.conservative.wgts.nc
setenv data_dir 		  /global/project/projectdirs/acme/obs_for_diagnostics
setenv plots_dir 		  /global/project/projectdirs/acme/$USER/coupled_diagnostics_$casename
setenv log_dir 			  /global/project/projectdirs/acme/$USER/$casename.test.pp/logs


#select sets of diagnostics to generate (False = 0, True = 1)
setenv generate_prect 0
setenv generate_rad 0
setenv generate_wind_stress 0

#generate standalone html file to view plots on a browser, if required
setenv generate_html 1
#location of website directory to host the webpage
setenv www_dir /global/project/projectdirs/acme/www/$USER

echo

if (! -d $scratch_dir) mkdir $scratch_dir
if (! -d $plots_dir)   mkdir $plots_dir
if (! -d $log_dir)     mkdir $log_dir


echo
echo casename: $casename 
echo archive_dir: $archive_dir

./ACME_atm_diags.csh
./ACME_ocn_diags.csh

