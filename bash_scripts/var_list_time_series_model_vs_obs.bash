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

# Radiation set
var_interp_grid="CERES-EBAF"
var_interp_method="conservative_mapping"
var_group="Radiation"

#RESTOM
var_set=("${var_set[@]}" "RESTOM")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "TOM Net Radiative Flux")

source_var_set=("${source_var_set[@]}" "FSNT" "FLNT")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method" "$var_interp_method")

#FLNT
var_set=("${var_set[@]}" "FLNT")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "TOM Net LW Flux")

source_var_set=("${source_var_set[@]}" "FLNT")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")

#FSNT
var_set=("${var_set[@]}" "FSNT")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "TOM Net SW Flux")

source_var_set=("${source_var_set[@]}" "FSNT")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")
