#!/bin/csh -f 

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



set hist_path = $archive_dir/$casename/atm/hist

cd $hist_path


echo condensing $field_name
echo

ncrcat -O -v date,time,lat,lon,area,$field_name $casename.cam*h0.*.nc $scratch_dir/$casename.cam.h0.$field_name.nc

cd -
