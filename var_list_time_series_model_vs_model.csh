#!/bin/csh -f

set var_set 			= ()
set interp_grid_set 		= ()
set interp_method_set 		= ()

set source_var_set 		= ()
set source_interp_grid_set 	= ()
set source_interp_method_set 	= ()

#PRECT
set var_interp_grid   		= GPCP
set var_interp_method 		= conservative_mapping

set var_set 			= ($var_set PRECT)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)

set source_var_set 		= ($source_var_set PRECC PRECL)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method $var_interp_method)

#Radiation set
set var_interp_grid 		= CERES-EBAF
set var_interp_method 		= conservative_mapping

#RESTOM
set var_set             	= ($var_set RESTOM)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)

set source_var_set      	= ($source_var_set FSNT FLNT)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method $var_interp_method)

#FLNT
set var_set 			= ($var_set FLNT)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)

set source_var_set 		= ($source_var_set FLNT)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method)

#FSNT
set var_set 			= ($var_set FSNT)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)

set source_var_set 		= ($source_var_set FSNT)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method)

