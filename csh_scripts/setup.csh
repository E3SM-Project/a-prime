#!/bin/csh -f 

if (! -d $test_scratch_dir) mkdir $test_scratch_dir
if (! -d $ref_scratch_dir) && ($ref_case != obs) mkdir $ref_scratch_dir
if (! -d $plots_dir)   mkdir $plots_dir
if (! -d $log_dir)     mkdir $log_dir
if (! -d $www_dir)     mkdir $www_dir

echo "set case_set                      = ($test_casename $ref_case)" > $log_dir/case_info.temp
echo "set archive_dir_set               = ($test_archive_dir $ref_archive_dir)" >> $log_dir/case_info.temp
echo "set short_term_archive_set        = ($test_short_term_archive $ref_short_term_archive)" >> $log_dir/case_info.temp
echo "set begin_yr_climo_set            = ($test_begin_yr_climo $ref_begin_yr_climo)" >> $log_dir/case_info.temp
echo "set end_yr_climo_set              = ($test_end_yr_climo $ref_end_yr_climo)" >> $log_dir/case_info.temp
echo "set begin_yr_ts_set               = ($test_begin_yr_ts $ref_begin_yr_ts)" >> $log_dir/case_info.temp
echo "set end_yr_ts_set                 = ($test_end_yr_ts $ref_end_yr_ts)" >> $log_dir/case_info.temp

echo "set native_res_set                = ($test_native_res $ref_native_res)" >> $log_dir/case_info.temp

if ($ref_case == obs) then
        echo "set scratch_dir_set               = ($test_scratch_dir $ref_archive_dir)" >> $log_dir/case_info.temp
        echo "set condense_field_climo_set      = ($test_condense_field_climo 0)" >> $log_dir/case_info.temp
        echo "set condense_field_ts_set         = ($test_condense_field_ts 0)" >> $log_dir/case_info.temp
        echo "set compute_climo_set             = ($test_compute_climo 0)" >> $log_dir/case_info.temp
        echo "set remap_climo_set               = ($test_remap_climo 0)" >> $log_dir/case_info.temp
        echo "set remap_ts_set                  = ($test_remap_ts 0)" >> $log_dir/case_info.temp
else
        echo "set scratch_dir_set               = ($test_scratch_dir $ref_scratch_dir)" >> $log_dir/case_info.temp
        echo "set condense_field_climo_set      = ($test_condense_field_climo $ref_condense_field_climo)" >> $log_dir/case_info.temp
        echo "set condense_field_ts_set         = ($test_condense_field_ts $ref_condense_field_ts)" >> $log_dir/case_info.temp
        echo "set compute_climo_set             = ($test_compute_climo $ref_compute_climo)" >> $log_dir/case_info.temp
        echo "set remap_climo_set               = ($test_remap_climo $ref_remap_climo)" >> $log_dir/case_info.temp
        echo "set remap_ts_set                  = ($test_remap_ts $ref_remap_ts)" >> $log_dir/case_info.temp
endif

echo
echo Case details for diagnostics computation:
echo
cat $log_dir/case_info.temp
echo

#Set seasons for climatology computations
echo "set begin_month_set = (0 2 5 8 11)" > $log_dir/season_info.temp
echo "set end_month_set   = (11 4 7 10 1)" >> $log_dir/season_info.temp
echo "set season_name_set = (ANN MAM JJA SON DJF)" >> $log_dir/season_info.temp

cat $log_dir/season_info.temp





