#!/bin/csh -f
#GENERATE OCEAN DIAGNOSTICS
if ( ${generate_ohc_trends} == 1 ) then
  echo ""
  echo "Plotting OHC time series..."
  python python/ohc_timeseries.py --indir ${archive_dir_ocn} -c ${casename} --meshfile ${mpas_meshfile} --plots_dir ${plots_dir} --year_offset ${yr_offset} --compare_with_model "true" --casename_model_tocompare ${casename_model_tocompare} --indir_model_tocompare ${ocndir_model_tocompare} --compare_with_obs "false"
endif

if ( ${generate_sst_trends} == 1 ) then
  echo ""
  echo "Plotting SST time series..."
  python python/sst_timeseries.py --indir ${archive_dir_ocn} -c ${casename} --plots_dir ${plots_dir} --year_offset ${yr_offset} --compare_with_model "true" --casename_model_tocompare ${casename_model_tocompare} --indir_model_tocompare ${ocndir_model_tocompare}
endif

if ( ${generate_nino34} == 1 ) then
  echo ""
  echo "Plotting Nino3.4 time series..."
endif

if ( ${generate_mht} == 1 ) then
  echo ""
  echo "Plotting Meridional heat transport (MHT)..."
endif

if ( ${generate_moc} == 1 ) then
  echo ""
  echo "Plotting Meridional Overturning Circulation (MOC)..."
endif

#GENERATE SEA-ICE DIAGNOSTICS
if ( ${generate_seaice_trends} == 1 ) then
  echo ""
  echo "Plotting sea-ice area time series..."
  python python/seaice_timeseries.py --indir ${archive_dir_ocn} -c ${casename} --meshfile ${mpas_meshfile} --plots_dir ${plots_dir} --year_offset ${yr_offset} --varname "iceAreaCell" --compare_with_model "true" --casename_model_tocompare ${casename_model_tocompare} --indir_model_tocompare ${seaicedir_model_tocompare} --compare_with_obs "true" --obs_filenameNH ${obs_iceareaNH} --obs_filenameSH ${obs_iceareaSH}
  echo ""
  echo "Plotting sea-ice volume time series..."
  python python/seaice_timeseries.py --indir ${archive_dir_ocn} -c ${casename} --meshfile ${mpas_meshfile} --plots_dir ${plots_dir} --year_offset ${yr_offset} --varname "iceVolumeCell" --compare_with_model "true" --casename_model_tocompare ${casename_model_tocompare} --indir_model_tocompare ${seaicedir_model_tocompare} --compare_with_obs "true" --obs_filenameNH ${obs_icevolNH} --obs_filenameSH ${obs_icevolSH}
endif

if ( ${generate_seaice_climo} == 1 ) then
  echo ""
  echo "Plotting 2-d maps of sea-ice concentration and thickness climatologies..."
  python python/seaice_modelvsobs.py --indir ${archive_dir_ocn} -c ${casename} --climodir ${mpas_climodir} --plots_dir ${plots_dir} --obsdir ${obs_seaicedir} --remapfile ${mpas_remapfile} --climo_year1 ${climo_yr1} --climo_year2 ${climo_yr2} --year_offset ${yr_offset}

  #echo ""
  #echo "Plotting 2-d maps of sea-ice concentration and thickness climatologies for comparison model run ${casename_model_tocompare}..."
  # May want to set these differently for v0:
  #set climo_yr1 = 
  #set climo_yr2 =
  #python python/seaice_modelvsobs_v0.py --indir ${seaicedir_model_tocompare} -c ${casename_model_tocompare} --plots_dir ${plots_dir} --obsdir ${obs_seaicedir} --remapfile ${model_tocompare_remapfile} --climo_year1 ${climo_yr1} --climo_year2 ${climo_yr2}
endif

#GENERATE LAND-ICE DIAGNOSTICS

