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
	set begin_yr 	= $argv[5]
	set end_yr      = $argv[6]
endif

	
cd $archive_dir

set file_list = ""

foreach yr (`seq -f "%04g" $begin_yr $end_yr`)
	foreach yr_file (*cam.h0.{$yr}*.nc)
		set file_list = ($file_list $yr_file)
	end
end	

echo begin_yr, end_yr: $begin_yr $end_yr
echo file_list:
echo $file_list
echo

echo condensing $field_name
echo

ncrcat -O -v date,time,lat,lon,area,$field_name $file_list $scratch_dir/$casename.cam.h0.$field_name.nc

if ($status != 0) then
	echo
	echo "Could not condense $field_name into one file. Exiting!"
	exit
endif

cd -
