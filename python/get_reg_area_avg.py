#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#
import numpy

def get_reg_area_avg(field, lat, lon, area_wgts, debug = False):
	nlon = lon.shape[0]
	nlat = lat.shape[0]
	if field.ndim == 2:
		nt = 1
	else:
		nt   = field.shape[0]

	if debug: print __name__, 'nlon, nlat: ', nlon, nlat

	if area_wgts == None:
		#assume equal spaced gridding over latitude and longitude
		area_wgts_lat = numpy.zeros(nlat)

		delta_lat = lat[1]-lat[0]

		print
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

	area_average = numpy.zeros(nt)

	if field.ndim == 2:
		area_average[0] = numpy.sum(field[:, :] * area_wgts[:, :])/numpy.sum(area_wgts)
	else:
		for i in range(0,nt):
		    area_average[i] = numpy.sum(field[i, :, :] * area_wgts[:, :])/numpy.sum(area_wgts)

	print __name__, 'area_average.shape: ', area_average.shape
        if debug: print __name__, 'area weighted total_field: ', area_average



	return area_average
