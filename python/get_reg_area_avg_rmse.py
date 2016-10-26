import numpy

def get_reg_area_avg_rmse(field, lat, lon, debug = False):
	nlon = lon.shape[0]
	nlat = lat.shape[0]
	if field.ndim == 2:
		nt = 1
	else:
		nt   = field.shape[0]

	if debug: print __name__, 'nlon, nlat: ', nlon, nlat

	area_wgts_lat = numpy.zeros(nlat)

        delta_lat = lat[1]-lat[0]

	print __name__, 'delta_lat: ', delta_lat

	area_wgts_lat[:] = numpy.absolute(numpy.sin((lat[:] + delta_lat/2.0) * numpy.pi/180.0) - numpy.sin((lat[:] - delta_lat/2.0)*numpy.pi/180.0))

	if debug: print __name__, 'numpy.sum(area_wgts_lat): ', numpy.sum(area_wgts_lat)
	if debug: print __name__, 'area_wgts_lat: ', area_wgts_lat

	area_wgts_tile = numpy.tile(area_wgts_lat, (nlon))
	area_wgts_transpose = numpy.reshape(area_wgts_tile, (nlon, nlat))

	area_wgts = numpy.transpose(area_wgts_transpose)

	if debug: print __name__, 'sum of area_wgts: ', numpy.sum(area_wgts)

	
	if debug: print __name__, 'lat_tile.shape: ', area_wgts_tile.shape
	if debug: print __name__, 'lat_reshape.shape: ', area_wgts.shape

	area_average_rmse = numpy.zeros(nt)

	if field.ndim == 2:
		area_average_rmse[0] = numpy.sqrt(numpy.sum(numpy.power(field[:, :], 2.0) * area_wgts[:, :])/numpy.sum(area_wgts))
	else:
		for i in range(0,nt):
		    area_average_rmse[i] = numpy.sqrt(numpy.sum(numpy.power(field[i, :, :], 2.0) * area_wgts[:, :])/numpy.sum(area_wgts))

	print __name__, 'area_average_rmse.shape: ', area_average_rmse.shape
        if debug: print __name__, 'area weighted total_field: ', area_average_rmse



	return area_average_rmse
