#!/bin/csh

<<<<<<< HEAD
module load nco
module load ncl

#Load the anaconda-2.7-climate env which loads all required python modules
=======
>>>>>>> e7754e1... Added ocean and sea-ice diagnostic scripts.
module unload python
module unload python_base
module use /global/project/projectdirs/acme/software/modulefiles/all
module load python/anaconda-2.7-climate
<<<<<<< HEAD

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

=======
if ( $NERSC_HOST == "edison" ) then
  setenv PATH "~zender/bin_edison:./:${PATH}"
  setenv LD_LIBRARY_PATH "~zender/lib_edison:${LD_LIBRARY_PATH}"
endif
if ( $NERSC_HOST == "cori" ) then
  setenv PATH "~zender/bin_cori:./:${PATH}"
  setenv LD_LIBRARY_PATH "~zender/lib_cori:${LD_LIBRARY_PATH}"
endif
module load ncl/6.3.0

#module unload PE-intel
#module load PE-gnu
#module load python
#module load python_numpy
#module load python_scipy
#module load python_matplotlib
#module load python_netcdf4
#module load geos
#module load python_matplotlib_basemap_toolkit
#module load python_pyqt4

# variables to specify
setenv casename	  "20160520.A_WCYCL1850.ne30_oEC.edison.alpha6_01"
setenv native_res "ne30"

set projdir = "/global/project/projectdirs/acme"
setenv archive_dir "/scratch1/scratchdirs/golaz/ACME_simulations/${casename}/run"
#setenv archive_dir "/scratch2/scratchdirs/tang30/ACME_simulations/${casename}/run"
#setenv scratch_dir ""
#setenv GPCP_regrid_wgt_file "$WORLDWORK/csc121/4ue/grids/$native_res-to-GPCP.conservative.wgts.nc"
#setenv CERES_EBAF_regrid_wgt_file "$WORLDWORK/csc121/4ue/grids/$native_res-to-CERES-EBAF.conservative.wgts.nc"
#setenv ERS_regrid_wgt_file "$PROJWORK/cli106/salil/archive/grids/$native_res-to-ERS.conservative.wgts.nc"
#setenv data_dir "$WORLDWORK/csc121/obs_data"
#set GPCP_data_dir = obs_for_diagnostics/GPCP
#set GPCP_regrid_wgt_file = grids/ne120_to_GPCP.conservative.wgts.nc
##set GPCP_data_dir = /lustre/atlas/world-shared/csc121/obs_data
setenv plots_dir "${projdir}/milena/ACME_coupled_diags/${casename}"
#setenv log_dir "$PROJWORK/cli106/$USER/$casename.test.pp/logs"

setenv mpas_meshfile "${projdir}/milena/MPAS-grids/ocn/gridfile.oEC60to30.nc"
setenv mpas_remapfile "${projdir}/milena/remapfiles/map_oEC60to30_TO_0.5x0.5degree_blin.160412.nc"
setenv model_tocompare_remapfile "${projdir}/milena/remapfiles/map_gx1v6_TO_0.5x0.5degree_blin.160413.nc"
setenv mpas_climodir "${projdir}/milena/climofiles" # casename will be appended to this
set obs_ocndir = "${projdir}/observations/Ocean"
setenv obs_seaicedir "${projdir}/observations/SeaIce"
setenv obs_iceareaNH "${obs_seaicedir}/IceArea_timeseries/iceAreaNH_climo.nc"
setenv obs_iceareaSH "${obs_seaicedir}/IceArea_timeseries/iceAreaSH_climo.nc"
setenv obs_icevolNH "${obs_seaicedir}/PIOMAS/PIOMASvolume_monthly_climo.nc"
setenv obs_icevolSH "none"
setenv casename_model_tocompare "B1850C5_ne30_v0.4"
setenv ocndir_model_tocompare "${projdir}/ACMEv0_lowres/${casename_model_tocompare}/ocn/postprocessing"
setenv seaicedir_model_tocompare "${projdir}/ACMEv0_lowres/${casename_model_tocompare}/ice/postprocessing"
#setenv casename_model_tocompare "b1850c5_acmev0_highres"
#setenv ocndir_model_tocompare "${projdir}/ACMEv0_highres/${casename_model_tocompare}/ocn/postprocessing"
#setenv seaicedir_model_tocompare "${projdir}/ACMEv0_highres/${casename_model_tocompare}/ice/postprocessing"
#setenv atmdir_model_tocompare "${projdir}/ACMEv0_highres/${casename_model_tocompare}/ice/atm/postprocessing"
>>>>>>> e7754e1... Added ocean and sea-ice diagnostic scripts.

#select sets of diagnostics to generate (False = 0, True = 1)
setenv generate_prect 0
setenv generate_rad 0
setenv generate_wind_stress 0
<<<<<<< HEAD

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

=======
setenv generate_ohc_trends 0
setenv generate_sst_trends 0
#setenv generate_sst_climo 0
setenv generate_seaice_trends 0
setenv generate_seaice_climo 1
#setenv generate_nino34 0
#setenv generate_moc 0
#setenv generate_mht 0

#generate standalone html file to view plots on a browser, if required
setenv generate_html 0
#location of website directory to host the webpage
setenv www_dir $HOME/www

setenv yr_offset 1999    # for 2000 time slices
#setenv yr_offset 1849   # for 1850 time slices

# Choose years over which to compute climatologies:
setenv climo_yr1 21
setenv climo_yr2 30

echo

if ( ! -d ${plots_dir} ) mkdir ${plots_dir}
#if ( ! -d ${scratch_dir} ) mkdir ${scratch_dir}
#if (! -d ${log_dir} ) mkdir ${log_dir}

echo
echo casename: $casename 
#echo archive_dir: $archive_dir

./ACME_atm_diags.csh
./ACME_ocnice_diags.csh
>>>>>>> e7754e1... Added ocean and sea-ice diagnostic scripts.
