import matplotlib as mpl
#changing the default backend to agg to resolve contouring issue on rhea
mpl.use('Agg')

from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator

import numpy
from netCDF4 import Dataset

from read_monthly_data_ts import read_monthly_data_ts
from get_season_months_index import get_season_months_index
from get_days_in_season_months import get_days_in_season_months
from get_reg_area_avg import get_reg_area_avg
from aggregate_ts_weighted import aggregate_ts_weighted
from get_reg_seasonal_avg import get_reg_seasonal_avg
from get_season_name import get_season_name
from get_reg_avg_climo import get_reg_avg_climo
from get_regress_index_field import get_regress_index_field
from optparse import OptionParser
from round_to_first import round_to_first
from get_season_name import get_season_name
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser(usage = "python %prog [options]")

    parser.add_argument("-d", "--debug", dest = "debug", default = False,
			help = "debug option to print some data")

    parser.add_argument("--indir", dest = "indir",
                        help = "filepath to directory model data")

    parser.add_argument("-c", "--casename", dest = "casename",
                        help = "casename of the run")

    parser.add_argument("-f", "--field_name", dest = "field_name", nargs = '+',
                        help = "variable name")

    parser.add_argument("--interp_grid", dest = "interp_grid", nargs = '+',
                        help = "variable name")

    parser.add_argument("--interp_method", dest = "interp_method", nargs = '+',
                        help = "method used for interpolating the test case e.g. conservative_mapping")

    parser.add_argument("--ref_case_dir", dest = "ref_case_dir", nargs = '+',
                        help = "filepath to ref_case directory")

    parser.add_argument("--ref_case", dest = "ref_case", nargs = '+',
                        help = "reference casename")

    parser.add_argument("--ref_interp_grid", dest = "ref_interp_grid", nargs = '+', 
                        help = "name of the interpolated grid of reference case")

    parser.add_argument("--ref_interp_method", dest = "ref_interp_method", nargs = '+', 
                        help = "method used for interpolating the reference case e.g. conservative_mapping")

    parser.add_argument("--begin_yr", dest = "begin_yr", type = int,
                        help = "begin year")

    parser.add_argument("--end_yr", dest = "end_yr", type = int,
                        help = "end year")

    parser.add_argument("--begin_month", dest = "begin_month", type = int, nargs = '+', 
                        help = "begin_month", default = 0)

    parser.add_argument("--end_month", dest = "end_month", type = int, nargs = '+',
                        help = "end_month", default = 11)

    parser.add_argument("--aggregate", dest = "aggregate", type = int,
                        help = "end_month", default = 1)

    parser.add_argument("--no_ann", dest = "no_ann", type = int,
                        help = "end_month", default = 0)

    parser.add_argument("--stdize", dest = "stdize", type = int,
                        help = "end_month", default = 0)

    parser.add_argument("--reg", dest = "reg", nargs = '+',
                        help = "regions to be analyzed/plotted")

    parser.add_argument("--reg_name", dest = "reg_name", nargs = '+',
                        help = "names of regions to be placed in plots")

    parser.add_argument("--plots_dir", dest = "plots_dir",
                        help = "filepath to GPCP directory")

    args = parser.parse_args()

debug	    		= args.debug
indir		    	= args.indir
casename	    	= args.casename
field_name	    	= args.field_name
interp_grid	    	= args.interp_grid
interp_method           = args.interp_method
ref_case_dir            = args.ref_case_dir
ref_case                = args.ref_case
ref_interp_grid         = args.ref_interp_grid
ref_interp_method       = args.ref_interp_method
begin_yr    		= args.begin_yr
end_yr      		= args.end_yr
begin_month 		= args.begin_month
end_month   		= args.end_month
aggregate   		= args.aggregate
no_ann			= args.no_ann
stdize			= args.stdize
reg			= args.reg
reg_name		= args.reg_name
plots_dir   		= args.plots_dir


colors = ['b', 'g', 'r', 'c', 'm', 'y']

x = mpl.get_backend()
print 'backend: ', x
 
def plot_regress_index_field (indir,
			   casename,
			   field_name,
			   interp_grid,
			   interp_method,
			   ref_case_dir,
			   ref_case,
			   ref_interp_grid,
			   ref_interp_method,
			   begin_yr,
			   end_yr,
			   begin_month,
			   end_month,
			   aggregate,
			   reg,
			   reg_name,
			   debug = False):


	print __name__, 'casename: ', casename
	print __name__, 'field_name: ', field_name

	regr_matrix, t_test_matrix, lat_reg, lon_reg, units = get_regress_index_field (
							  indir 	= indir,
							  casename 	= casename, 
							  field_name 	= field_name,
							  interp_grid 	= interp_grid,
							  interp_method = interp_method,
							  begin_yr 	= begin_yr,
							  end_yr 	= end_yr,
							  begin_month 	= begin_month,
							  end_month 	= end_month,
							  aggregate	= aggregate,
							  no_ann	= no_ann,
							  stdize	= stdize,
							  reg 		= reg,
							  reg_name	= reg_name,
							  debug 	= debug)

	plot_field =  regr_matrix


	if ref_case == 'CERES-EBAF':
		if field_name == 'FLNT': field_name_ref = 'FLUT'
		if field_name == 'RESTOM': field_name_ref = 'RESTOA'
		if field_name == 'FSNT': field_name_ref = 'FSNTOA'

	elif ref_case == 'HadISST':
		if field_name == 'TS': field_name_ref = 'SST'

	else:
		field_name_ref = field_name 

