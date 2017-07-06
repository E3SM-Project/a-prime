#!/bin/csh -f 

set scratch_dir = $argv[1]
set casename = $argv[2]
set begin_yr = $argv[3]
set end_yr = $argv[4]
set native_res = $argv[5]
set compute_climo_var_list_file = $argv[6]

# Read in variable list for  diagnostics e.g FLUT, FSNT etc.
source $compute_climo_var_list_file
set n_var = $#var_set

# Read in list of seasons for which diagnostics are being computed
source $log_dir/season_info.temp
set n_seasons = $#begin_month_set


# Remap climos using ncremap
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

		foreach i (`seq 1 $n_seasons`)
			set season_name       = $season_name_set[$i]
			set climo_file        = ${casename}_${season_name}_climo.$var.$begin_yr-$end_yr.nc
			set interp_climo_file = ${casename}_${season_name}_climo.${interp_grid}_$interp_method.$var.$begin_yr-$end_yr.nc

			if (-f $interp_climo_file) then
				echo file $interp_climo_file exists! Not remapping.
			else
				ncremap -I $scratch_dir \
					-i $climo_file \
					-m $regrid_wgt_file \
					-O $scratch_dir \
					-o $interp_climo_file >& $log_dir/remap_climo_${casename}_${var}_$season_name.log &
			endif

		end

	end

	cd -
endif

echo
echo Waiting for jobs to complete ...
echo

wait

 	


