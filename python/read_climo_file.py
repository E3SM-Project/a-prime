from netCDF4 import Dataset
from get_reg_box import get_reg_box
from get_climo_filename import get_climo_filename
from get_derived_var_expr import get_derived_var_expr
import numpy
from sympy import *

def read_climo_file (indir, \
		     casename, \
		     season, \
		     field_name, \
		     begin_yr, \
		     end_yr, \
		     interp_grid, \
		     interp_method, \
		     reg, \
		     debug = False):

	file_name = get_climo_filename(	indir,
					casename,
					field_name,
					season,
					begin_yr,
					end_yr,
					interp_grid,
					interp_method)

	try:
		f = Dataset(file_name, "r")
		field = f.variables[field_name]
		lat = f.variables['lat']
		lon = f.variables['lon']
		try:
			units = field.units
		except AttributeError:
			units = field.lunits
		
	except:
	
		print
		print file_name, 'not found! Checking derived variables list for ', field_name

		var_expr, var_expr_numpy = get_derived_var_expr(field_name)

		for i, field_name_temp in enumerate(var_expr.atoms(Symbol)):

			print field_name_temp
			field_name_temp_str = str(field_name_temp)
			print field_name_temp_str

			file_name_temp = get_climo_filename( 	indir,
								casename,
								field_name_temp_str,
								season,
								begin_yr,
								end_yr,
								interp_grid,
								interp_method)

			f = Dataset(file_name_temp, "r")

			field_temp = f.variables[field_name_temp_str] 

			print 'field_temp.shape: ', field_temp.shape

			if i == 0:
				field_list = [field_temp[:]]			
				units = field_temp.units
				lat = f.variables['lat']
				lon = f.variables['lon']
			else:
				field_list = [field_list, field_temp[:]]
	
		print
		print 'field_list length: ', len(field_list)

		field = var_expr_numpy(*field_list)
		print __name__, 'field.shape: ', field.shape

	print __name__, 'field.shape: ', field.shape
	print field

	#Getting the requested region
	nlon = lon.shape[0]
	nlat = lat.shape[0]

	lat_ll, lat_ul, lon_ll, lon_ul = get_reg_box(reg) 

	print
	print __name__, 'lat_ll, lat_ul, lon_ll, lon_ul: ', lat_ll, lat_ul, lon_ll, lon_ul

	lat_reg_boolean = numpy.logical_and(lat[:]>=lat_ll, lat[:]<=lat_ul)
	lat_index_reg   = numpy.asarray(numpy.where(lat_reg_boolean))[0, :]
	lat_reg         = lat[lat_reg_boolean]

	#The following also works:
	#lat_index = numpy.arange(0,nlat)
	#lat_index_reg = lat_index[lat_reg_boolean]

	if lon_ll > lon_ul:
		lon_reg_boolean = numpy.logical_or(lon[:]>=lon_ll, lon[:] <= lon_ul)
	else:
		lon_reg_boolean = numpy.logical_and(lon[:]>=lon_ll, lon[:] <= lon_ul)

	lon_index_reg   = numpy.asarray(numpy.where(lon_reg_boolean))[0, :]
	lon_reg         = lon[lon_reg_boolean]

	#lon_index = numpy.arange(0,nlon)
	#lon_index_reg = lon_index[lon_reg_boolean]

	if debug: print
	if debug: print __name__, 'lat_reg: ', lat_reg_boolean
	if debug: print __name__, 'lon_reg: ', lon_reg_boolean
	if debug: print __name__, 'lat_index_reg.shape: ', lat_index_reg.shape
	if debug: print __name__, 'lat_index_reg: ', lat_index_reg
	if debug: print __name__, 'lon_index_reg: ', lon_index_reg
	if debug: print __name__, 'type(field): ', type(field)

	#Mulitdimensional indexing with numpy require indexes to be multidimensional arrays
	#Used here only for derived variables like RESTOM

	if type(field) == numpy.ndarray:
		if field.ndim == 2:
			field_in = field[lat_index_reg[:, None],lon_index_reg[None, :]] 
		if field.ndim == 3:
			field_in = field[0,lat_index_reg[:, None],lon_index_reg[None, :]] 


        #Multidimensional indexing with netcdf variables require 1d index variables
	#Used here for variables that are available in netcdf files

	else:
		if field.ndim == 2:
			field_in = field[lat_index_reg,lon_index_reg] 
		if field.ndim == 3:
			field_in = field[0,lat_index_reg,lon_index_reg] 


	print __name__, "field_in.shape: ", field_in.shape

	return field_in, lat_reg, lon_reg, units		
