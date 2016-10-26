#python script to plot wind stress vectors and magnitude over the oceans using 
#CF variables TAUX and TAUY

import matplotlib as mpl
#changing the default backend to agg to resolve contouring issue on rhea
mpl.use('Agg')

from   mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import math
import numpy
from   netCDF4 import Dataset
from   optparse import OptionParser

from get_season_name import get_season_name
from round_to_first  import round_to_first
from get_reg_area_avg      import get_reg_area_avg
from get_reg_area_avg_rmse import get_reg_area_avg_rmse

if __name__ == "__main__":
    parser = OptionParser(usage = "python %prog [options]")

    parser.add_option("--indir", dest = "indir",
                        help = "filepath to directory model data")

    parser.add_option("-c", "--casename", dest = "casename",
                        help = "casename of the run")

    parser.add_option("-f", "--field_name", dest = "field_name",
                        help = "variable name")

    parser.add_option("--begin_yr", dest = "begin_yr", type = "int",
                        help = "begin year")

    parser.add_option("--end_yr", dest = "end_yr", type = "int",
                        help = "end year")

    parser.add_option("--begin_month", dest = "begin_month", type = "int",
                        help = "begin_month", default = 0)

    parser.add_option("--end_month", dest = "end_month", type = "int",
                        help = "end_month", default = 11)

    parser.add_option("--ERS_dir", dest = "ERS_dir",
                        help = "filepath to ERS directory")

    parser.add_option("--plots_dir", dest = "plots_dir",
                        help = "filepath to ERS directory")

    (options, args) = parser.parse_args()

indir       = options.indir
casename    = options.casename
field_name  = options.field_name
begin_yr    = options.begin_yr
end_yr      = options.end_yr
begin_month = options.begin_month
end_month   = options.end_month
ERS_dir     = options.ERS_dir
plots_dir   = options.plots_dir


#Read Variables TAUX, TAUY and OCNFRAC

if field_name == 'wind_stress':

    #Reading OCNFRAC
    file_name_OCNFRAC = indir + '/' + casename + \
                '.climo.' + str(begin_month) + '_' + str(end_month) + \
                '.ERS_conservative_mapping.' + 'OCNFRAC.nc'

    f_OCNFRAC     = Dataset(file_name_OCNFRAC, "r")
    field_OCNFRAC = f_OCNFRAC.variables['OCNFRAC']


    #Reading TAUX and masking non-ocn grid boxes
    file_name_TAUX = indir + '/' + casename + \
                '.climo.' + str(begin_month) + '_' + str(end_month) + \
                '.ERS_conservative_mapping.' + 'TAUX.nc'

    f_TAUX     = Dataset(file_name_TAUX, "r")
    field_TAUX = f_TAUX.variables['TAUX']
    lat        = f_TAUX.variables['lat']
    lon        = f_TAUX.variables['lon']
    units      = field_TAUX.units

    field_TAUX_plot      = numpy.ma.zeros((lat.shape[0], lon.shape[0]))
    field_TAUX_plot[:,:] = field_TAUX[:,:]
    field_TAUX_plot.mask = numpy.where(field_OCNFRAC[:,:] < 0.5, 1, 0)

    #Reading TAUY and masking non-ocn grid boxes
    file_name_TAUY = indir + '/' + casename + \
                '.climo.' + str(begin_month) + '_' + str(end_month) + \
                '.ERS_conservative_mapping.' + 'TAUY.nc'


    f_TAUY     = Dataset(file_name_TAUY, "r")
    field_TAUY = f_TAUY.variables['TAUY']

    field_TAUY_plot      = numpy.ma.zeros((lat.shape[0], lon.shape[0]))
    field_TAUY_plot[:,:] = field_TAUY[:,:]
    field_TAUY_plot.mask = numpy.where(field_OCNFRAC[:,:] < 0.5, 1, 0)

    #Computing an approximation of wind stress magnitude from monthly averages	
    field_TAU = numpy.ma.sqrt(numpy.ma.power(field_TAUX_plot, 2.0) + numpy.ma.power(field_TAUY_plot, 2.0))


#Getting season name from begin_month and end_month
season = get_season_name(begin_month, end_month)

#Reading ERS data
file_ERS = ERS_dir + '/' + 'ERS_' + season + '_climo.nc'

print "Using ERS file: ", file_ERS

f_ERS 	       = Dataset(file_ERS, "r")
field_ERS_TAUX = f_ERS.variables['TAUX'] 
field_ERS_TAUY = f_ERS.variables['TAUY'] 

