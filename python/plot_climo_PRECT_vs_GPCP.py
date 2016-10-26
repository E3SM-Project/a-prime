
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

    parser.add_option("--GPCP_dir", dest = "GPCP_dir",
                        help = "filepath to GPCP directory")

    parser.add_option("--plots_dir", dest = "plots_dir",
                        help = "filepath to GPCP directory")

    (options, args) = parser.parse_args()

indir       = options.indir
casename    = options.casename
field_name  = options.field_name
begin_yr    = options.begin_yr
end_yr      = options.end_yr
begin_month = options.begin_month
end_month   = options.end_month
GPCP_dir    = options.GPCP_dir
plots_dir   = options.plots_dir

#Get filename

if field_name == 'PRECT':
    file_name_PRECC = indir + '/' + casename + \
                '.climo.' + str(begin_month) + '_' + str(end_month) + \
                '.GPCP_conservative_mapping.' + 'PRECC.nc'

    print "file_name: ", file_name_PRECC


    f_PRECC = Dataset(file_name_PRECC, "r")


    field_PRECC = f_PRECC.variables['PRECC']
    lat = f_PRECC.variables['lat']
    lon = f_PRECC.variables['lon']
    units = field_PRECC.units

    file_name_PRECL = indir + '/' + casename + \
                '.climo.' + str(begin_month) + '_' + str(end_month) + \
                '.GPCP_conservative_mapping.' + 'PRECL.nc'

    print "file_name: ", file_name_PRECL


    f_PRECL = Dataset(file_name_PRECL, "r")


    field_PRECL = f_PRECL.variables['PRECL']

    field = field_PRECC[:, :] + field_PRECL[:, :]
    field1 = field

else:
    file_name = indir + '/' + casename + \
                '.climo.' + str(begin_month) + '_' + str(end_month) + \
	        '.GPCP_conservative_mapping.' + field_name + '.nc'

    print "file_name: ", file_name


    f = Dataset(file_name, "r")


    field = f.variables[field_name]
    lat = f.variables['lat']
    lon = f.variables['lon']
    units = field.units

print 'field.shape: ', field.shape


#file_GPCP = GPCP_dir + '/'+ 'GPCP' + \
#               '.climo.' + str(begin_month) + '_' + str(end_month) + \
#              '.' + field_name + '.nc'

season = get_season_name(begin_month, end_month)

file_GPCP = GPCP_dir + '/' + 'GPCP_' + season + '_climo.nc'

print "Using GPCP file: ", file_GPCP

f_GPCP = Dataset(file_GPCP, "r")

field_GPCP = f_GPCP.variables[field_name] 
field_GPCP1 = field_GPCP[0, :, :]

field_max = numpy.max(field[:])
field_min = numpy.min(field[:])
max_plot = max(field_max, numpy.max(field_GPCP[:]))
min_plot = min(field_min, numpy.min(field_GPCP[:]))

print 'max_plot, min_plot: ', max_plot, min_plot, field_max, field_min, numpy.max(field_GPCP[:]), numpy.min(field_GPCP[:])

step = 1
levels = numpy.arange(math.floor(min_plot), math.ceil(max_plot)+step, step = step)

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

c = m.contourf(x, y, field[:, :], cmap = 'gnuplot_r', levels = levels, extend = 'both')
cb = m.colorbar(c)


plt.subplot(3,1,2)

plt.title('GPCP')

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

c = m.contourf(x, y, field_GPCP[0, :, :], cmap = 'gnuplot_r', levels = levels, extend = 'both')
cb = m.colorbar(c)

plt.subplot(3,1,3)

plt.title(casename + ' - GPCP')


field_diff = field[:, :] - field_GPCP[0, :, :]

max_abs = math.ceil(numpy.max(numpy.abs(field_diff)))
print __name__, 'max_abs diff, max, min: ', max_abs, numpy.max(field_diff), numpy.min(field_diff)


m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

num = 11
levels_diff = numpy.linspace(-max_abs, max_abs, num = num)

#step = 1
#levels_diff = numpy.arange(-max_abs, max_abs+step, step = step)

print __name__, 'levels_diff: ', levels_diff
print ''

#Fill contour seems to have a bug when plotting negative values, so we use image plots with line contours overlayed

#c = m.contourf(x, y, field_diff[:, :], cmap = 'seismic', extend = 'both')
#cb = m.colorbar()


c = m.imshow(field_diff, cmap = 'seismic', vmin = -max_abs, vmax = max_abs, filternorm = 0, interpolation = 'nearest')
cb = m.colorbar(extend = 'both')

c = m.contour(x, y, field_diff[:, :], levels = levels_diff, colors = 'k', extend = 'both', linewidths = 0.25)


mpl.rcParams['savefig.dpi']=300

outfile = plots_dir + '/' + casename + '_' \
                   + field_name + '_climo_GPCP_' + season + '.png' 

plt.savefig(outfile)

plt.show()



