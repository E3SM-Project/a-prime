
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import matplotlib as mpl

import numpy
from netCDF4 import Dataset

from read_monthly_data_ts import read_monthly_data_ts
from get_season_months_index import get_season_months_index
from get_days_in_season_months import get_days_in_season_months
from get_reg_area_avg import get_reg_area_avg
from aggregate_ts_weighted import aggregate_ts_weighted
from get_reg_seasonal_avg import get_reg_seasonal_avg
from get_season_name import get_season_name

from optparse import OptionParser

if __name__ == "__main__":
    parser = OptionParser(usage = "python %prog [options]")

    parser.add_option("-d", "--debug", dest = "debug", default = False,
			help = "debug option to print some data")

    parser.add_option("--indir", dest = "indir",
                        help = "filepath to directory model data")

    parser.add_option("-c", "--casename", dest = "casename",
                        help = "casename of the run")

    parser.add_option("-f", "--field_name", dest = "field_name",
                        help = "variable name")

    parser.add_option("--interp_grid", dest = "interp_grid",
                        help = "variable name")

    parser.add_option("--begin_yr", dest = "begin_yr", type = "int",
                        help = "begin year")

    parser.add_option("--end_yr", dest = "end_yr", type = "int",
                        help = "end year")

    parser.add_option("--begin_month", dest = "begin_month", type = "int",
                        help = "begin_month", default = 0)

    parser.add_option("--end_month", dest = "end_month", type = "int",
                        help = "end_month", default = 11)

    parser.add_option("--aggregate", dest = "aggregate", type = "int",
                        help = "end_month", default = 1)

    parser.add_option("--plots_dir", dest = "plots_dir",
                        help = "filepath to GPCP directory")

    (options, args) = parser.parse_args()

debug	    = options.debug
indir       = options.indir
casename    = options.casename
field_name  = options.field_name
interp_grid = options.interp_grid
begin_yr    = options.begin_yr
end_yr      = options.end_yr
begin_month = options.begin_month
end_month   = options.end_month
aggregate   = options.aggregate
plots_dir   = options.plots_dir

regs = ['global', 'NH_high_lats', 'NH_mid_lats', 'tropics', 'SH_mid_lats', 'SH_high_lats']
names = ['Global', '90N-50N', '50N-20N', '20N-20S', '20S-50S', '50S-90S']

colors = ['b', 'g', 'r', 'c', 'm', 'y']

def plot_multiple_reg_seasonal_avg (indir,
			   casename,
			   field_name,
			   interp_grid,
			   begin_yr,
			   end_yr,
			   begin_month,
			   end_month,
			   regs,
			   aggregate,
			   debug = False):

	n_reg = len(regs)


	for i,reg in enumerate(regs):
		area_seasonal_avg, n_months_season, units = get_reg_seasonal_avg (indir = indir,
					  casename = casename, 
					  field_name = field_name,
					  interp_grid = interp_grid,
					  begin_yr = begin_yr,
					  end_yr = end_yr,
					  begin_month = begin_month,
					  end_month = end_month,
					  reg = reg,
					  aggregate = aggregate,
					  debug = debug)

		if i == 0: plot_ts = numpy.zeros((n_reg, area_seasonal_avg.shape[0]))

		plot_ts[i, :] = area_seasonal_avg 

		

        if debug: print __name__, 'plot_ts: ', plot_ts

	plot_ts_mean = numpy.mean(plot_ts, axis = 1)

	f, ax = plt.subplots(n_reg, sharex = True, figsize=(8,11))

	nt = area_seasonal_avg.shape[0]
	nyrs = nt/n_months_season


	f.text(0.5, 0.04, 'Model Year', ha='center', fontsize = 24)

        if begin_month == 0 and end_month == 11 and aggregate == 0:
            plot_time = numpy.arange(0,nt)
	else:
            plot_time = numpy.arange(0,nyrs)

	f.text(0.04, 0.5, field_name + ' (' + units + ')', va='center', rotation='vertical', fontsize = 16)

	season = get_season_name(begin_month, end_month)
	plt.suptitle(field_name + ' ' + season, fontsize = 24)


	for i,name in enumerate(names):
		if begin_month == 0 and end_month == 11 and aggregate == 0:
			bw = 13
			wgts = numpy.ones(bw)/bw
			plot_ts_moving_avg = numpy.convolve(plot_ts[i, :], wgts, 'valid')
			
			ax[i].plot(plot_time[bw/2:-bw/2+1], plot_ts_moving_avg, color = colors[i], linewidth = 4.0)
			ax[i].plot(plot_time, plot_ts[i, :], color = colors[i], linewidth = 1.0)
			ax[i].set_xticks(numpy.arange(0, nt, 12))
			ax[i].set_xticklabels(numpy.arange(0, nyrs, 1))
		else:
		        ax[i].plot(plot_time, plot_ts[i, :], color = colors[i], linewidth = 4.0)

		ax[i].set_title(name + ' , mean = ' +  "%.2f" % plot_ts_mean[i], fontsize = 12)

		for tick in ax[i].yaxis.get_major_ticks():
				tick.label.set_fontsize(12)
		for tick in ax[i].xaxis.get_major_ticks():
				tick.label.set_fontsize(12)

	#plt.plot(numpy.transpose(plot_ts))


	mpl.rcParams['savefig.dpi']=300

	outfile = plots_dir + '/' + casename + '_' \
		   + field_name + '_' + season + '_reg_ts.png'	

	plt.savefig(outfile)
	#plt.show()


if __name__ == "__main__":
	plot_multiple_reg_seasonal_avg (indir = indir,
			       casename = casename,
                               field_name = field_name,
			       interp_grid = interp_grid,
                               begin_yr = begin_yr,
                               end_yr = end_yr,
                               begin_month = begin_month,
                               end_month = end_month,
                               regs = regs,
			       aggregate = aggregate,
                               debug = debug)