#Computing an approximation of wind stress magnitude
field_ERS_TAU = numpy.ma.sqrt(numpy.ma.power(field_ERS_TAUX[0,:,:], 2.0) + numpy.ma.power(field_ERS_TAUY[0,:,:], 2.0))


#Computing levels using mean and standard deviation
num = 11

max_plot = round_to_first(numpy.ma.mean(field_TAU) + \
			  3.0 * numpy.ma.std(field_TAU))
min_plot = 0.0

levels = numpy.linspace(min_plot, max_plot, num = num)

field_max_TAU = numpy.ma.max(field_TAU)
field_min_TAU = numpy.ma.min(field_TAU)
field_max_ERS_TAU = numpy.ma.max(field_ERS_TAU)
field_min_ERS_TAU = numpy.ma.min(field_ERS_TAU)

print 'mean, stddev, min_plot, max_plot: ', \
	numpy.ma.mean(field_TAU), numpy.ma.std(field_TAU), min_plot, max_plot
print 'min, max: ', field_min_TAU, field_max_TAU
print 'levels:', levels



#PLOT CASE DATA
f = plt.figure(figsize=(8.5, 11))

plt.suptitle(field_name + ' (' + units + ') ' + season, fontsize = 20)

ax = f.add_subplot(3,1,1)

ax.set_title(casename)

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

lons, lats = numpy.meshgrid(lon,lat)
x, y       = m(lons,lats)

c = m.contourf(	x, y, field_TAU, \
	   	cmap = 'gnuplot2_r', \
		levels = levels, \
		extend = 'both')

cb = m.colorbar(c)

q = m.quiver(	x[::3,::3], y[::3,::3], \
		-field_TAUX_plot[::3, ::3], -field_TAUY_plot[::3, ::3], \
		scale = 3.0)

text_data = 'min = '  + str(round(field_min_TAU, 2)) + ', ' + \
            'max = '  + str(round(field_max_TAU, 2))

ax.text(0, -100, text_data, transform = ax.transData, fontsize = 10)

#PLOT REF CASE DATA
ax = f.add_subplot(3,1,2)

ax.set_title('ERS')

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

c  = m.contourf(	x, y, field_ERS_TAU, \
		cmap = 'gnuplot2_r', \
		levels = levels, \
		extend = 'both')

cb = m.colorbar(c)

q  = m.quiver(	x[::3,::3], y[::3,::3], \
		field_ERS_TAUX[0, ::3, ::3], field_ERS_TAUY[0, ::3, ::3], \
		scale = 3.0)

text_data = 'min = '  + str(round(field_min_ERS_TAU, 2)) + ', ' + \
            'max = '  + str(round(field_max_ERS_TAU, 2))

ax.text(0, -100, text_data, transform = ax.transData, fontsize = 10)

#PLOT DIFFERENCE
ax = f.add_subplot(3,1,3)

ax.set_title(casename + ' - ERS')

field_diff_TAU = field_TAU - field_ERS_TAU

field_diff_max_TAU = numpy.ma.max(field_diff_TAU)
field_diff_min_TAU = numpy.ma.min(field_diff_TAU)


#Computing levels using mean and standard deviation
num         = 11
max_plot    = round_to_first(3.0 * numpy.ma.std(field_diff_TAU))
levels_diff = numpy.linspace(-max_plot, max_plot, num = num)

print 'For difference plot: '
print 'mean, stddev, max_plot: ', \
	numpy.ma.mean(field_diff_TAU), numpy.ma.std(field_diff_TAU), max_plot
print 'min, max: ', numpy.ma.min(field_diff_TAU), numpy.ma.max(field_diff_TAU)
print 'contour levels: ', levels

#Computing difference vectors
field_diff_TAUX = -field_TAUX_plot[:, :] - field_ERS_TAUX[0, :, :]
field_diff_TAUY = -field_TAUY_plot[:, :] - field_ERS_TAUY[0, :, :]

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

c  = m.contourf(x, y, field_diff_TAU, \
		cmap = 'seismic', \
		levels = levels_diff, \
		extend = 'both')

cb = m.colorbar(c)

q  = m.quiver(	x[::3,::3], y[::3,::3], \
		field_diff_TAUX[::3, ::3], field_diff_TAUY[::3, ::3], \
		scale = 1.0)

text_data = 'min = '  + str(round(field_diff_min_TAU, 2)) + ', ' + \
            'max = '  + str(round(field_diff_max_TAU, 2))

ax.text(0, -100, text_data, transform = ax.transData, fontsize = 10)

#saving plot
mpl.rcParams['savefig.dpi']=300

outfile = plots_dir + '/' + casename + '_' \
                   + field_name + '_climo_ERS_' + season + '.png' 

plt.savefig(outfile)

#plt.show()



