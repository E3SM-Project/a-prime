#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#
from read_monthly_data_ts_field import read_monthly_data_ts_field


def read_monthly_data_ts(indir,
			 casename,
                         field_name,
			 interp_grid,
			 interp_method,
                         begin_yr,
                         end_yr,
                         begin_month,
                         end_month,
			 reg,
                         debug = False):


    if field_name == 'PRECT':

	try:
		field_in, lat, lon, area, units = read_monthly_data_ts_field(indir = indir,
				 casename = casename,
				 field_name = field_name,
				 interp_grid = interp_grid,
				 interp_method = interp_method,
				 begin_yr = begin_yr,
				 end_yr = end_yr,
				 begin_month = begin_month,
				 end_month = end_month,
				 reg = reg,
				 debug = debug)
		
	
	except:
		print
		print "Could not find file for: ", field_name, " Trying to look for PRECC and PRECL files!"
		print

		field_PRECC, lat, lon, area, units = read_monthly_data_ts_field(indir = indir,
				 casename = casename,
				 field_name = 'PRECC',
				 interp_grid = interp_grid,
				 interp_method = interp_method,
				 begin_yr = begin_yr,
				 end_yr = end_yr,
				 begin_month = begin_month,
				 end_month = end_month,
				 reg = reg,
				 debug = debug)

		field_PRECL, lat, lon, area, units = read_monthly_data_ts_field(indir = indir,
				 casename = casename,
				 field_name = 'PRECL',
				 interp_grid = interp_grid,
				 interp_method = interp_method,
				 begin_yr = begin_yr,
				 end_yr = end_yr,
				 begin_month = begin_month,
				 end_month = end_month,
				 reg = reg,
				 debug = debug)

		field_in = field_PRECC + field_PRECL



    elif field_name == 'RESTOM':

	try:
		field_in, lat, lon, area, units = read_monthly_data_ts_field(indir = indir,
				 casename = casename,
				 field_name = field_name,
				 interp_grid = interp_grid,
				 interp_method = interp_method,
				 begin_yr = begin_yr,
				 end_yr = end_yr,
				 begin_month = begin_month,
				 end_month = end_month,
				 reg = reg,
				 debug = debug)
		
	
	except:
		print
		print "Could not find file for: ", field_name, " Trying to look for FSNT and FLNT files!"
		print

        field_FSNT, lat, lon, area, units = read_monthly_data_ts_field(indir = indir,
			 casename = casename,
                         field_name = 'FSNT',
			 interp_grid = interp_grid,
			 interp_method = interp_method,
                         begin_yr = begin_yr,
                         end_yr = end_yr,
                         begin_month = begin_month,
                         end_month = end_month,
			 reg = reg,
                         debug = debug)

        field_FLNT, lat, lon, area, units = read_monthly_data_ts_field(indir = indir,
			 casename = casename,
                         field_name = 'FLNT',
			 interp_grid = interp_grid,
			 interp_method = interp_method,
                         begin_yr = begin_yr,
                         end_yr = end_yr,
                         begin_month = begin_month,
                         end_month = end_month,
			 reg = reg,
                         debug = debug)

	field_in = field_FSNT - field_FLNT 	#positive downwards

    else:
 
        field_in, lat, lon, area, units = read_monthly_data_ts_field(indir = indir,
			 casename = casename,
                         field_name = field_name,
			 interp_grid = interp_grid,
			 interp_method = interp_method,
                         begin_yr = begin_yr,
                         end_yr = end_yr,
                         begin_month = begin_month,
                         end_month = end_month,
			 reg = reg,
                         debug = debug)

    return (field_in, lat, lon, area, units)
