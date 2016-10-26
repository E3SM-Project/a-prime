
import os
import subprocess
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
import datetime
from netCDF4 import Dataset as netcdf_dataset

try:
    get_ipython()
    # Place figures within document
    get_ipython().magic(u'pylab inline')
    get_ipython().magic(u'matplotlib inline')

    #indir       = "/scratch2/scratchdirs/tang30/ACME_simulations/20160428.A_WCYCL1850.ne30_oEC.edison.alpha5_00/run"
    #casename    = "20160428.A_WCYCL1850.ne30_oEC.edison.alpha5_00"
    indir       = "/scratch1/scratchdirs/golaz/ACME_simulations/20160520.A_WCYCL1850.ne30_oEC.edison.alpha6_01/run"
    casename    = "20160520.A_WCYCL1850.ne30_oEC.edison.alpha6_01"
    #indir       = "/scratch2/scratchdirs/tang30/ACME_simulations/20160428.A_WCYCL2000.ne30_oEC.edison.alpha5_00/run"
    #casename = "20160428.A_WCYCL2000.ne30_oEC.edison.alpha5_00"
    ##indir       = "/lustre/scratch1/turquoise/milena/ACME/cases/T62_oRRS30to10_GIAF_02/run"
    ##casename    = "T62_oRRS30to10_GIAF_02"
    plots_dir   = "plots"
    yr_offset = 1849
    #yr_offset = 1999
    compare_with_model = "true"
    indir_model_tocompare = "/global/project/projectdirs/acme/ACMEv0_lowres/B1850C5_ne30_v0.4/ocn/postprocessing/"
    casename_model_tocompare = "B1850C5_ne30_v0.4"
    #indir_model_tocompare = "/global/project/projectdirs/acme/ACMEv0_highres/b1850c5_acmev0_highres/ocn/postprocessing/"
    ##indir_model_tocompare = "/usr/projects/climate/milena/ACMEv0_highres/b1850c5_acmev0_highres/ocn/postprocessing/"
    #casename_model_tocompare = "b1850c5_acmev0_highres"
except:
    import argparse
    parser = argparse.ArgumentParser(description="Compute Ocean Heat Content (OHC)")
    parser.add_argument("--indir", dest = "indir", required=True,
        help = "full path to main model data directory")
    parser.add_argument("-c", "--casename", dest = "casename", required=True,
        help = "casename of the run")
    parser.add_argument("--plots_dir", dest = "plots_dir", required=True,
        help = "full path to plot directory")
    parser.add_argument("--year_offset", dest = "yr_offset", required=True,
        help = "year offset (1849 for pre-industrial runs, 1999 for present-day runs, 0 for transient runs)")
    parser.add_argument("--compare_with_model", dest = "compare_with_model", required=True,
        default = "true", choices = ["true","false"],
        help = "logic flag to enable comparison with other model")
    parser.add_argument("--indir_model_tocompare", dest = "indir_model_tocompare", required=False,
        help = "full path to model_tocompare data directory")
    parser.add_argument("--casename_model_tocompare", dest = "casename_model_tocompare", required=False,
        help = "casename of the run to compare")
    args = parser.parse_args()
    indir     = args.indir
    casename  = args.casename
    plots_dir = args.plots_dir
    yr_offset = int(args.yr_offset)
    compare_with_model = args.compare_with_model
    if compare_with_model == "true":
        indir_model_tocompare = args.indir_model_tocompare
        casename_model_tocompare = args.casename_model_tocompare
        
# Checks on directory/files existence:
if os.path.isdir("%s" % indir) != True:
    raise SystemExit("Model directory %s not found. Exiting..." % indir)
if compare_with_model == "true":
    if os.path.isdir("%s" % indir_model_tocompare) != True:
        raise SystemExit("Model_tocompare directory %s not found. Exiting..." % indir_model_tocompare)


# Some plotting rules
axis_font = {'size':'16'}    
title_font = {'size':'18', 'color':'black', 'weight':'normal'}


# Define/read in general variables
print "  Load SST data..."
#infiles = "".join([indir,'/am.mpas-o.timeSeriesStats.????-??*nc'])
infiles = "".join([indir,'/am.mpas-o.timeSeriesStats.00[0-3]?-??*nc'])
#infiles2 = "".join([indir,'/am.mpas-o.surfaceAreaWeightedAverages.????-??*nc'])

