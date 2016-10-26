
from netCDF4 import Dataset                     # For reading data
from matplotlib.colors import LogNorm
from mpas_xarray import preprocess_mpas, remove_repeated_time_index
import matplotlib.pyplot as plt                 # For plotting
from matplotlib.patches import Rectangle
#from iotasks import timeit_context
import numpy.ma as ma
import xarray as xr
import pandas as pd
from netCDF4 import Dataset as netcdf_dataset
from pylab import rcParams
rcParams['figure.figsize'] = (20.0, 10.0)
rcParams['savefig.dpi'] = 600

try:
    get_ipython()
    # Place figures within document
    get_ipython().magic(u'pylab inline')
    pylab.rcParams['figure.figsize'] = (18.0, 10.0) # Large figures
    get_ipython().magic(u'matplotlib inline')

    indir       = "/net/scratch3/milena/ACME/cases/"
    casename    = "ACMEpre-alpha_iter2"
    plots_dir   = "plots"
    compare_with_model = "true"
    indir_model_tocompare = "/usr/projects/climate/milena/ACMEv0_highres/"
    casename_model_tocompare = "b1850c5_acmev0_highres"
    compare_with_obs = "false"
    indir_obs = ""
    obs_filename = ""

except:
    import argparse
    parser = argparse.ArgumentParser(description="Compute Ocean Heat Content (OHC)")
    parser.add_argument("--indir", dest = "indir", required=True,
        help = "filepath to model data directory")
    parser.add_argument("-c", "--casename", dest = "casename", required=True,
        help = "casename of the run")
    parser.add_argument("--plots_dir", dest = "plots_dir", required=True,
        help = "filepath to plot directory")
    parser.add_argument("--compare_with_model", dest = "compare_with_model", required=True,
        default = "true", choices = ["true","false"], 
        help = "logic flag to enable comparison with other model")
    parser.add_argument("--indir_model_tocompare", dest = "indir_model_tocompare", required=False,
        help = "filepath to model-to-compare data directory")
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
    plots_dir   = args.plots_dir
    compare_with_model = args.compare_with_model
    compare_with_obs = args.compare_with_obs
    if compare_with_model == "true":
        indir_model_tocompare = args.indir_model_tocompare
        casename_model_tocompare = args.casename_model_tocompare
    if compare_with_obs == "true":
        indir_obs = args.indir_obs
        obs_filename = args.obs_filename


# Some plotting rules
axis_font = {'size':'14'}    
title_font = {'size':'16', 'color':'black', 'weight':'normal'}


# Define/read in general variables
infiles = "".join([indir,casename,'/run/analysis_members/ocn.layerVolumeWeightedAverage.0*nc'])
infiles_yr1 = "".join([indir,casename,'/run/analysis_members/ocn.layerVolumeWeightedAverage.0005-*nc'])
#indir = "".join([indir,casename,'/run/'])
#infiles = "".join([indir,casename,'/run/am.mpas-o.layerVolumeWeightedAverage.*nc'])
#infiles_yr1 = "".join([indir,casename,'/run/am.mpas-o.layerVolumeWeightedAverage.0001-*nc'])
if not infiles_yr1:
    print "Error: Files for year 1 not available. Exiting..."
    #quit()
infofile = "".join([indir,casename,'/run/hist.ocn.0001-01-01_00.00.00.nc'])
if not infofile:
    print "Error: History file needed for genereal info not available. Exiting..."
    #quit()
if compare_with_model == "true":
    indir_model_tocompare = "".join([indir_model_tocompare,casename_model_tocompare,'/ocn/hist/monthlyFields/matfiles'])
    
f = netcdf_dataset(infofile,mode='r')
depth = f.variables["refBottomDepth"][:] # reference depth [m]
cp = f.getncattr("config_specific_heat_sea_water") # specific heat [J/(Kg*degC)]
rho = f.getncattr("config_density0") # [kg/m3]
global_vol = 1.33148096426328e+18; # [m3] hardwired value for EC60to30
fac0 = 1e-22*rho*cp*global_vol;
fac = 1e-22*rho*cp;
# Number of points over which to compute moving average (e.g., for monthly
# output, N_movavg=12 corresponds to a 12-month moving average window)
N_movavg = 12

ind_700m = np.where(depth>700)
ind_700m = ind_700m[0]
k700m = ind_700m[0]-1

ind_2000m = np.where(depth>2000)
ind_2000m = ind_2000m[0]
k2000m = ind_2000m[0]-1

kbtm = len(depth)-1

#print depth[k700m], depth[k2000m], depth[kbtm]
#print infiles
#print infiles_yr1


# Load year-1 data and compute first-year average
ds_yr1 = xr.open_mfdataset(infiles_yr1,preprocess=preprocess_mpas)
ds_yr1 = remove_repeated_time_index(ds_yr1)
mean_yr1 = ds_yr1.mean('Time')


