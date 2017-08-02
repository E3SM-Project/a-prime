#!/bin/csh -f

set var_set 			= ()
set interp_grid_set 		= ()
set interp_method_set 		= ()
set var_group_set		= ()
set var_name_set		= ()

set source_var_set 		= ()
set source_interp_grid_set 	= ()
set source_interp_method_set 	= ()

#PRECT
set var_interp_grid   		= COREv2
set var_interp_method 		= conservative_mapping
set var_group			= Precipitation

set var_set 			= ($var_set PRECT)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)
set var_group_set		= ($var_group_set $var_group)
set var_name_set                = ($var_name_set:q "Precipitation Rate")

set source_var_set 		= ($source_var_set PRECC PRECL)
set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid $var_interp_grid)
set source_interp_method_set 	= ($source_interp_method_set $var_interp_method $var_interp_method)

#TS
#set var_interp_grid   		= NCEP2
#set var_interp_method 		= conservative_mapping
#set var_group			= Temperature

#set var_set 			= ($var_set TS)
#set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
#set interp_method_set 		= ($interp_method_set $var_interp_method)
#set var_group_set		= ($var_group_set $var_group)
#set var_name_set                = ($var_name_set:q "Surface Temperature")

#set source_var_set 		= ($source_var_set TS)
#set source_interp_grid_set 	= ($source_interp_grid_set $var_interp_grid)
#set source_interp_method_set 	= ($source_interp_method_set $var_interp_method)

#TS
set var_interp_grid   		= NCEP2
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

#SLP
set var_interp_grid   		= NCEP2_surface
set var_interp_method 		= conservative_mapping
set var_group			= Sea_Level_Pressure

set var_set 			= ($var_set PSL)
set interp_grid_set 		= ($interp_grid_set $var_interp_grid)
set interp_method_set 		= ($interp_method_set $var_interp_method)
set var_group_set		= ($var_group_set $var_group)
set var_name_set                = ($var_name_set:q "Sea Level Pressure")

set source_var_set 		= ($source_var_set PSL)
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
set var_interp_grid             = COREv2_flux
set var_interp_method           = conservative_mapping
set var_group                   = Wind_Stress

set var_set                     = ($var_set TAUX)
set interp_grid_set             = ($interp_grid_set $var_interp_grid)
set interp_method_set           = ($interp_method_set $var_interp_method)
set var_group_set               = ($var_group_set $var_group)
set var_name_set                = ($var_name_set:q "Ocean Zonal Wind Stress")

set source_var_set              = ($source_var_set TAUX OCNFRAC)
set source_interp_grid_set      = ($source_interp_grid_set $var_interp_grid $var_interp_grid $var_interp_grid)
set source_interp_method_set    = ($source_interp_method_set $var_interp_method $var_interp_method $var_interp_method)

#Heat Flux set
set var_interp_grid             = COREv2_flux
set var_interp_method           = conservative_mapping
set var_group                   = Surface_Heat_Flux

set var_set                     = ($var_set LHFLX)
set interp_grid_set             = ($interp_grid_set $var_interp_grid)
set interp_method_set           = ($interp_method_set $var_interp_method)
set var_group_set               = ($var_group_set $var_group)
set var_name_set                = ($var_name_set:q "Latent Heat Flux")

set source_var_set              = ($source_var_set LHFLX)
set source_interp_grid_set      = ($source_interp_grid_set $var_interp_grid $var_interp_grid $var_interp_grid)
set source_interp_method_set    = ($source_interp_method_set $var_interp_method $var_interp_method $var_interp_method)


set var_set                     = ($var_set SHFLX)
set interp_grid_set             = ($interp_grid_set $var_interp_grid)
set interp_method_set           = ($interp_method_set $var_interp_method)
set var_group_set               = ($var_group_set $var_group)
set var_name_set                = ($var_name_set:q "Sensible Heat Flux")

set source_var_set              = ($source_var_set SHFLX)
set source_interp_grid_set      = ($source_interp_grid_set $var_interp_grid $var_interp_grid $var_interp_grid)
set source_interp_method_set    = ($source_interp_method_set $var_interp_method $var_interp_method $var_interp_method)


set var_set                     = ($var_set FLNS)
set interp_grid_set             = ($interp_grid_set $var_interp_grid)
set interp_method_set           = ($interp_method_set $var_interp_method)
set var_group_set               = ($var_group_set $var_group)
set var_name_set                = ($var_name_set:q "Longwave Heat Flux")

set source_var_set              = ($source_var_set FLNS)
set source_interp_grid_set      = ($source_interp_grid_set $var_interp_grid $var_interp_grid $var_interp_grid)
set source_interp_method_set    = ($source_interp_method_set $var_interp_method $var_interp_method $var_interp_method)


set var_set                     = ($var_set FSNS)
set interp_grid_set             = ($interp_grid_set $var_interp_grid)
set interp_method_set           = ($interp_method_set $var_interp_method)
set var_group_set               = ($var_group_set $var_group)
set var_name_set                = ($var_name_set:q "Shortwave Heat Flux")

set source_var_set              = ($source_var_set FSNS)
set source_interp_grid_set      = ($source_interp_grid_set $var_interp_grid $var_interp_grid $var_interp_grid)
set source_interp_method_set    = ($source_interp_method_set $var_interp_method $var_interp_method $var_interp_method)


set var_set                     = ($var_set RESSURF)
set interp_grid_set             = ($interp_grid_set $var_interp_grid)
set interp_method_set           = ($interp_method_set $var_interp_method)
set var_group_set               = ($var_group_set $var_group)
set var_name_set                = ($var_name_set:q "Surface Net Heat Flux")

set source_var_set              = ($source_var_set FLNS FSNS LHFLX SHFLX)
set source_interp_grid_set      = ($source_interp_grid_set $var_interp_grid $var_interp_grid $var_interp_grid)
set source_interp_method_set    = ($source_interp_method_set $var_interp_method $var_interp_method $var_interp_method)
