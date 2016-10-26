#!/bin/csh -f
#GENERATE OCEAN DIAGNOSTICS

# initialize MPAS-Analysis code
setenv tmp_currentdir "`pwd`"
setenv tmp_gittopdir "`git rev-parse --show-toplevel`"
cd $tmp_gittopdir
git submodule update --init
echo 'MPAS-Analysis submodule: '`git submodule status`
cd $tmp_currentdir
unsetenv tmp_currentdir, tmp_gittopdir

set configFile = config.driver
rm -rf $configFile

echo "[case]" >> $configFile
echo "casename = $test_casename" >> $configFile
echo "native_res = $test_native_res" >> $configFile
echo "short_term_archive = $test_short_term_archive" >> $configFile
echo "ref_casename_v0 = $ref_case_v0" >> $configFile
echo "" >> $configFile
echo "[paths]" >> $configFile
echo "archive_dir = $test_archive_dir" >> $configFile

set archive_dir_ocn = $test_archive_dir/$test_casename/run

if ($test_short_term_archive == 1) then
	echo Using ACME short term archiving directory structure!
	set archive_dir_ocn = $test_archive_dir/$test_casename/ocn/hist
endif

echo "archive_dir_ocn = $archive_dir_ocn" >> $configFile
echo "scratch_dir = $test_scratch_dir" >> $configFile
echo "plots_dir = $plots_dir" >> $configFile
echo "log_dir = $log_dir" >> $configFile
echo "obs_ocndir = $obs_ocndir" >> $configFile
echo "obs_sstdir = $obs_sstdir" >> $configFile
echo "obs_seaicedir = $obs_seaicedir" >> $configFile
echo "ref_archive_v0_ocndir = $ref_archive_v0_ocndir" >> $configFile
echo "ref_archive_v0_seaicedir = $ref_archive_v0_seaicedir" >> $configFile
echo "" >> $configFile
echo "[data]" >> $configFile
echo "mpas_meshfile = $mpas_meshfile" >> $configFile
echo "mpas_remapfile = $mpas_remapfile" >> $configFile
echo "pop_remapfile = $pop_remapfile" >> $configFile
echo "mpas_climodir = $mpas_climodir" >> $configFile
echo "" >> $configFile
echo "[seaIceData]" >> $configFile
echo "obs_iceareaNH = $obs_iceareaNH" >> $configFile
echo "obs_iceareaSH = $obs_iceareaSH" >> $configFile
echo "obs_icevolNH = $obs_icevolNH" >> $configFile
echo "obs_icevolSH = $obs_icevolSH" >> $configFile
echo "" >> $configFile
echo "[time]" >> $configFile
echo "climo_yr1 = $test_begin_yr_climo" >> $configFile
echo "climo_yr2 = $test_end_yr_climo" >> $configFile
echo "yr_offset = $yr_offset" >> $configFile
echo "" >> $configFile
echo "[ohc_timeseries]" >> $configFile
echo "generate = $generate_ohc_trends" >> $configFile
echo "" >> $configFile
echo "[sst_timeseries]" >> $configFile
echo "generate = $generate_sst_trends" >> $configFile
echo "" >> $configFile
echo "[nino34_timeseries]" >> $configFile
echo "generate = $generate_nino34" >> $configFile
echo "" >> $configFile
echo "[mht_timeseries]" >> $configFile
echo "generate = $generate_mht" >> $configFile
echo "" >> $configFile
echo "[moc_timeseries]" >> $configFile
echo "generate = $generate_moc" >> $configFile
echo "" >> $configFile
echo "[sst_modelvsobs]" >> $configFile
echo "generate = $generate_sst_climo" >> $configFile
echo "" >> $configFile
echo "[seaice_timeseries]" >> $configFile
echo "generate = $generate_seaice_trends" >> $configFile
echo "" >> $configFile
echo "[seaice_modelvsobs]" >> $configFile
echo "generate = $generate_seaice_climo" >> $configFile

python python/MPAS-Analysis/run_analysis.py config.ocnice $configFile
