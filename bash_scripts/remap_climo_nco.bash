#!/bin/bash

scratch_dir=$1
casename=$2
begin_yr=$3
end_yr=$4
native_res=$5
compute_climo_var_list_file=$6

# Read in variable list for  diagnostics e.g FLUT, FSNT etc.
source $compute_climo_var_list_file
n_var=${#var_set[@]}

# Read in list of seasons for which diagnostics are being computed
source $log_dir/season_info.temp
n_seasons=${#begin_month_set[@]}

# Remap climos using ncremap
if [ "$casename" != "obs" ]; then

  cd $scratch_dir

  k=0
  while [ $k -lt $n_var ]; do
     var="${var_set[$k]}"
     interp_grid="${interp_grid_set[$k]}"
     interp_method="${interp_method_set[$k]}"
     regrid_wgt_file="$remap_files_dir/$native_res-to-$interp_grid.conservative.wgts.nc"

     echo
     echo "$casename $var"
     echo

     ns=0
     while [ $ns -lt $n_seasons ]; do
        season_name="${season_name_set[$ns]}"
        climo_file="${casename}_${season_name}_climo.$var.$begin_yr-$end_yr.nc"
        interp_climo_file="${casename}_${season_name}_climo.${interp_grid}_$interp_method.$var.$begin_yr-$end_yr.nc"

        ncremap -I $scratch_dir \
		-i $climo_file \
		-m $regrid_wgt_file \
		-O $scratch_dir \
		-o $interp_climo_file >& $log_dir/remap_climo_${casename}_${var}_$season_name.log &

        ns=$((ns+1))
     done

     k=$((k+1))
  done

  cd -
fi

echo
echo "Waiting for jobs to complete ..."
echo

wait
