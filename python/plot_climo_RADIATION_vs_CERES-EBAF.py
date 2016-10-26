
import matplotlib as mpl
#changing the default backend to agg to resolve contouring issue on rhea
mpl.use('Agg')

from   mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import math
import numpy

from netCDF4 import Dataset

from get_season_name       import get_season_name
from round_to_first        import round_to_first
from get_reg_area_avg      import get_reg_area_avg
from get_reg_area_avg_rmse import get_reg_area_avg_rmse

from optparse 		   import OptionParser

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

    parser.add_option("--CERES_EBAF_dir", dest = "CERES_EBAF_dir",
                        help = "filepath to CERES-EBAF directory")

    parser.add_option("--plots_dir", dest = "plots_dir",
                        help = "filepath to plots directory")

    (options, args) = parser.parse_args()

indir          = options.indir
casename       = options.casename
field_name     = options.field_name
begin_yr       = options.begin_yr
end_yr         = options.end_yr
begin_month    = options.begin_month
end_month      = options.end_month
CERES_EBAF_dir = options.CERES_EBAF_dir
plots_dir      = options.plots_dir

#Get filename

file_name = indir + '/' + casename + \
	'.climo.' + str(begin_month) + '_' + str(end_month) + \
	'.CERES-EBAF_conservative_mapping.' + field_name + '.nc'

print "file_name: ", file_name

f     = Dataset(file_name, "r")
field = f.variables[field_name]
lat   = f.variables['lat']
lon   = f.variables['lon']
units = field.units

print 'field.shape: ', field.shape

season = get_season_name(begin_month, end_month)

file_CERES_EBAF = CERES_EBAF_dir + '/' + 'CERES-EBAF_' + season + '_climo.nc'

print "Using CERES_EBAF file: ", file_CERES_EBAF

f_CERES_EBAF     = Dataset(file_CERES_EBAF, "r")
field_CERES_EBAF = f_CERES_EBAF.variables[field_name] 

field_max = numpy.max(field[:])
field_min = numpy.min(field[:])
field_avg = get_reg_area_avg(field, lat, lon)
print 'field_avg: ', field_avg

field_CERES_EBAF_max = numpy.max(field_CERES_EBAF[:])
field_CERES_EBAF_min = numpy.min(field_CERES_EBAF[:])
field_CERES_EBAF_avg = get_reg_area_avg(field_CERES_EBAF, lat, lon)


#Computing levels using mean and standard deviation
num = 11

max_plot_temp = numpy.ma.mean(field_CERES_EBAF[:]) + \
                          4.0 * numpy.ma.std(field_CERES_EBAF[:])
if max_plot_temp > numpy.ma.max(field_CERES_EBAF[:]):
        max_plot_temp = numpy.ma.max(field_CERES_EBAF[:])

max_plot      = round_to_first(max_plot_temp)

min_plot_temp = numpy.ma.mean(field_CERES_EBAF[:]) - \
                          4.0 * numpy.ma.std(field_CERES_EBAF[:])

if min_plot_temp < numpy.ma.min(field_CERES_EBAF[:]):
        min_plot_temp = numpy.ma.min(field_CERES_EBAF[:])

min_plot      = round_to_first(min_plot_temp)

levels = numpy.linspace(min_plot, max_plot, num = num)


print 'mean, stddev, min_plot, max_plot CERES_EBAF: ', \
        numpy.ma.mean(field_CERES_EBAF[0,:,:]), numpy.ma.std(field_CERES_EBAF[0,:,:]), min_plot, max_plot
print 'min, max field: ', field_min, field_max
print 'levels:', levels

f = plt.figure(figsize=(8.5, 11))

plt.suptitle(field_name + ' (' + units + ') ' + season, fontsize = 20)

ax = f.add_subplot(3,1,1)

ax.set_title(casename)

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

lons, lats = numpy.meshgrid(lon,lat)
x, y = m(lons,lats)

c = m.contourf(x, y, field[:, :], cmap = 'hot_r', levels = levels, extend = 'both')
cb = m.colorbar(c)

text_data = 'mean = ' + str(round(field_avg, 2)) + ', ' + \
                               'min = '  + str(round(field_min, 2)) + ', ' + \
                               'max = '  + str(round(field_max, 2))
ax.text(0, -100, text_data, transform = ax.transData, fontsize = 10)



ax = f.add_subplot(3,1,2)

text_title = 'CERES_EBAF' + '\n' + 'mean = ' + str(round(field_CERES_EBAF_avg[0], 2)) + ', ' + \
                               'min = '  + str(round(field_CERES_EBAF_min, 2)) + ', ' + \
                               'max = '  + str(round(field_CERES_EBAF_max, 2))
ax.set_title('CERES_EBAF')

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

c = m.contourf(x, y, field_CERES_EBAF[0, :, :], cmap = 'hot_r', levels = levels, extend = 'both')
cb = m.colorbar(c)

text_data = 'mean = ' + str(round(field_CERES_EBAF_avg[0], 2)) + ', ' + \
            'min = '  + str(round(field_CERES_EBAF_min, 2)) + ', ' + \
            'max = '  + str(round(field_CERES_EBAF_max, 2))

ax.text(0, -100, text_data, transform = ax.transData, fontsize = 10)


field_diff      = field[:, :] - field_CERES_EBAF[0, :, :]
field_diff_rmse = get_reg_area_avg_rmse(field_diff, lat, lon)
field_diff_min  = numpy.min(field_diff)
field_diff_max  = numpy.max(field_diff)

ax = f.add_subplot(3,1,3)

ax.set_title(casename + ' - CERES_EBAF')

#Computing levels using mean and standard deviation
num         = 11
max_plot    = round_to_first(4.0 * numpy.ma.std(field_diff))
levels_diff = numpy.linspace(-max_plot, max_plot, num = num)

print 'For difference plot: '
print 'mean, stddev, max_plot: ', \
        numpy.ma.mean(field_diff), numpy.ma.std(field_diff), max_plot
print 'min, max: ', numpy.ma.min(field_diff), numpy.ma.max(field_diff)
print 'contour levels: ', levels_diff

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()


#Fill contour seems to have a bug when plotting negative values, so we use image plots with line contours overlayed

c = m.contourf(x, y, field_diff[:, :], cmap = 'seismic', levels = levels_diff, extend = 'both')
cb = m.colorbar()

text_data = 'RMSE = ' + str(round(field_diff_rmse, 2))+ ', ' + \
            'min = '  + str(round(field_diff_min, 2)) + ', ' + \
            'max = '  + str(round(field_diff_max, 2))

ax.text(0, -100, text_data, transform = ax.transData, fontsize = 10)

#c = m.imshow(field_diff, cmap = 'seismic', vmin = -max_abs, vmax = max_abs, filternorm = 0, interpolation = 'nearest')
#cb = m.colorbar(extend = 'both')

#c = m.contour(x, y, field_diff, levels = levels_diff, colors = 'k', extend = 'both', linewidths = 0.25)


mpl.rcParams['savefig.dpi']=300

outfile = plots_dir + '/' + casename + '_' \
                   + field_name + '_climo_CERES_EBAF_' + season + '.png' 

plt.savefig(outfile)

#plt.show()



