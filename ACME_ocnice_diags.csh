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

setenv archive_dir_ocn $test_archive_dir/$test_casename

if ($test_short_term_archive == 1) then
	echo Using ACME short term archiving directory structure!
	setenv archive_dir_ocn $test_archive_dir/$test_casename/ocn/hist
endif

python python/setup_ocnice_config.py
python python/MPAS-Analysis/run_analysis.py config.ocnice
