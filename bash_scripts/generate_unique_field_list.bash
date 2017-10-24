#!/bin/bash
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

# Script to create a list of unique fields to reduce redundancy in climatology computations

field_list_file=$1
outfile=$2

source $field_list_file

var_set=()
interp_grid_set=()
interp_method_set=()

i=0
while [ $i -lt ${#source_var_set[@]} ]; do

   var="${source_var_set[$i]}"

   add_var=1

   j=0
   while [ $j -lt ${#var_set[@]} ]; do
      if [[ "$var" =~ "${var_set[$j]}" ]]; then
        add_var=0
      fi
      j=$((j+1))
   done 
 
   if [ $add_var -eq 1 ]; then 
     var_set=("${var_set[@]}" "$var")
     interp_grid_set=("${interp_grid_set[@]}" "${source_interp_grid_set[$i]}")
     interp_method_set=("${interp_method_set[@]}" "${source_interp_method_set[$i]}")
    fi
	
    i=$((i + 1))
done

echo "var_set=(${var_set[@]})" > $outfile
echo "interp_grid_set=(${interp_grid_set[@]})" >> $outfile
echo "interp_method_set=(${interp_method_set[@]})" >> $outfile

chmod a+x $outfile
