
from netCDF4 import Dataset
from matplotlib.colors import LogNorm
from mpas_xarray import preprocess_mpas, preprocess_mpas_timeSeriesStats, remove_repeated_time_index
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
#from iotasks import timeit_context
import numpy as np
import numpy.ma as ma
import xarray as xr
import pandas as pd
from netCDF4 import Dataset as netcdf_dataset
from pylab import rcParams
rcParams['figure.figsize'] = (20.0, 15.0)
rcParams['savefig.dpi'] = 600

try:
    get_ipython()
    # Place figures within document
    get_ipython().magic(u'pylab inline')
    pylab.rcParams['figure.figsize'] = (18.0, 10.0) # Large figures
    get_ipython().magic(u'matplotlib inline')

    indir       = "/scratch2/scratchdirs/tang30/ACME_simulations/"
    casename    = "20160428.A_WCYCL2000.ne30_oEC.edison.alpha5_00"
    meshfile    = "/global/project/projectdirs/acme/milena/MPAS-grids/ocn/gridfile.oEC60to30.nc"
    plots_dir   = "plots"
    yr_offset = 1999
    compare_with_model = "true"
    casename_model_tocompare = "b1850c5_acmev0_highres"    
    compare_with_obs = "false"
    indir_obs = ""
    obs_filename = ""

except:
    import argparse
    parser = argparse.ArgumentParser(description="Compute Ocean Heat Content (OHC)")
    parser.add_argument("--indir", dest = "indir", required=True,
        help = "filepath to main model data directory ('casename/run' will be appended)")
    parser.add_argument("-c", "--casename", dest = "casename", required=True,
        help = "casename of the run")
    parser.add_argument("--meshfile", dest = "meshfile", required=True,
        help = "MPAS mesh filename (with full path)")
    parser.add_argument("--plots_dir", dest = "plots_dir", required=True,
        help = "filepath to plot directory")
    parser.add_argument("--year_offset", dest = "yr_offset", required=True,
        help = "year offset (1849 for pre-industrial runs, 1999 for present-day runs, 0 for transient runs)")
    parser.add_argument("--compare_with_model", dest = "compare_with_model", required=True,
        default = "true", choices = ["true","false"], 
        help = "logic flag to enable comparison with other model")
    parser.add_argument("--casename_model_tocompare", dest = "casename_model_tocompare", required=False,
        help = "casename of the run to compare")
    parser.add_argument("--compare_with_obs", dest = "compare_with_obs", required=True,
        default = "false", choices = ["true","false"], 
        help = "logic flag to enable comparison with observations")
    parser.add_argument("--indir_obs", dest = "indir_obs", required=False,
        help = "filepath to observational data directory")
    parser.add_argument("--obs_filename", dest = "obs_filename", required=False,
        help = "name of observational data file")
    args = parser.parse_args()
    indir       = args.indir
    casename    = args.casename
    meshfile    = args.meshfile
    plots_dir   = args.plots_dir
    yr_offset   = args.yr_offset
    compare_with_model = args.compare_with_model
    compare_with_obs = args.compare_with_obs
    if compare_with_model == "true":
        #indir_model_tocompare = args.indir_model_tocompare
        casename_model_tocompare = args.casename_model_tocompare
    if compare_with_obs == "true":
        indir_obs = args.indir_obs
        obs_filename = args.obs_filename

indir = "%s/%s/run" % (indir,casename)
if compare_with_model == "true":
    indir_model_tocompare = "/global/project/projectdirs/acme/ACMEv0_highres/%s/ocn/postprocessing" % casename_model_tocompare


# Some plotting rules
axis_font = {'size':'16'}    
title_font = {'size':'18', 'color':'black', 'weight':'normal'}


# Define/read in general variables
f = netcdf_dataset(meshfile,mode='r')
depth = f.variables["refBottomDepth"][:] # reference depth [m]
cp = f.getncattr("config_specific_heat_sea_water") # specific heat [J/(kg*degC)]
rho = f.getncattr("config_density0") # [kg/m3]
fac = 1e-22*rho*cp;
# Number of points over which to compute moving average (e.g., for monthly
# output, N_movavg=12 corresponds to a 12-month moving average window)
N_movavg = 12
#N_movavg = 1

ind_700m = np.where(depth>700)
ind_700m = ind_700m[0]
k700m = ind_700m[0]-1

ind_2000m = np.where(depth>2000)
ind_2000m = ind_2000m[0]
k2000m = ind_2000m[0]-1

kbtm = len(depth)-1

#print depth[k700m], depth[k2000m], depth[kbtm]