#	ref_regr_matrix, ref_t_test_matrix, lat_reg, lon_reg, units = get_regress_index_field (
#                                                          indir         = ref_case_dir,
#                                                          casename      = ref_case,
#                                                          field_name    = field_name,
#                                                          interp_grid   = ref_interp_grid,
#                                                          interp_method = ref_interp_method,
#                                                          begin_yr      = begin_yr,
#                                                          end_yr        = end_yr,
#                                                          begin_month   = begin_month,
#                                                          end_month     = end_month,
#							   aggregate	= aggregate,
#							   no_ann	= no_ann,
#							   stdize	= stdize,
#                                                          reg           = reg,
#							   reg_name	 = reg_name,
#                                                          debug         = debug)

#	ref_plot_field = ref_regr_matrix

#	if debug: print __name__, 'ref_plot_field.shape ', ref_plot_field.shape

        if debug: print __name__, 'plot_field: ', plot_field

	season_field = get_season_name(begin_month[0], end_month[0])
	season_index = get_season_name(begin_month[1], end_month[1])

	#Computing levels using mean and standard deviation
	plot_field_min  = numpy.min(plot_field)
	plot_field_max  = numpy.max(plot_field) 


	num      = 21
	max_plot = round_to_first(4.0 * numpy.ma.std(plot_field))
	levels 	 = numpy.linspace(-max_plot, max_plot, num = num)

	print
	print 'mean, stddev, max_plot: ', \
		numpy.ma.mean(plot_field), numpy.ma.std(plot_field), max_plot
	print 'min, max: ', numpy.ma.min(plot_field), numpy.ma.max(plot_field)
	print 'contour levels: ', levels



	f = plt.figure(figsize=(11, 8.5))

	title_txt = 'Regression Coefficients \n' + field_name[0] + ' (' + season_field + ') on ' \
				   + reg_name[1] + ' ' + field_name[1] + ' index' + ' (' + season_index + ')'

	if stdize == 1:
		title_txt = 'Regression Coefficients \n' + field_name[0] + ' (' + season_field + ') on ' \
				+ reg_name[1] + ' ' + field_name[1] + ' index' + ' (' + season_index + \
				', standardized (mean = 0, std. dev. = 1))' \

	f.suptitle(title_txt, fontsize = 12) 

	ax = f.add_subplot(1,1,1)

	ax.set_title(casename)

	m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

	m.drawcoastlines()

	lons, lats = numpy.meshgrid(lon_reg,lat_reg)
	x, y = m(lons,lats)

	c = m.contourf(x, y, plot_field[:, :], cmap = 'seismic', levels = levels, extend = 'both')
	cb = m.colorbar(c)

	#plotting hatches representing statistical significance
	m.contourf(x, y, t_test_matrix, 2, colors = 'none', extend = 'both', hatches = [None, '////'])

	text_data = 'Units = ' + units + ', ' + \
		    'min = '  + str(round(plot_field_min, 2)) + ', ' + \
		    'max = '  + str(round(plot_field_max, 2)) + ', ' + \
		    'Hatched areas: Coeff. significantly different from zero at 95% confidence level'

	ax.text(0, -100, text_data, transform = ax.transData, fontsize = 10)

	mpl.rcParams['savefig.dpi']=300


	print __name__, 'begin_month: ', begin_month
	print __name__, 'end_month: ', end_month

	outfile = plots_dir + '/' + casename + '_regr_' \
			   + field_name[0] + '_' + reg[0] + '_' + season_field + '_' \
			   + field_name[1] + '_' + reg[1] + '_' + season_index + '.png'

	plt.savefig(outfile)

if __name__ == "__main__":
	plot_regress_index_field (indir = indir,
			       casename = casename,
                               field_name = field_name,
			       interp_grid = interp_grid,
			       interp_method = interp_method,
			       ref_case_dir = ref_case_dir,
			       ref_case = ref_case,
			       ref_interp_grid = ref_interp_grid,
			       ref_interp_method = ref_interp_method,
                               begin_yr = begin_yr,
                               end_yr = end_yr,
                               begin_month = begin_month,
                               end_month = end_month,
                               reg = reg,
			       reg_name = reg_name,
			       aggregate = aggregate,
                               debug = debug)
