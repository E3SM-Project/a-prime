import numpy
from round_to_first import round_to_first

def compute_contour_levels(field, n_stddev, num_levels):

	max_plot_temp = numpy.ma.mean(field[:]) + \
                          4.0 * numpy.ma.std(field[:])

	if max_plot_temp > numpy.ma.max(field[:]):
		max_plot_temp = numpy.ma.max(field[:])

	max_plot      = round_to_first(max_plot_temp)
	min_plot_temp = numpy.ma.mean(field[:]) - \
				  4.0 * numpy.ma.std(field[:])

	if min_plot_temp < numpy.ma.min(field[:]):
		min_plot_temp = numpy.ma.min(field[:])

	min_plot      = round_to_first(min_plot_temp)

	levels = numpy.linspace(min_plot, max_plot, num = num_levels)
	
	return levels
