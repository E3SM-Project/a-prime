#!/bin/csh -f 

if ($#argv == 0) then
        echo Input arguments not set. Will stop!
else
        set archive_dir  		= $argv[1]
        set scratch_dir 		= $argv[2]
        set casename    		= $argv[3]
        set begin_yr    		= $argv[4]
        set end_yr      		= $argv[5]
	set var_set_file		= $argv[6]
endif

source $var_set_file

echo
echo Submitting jobs to condense $casename fields:
echo $var_set
echo
echo Log files in $log_dir/condense_field_${casename}...log
echo

foreach var ($var_set)
	echo $var

	set outfile = $scratch_dir/$casename.cam.h0.$var.$begin_yr-$end_yr.nc

	if (-f $outfile) then
		echo file $outfile exists! Not condensing.
	else
		csh_scripts/condense_field.csh  $archive_dir \
						$scratch_dir \
						$casename \
						$var \
						$begin_yr \
						$end_yr >& $log_dir/condense_field_${casename}_$var.log &
	endif
end

wait


echo
