#!/bin/csh -f 

#Script to create a list of unique fields to reduce redundancy in climatology computations

set field_list_file = $argv[1]
set outfile = $argv[2]

source $field_list_file


set var_grp_unique_set = ()
set grp_interp_grid_set = ()

@ i = 1

foreach grp ($var_group_set)

set add_var = 1

foreach temp_grp ($var_grp_unique_set)
	if ($grp =~ $temp_grp) then
		set add_var = 0
	endif
end

if ($add_var == 1) then
	set var_grp_unique_set = ($var_grp_unique_set $grp)
	set grp_interp_grid_set  = ($grp_interp_grid_set $interp_grid_set[$i])
endif

@ i = $i + 1
end


echo "set var_grp_unique_set = ($var_grp_unique_set)" > $outfile
echo "set grp_interp_grid_set = ($grp_interp_grid_set)" >> $outfile

