# This file will only have commands like:
# setenv configoption configvalue
# set configoption = configvalue

# variables to specify
#setenv casename	  "20160520.A_WCYCL1850.ne30_oEC.edison.alpha6_01"
setenv casename	  "20160520.A_WCYCL2000.ne30_oEC.edison.alpha6_01"
setenv native_res "ne30"

set projdir = "/global/project/projectdirs/acme"
setenv archive_dir "/scratch1/scratchdirs/golaz/ACME_simulations/${casename}/run"
setenv plots_dir "${projdir}/ACME_coupled_diags/${casename}"

setenv mpas_meshfile "${projdir}/milena/MPAS-grids/ocn/gridfile.oEC60to30.nc"
setenv mpas_remapfile "${projdir}/mapping/maps/map_oEC60to30_TO_0.5x0.5degree_blin.160412.nc"
setenv model_tocompare_remapfile "${projdir}/mapping/maps/map_gx1v6_TO_0.5x0.5degree_blin.160413.nc"
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

#select sets of diagnostics to generate (False = 0, True = 1)
setenv generate_prect 0
setenv generate_rad 0
setenv generate_wind_stress 0
setenv generate_ohc_trends 1
setenv generate_sst_trends 1
setenv generate_sst_climo 0
setenv generate_seaice_trends 1
setenv generate_seaice_climo 1
setenv generate_moc 0
setenv generate_mht 0
setenv generate_nino34 0

#generate standalone html file to view plots on a browser, if required
setenv generate_html 0
#location of website directory to host the webpage
setenv www_dir $HOME/www

setenv yr_offset 1999    # for 2000 time slices
#setenv yr_offset 1849   # for 1850 time slices

# Choose years over which to compute climatologies:
setenv climo_yr1 71
setenv climo_yr2 100
#setenv climo_yr1 15
#setenv climo_yr2 16

#setenv ohc_timeseries_compare_with_model true
