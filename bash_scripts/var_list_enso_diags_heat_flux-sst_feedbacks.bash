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


#TS
var_interp_grid="NCEP2"
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



# Surface Heat Flux Set
var_interp_grid="COREv2_flux"
var_interp_method="conservative_mapping"
var_group="Surface Heat Flux"

#LHFLX
var_set=("${var_set[@]}" "LHFLX")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "Latent Heat Flux")

source_var_set=("${source_var_set[@]}" "LHFLX")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")

#SHFLX
var_set=("${var_set[@]}" "SHFLX")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "Sensible Heat Flux")

source_var_set=("${source_var_set[@]}" "SHFLX")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")


#FLNS
var_set=("${var_set[@]}" "FLNS")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "Longwave Heat Flux")

source_var_set=("${source_var_set[@]}" "FLNS")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")

#FSNS
var_set=("${var_set[@]}" "FSNS")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "Shortwave Heat Flux")

source_var_set=("${source_var_set[@]}" "FSNS")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method")

#RESSURF
var_set=("${var_set[@]}" "RESSURF")
interp_grid_set=("${interp_grid_set[@]}" "$var_interp_grid")
interp_method_set=("${interp_method_set[@]}" "$var_interp_method")
var_group_set=("${var_group_set[@]}" "$var_group")
var_name_set=("${var_name_set[@]}" "Surface Net Heat Flux")

source_var_set=("${source_var_set[@]}" "FLNS" "FSNS" "LHFLX" "SHFLX")
source_interp_grid_set=("${source_interp_grid_set[@]}" "$var_interp_grid" "$var_interp_grid" "$var_interp_grid" "$var_interp_grid")
source_interp_method_set=("${source_interp_method_set[@]}" "$var_interp_method" "$var_interp_method" "$var_interp_method" "$var_interp_method")


