#!/bin/bash
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

var_set=()
interp_grid_set=()
interp_method_set=()
var_group_set=()
var_name_set=()

source_var_set=()
source_interp_grid_set=()
source_interp_method_set=()


#SLP
var_interp_grid="NCEP2_surface"
var_interp_method="conservative_mapping"
var_group="Sea Level Pressure"

var_set=("${var_set[@]}" "PSL")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "Sea Level Pressure")

source_var_set=("${source_var_set[@]}" "PSL")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")



