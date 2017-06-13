#!/bin/bash

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
#FSNTOA
var_interp_grid="CERES-EBAF"
var_interp_method="conservative_mapping"
var_group="Radiation"

var_set=("${var_set[@]}" "FSNTOA")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "TOA net SW flux")

source_var_set=("${source_var_set[@]}" "FSNTOA")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")

#FLUT
var_set=("${var_set[@]}" "FLUT")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "TOA upward LW flux")

source_var_set=("${source_var_set[@]}" "FLUT")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")

#SWCF
var_set=("${var_set[@]}" "SWCF")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "TOA shortwave cloud forcing")

source_var_set=("${source_var_set[@]}" "SWCF")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")

#LWCF
var_set=("${var_set[@]}" "LWCF")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "TOA longwave cloud forcing")

source_var_set=("${source_var_set[@]}" "LWCF")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")

# Wind stress set
var_interp_grid="ERS"
var_interp_method="conservative_mapping"
var_group="Wind Stress"

var_set=("${var_set[@]}" "TAU")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "Ocean Wind Stress")

source_var_set=("${source_var_set[@]}" "TAUX" "TAUY" "OCNFRAC")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid" "$var_interp_grid" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method" "$var_interp_method" "$var_interp_method")