# Load data
infiles = "".join([indir,'/am.mpas-o.timeSeriesStats.????-??*nc'])
#infiles = "".join([indir,'/am.mpas-o.layerVolumeWeightedAverage.????-??*nc'])

# Load data:
ds = xr.open_mfdataset(infiles,preprocess=lambda x: preprocess_mpas_timeSeriesStats(x, yearoffset=yr_offset,                         timestr='timeSeriesStats_avg_daysSinceStartOfSim_1',                                                         onlyvars=['timeSeriesStats_avg_avgValueWithinOceanLayerRegion_1_avgLayerTemperature',                                  'timeSeriesStats_avg_avgValueWithinOceanLayerRegion_1_sumLayerMaskValue',                                    'timeSeriesStats_avg_avgValueWithinOceanLayerRegion_1_avgLayerArea',                                         'timeSeriesStats_avg_avgValueWithinOceanLayerRegion_1_avgLayerThickness']))
#ds = xr.open_mfdataset(infiles,preprocess=preprocess_mpas)
ds = remove_repeated_time_index(ds)

# Select year-1 data and average it (for later computing anomalies)
time_start = datetime.datetime(yr_offset+1,1,1)
time_end = datetime.datetime(yr_offset+1,12,31)
ds_yr1 = ds.sel(Time=slice(time_start,time_end))
mean_yr1 = ds_yr1.mean('Time')


avgLayerTemperature = ds.timeSeriesStats_avg_avgValueWithinOceanLayerRegion_1_avgLayerTemperature
avgLayerTemperature_yr1 = mean_yr1.timeSeriesStats_avg_avgValueWithinOceanLayerRegion_1_avgLayerTemperature
#avgLayerTemperature = ds.avgLayerTemperature
#avgLayerTemperature_yr1 = mean_yr1.avgLayerTemperature
avgLayTemp_anomaly = avgLayerTemperature - avgLayerTemperature_yr1

#avgVolumeTemperature = ds.timeSeriesStats_avg_avgValueWithinOceanVolumeRegion_1_avgVolumeTemperature
#avgVolumeTemperature_yr1 = mean_yr1.timeSeriesStats_avg_avgValueWithinOceanVolumeRegion_1_avgVolumeTemperature
#avgVolTemp_anomaly = avgVolumeTemperature - avgVolumeTemperature_yr1


def timeseries_analysis_plot(dsvalue1,dsvalue2,dsvalue3,dsvalue4,dsvalue5,dsvalue6,N,title,xlabel,ylabel,figname):
    
    plt.figure(figsize=(15,6), dpi=300)
    #dsvalue.plot.line('k-')
    ax1 = pd.rolling_mean(dsvalue1.to_pandas(),N,center=True).plot(style='r-',lw=1.2)
    ax2 = pd.rolling_mean(dsvalue2.to_pandas(),N,center=True).plot(style='r--',lw=1.2)
    ax3 = pd.rolling_mean(dsvalue3.to_pandas(),N,center=True).plot(style='r-.',lw=1.2)
    if len(dsvalue4):
        ax4 = pd.rolling_mean(dsvalue4.to_pandas(),N,center=True).plot(style='b-',lw=1.2)
    if len(dsvalue5):
        ax5 = pd.rolling_mean(dsvalue5.to_pandas(),N,center=True).plot(style='b--',lw=1.2)
    if len(dsvalue6):
        ax6 = pd.rolling_mean(dsvalue6.to_pandas(),N,center=True).plot(style='b-.',lw=1.2)
    #for label in (ax.get_xticklabels() + ax.get_yticklabels()):
    #    label.set_fontsize(16)
    ax3.grid(True)
    
    if (title != None):
        plt.title(title, **title_font)
    if (xlabel != None):
        plt.xlabel(xlabel, **axis_font)
    if (ylabel != None):
        plt.ylabel(ylabel, **axis_font)
    if (figname != None):
        plt.savefig(figname)


year_start = (pd.to_datetime(ds.Time.min().values)).year
year_end   = (pd.to_datetime(ds.Time.max().values)).year
time_start = datetime.datetime(year_start,1,1)
time_end   = datetime.datetime(year_end,12,31)
#time_start = pd.to_datetime(ds.Time.min().values)
#time_end   = pd.to_datetime(ds.Time.max().values)
#print pd.to_datetime(ds.Time.min().values),pd.to_datetime(ds.Time.max().values)


# Load data and make plot for every region
if compare_with_obs == "true":
    regions = ["global_65N-65S","atl","pac","ind","so"]
    plot_title = ["Global Ocean (65N-65S)","Atlantic Ocean","Pacific Ocean","Indian Ocean","Southern Ocean"]
