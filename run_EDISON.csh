#!/bin/csh

#
# Template driver script to generate coupled diagnostics on rhea
#
#Basic usage:
#       1. copy this template to something like run_EDISON_$user.csh
#       2. open run_EDISON_$user.csh and set user defined, case-specific variables
#       3. execute: csh run_EDISON_$user.csh

#Meaning of acronyms/words used in variable names below:
#	test:		Test case
#	ref:		Reference case
#	ts: 		Time series; e.g. test_begin_yr_ts, here ts refers to time series
#	climo: 		Climatology
#	begin_yr: 	Model year to start analysis 
#	end_yr:		Model year to end analysis
#       condense:       Create a new file for each variable with time series data for that variable.
#                       This is used to create climatology (if not pre-computed) and in generating time series plots
#	archive_dir:	Location of model generated output directory
#	scratch_dir:	Location of directory where the user wants to store files generated by the diagnostics.
#			This includes climos, remapped climos, condensed files and data files used for plotting. 
#	short_term_archive:	Adds /atm/hist after the casename. If the data sits in a different structure, add it after
#	the casename in test_casename 

set projdir =                  		/global/project/projectdirs/acme

#USER DEFINED CASE SPECIFIC VARIABLES TO SPECIFY (REQUIRED)

#Test case variables
setenv test_casename                    20160805.A_WCYCL1850.ne30_oEC.edison.alpha7_00/run
setenv test_native_res                  ne30
setenv test_archive_dir                 /global/cscratch1/sd/golaz/ACME_simulations
setenv test_short_term_archive		0
setenv test_begin_yr_climo		6
setenv test_end_yr_climo		10
setenv test_begin_yr_ts			1
setenv test_end_yr_ts			10

#Atmosphere switches (True(1)/False(0)) to condense variables, compute climos, remap climos and condensed time series file
#If no pre-processing is done (climatology, remapping), all the switches below should be 1
setenv test_compute_climo		1
setenv test_remap_climo			1
setenv test_condense_field_climo	1	#ignored if test_compute_climo = 0
						#if test_condense_field_climo = 1 and test_compute_climo = 0
						#the script will look for a condensed file 
setenv test_condense_field_ts		1
setenv test_remap_ts			1

#Reference case variables (similar to test_case variables)
setenv ref_case			obs
setenv ref_archive_dir 		$projdir/obs_for_diagnostics
#setenv ref_case				20160520.A_WCYCL1850.ne30_oEC.edison.alpha6_01
#setenv ref_archive_dir 			/scratch1/scratchdirs/golaz/ACME_simulations

#ACMEv0 ref_case info for ocn/ice diags
# IMPORTANT: the ACMEv0 model data MUST have been pre-processed. If this pre-processed data is not available, set ref_case_v0 to None.
setenv ref_case_v0                   B1850C5_ne30_v0.4
setenv ref_archive_v0_ocndir         $projdir/ACMEv0_lowres/${ref_case_v0}/ocn/postprocessing
setenv ref_archive_v0_seaicedir      $projdir/ACMEv0_lowres/${ref_case_v0}/ice/postprocessing

#The following are ignored if ref_case is obs
setenv ref_native_res             	ne30
setenv ref_short_term_archive     	0
setenv ref_begin_yr_climo         	95
setenv ref_end_yr_climo           	100
setenv ref_begin_yr_ts		  	95
setenv ref_end_yr_ts		  	100

setenv ref_condense_field_climo		1
setenv ref_condense_field_ts		1
setenv ref_compute_climo        	1
setenv ref_remap_climo          	1
setenv ref_remap_ts			1

#Set yr_offset for ocn/ice time series plots
#setenv yr_offset 1999    # for 2000 time slices
setenv yr_offset 1849   # for 1850 time slices

#Set ocn/ice specific paths to mapping files locations
# IMPORTANT: user will need to change mpas_meshfile and mpas_remapfile *if* MPAS grid varies.
#     EXAMPLES of MPAS meshfiles:
#      $projdir/milena/MPAS-grids/ocn/gridfile.oEC60to30.nc  for the EC60to30 grid
#      $projdir/milena/MPAS-grids/ocn/gridfile.oRRS30to10.nc for the RRS30to10 grid
#     EXAMPLES of MPAS remap files:
#      $projdir/mapping/maps/map_oEC60to30_TO_0.5x0.5degree_blin.160412.nc  remap from EC60to30 to regular 0.5degx0.5deg grid
#      $projdir/mapping/maps/map_oRRS30to10_TO_0.5x0.5degree_blin.160412.nc remap from RRS30to10 to regular 0.5degx0.5deg grid
#      $projdir/mapping/maps/map_oRRS15to5_TO_0.5x0.5degree_blin.160412.nc  remap from RRS15to5 to regular 0.5degx0.5deg grid
#
#     Finally, note that pop_remapfile is not currently used
setenv mpas_meshfile              $projdir/milena/MPAS-grids/ocn/gridfile.oEC60to30.nc
setenv mpas_remapfile             $projdir/mapping/maps/map_oEC60to30_TO_0.5x0.5degree_blin.160412.nc
setenv pop_remapfile              $projdir/mapping/maps/map_gx1v6_TO_0.5x0.5degree_blin.160413.nc

