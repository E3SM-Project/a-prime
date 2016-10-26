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
module load python_sympy/0.7.5

module load python_pyqt4

setenv PATH $PATH\:/autofs/nccs-svm1_home1/zender/bin_rhea


# variables to specify
# test case variables
setenv test_casename 			20160428.A_WCYCL1850.ne30_oEC.edison.alpha5_00 
setenv test_native_res			ne30
setenv test_short_term_archive		1
setenv test_scratch_dir			$PROJWORK/cli106/$USER/$test_casename.test.pp
setenv test_begin_yr_climo		15
setenv test_end_yr_climo		20
setenv test_archive_dir 		/lustre/atlas1/cli115/proj-shared/mbranst  
setenv test_condense_field_climo	1
setenv test_condense_field_ts		1
setenv test_compute_climo		1
setenv test_remap_climo			1
setenv test_remap_ts			1

#reference case variables
#setenv ref_case			20160401.A_WCYCL2000.ne30_oEC.edison.alpha4_00H
#setenv ref_archive_dir 		/lustre/atlas1/cli115/proj-shared/mbranst
setenv ref_case			obs
setenv ref_archive_dir 		$WORLDWORK/csc121/obs_data
setenv ref_condense_field_climo	1
setenv ref_condense_field_ts	1
setenv ref_compute_climo        1
setenv ref_remap_climo          1
setenv ref_remap_ts		1

#the following are ignored if ref_case is obs
setenv ref_scratch_dir		$PROJWORK/cli106/$USER/$ref_case.test.pp
setenv ref_native_res             ne30
setenv ref_short_term_archive     1
setenv ref_begin_yr_climo         1
setenv ref_end_yr_climo           5

#set locations of plots directory and log files directory
setenv plots_dir 		  $PROJWORK/cli106/$USER/coupled_diagnostics_${test_casename}-$ref_case
setenv log_dir 			  $PROJWORK/cli106/$USER/coupled_diagnostics_${test_casename}-$ref_case.logs

#set location of mapping weight files
#setenv remap_files_dir		  $WORLDWORK/csc121/4ue/grids
setenv remap_files_dir		  $PROJWORK/cli106/salil/archive/grids
setenv GPCP_regrid_wgt_file 	  $WORLDWORK/csc121/4ue/grids/$test_native_res-to-GPCP.conservative.wgts.nc
setenv CERES_EBAF_regrid_wgt_file $WORLDWORK/csc121/4ue/grids/$test_native_res-to-CERES-EBAF.conservative.wgts.nc
setenv ERS_regrid_wgt_file        $PROJWORK/cli106/salil/archive/grids/$test_native_res-to-ERS.conservative.wgts.nc


#select sets of diagnostics to generate (False = 0, True = 1)
setenv generate_prect 0
setenv generate_rad 1
setenv generate_wind_stress 0

#generate standalone html file to view plots on a browser, if required
setenv generate_html 1
#location of website directory to host the webpage
setenv www_dir $HOME/www

##############################################################################

if (! -d $test_scratch_dir) mkdir $test_scratch_dir
if (! -d $ref_scratch_dir) mkdir $ref_scratch_dir
if (! -d $plots_dir)   mkdir $plots_dir
if (! -d $log_dir)     mkdir $log_dir

echo "set case_set 			= ($test_casename $ref_case)" > $log_dir/case_info.temp
echo "set archive_dir_set 		= ($test_archive_dir $ref_archive_dir)" >> $log_dir/case_info.temp
echo "set short_term_archive_set 	= ($test_short_term_archive $ref_short_term_archive)" >> $log_dir/case_info.temp
echo "set begin_yr_climo_set		= ($test_begin_yr_climo $ref_begin_yr_climo)" >> $log_dir/case_info.temp
echo "set end_yr_climo_set 		= ($test_end_yr_climo $ref_end_yr_climo)" >> $log_dir/case_info.temp
echo "set native_res_set 		= ($test_native_res $ref_native_res)" >> $log_dir/case_info.temp

if ($ref_case == obs) then
	echo "set scratch_dir_set		= ($test_scratch_dir $ref_archive_dir)" >> $log_dir/case_info.temp	
	echo "set condense_field_climo_set	= ($test_condense_field_climo 0)" >> $log_dir/case_info.temp
	echo "set condense_field_ts_set		= ($test_condense_field_ts 0)" >> $log_dir/case_info.temp
	echo "set compute_climo_set		= ($test_compute_climo 0)" >> $log_dir/case_info.temp
	echo "set remap_climo_set		= ($test_remap_climo 0)" >> $log_dir/case_info.temp
	echo "set remap_ts_set 			= ($test_remap_ts 0)" >> $log_dir/case_info.temp
else
	echo "set scratch_dir_set		= ($test_scratch_dir $ref_scratch_dir)" >> $log_dir/case_info.temp	
	echo "set condense_field_climo_set	= ($test_condense_field_climo $ref_condense_field_climo)" >> $log_dir/case_info.temp
	echo "set condense_field_ts_set		= ($test_condense_field_ts $ref_condense_field_ts)" >> $log_dir/case_info.temp
	echo "set compute_climo_set		= ($test_compute_climo $ref_compute_climo)" >> $log_dir/case_info.temp
	echo "set remap_climo_set		= ($test_remap_climo $ref_remap_climo)" >> $log_dir/case_info.temp
	echo "set remap_ts_set			= ($test_remap_ts $ref_remap_ts)" >> $log_dir/case_info.temp
endif

echo
echo Case details for diagnostics computation:
echo
cat $log_dir/case_info.temp
echo

#Set seasons for climatology computations 
echo "set begin_month_set = (0 2 5 8 11)" > $log_dir/season_info.temp
echo "set end_month_set   = (11 4 7 10 1)" >> $log_dir/season_info.temp
echo "set season_name_set = (ANN MAM JJA SON DJF)" >> $log_dir/season_info.temp

cat $log_dir/season_info.temp

./ACME_atm_diags.csh
#./ACME_ocn_diags.csh

