#!/bin/csh -f

set var_set 			= ()
set interp_grid_set 		= ()
set interp_method_set 		= ()
set var_group_set		= ()
set var_name_set		= ()

set source_var_set 		= ()
set source_interp_grid_set 	= ()
set source_interp_method_set 	= ()

#TS
set var_interp_grid   		= HadISST
set var_interp_method 		= conservative_mapping
set var_group			= Temperature

set var_set 			= ($var_set TS)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)
set var_group_set		= ($var_group_set $var_group)
set var_name_set                = ($var_name_set:q "Surface Temperature")

set source_var_set 		= ($source_var_set TS)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method)

#TREFHT
#set var_interp_grid             = HadISST
#set var_interp_method           = conservative_mapping
#set var_group                   = Temperature

#set var_set                     = ($var_set TREFHT)
#set interp_grid_set             = ($interp_grid_set $var_interp_grid)
#set interp_method_set           = ($interp_method_set $var_interp_method)
#set var_group_set               = ($var_group_set $var_group)
#set var_name_set                = ($var_name_set:q "Reference height Temperature")

#set source_var_set              = ($source_var_set TREFHT)
#set source_interp_grid_set      = ($source_interp_grid_set $var_interp_grid)
#set source_interp_method_set    = ($source_interp_method_set $var_interp_method)

#Wind stress set
set var_interp_grid             = ERS
set var_interp_method           = conservative_mapping
set var_group                   = Wind Stress

set var_set                     = ($var_set TAUX)
set interp_grid_set             = ($interp_grid_set $var_interp_grid)
set interp_method_set           = ($interp_method_set $var_interp_method)
set var_group_set               = ($var_group_set $var_group)
set var_name_set                = ($var_name_set:q "Ocean Zonal Wind Stress")

set source_var_set              = ($source_var_set TAUX OCNFRAC)
set source_interp_grid_set      = ($source_interp_grid_set $var_interp_grid $var_interp_grid $var_interp_grid)
set source_interp_method_set    = ($source_interp_method_set $var_interp_method $var_interp_method $var_interp_method)
