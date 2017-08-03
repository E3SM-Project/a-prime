
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
from remove_seasonal_cycle_monthly_data import remove_seasonal_cycle_monthly_data
from standardize_time_series import standardize_time_series
from optparse import OptionParser
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser(usage = "python %prog [options]")

    parser.add_argument("-d", "--debug", dest = "debug", default = False,
			help = "debug option to print some data")

    parser.add_argument("--indir", dest = "indir",
                        help = "filepath to directory model data")

    parser.add_argument("-c", "--casename", dest = "casename",
                        help = "casename of the run")

    parser.add_argument("-f", "--field_name", dest = "field_name",
                        help = "variable name")

    parser.add_argument("--interp_grid", dest = "interp_grid",
                        help = "variable name")

    parser.add_argument("--interp_method", dest = "interp_method",
                        help = "method used for interpolating the test case e.g. conservative_mapping")

    parser.add_argument("--ref_case_dir", dest = "ref_case_dir",
                        help = "filepath to ref_case directory")

    parser.add_argument("--ref_case", dest = "ref_case",
                        help = "reference casename")

    parser.add_argument("--ref_interp_grid", dest = "ref_interp_grid",
                        help = "name of the interpolated grid of reference case")

    parser.add_argument("--ref_interp_method", dest = "ref_interp_method",
                        help = "method used for interpolating the reference case e.g. conservative_mapping")

    parser.add_argument("--begin_yr", dest = "begin_yr", type = int,
                        help = "begin year")

    parser.add_argument("--end_yr", dest = "end_yr", type = int,
                        help = "end year")

    parser.add_argument("--ref_begin_yr", dest = "ref_begin_yr", type = int,
                        help = "reference case begin year")

    parser.add_argument("--ref_end_yr", dest = "ref_end_yr", type = int,
                        help = "reference case end year")

    parser.add_argument("--begin_month", dest = "begin_month", type = int,
                        help = "begin_month", default = 0)

    parser.add_argument("--end_month", dest = "end_month", type = int,
                        help = "end_month", default = 11)

    parser.add_argument("--regs", dest = "regs", nargs = '+', 
                        help = "regions to be analyzed/plotted")

    parser.add_argument("--names", dest = "names", nargs = '+', 
                        help = "names of regions to be placed in plots")

    parser.add_argument("--index_set_name", dest = "index_set_name", 
                        help = "name of the index set for naming plot files")

    parser.add_argument("--aggregate", dest = "aggregate", type = int,
                        help = "end_month", default = 1)

    parser.add_argument("--no_ann", dest = "no_ann", type = int,
			help = "flag (0/1) to remove annual cycle, default is off (0)", default = 0)

    parser.add_argument("--stdize", dest = "stdize", type = int,
			help = "flag (0/1) to standardize index, default is off (0)", default = 0)

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
ref_begin_yr            = args.ref_begin_yr
ref_end_yr              = args.ref_end_yr
regs			= args.regs
names			= args.names
index_set_name		= args.index_set_name
aggregate   		= args.aggregate
no_ann			= args.no_ann
stdize			= args.stdize
plots_dir   		= args.plots_dir


colors = ['b', 'g', 'r', 'c', 'm', 'y']

x = mpl.get_backend()
print 'backend: ', x
 
def plot_diff_index   (indir,
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
                           ref_begin_yr,
                           ref_end_yr,
			   begin_month,
			   end_month,
			   regs,
			   names,
			   index_set_name,
			   aggregate,
			   no_ann,
			   stdize,
			   debug = False):

	n_reg = len(regs)

	for i,reg in enumerate(regs):
		print __name__, 'casename: ', casename
		area_seasonal_avg, n_months_season, units = get_reg_seasonal_avg (
								  indir 	= indir,
								  casename 	= casename, 
								  field_name 	= field_name,
								  interp_grid 	= interp_grid,
								  interp_method = interp_method,
								  begin_yr 	= begin_yr,
								  end_yr 	= end_yr,
								  begin_month 	= begin_month,
								  end_month 	= end_month,
								  reg 		= reg,
								  aggregate 	= aggregate,
								  debug 	= debug)

		if i == 0: test_ts = numpy.zeros((n_reg, area_seasonal_avg.shape[0]))

		test_ts[i, :] = area_seasonal_avg 

		if aggregate == 0 and no_ann == 1:
			area_seasonal_avg_no_ann = remove_seasonal_cycle_monthly_data(test_ts[i, :], n_months_season, debug = debug)
			test_ts[i, :] = area_seasonal_avg_no_ann
		
		if stdize == 1:
			area_seasonal_avg_stddize = standardize_time_series(test_ts[i, :])
			test_ts[i, :] = area_seasonal_avg_stddize

	
        if debug: print __name__, 'test_ts: ', test_ts


	test_plot_ts = test_ts[0, :] - test_ts[-1, :]



	if aggregate == 1: 
		plot_time = numpy.arange(0,nt) + plot_begin_yr
	else:
		time = numpy.arange(0,nt)

	season = get_season_name(begin_month, end_month)

	index_name = index_set_name

	#Writing netcdf file
	outfile = outdir + '/'+ casename + '_' + index_name + '_' + field_name + '_' + season \
		    '.' + str(begin_yr) + '-' + str(end_yr) + '.nc'

	if aggregate == 1:
		outfile = outdir + '/'+ casename + '_' + index_name + '_' + field_name + '_' + season \
			    '_aggregated.' + str(begin_yr) + '-' + str(end_yr) + '.nc'
	

	print "Writing ", outfile
	print ""

	f_write = Dataset(outfile, 'w', format = 'NETCDF4')
	
	time_dim_outfile = f_write.createDimension('time', time)

	field_outfile = f_write.createVariable(index_name, 'f4', ('time'))
	field_outfile.setncattr('long_name', 'index')
	field_outfile.setncattr('units', 'unitless')
	
	field_outfile[:] = index

	time_outfile = f_write.createVariable(time, 'f4', ('time'))
	time_outfile.setncattr('long_name', 'time')

	time_outfile[:] = time


if __name__ == "__main__":
	compute_diff_index (indir = indir,
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
                               ref_begin_yr = ref_begin_yr,
                               ref_end_yr = ref_end_yr,
                               begin_month = begin_month,
                               end_month = end_month,
                               regs = regs,
			       names = names,
			       index_set_name = index_set_name,
			       aggregate = aggregate,
			       no_ann = no_ann,
			       stdize = stdize,
                               debug = debug)
