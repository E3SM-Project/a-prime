from netCDF4 import Dataset


def get_climo_filename(	indir,
			casename,
			field_name,
			season,
			interp_grid,
			interp_method):

	if interp_grid == '0':
		file_name = indir + '/' + casename + '_' + season + '_' +\
				'climo.' + field_name + '.nc'
	else:
		file_name = indir + '/' + casename + '_' + season + '_' + \
				'climo.' + interp_grid + '_' + interp_method + \
				'.' + field_name + '.nc'


	print "file_name: ", file_name


	try:
		f     = Dataset(file_name, "r")

	except RuntimeError:
		print
		print file_name, " not found!"

		if interp_grid == '0':
			file_name = indir + '/' + casename + '_' + season + '_' +\
				'climo' + '.nc'
		else:
			file_name = indir + '/' + casename + '_' + season + '_' + \
				'climo.' + interp_grid + '_' + interp_method + \
				'.nc'

		print
		print "Using file: ", file_name
		print

	return file_name
