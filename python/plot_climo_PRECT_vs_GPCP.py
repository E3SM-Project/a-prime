
import matplotlib as mpl
#changing the default backend to agg to resolve contouring issue on rhea
mpl.use('Agg')

from   mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import math
import numpy
from   netCDF4 		   import Dataset

from get_season_name       import get_season_name
from round_to_first  	   import round_to_first
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


    f_PRECC     = Dataset(file_name_PRECC, "r")
    field_PRECC = f_PRECC.variables['PRECC']
    lat 	= f_PRECC.variables['lat']
    lon 	= f_PRECC.variables['lon']
    units 	= field_PRECC.units

    file_name_PRECL = indir + '/' + casename + \
                '.climo.' + str(begin_month) + '_' + str(end_month) + \
                '.GPCP_conservative_mapping.' + 'PRECL.nc'

    print "file_name: ", file_name_PRECL


    f_PRECL 	= Dataset(file_name_PRECL, "r")
    field_PRECL = f_PRECL.variables['PRECL']

    field  = field_PRECC[:, :] + field_PRECL[:, :]
    field1 = field

else:
    file_name = indir + '/' + casename + \
                '.climo.' + str(begin_month) + '_' + str(end_month) + \
	        '.GPCP_conservative_mapping.' + field_name + '.nc'

    print "file_name: ", file_name


    f = Dataset(file_name, "r")


    field = f.variables[field_name]
    lat   = f.variables['lat']
    lon   = f.variables['lon']
    units = field.units


print 'field.shape: ', field.shape

season = get_season_name(begin_month, end_month)

file_GPCP = GPCP_dir + '/' + 'GPCP_' + season + '_climo.nc'
print "Using GPCP file: ", file_GPCP

f_GPCP 	    = Dataset(file_GPCP, "r")
field_GPCP  = f_GPCP.variables[field_name] 
field_GPCP1 = field_GPCP[0, :, :]

field_max = numpy.max(field[:])
field_min = numpy.min(field[:])
field_avg = get_reg_area_avg(field, lat, lon)
print 'field_avg: ', field_avg

field_GPCP_max = numpy.max(field_GPCP[:])
field_GPCP_min = numpy.min(field_GPCP[:])
field_GPCP_avg = get_reg_area_avg(field_GPCP, lat, lon)

#Computing levels using mean and standard deviation
num = 11

max_plot_temp = numpy.ma.mean(field_GPCP[:]) + \
                          4.0 * numpy.ma.std(field_GPCP[:])

if max_plot_temp > numpy.ma.max(field_GPCP[:]):
	max_plot_temp = numpy.ma.max(field_GPCP[:])

max_plot      = round_to_first(max_plot_temp)
min_plot      = 0.0

levels = numpy.linspace(min_plot, max_plot, num = num)

print 'mean, stddev, min_plot, max_plot GPCP: ', \
        numpy.ma.mean(field_GPCP[0,:,:]), numpy.ma.std(field_GPCP[0,:,:]), min_plot, max_plot
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

ax.set_title('GPCP')

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

c = m.contourf(x, y, field_GPCP[0, :, :], cmap = 'hot_r', levels = levels, extend = 'both')
cb = m.colorbar(c)

text_data = 'mean = ' + str(round(field_GPCP_avg[0], 2)) + ', ' + \
	    'min = '  + str(round(field_GPCP_min, 2)) + ', ' + \
	    'max = '  + str(round(field_GPCP_max, 2)) 	

ax.text(0, -100, text_data, transform = ax.transData, fontsize = 10)


field_diff      = field[:, :] - field_GPCP[0, :, :]
field_diff_rmse = get_reg_area_avg_rmse(field_diff, lat, lon)
field_diff_min  = numpy.min(field_diff)
field_diff_max  = numpy.max(field_diff)

ax = f.add_subplot(3,1,3)

ax.set_title(casename + ' - GPCP')

#Computing levels using mean and standard deviation
num         = 11
max_plot    = round_to_first(3.0 * numpy.ma.std(field_diff))
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

c  = m.contourf(x, y, field_diff[:, :], levels = levels_diff, cmap = 'seismic', extend = 'both')
cb = m.colorbar()

text_data = 'RMSE = ' + str(round(field_diff_rmse, 2))+ ', ' + \
            'min = '  + str(round(field_diff_min, 2)) + ', ' + \
            'max = '  + str(round(field_diff_max, 2)) 	

ax.text(0, -100, text_data, transform = ax.transData, fontsize = 10)

#c = m.imshow(field_diff, cmap = 'seismic', vmin = -max_abs, vmax = max_abs, filternorm = 0, interpolation = 'nearest')
#cb = m.colorbar(extend = 'both')

#c = m.contour(x, y, field_diff[:, :], levels = levels_diff, colors = 'k', extend = 'both', linewidths = 0.25)


mpl.rcParams['savefig.dpi']=300

outfile = plots_dir + '/' + casename + '_' \
                   + field_name + '_climo_GPCP_' + season + '.png' 

plt.savefig(outfile)

plt.show()



