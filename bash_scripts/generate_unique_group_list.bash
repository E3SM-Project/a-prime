#!/bin/bash -f 

#Script to create a list of unique fields to reduce redundancy in climatology computations

field_list_file=$1
outfile=$2

source $field_list_file


var_grp_unique_set=()
grp_interp_grid_set=()

var_grp_unique_set_file=()
grp_interp_grid_set_file=()

i=0

for grp in "${var_group_set[@]}"; do

	add_var=1

	for temp_grp in "${var_grp_unique_set[@]}"; do
		if [ "$grp" == "$temp_grp" ]; then
			add_var=0
		fi
	done

	if [ $add_var -eq 1 ]; then
		var_grp_unique_set=("${var_grp_unique_set[@]}" "$grp")
		grp_interp_grid_set=("${grp_interp_grid_set[@]}" "${interp_grid_set[$i]}")

		var_grp_unique_set_file=("${var_grp_unique_set_file[@]}" \'$grp\')
		grp_interp_grid_set_file=("${grp_interp_grid_set_file[@]}" \'${interp_grid_set[$i]}\')
	fi

	i=$((i+1))
done

if [ -f $outfile ]; then 
	rm $outfile
fi

echo 'var_grp_unique_set=(' "${var_grp_unique_set_file[@]}" ')' > $outfile
echo 'grp_interp_grid_set=(' "${grp_interp_grid_set_file[@]}" ')' >> $outfile

chmod a+x $outfile

