
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import matplotlib as mpl

import math
import numpy
from netCDF4 import Dataset

from get_season_name import get_season_name

from optparse import OptionParser

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


f = Dataset(file_name, "r")


field = f.variables[field_name]
lat = f.variables['lat']
lon = f.variables['lon']
units = field.units

print 'field.shape: ', field.shape


#file_CERES_EBAF = CERES_EBAF_dir + '/'+ 'CERES_EBAF' + \
#               '.climo.' + str(begin_month) + '_' + str(end_month) + \
#              '.' + field_name + '.nc'

season = get_season_name(begin_month, end_month)

file_CERES_EBAF = CERES_EBAF_dir + '/' + 'CERES-EBAF_' + season + '_climo.nc'

print "Using CERES_EBAF file: ", file_CERES_EBAF

f_CERES_EBAF = Dataset(file_CERES_EBAF, "r")

field_CERES_EBAF = f_CERES_EBAF.variables[field_name] 

field_max = numpy.max(field[:])
field_min = numpy.min(field[:])
max_plot = max(field_max, numpy.max(field_CERES_EBAF[:]))
min_plot = min(field_min, numpy.min(field_CERES_EBAF[:]))

print 'max_plot, min_plot: ', max_plot, min_plot, field_max, field_min, numpy.max(field_CERES_EBAF[:]), numpy.min(field_CERES_EBAF[:])

step = 20
levels = numpy.arange(math.floor(min_plot/10.) * 10., math.ceil(max_plot/10.)*10. + step, step = step)

print math.ceil(max_plot/10.)*10.

print __name__, 'contour levels: ', levels

plt.figure(figsize=(8.5, 11))

plt.subplot(3,1,1)

plt.suptitle(field_name + ' (' + units + ') ' + season)

plt.title(casename)

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

lons, lats = numpy.meshgrid(lon,lat)
x, y = m(lons,lats)

c = m.contourf(x, y, field[:, :], cmap = 'gnuplot2_r', levels = levels, extend = 'both')
cb = m.colorbar(c)


plt.subplot(3,1,2)

plt.title('CERES_EBAF')

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

c = m.contourf(x, y, field_CERES_EBAF[0, :, :], cmap = 'gnuplot2_r', levels = levels, extend = 'both')
cb = m.colorbar(c)

plt.subplot(3,1,3)

plt.title(casename + ' - CERES_EBAF')

field_diff = field[:, :] - field_CERES_EBAF[0, :, :]


max_abs = (math.ceil(numpy.max(numpy.abs(field_diff))/10.)) * 10.
print __name__, 'max_abs diff: ', max_abs

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

num = 11
levels_diff = numpy.linspace(-max_abs, max_abs, num = num)

print __name__, 'levels_diff: ', levels_diff
print ''


#Fill contour seems to have a bug when plotting negative values, so we use image plots with line contours overlayed

#c = m.contourf(x, y, field_diff1[:, :], cmap = 'seismic', levels = levels_diff, extend = 'both')
#cb = m.colorbar()


c = m.imshow(field_diff, cmap = 'seismic', vmin = -max_abs, vmax = max_abs, filternorm = 0, interpolation = 'nearest')
cb = m.colorbar(extend = 'both')

c = m.contour(x, y, field_diff, levels = levels_diff, colors = 'k', extend = 'both', linewidths = 0.25)


mpl.rcParams['savefig.dpi']=300

outfile = plots_dir + '/' + casename + '_' \
                   + field_name + '_climo_CERES_EBAF_' + season + '.png' 

plt.savefig(outfile)

#plt.show()