#Select sets of diagnostics to generate (False = 0, True = 1)
setenv generate_atm_diags 		1
setenv generate_ocnice_diags 		1

#The following ocn/ice diagnostic switches are ignored if generate_ocnice_diags is set to 0
setenv generate_ohc_trends 		1
setenv generate_sst_trends 		1
setenv generate_sst_climo 		1
setenv generate_seaice_trends 		1
setenv generate_seaice_climo 		1

#Other diagnostics not working currently, work in progress
setenv generate_moc 			0
setenv generate_mht 			0
setenv generate_nino34 			0

#Generate standalone html file to view plots on a browser, if required
setenv generate_html 			1
###############################################################################################


#OTHER VARIABLES (NOT REQUIRED TO BE CHANGED BY THE USER - DEFAULTS SHOULD WORK, USER PREFERENCE BASED CHANGES)

#Set paths to scratch, logs and plots directories
setenv test_scratch_dir		  $projdir/$USER/$test_casename.test.pp
setenv ref_scratch_dir		  $projdir/$USER/$ref_case.test.pp
setenv plots_dir 		  $projdir/$USER/coupled_diagnostics_${test_casename}-$ref_case
setenv log_dir 			  $projdir/$USER/coupled_diagnostics_${test_casename}-$ref_case.logs

#Set atm specific paths to mapping and data files locations
setenv remap_files_dir		  $projdir/mapping/maps
setenv GPCP_regrid_wgt_file 	  $projdir/mapping/maps/$test_native_res-to-GPCP.conservative.wgts.nc
setenv CERES_EBAF_regrid_wgt_file $projdir/mapping/maps/$test_native_res-to-CERES-EBAF.conservative.wgts.nc
setenv ERS_regrid_wgt_file        $projdir/mapping/maps/$test_native_res-to-ERS.conservative.wgts.nc

#Set ocn/ice specific paths to data file names and locations
setenv mpas_climodir              $test_scratch_dir

setenv obs_ocndir                 $projdir/observations/Ocean
setenv obs_seaicedir              $projdir/observations/SeaIce
setenv obs_sstdir                 $obs_ocndir/SST
setenv obs_iceareaNH              $obs_seaicedir/IceArea_timeseries/iceAreaNH_climo.nc
setenv obs_iceareaSH              $obs_seaicedir/IceArea_timeseries/iceAreaSH_climo.nc
setenv obs_icevolNH               $obs_seaicedir/PIOMAS/PIOMASvolume_monthly_climo.nc
setenv obs_icevolSH               none

#Location of website directory to host the webpage
setenv www_dir /global/project/projectdirs/acme/www/$USER

##############################################################################
###USER SHOULD NOT NEED TO CHANGE ANYTHING HERE ONWARDS######################

setenv coupled_diags_home $PWD

#LOAD THE ANACONDA-2.7-CLIMATE ENV WHICH LOADS ALL REQUIRED PYTHON MODULES
module unload python
module unload python_base
module use /global/project/projectdirs/acme/software/modulefiles/all
module load python/anaconda-2.7-climate

module load nco

#PUT THE PROVIDED CASE INFORMATION IN CSH ARRAYS TO FACILITATE READING BY OTHER SCRIPTS
csh_scripts/setup.csh

#RUN DIAGNOSTICS
if ($generate_atm_diags == 1) then
	./ACME_atm_diags.csh
endif

if ($generate_ocnice_diags == 1) then
	./ACME_ocnice_diags.csh
endif

#GENERATE HTML PAGE IF ASKED
source $log_dir/case_info.temp 

set n_cases = $#case_set

@ n_test_cases = $n_cases - 1

foreach j (`seq 1 $n_test_cases`)

	if ($generate_html == 1) then
		csh csh_scripts/generate_html_index_file.csh 	$j \
								$plots_dir \
								$www_dir
	endif
end
