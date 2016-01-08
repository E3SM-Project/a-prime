
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import matplotlib as mpl

import numpy
from netCDF4 import Dataset

filename = "/Users/seo/archive/b1850c5_t1a.pp/atm/pp/b1850c5_t1a.climo.0_11.GPCP_conservative_mapping.PRECL.nc"

f = Dataset(filename, "r")


field = f.variables['PRECL']
lat = f.variables['lat']
lon = f.variables['lon']

print 'field.shape: ', field.shape

m = Basemap(projection='cyl',llcrnrlat=-90,urcrnrlat=90,\
            llcrnrlon=0,urcrnrlon=360,resolution='c')

m.drawcoastlines()

lons, lats = numpy.meshgrid(lon,lat)
x, y = m(lons,lats)

c = m.contourf(x, y, field[:, :], cmap = 'Oranges')
cb = m.colorbar()

mpl.rcParams['savefig.dpi']=300
plt.show()

