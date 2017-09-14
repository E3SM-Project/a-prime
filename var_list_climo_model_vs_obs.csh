#!/bin/csh -f
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#

set var_set 		= ()
set interp_grid_set 	= ()
set interp_method_set 	= ()
set var_group_set	= ()
set var_name_set	= ()

set source_var_set 	= ()
set source_interp_grid_set 	= ()
set source_interp_method_set 	= ()

#PRECT
set var_interp_grid   		= GPCP
set var_interp_method 		= conservative_mapping
set var_group			= Precipitation

set var_set 			= ($var_set PRECT)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)
set var_group_set		= ($var_group_set $var_group)
set var_name_set		= ($var_name_set:q "Precipitation Rate")

set source_var_set 		= ($source_var_set PRECC PRECL)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method $var_interp_method)

#Radiation set
#FSNTOA
set var_interp_grid 		= CERES-EBAF
set var_interp_method 		= conservative_mapping
set var_group			= Radiation

set var_set 			= ($var_set FSNTOA)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)
set var_group_set		= ($var_group_set $var_group)
set var_name_set		= ($var_name_set:q "TOA net SW flux")

set source_var_set 		= ($source_var_set FSNTOA)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method)

#FLUT
set var_set 			= ($var_set FLUT)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)
set var_group_set		= ($var_group_set $var_group)
set var_name_set		= ($var_name_set:q "TOA upward LW flux")

set source_var_set 		= ($source_var_set FLUT)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method)

#SWCF
set var_set 			= ($var_set SWCF)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)
set var_group_set		= ($var_group_set $var_group)
set var_name_set		= ($var_name_set:q "TOA shortwave cloud forcing")

set source_var_set 		= ($source_var_set SWCF)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method)

#LWCF
set var_set 			= ($var_set LWCF)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)
set var_group_set		= ($var_group_set $var_group)
set var_name_set		= ($var_name_set:q "TOA longwave cloud forcing")

set source_var_set 		= ($source_var_set LWCF)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method)

#Wind stress set
set var_interp_grid		= ERS
set var_interp_method   	= conservative_mapping
set var_group			= Wind Stress

set var_set 			= ($var_set TAU)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)
set var_group_set		= ($var_group_set $var_group)
set var_name_set		= ($var_name_set:q "Ocean Wind Stress")

set source_var_set 		= ($source_var_set TAUX TAUY OCNFRAC)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid $var_interp_grid $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method $var_interp_method $var_interp_method)