# Load data:
ds = xr.open_mfdataset(infiles,preprocess=lambda x: preprocess_mpas_timeSeriesStats(x, yearoffset=yr_offset,                         timestr='time_avg_daysSinceStartOfSim',                                                                      onlyvars=['time_avg_avgValueWithinOceanRegion_avgSurfaceTemperature']))
#                        timestr='timeSeriesStats_avg_daysSinceStartOfSim_1',                                 \
#                        onlyvars=['timeSeriesStats_avg_avgValueWithinOceanRegion_1_avgSurfaceTemperature']))
ds = remove_repeated_time_index(ds)
#ds2 = xr.open_mfdataset(infiles2,preprocess=lambda x: preprocess_mpas(x, yearoffset=yr_offset))
#ds2 = remove_repeated_time_index(ds2)

# Number of points over which to compute moving average (e.g., for monthly
# output, N_movavg=12 corresponds to a 12-month moving average window)
N_movavg = 12
#N_movavg = 1

SST_obs_HadSST = []


SSTregions = ds.time_avg_avgValueWithinOceanRegion_avgSurfaceTemperature
#SSTregions = ds.timeSeriesStats_avg_avgValueWithinOceanRegion_1_avgSurfaceTemperature

#SSTregions2 = ds2.avgSurfaceTemperature
#SSTregions[:,6].plot()
#SSTregions2[:,6].plot()


def timeseries_analysis_plot(dsvalue1,dsvalue2,N,title,xlabel,ylabel,figname):
    
    plt.figure(figsize=(15,6), dpi=300)
    #dsvalue.plot.line('k-')
    ax1 = pd.Series.rolling(dsvalue1.to_pandas(),N,center=True).mean().plot(style='r-',lw=1.2)
    if len(dsvalue2):
        ax2 = pd.Series.rolling(dsvalue2.to_pandas(),N,center=True).mean().plot(style='b-',lw=1.2)
    
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

print "  Make plots..."
#regions = ["global","atl","pac","ind","so"]
#plot_title = ["Global Ocean","Atlantic Ocean","Pacific Ocean","Indian Ocean","Southern Ocean"]
regions = ["global"]
plot_title = ["Global Ocean"]
#iregions =
iregions = [6] # current 'global'

for iregion in range(len(iregions)):

    title = plot_title[iregion]
    #title = "".join(["SST, ",title,", %s (r-), HadSST data (b-)" % casename])
    title = "".join(["SST, ",title,", %s (r-)" % casename])
    #xlabel = "time"
    xlabel = ""
    ylabel = "[$^\circ$ C]"
    if compare_with_model == "true":
        figname = "%s/sst_%s_%s_%s.png" % (plots_dir,regions[iregion],casename,casename_model_tocompare)
    else:
        figname = "%s/sst_%s_%s.png" % (plots_dir,regions[iregion],casename)
    
    SST = SSTregions[:,iregions[iregion]]
    
    if compare_with_model == "true":
        # load in other model run data
        #infiles_model_tocompare = "".join([indir_model_tocompare,'OHC',regions[iregion],'.',casename_model_tocompare,'.year*.nc'])
        infiles_model_tocompare = "".join([indir_model_tocompare,'/SST.',casename_model_tocompare,'.year*.nc'])
        ds_model_tocompare = xr.open_mfdataset(infiles_model_tocompare,preprocess=lambda x: preprocess_mpas(x, yearoffset=yr_offset))
        ds_model_tocompare = remove_repeated_time_index(ds_model_tocompare)
        ds_model_tocompare_tslice = ds_model_tocompare.sel(Time=slice(time_start,time_end))
        SST_model_tocompare = ds_model_tocompare_tslice.SST
        title = "".join([title,"\n %s (b-)" % casename_model_tocompare])
        timeseries_analysis_plot(SST,SST_model_tocompare,N_movavg,title,xlabel,ylabel,figname)
    else:
        timeseries_analysis_plot(SST,[],N_movavg,title,xlabel,ylabel,figname)
    
##    if compare_with_obs == "true":
##        if regions[iregion] == "global_65N-65S":
##            # load in observational data set
##            ohc_obs = []
##            title = "".join([title," (r), observations (k)"])
##            timeseries_analysis_multiplot(ohc_700m,ohc_2000m,ohc_btm,ohc_obs,[],[],N_movavg,title,xlabel,ylabel,figname)
##        else:
##            timeseries_analysis_plot(ohc_700m,ohc_2000m,ohc_btm,N_movavg,title,xlabel,ylabel,figname)
#    if compare_with_obs == "false" and compare_with_model == "false":
#        timeseries_analysis_plot(ohc_700m,ohc_2000m,ohc_btm,N_movavg,title,xlabel,ylabel,figname)