else:
    #regions = ["global","atl","pac","ind","so"]
    #plot_title = ["Global Ocean","Atlantic Ocean","Pacific Ocean","Indian Ocean","Southern Ocean"]
    regions = ["global"]
    plot_title = ["Global Ocean"]
#iregions =
iregions = [6] # current 'global'
for iregion in range(len(iregions)):

    # Compute volume of each layer in the region:
    sumLayerMaskValue = ds.timeSeriesStats_avg_avgValueWithinOceanLayerRegion_1_sumLayerMaskValue
    avgLayerArea = ds.timeSeriesStats_avg_avgValueWithinOceanLayerRegion_1_avgLayerArea
    avgLayerThickness = ds.timeSeriesStats_avg_avgValueWithinOceanLayerRegion_1_avgLayerThickness
    #sumLayerMaskValue = ds.sumLayerMaskValue
    #avgLayerArea = ds.avgLayerArea
    #avgLayerThickness = ds.avgLayerThickness
    layerArea = sumLayerMaskValue[:,iregions[iregion],:] * avgLayerArea[:,iregions[iregion],:]
    layerVolume = layerArea * avgLayerThickness[:,iregions[iregion],:]
    
    # Compute OHC:
    ohc = layerVolume * avgLayTemp_anomaly[:,iregions[iregion],:]
    # OHC over 0-bottom depth range:
    ohc_tot = ohc.sum('nVertLevels')
    ohc_tot = fac*ohc_tot
    # OHC over 0-700m depth range:
    ohc_700m = ohc[:,0:k700m].sum('nVertLevels')
    ohc_700m = fac*ohc_700m
    # OHC over 700m-2000m depth range:
    ohc_2000m = ohc[:,k700m+1:k2000m].sum('nVertLevels')    
    ohc_2000m = fac*ohc_2000m
    # OHC over 2000m-bottom depth range:
    ohc_btm = ohc[:,k2000m+1:kbtm].sum('nVertLevels')    
    ohc_btm = fac*ohc_btm
    
    title = plot_title[iregion]
    title = "".join([title,", 0-700m (-), 700-2000m (--), 2000m-bottom (-.) \n ",casename])
    #xlabel = "time"
    xlabel = ""
    ylabel = "[x$10^{22}$ J]"
    figname = "%s/%s.ohc_%s.png" % (plots_dir,casename,regions[iregion])

##    if compare_with_obs == "true":
##        if regions[iregion] == "global_65N-65S":
##            # load in observational data set
##            ohc_obs = []
##            title = "".join([title," (r), observations (k)"])
##            timeseries_analysis_multiplot(ohc_700m,ohc_2000m,ohc_btm,ohc_obs,[],[],N_movavg,title,xlabel,ylabel,figname)
##        else:
##            timeseries_analysis_plot(ohc_700m,ohc_2000m,ohc_btm,N_movavg,title,xlabel,ylabel,figname)
    
    if compare_with_model == "true":
        # load in other model run data
        #infiles_model_tocompare = "".join([indir_model_tocompare,'OHC',regions[iregion],'.',casename_model_tocompare,'.year*.nc'])
        infiles_model_tocompare = "".join([indir_model_tocompare,'/OHC.',casename_model_tocompare,'.year*.nc'])
        ds_model_tocompare = xr.open_mfdataset(infiles_model_tocompare,preprocess=lambda x: preprocess_mpas(x, yearoffset=yr_offset))
        ds_model_tocompare = remove_repeated_time_index(ds_model_tocompare)
        ds_model_tocompare_tslice = ds_model_tocompare.sel(Time=slice(time_start,time_end))
        ohc_model_tocompare_700m = ds_model_tocompare_tslice.ohc_700m
        ohc_model_tocompare_2000m = ds_model_tocompare_tslice.ohc_2000m
        ohc_model_tocompare_btm = ds_model_tocompare_tslice.ohc_btm
        title = "".join([title," (r), ",casename_model_tocompare," (k)"])
        timeseries_analysis_plot(ohc_700m,ohc_2000m,ohc_btm,ohc_model_tocompare_700m,ohc_model_tocompare_2000m,ohc_model_tocompare_btm,N_movavg,title,xlabel,ylabel,figname)
    
    if compare_with_obs == "false" and compare_with_model == "false":
        timeseries_analysis_plot(ohc_700m,ohc_2000m,ohc_btm,[],[],[],N_movavg,title,xlabel,ylabel,figname)


# make the plot
#ds.avgVolumeTemperature.plot()
#plt.savefig('avgVolumeTemperatureBar.png')


# make the plot
#ds.avgVolumeTemperature[:,6].plot()
#plt.savefig('avgVolumeTemperatureLine.png')