# Load all-years data and compute anomalies with respect to first-year avg
ds = xr.open_mfdataset(infiles,preprocess=preprocess_mpas)
ds = remove_repeated_time_index(ds)
avgVolTemp_anomaly = ds.avgVolumeTemperature - mean_yr1.avgVolumeTemperature
avgLayTemp_anomaly = ds.avgLayerTemperature - mean_yr1.avgLayerTemperature


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
    layerVolume = ds.sumLayerMaskValue[:,iregions[iregion],:] * ds.avgLayerArea[:,iregions[iregion],:] * ds.avgLayerThickness[:,iregions[iregion],:]
    ohc = layerVolume * avgLayTemp_anomaly[:,iregions[iregion],:]
    # OHC over 0-bottom depth range:
    #ohc_btm = ohc.sum('nVertLevels')
    #ohc_btm = fac*ohc_btm
    #ohc_btm0 = fac0*avgVolTemp_anomaly[:,iregions[iregion]]
    # OHC over 0-700m depth range:
    ohc_700m = ohc[:,0:k700m].sum('nVertLevels')
    ohc_700m = fac*ohc_700m
    # OHC over 0-2000m depth range:
    #ohc_2000m = ohc[:,0:k2000m].sum('nVertLevels')    
    #ohc_2000m = fac*ohc_2000m
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
    figname = "".join(["ohc_",regions[iregion],".png"])

    if compare_with_obs == "true":
        if regions[iregion] == "global_65N-65S":
            # load in observational data set
            ohc_obs = []
            title = "".join([title," (r), observations (k)"])
            timeseries_analysis_multiplot(ohc_btm,ohc_700m,ohc_2000m,ohc_obs,[],[],N_movavg,title,xlabel,ylabel,figname)
        else:
            timeseries_analysis_plot(ohc_btm,ohc_700m,ohc_2000m,N_movavg,title,xlabel,ylabel,figname)
    
    if compare_with_model == "true":
        # load in other model run data
        #infiles_model_tocompare = "".join([indir_model_tocompare,'OHC',regions[iregion],'.',casename_model_tocompare,'.year*.nc'])
        infiles_model_tocompare = "".join([indir_model_tocompare,'/OHC.',casename_model_tocompare,'.year*.nc'])
        ds_model_tocompare = xr.open_mfdataset(infiles_model_tocompare,preprocess=preprocess_mpas)
        ds_model_tocompare = remove_repeated_time_index(ds_model_tocompare)
        ohc_model_tocompare_700m = ds_model_tocompare.ohc_700m
        ohc_model_tocompare_2000m = ds_model_tocompare.ohc_2000m
        ohc_model_tocompare_btm = ds_model_tocompare.ohc_btm
        #pop_time = ds_model_tocompare.xtime
        #pop_time = datetime64('1970-01-01') + pop_time
        title = "".join([title," (r), ",casename_model_tocompare," (k)"])
        timeseries_analysis_multiplot(ohc_700m,ohc_2000m,ohc_btm,ohc_model_tocompare_700m,ohc_model_tocompare_2000m,ohc_model_tocompare_btm,N_movavg,title,xlabel,ylabel,figname)
    
    if compare_with_obs == "false" and compare_with_model == "false":
        timeseries_analysis_plot(ohc_btm,ohc_700m,ohc_2000m,N_movavg,title,xlabel,ylabel,figname)


#time_origin = np.datetime64('1970-01-01')-np.datetime64('0000-01-01')
#date='0000-01-10'


def timeseries_analysis_plot(dsvalue1,dsvalue2,dsvalue3,N,title,xlabel,ylabel,figname):
    
    plt.figure()
    #dsvalue.plot.line('k-')
    ax1 = pd.rolling_mean(dsvalue1.to_pandas(),N,center=True).plot(style='r-',lw=1.5)
    ax2 = pd.rolling_mean(dsvalue2.to_pandas(),N,center=True).plot(style='r--',lw=1.5)
    ax3 = pd.rolling_mean(dsvalue3.to_pandas(),N,center=True).plot(style='r-.',lw=1.5)
    #for label in (ax.get_xticklabels() + ax.get_yticklabels()):
    #    label.set_fontsize(16)
    
    if (title != None):
        plt.title(title, **title_font)
    if (xlabel != None):
        plt.xlabel(xlabel, **axis_font)
    if (ylabel != None):
        plt.ylabel(ylabel, **axis_font)
    if (figname != None):
        plt.savefig(figname)


def timeseries_analysis_multiplot(dsvalue1,dsvalue2,dsvalue3,dsvalue4,dsvalue5,dsvalue6,N,title,xlabel,ylabel,figname):
    
    plt.figure()
    #dsvalue.plot.line('k-')
    ax1 = pd.rolling_mean(dsvalue1.to_pandas(),N,center=True).plot(style='r-',lw=1.5)
    ax2 = pd.rolling_mean(dsvalue2.to_pandas(),N,center=True).plot(style='r--',lw=1.5)
    ax3 = pd.rolling_mean(dsvalue3.to_pandas(),N,center=True).plot(style='r-.',lw=1.5)
    ax4 = pd.rolling_mean(dsvalue4.to_pandas(),N,center=True).plot(style='k-',lw=1.5)
    ax5 = pd.rolling_mean(dsvalue5.to_pandas(),N,center=True).plot(style='k--',lw=1.5)
    ax6 = pd.rolling_mean(dsvalue6.to_pandas(),N,center=True).plot(style='k-.',lw=1.5)
    #for label in (ax.get_xticklabels() + ax.get_yticklabels()):
    #    label.set_fontsize(16)
    
    if (title != None):
        plt.title(title, **title_font)
    if (xlabel != None):
        plt.xlabel(xlabel, **axis_font)
    if (ylabel != None):
        plt.ylabel(ylabel, **axis_font)
    if (figname != None):
        plt.savefig(figname)


# make the plot
#ds.avgVolumeTemperature.plot()
#plt.savefig('avgVolumeTemperatureBar.png')


# make the plot
#ds.avgVolumeTemperature[:,6].plot()
#plt.savefig('avgVolumeTemperatureLine.png')

