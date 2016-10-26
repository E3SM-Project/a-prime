#!/bin/csh -f

#setenv NCARG_ROOT /usr/local/src/NCL-6.3.0

source /usr/local/uvcdat/latest/bin/setup_runtime.sh

setenv NCO_PATH /export/zender1/bin
setenv NCARG_ROOT /usr/local/src/NCL-6.3.0
setenv PATH $PATH\:$NCARG_ROOT/bin\:$NCO_PATH


setenv casename 		  b1850c5_t1a
setenv native_res		  ne120
setenv archive_dir 		  /space
setenv scratch_dir 		  /export/$USER/diags_out/$casename.test.pp
setenv data_dir	 		  /space2/ACME_obs_data/acme-repo/acme/obs_for_diagnostics
setenv GPCP_regrid_wgt_file       /space2/ACME_grids/$native_res-to-GPCP.conservative.wgts.nc
setenv CERES_EBAF_regrid_wgt_file /space2/ACME_grids/$native_res-to-CERES-EBAF.conservative.wgts.nc
setenv ERS_regrid_wgt_file        /space2/ACME_grids/$native_res-to-ERS.conservative.wgts.nc
setenv plots_dir 		  /export/$USER/diags_out/coupled_diagnostics_$casename
setenv log_dir 			  /export/$USER/diags_out/$casename.test.pp/logs


#select sets of diagnostics to generate (False = 0, True = 1)
setenv generate_prect 1
setenv generate_rad 1
setenv generate_wind_stress 1

echo

#generate standalone html file to view plots on a browser, if required
setenv generate_html 1
#location of website directory to host the webpage
setenv www_dir $HOME

if (! -d $scratch_dir) mkdir $scratch_dir
if (! -d $plots_dir)   mkdir $plots_dir
if (! -d $log_dir)     mkdir $log_dir


echo
echo casename: $casename 
echo archive_dir: $archive_dir

echo $NCARG_ROOT

./ACME_atm_diags.csh
./ACME_ocn_diags.csh
