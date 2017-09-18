#!/bin/bash
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

# calling sequence: ./condense_field.bash archive_dir scratch_dir casename field_name

if [ $# -eq 0 ]; then
  echo "Input arguments not set. Will stop!"
else
  archive_dir=$1
  scratch_dir=$2
  casename=$3
  field_name=$4
  begin_yr=$5
  end_yr=$6
fi

cd $archive_dir

file_list=()
for yr in `seq -f "%04g" $begin_yr $end_yr`; do
   for yr_file in "*cam.h0.$yr*.nc"; do
      file_list=("${file_list[@]}" $yr_file)
   done
done

echo "begin_yr, end_yr: $begin_yr $end_yr"
echo "file_list:"
echo "${file_list[@]}"
echo

echo "condensing $field_name"
echo

ncrcat -O -v date,time,lat,lon,area,$field_name ${file_list[@]} $scratch_dir/$casename.cam.h0.$field_name.$begin_yr-$end_yr.nc

if [ $? -ne 0 ]; then
  echo
  echo "Could not condense $field_name into one file. Exiting!"
  exit
fi

cd -
