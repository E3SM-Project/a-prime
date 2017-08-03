#!/bin/csh -f

set var_set 			= ()
set interp_grid_set 		= ()
set interp_method_set 		= ()
set var_group_set		= ()
set var_name_set		= ()

set source_var_set 		= ()
set source_interp_grid_set 	= ()
set source_interp_method_set 	= ()


#SLP
set var_interp_grid             = NCEP2_surface
set var_interp_method           = conservative_mapping
set var_group                   = Sea_Level_Pressure

set var_set                     = ($var_set PSL)
set interp_grid_set             = ($interp_grid_set $var_interp_grid)
set interp_method_set           = ($interp_method_set $var_interp_method)
set var_group_set               = ($var_group_set $var_group)
set var_name_set                = ($var_name_set:q "Sea Level Pressure")

set source_var_set              = ($source_var_set PSL)
set source_interp_grid_set      = ($source_interp_grid_set $var_interp_grid)
set source_interp_method_set    = ($source_interp_method_set $var_interp_method)
