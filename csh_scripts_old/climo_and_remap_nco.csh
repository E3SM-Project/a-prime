#!/bin/csh -f 
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

# calling sequence: ./condense_field.csh archive_dir scratch_dir casename field_name

#module load nco

if ($#argv == 0) then
        echo Input arguments not set. Will stop!
else
        set archive_dir  = $argv[1]
	set scratch_dir = $argv[2]
        set casename    = $argv[3]
        set field_name  = $argv[4]
endif

set hist_path = $archive_dir/$casename

if ($short_term_archive == 1) then
	echo Using ACME short term archiving directory structure!
	set hist_path = $archive_dir/$casename/atm/hist
endif

source $scratch_dir/var_list.temp

ncclimo -i $hist_path \
	-o $scratch_dir \
	-c $casename \
	-s $begin_yr \
	-e $end_yr \
	-v $field_list 

ncremap -I $scratch_dir \
	-r $wgt_file \
	-O $scratch_dir

 	
cd $hist_path


echo condensing $field_name
echo

ncrcat -O -v date,time,lat,lon,area,$field_name $casename.cam*h0.*.nc $scratch_dir/$casename.cam.h0.$field_name.nc

cd -
