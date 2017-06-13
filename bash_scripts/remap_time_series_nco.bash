#!/bin/bash

scratch_dir=$1
casename=$2
begin_yr=$3
end_yr=$4
native_res=$5
ts_remap_var_list_file=$6

# Read in variable list for  diagnostics e.g FLUT, FSNT etc.
source $ts_remap_var_list_file
n_var=${#var_set[@]}

# Remap files using ncremap
if [ "$casename" != "obs" ]; then

  cd $scratch_dir

  i=0
  while [ $i -lt $n_var ]; do
     var="${var_set[$i]}"
     interp_grid="${interp_grid_set[$i]}"
     interp_method="${interp_method_set[$i]}"
     regrid_wgt_file="$remap_files_dir/$native_res-to-$interp_grid.conservative.wgts.nc"

     echo
     echo "$casename $var"
     echo

     ts_file="${casename}.cam.h0.$var.$begin_yr-$end_yr.nc"
     interp_ts_file="${casename}.cam.h0.${interp_grid}_$interp_method.$var.nc"

     ncremap -I $scratch_dir \
	     -i $ts_file \
	     -m $regrid_wgt_file \
	     -O $scratch_dir \
	     -o $interp_ts_file >& $log_dir/remap_time_series_${casename}_${var}.log &

     i=$((i+1))
  done

  cd -
fi

echo
echo "Waiting for jobs to complete ..."
echo

wait
