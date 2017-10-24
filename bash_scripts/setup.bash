#!/bin/bash
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

# Creating scratch, plots and logs directories
if [ ! -d $output_base_dir ]; then
  mkdir -p $output_base_dir
fi
if [ ! -d $test_scratch_dir ]; then
  mkdir -p $test_scratch_dir
fi

test_scratch_dir_atm=$test_scratch_dir/atm
if [ ! -d $test_scratch_dir_atm ]; then
  mkdir -p $test_scratch_dir_atm
fi

if [ ! -d $ref_scratch_dir ]; then
  mkdir -p $ref_scratch_dir
fi

ref_scratch_dir_atm=$ref_scratch_dir/atm
if [ ! -d $ref_scratch_dir_atm ]; then
  mkdir -p $ref_scratch_dir_atm
fi

if [ ! -d $plots_dir ]; then
  mkdir -p $plots_dir
fi
if [ ! -d $log_dir ]; then
  mkdir -p $log_dir
fi
if [ ! -d $www_dir ]; then
  mkdir -p $www_dir
fi

# Placing case information in a file: $log_dir/case_info.temp for scripts to read
echo "case_set=($test_casename $ref_case)" > $log_dir/case_info.temp
echo "archive_dir_set=($test_archive_dir $ref_archive_dir)" >> $log_dir/case_info.temp
echo "short_term_archive_set=($test_short_term_archive $ref_short_term_archive)" >> $log_dir/case_info.temp
echo "scratch_dir_set=($test_scratch_dir_atm $ref_scratch_dir_atm)" >> $log_dir/case_info.temp
echo "begin_yr_climo_set=($test_begin_yr_climo $ref_begin_yr_climo)" >> $log_dir/case_info.temp
echo "end_yr_climo_set=($test_end_yr_climo $ref_end_yr_climo)" >> $log_dir/case_info.temp
echo "begin_yr_ts_set=($test_begin_yr_ts $ref_begin_yr_ts)" >> $log_dir/case_info.temp
echo "end_yr_ts_set=($test_end_yr_ts $ref_end_yr_ts)" >> $log_dir/case_info.temp
echo "begin_yr_climateIndex_set=($test_begin_yr_climateIndex_ts $ref_begin_yr_climateIndex_ts)" >> $log_dir/case_info.temp
echo "end_yr_climateIndex_set=($test_end_yr_climateIndex_ts $ref_end_yr_climateIndex_ts)" >> $log_dir/case_info.temp

echo "native_res_set=($test_atm_res $ref_atm_res)" >> $log_dir/case_info.temp

if [ "$ref_case" == "obs" ]; then
  echo "condense_field_climo_set=($test_condense_field_climo 0)" >> $log_dir/case_info.temp
  echo "condense_field_ts_set=($test_condense_field_ts 0)" >> $log_dir/case_info.temp
  echo "compute_climo_set=($test_compute_climo 0)" >> $log_dir/case_info.temp
  echo "remap_climo_set=($test_remap_climo 0)" >> $log_dir/case_info.temp
  echo "remap_ts_set=($test_remap_ts 0)" >> $log_dir/case_info.temp

  echo "condense_field_enso_atm_set=($test_condense_field_enso_atm 0)" >> $log_dir/case_info.temp
  echo "compute_climo_enso_atm_set=($test_compute_climo_enso_atm 0)" >> $log_dir/case_info.temp
  echo "remap_climo_enso_atm_set=($test_remap_climo_enso_atm 0)" >> $log_dir/case_info.temp
  echo "remap_ts_enso_atm_set=($test_remap_ts_enso_atm 0)" >> $log_dir/case_info.temp
else
  echo "condense_field_climo_set=($test_condense_field_climo $ref_condense_field_climo)" >> $log_dir/case_info.temp
  echo "condense_field_ts_set=($test_condense_field_ts $ref_condense_field_ts)" >> $log_dir/case_info.temp
  echo "compute_climo_set=($test_compute_climo $ref_compute_climo)" >> $log_dir/case_info.temp
  echo "remap_climo_set=($test_remap_climo $ref_remap_climo)" >> $log_dir/case_info.temp
  echo "remap_ts_set=($test_remap_ts $ref_remap_ts)" >> $log_dir/case_info.temp

  echo "condense_field_enso_atm_set=($test_condense_field_enso_atm $ref_condense_field_enso_atm)" >> $log_dir/case_info.temp
  echo "compute_climo_enso_atm_set=($test_compute_climo_enso_atm $ref_compute_climo_enso_atm)" >> $log_dir/case_info.temp
  echo "remap_climo_enso_atm_set=($test_remap_climo_enso_atm $ref_remap_climo_enso_atm)" >> $log_dir/case_info.temp
  echo "remap_ts_enso_atm_set=($test_remap_ts_enso_atm $ref_remap_ts_enso_atm)" >> $log_dir/case_info.temp
fi

echo
echo "Case details for diagnostics computation:"
echo
cat $log_dir/case_info.temp
echo

# Set seasons for climatology computations
echo "begin_month_set=(0 2 5 8 11)" > $log_dir/season_info.temp
echo "end_month_set=(11 4 7 10 1)" >> $log_dir/season_info.temp
echo "season_name_set=(ANN MAM JJA SON DJF)" >> $log_dir/season_info.temp

cat $log_dir/season_info.temp
