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

#PRECT
var_interp_grid="GPCP"
var_interp_method="conservative_mapping"
var_group="Precipitation"

var_set=("${var_set[@]}" "PRECT")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "Precipitation Rate")

source_var_set=("${source_var_set[@]}" "PRECC" "PRECL")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method" "$var_interp_method")

#TS
var_interp_grid="HadISST"
var_interp_method="conservative_mapping"
var_group="Temperature"

var_set=("${var_set[@]}" "TS")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "Surface Temperature")

source_var_set=("${source_var_set[@]}" "TS")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")

# Wind stress set
var_interp_grid="ERS"
var_interp_method="conservative_mapping"
var_group="Wind Stress"

var_set=("${var_set[@]}" "TAUX")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "Ocean Zonal Wind Stress")

source_var_set=("${source_var_set[@]}" "TAUX" "OCNFRAC")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method" "$var_interp_method")
