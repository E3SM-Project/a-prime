#!/bin/csh -f 

#Script to create a list of unique fields to reduce redundancy in climatology computations

set field_list_file = $argv[1]
set outfile = $argv[2]

source $field_list_file


set var_set = ()
set interp_grid_set = ()
set interp_method_set = ()

@ i = 1
foreach var ($source_var_set)

        set add_var = 1

        foreach temp_var ($var_set)
                if ($var =~ $temp_var) then
                        set add_var = 0
                endif
        end 
        
        if ($add_var == 1) then 
                set var_set 		= ($var_set $var)
                set interp_grid_set 	= ($interp_grid_set $source_interp_grid_set[$i])
                set interp_method_set 	= ($interp_method_set $source_interp_method_set[$i])
        endif
	
	@ i = $i + 1
end     

echo "set var_set = ($var_set)" > $outfile
echo "set interp_grid_set = ($interp_grid_set)" >> $outfile
echo "set interp_method_set = ($interp_method_set)" >> $outfile

