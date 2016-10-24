#!/bin/csh -f 

set scratch_dir = $argv[1]
set casename = $argv[2]
set begin_yr = $argv[3]
set end_yr = $argv[4]
set native_res = $argv[5]
set ts_remap_var_list_file = $argv[6]

# Read in variable list for  diagnostics e.g FLUT, FSNT etc.
source $ts_remap_var_list_file
set n_var = $#var_set


# Remap files using ncremap
if ($casename != obs) then

	cd $scratch_dir

	foreach i (`seq 1 $n_var`)
		set var 		= $var_set[$i]
		set interp_grid 	= $interp_grid_set[$i]
		set interp_method 	= $interp_method_set[$i]
		set regrid_wgt_file   	= $remap_files_dir/$native_res-to-$interp_grid.conservative.wgts.nc

		echo
		echo $casename $var
		echo

		set ts_file        = ${casename}.cam.h0.$var.$begin_yr-$end_yr.nc
		set interp_ts_file = ${casename}.cam.h0.${interp_grid}_$interp_method.$var.nc

		ncremap -I $scratch_dir \
			-i $ts_file \
			-m $regrid_wgt_file \
			-O $scratch_dir \
			-o $interp_ts_file >& $log_dir/remap_time_series_${casename}_${var}.log &


	end

	cd -
endif

echo
echo Waiting for jobs to complete ...
echo

wait

 	


