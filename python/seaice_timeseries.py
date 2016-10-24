
import os
import subprocess
import matplotlib as mpl
mpl.use('Agg')
from matplotlib.colors import LogNorm
from mpas_xarray import preprocess_mpas, preprocess_mpas_timeSeriesStats, remove_repeated_time_index
import matplotlib.pyplot as plt                 # For plotting
from matplotlib.patches import Rectangle
#from iotasks import timeit_context
import numpy as np
import numpy.ma as ma
import xarray as xr
import pandas as pd
import datetime

try:
    get_ipython()
    # Place figures within document
    get_ipython().magic(u'pylab inline')
    #pylab.rcParams['figure.figsize'] = (18.0, 10.0) # Large figures
    get_ipython().magic(u'matplotlib inline')

    #indir       = "/scratch2/scratchdirs/tang30/ACME_simulations/20160428.A_WCYCL1850.ne30_oEC.edison.alpha5_00/run"
    #casename    = "20160428.A_WCYCL1850.ne30_oEC.edison.alpha5_00"
    indir       = "/scratch1/scratchdirs/golaz/ACME_simulations/20160520.A_WCYCL1850.ne30_oEC.edison.alpha6_01/run"
    casename    = "20160520.A_WCYCL1850.ne30_oEC.edison.alpha6_01"
    #indir       = "/scratch2/scratchdirs/tang30/ACME_simulations/20160428.A_WCYCL2000.ne30_oEC.edison.alpha5_00/run"
    #casename = "20160428.A_WCYCL2000.ne30_oEC.edison.alpha5_00"
    ##indir       = "/lustre/scratch1/turquoise/milena/ACME/cases/T62_oRRS30to10_GIAF_02/run"
    ##casename    = "T62_oRRS30to10_GIAF_02"
    meshfile    = "/global/project/projectdirs/acme/milena/MPAS-grids/ocn/gridfile.oEC60to30.nc"
    ##meshfile    = "/usr/projects/climate/milena/MPAS-grids/ice/seaice.RRS.30-10km.151031.nc"
    plots_dir   = "plots"
    yr_offset = 1849
    #yr_offset = 1999
    #varname = "iceAreaCell"
    varname = "iceVolumeCell" # this is really thickness, but will plot volume
    #varname = "iceThickCell"  # will also read in iceVolumeCell, but will plot thickness
    compare_with_model = "true"
    indir_model_tocompare = "/global/project/projectdirs/acme/ACMEv0_lowres/B1850C5_ne30_v0.4/ice/postprocessing/"
    casename_model_tocompare = "B1850C5_ne30_v0.4"
    #indir_model_tocompare = "/global/project/projectdirs/acme/ACMEv0_highres/b1850c5_acmev0_highres/ice/postprocessing/"
    ##indir_model_tocompare = "/usr/projects/climate/milena/ACMEv0_highres/b1850c5_acmev0_highres/ice/postprocessing/"
    #casename_model_tocompare = "b1850c5_acmev0_highres"
    compare_with_obs = "true"
    #obs_filenameNH = "/global/project/projectdirs/acme/observations/SeaIce/IceArea_timeseries/iceAreaNH_climo.nc"
    #obs_filenameSH = "/global/project/projectdirs/acme/observations/SeaIce/IceArea_timeseries/iceAreaSH_climo.nc"
    ##obs_filenameNH = "/usr/projects/climate/SHARED_CLIMATE/observations/SeaIce/IceArea_timeseries/iceAreaNH_climo.nc"
    ##obs_filenameSH = "/usr/projects/climate/SHARED_CLIMATE/observations/SeaIce/IceArea_timeseries/iceAreaSH_climo.nc"
    obs_filenameNH = "/global/project/projectdirs/acme/observations/SeaIce/PIOMAS/PIOMASvolume_monthly_climo.nc"
    #obs_filenameNH = "/usr/projects/climate/SHARED_CLIMATE/observations/SeaIce/PIOMAS/PIOMASvolume_monthly_climo.nc"
    obs_filenameSH = "none"

except:
    import argparse
    parser = argparse.ArgumentParser(description="Compute Ocean Heat Content (OHC)")
    parser.add_argument("--indir", dest = "indir", required=True,
        help = "full path to main model data directory")
    parser.add_argument("-c", "--casename", dest = "casename", required=True,
        help = "casename of the run")
    parser.add_argument("--meshfile", dest = "meshfile", required=True,
        help = "MPAS mesh filename (with full path)")
    parser.add_argument("--plots_dir", dest = "plots_dir", required=True,
        help = "full path to plot directory")
    parser.add_argument("--year_offset", dest = "yr_offset", required=True,
        help = "year offset (1849 for pre-industrial runs, 1999 for present-day runs, 0 for transient runs)")
    parser.add_argument("-v", "--varname", dest = "varname", required=True,
        help = "name of sea-ice variable to plot")
    parser.add_argument("--compare_with_model", dest = "compare_with_model", required=True,
        default = "true", choices = ["true","false"], 
        help = "logic flag to enable comparison with other model")
    parser.add_argument("--indir_model_tocompare", dest = "indir_model_tocompare", required=False,
        help = "full path to model_tocompare data directory")
    parser.add_argument("--casename_model_tocompare", dest = "casename_model_tocompare", required=False,
        help = "casename of the run to compare")
    parser.add_argument("--compare_with_obs", dest = "compare_with_obs", required=True,
        default = "false", choices = ["true","false"], 
        help = "logic flag to enable comparison with observations")
    parser.add_argument("--obs_filenameNH", dest = "obs_filenameNH", required=False,
        help = "filename (with full path) of NH observational sea-ice data")
    parser.add_argument("--obs_filenameSH", dest = "obs_filenameSH", required=False,
        help = "filename (with full path) of SH observational sea-ice data")
    args = parser.parse_args()
    indir     = args.indir
    casename  = args.casename
    meshfile  = args.meshfile
    plots_dir = args.plots_dir
    yr_offset = int(args.yr_offset)
    varname = args.varname
    compare_with_model = args.compare_with_model
    compare_with_obs = args.compare_with_obs
    if compare_with_model == "true":
        indir_model_tocompare = args.indir_model_tocompare
        casename_model_tocompare = args.casename_model_tocompare
    if compare_with_obs == "true":
        obs_filenameNH = args.obs_filenameNH
        obs_filenameSH = args.obs_filenameSH

# Checks on directory/files existence:
if os.path.isdir("%s" % indir) != True:
    raise SystemExit("Model directory %s not found. Exiting..." % indir)
if compare_with_model == "true":
    if os.path.isdir("%s" % indir_model_tocompare) != True:
        raise SystemExit("Model_tocompare directory %s not found. Exiting..." % indir_model_tocompare)
if compare_with_obs == "true":
    if obs_filenameNH != "none" and os.path.isfile("%s" % obs_filenameNH) != True:
        raise SystemExit("Obs file %s not found. Exiting..." % obs_filenameNH)
    if obs_filenameSH != "none" and os.path.isfile("%s" % obs_filenameSH) != True:
        raise SystemExit("Obs file %s not found. Exiting..." % obs_filenameSH)


# Some plotting rules
axis_font = {'size':'16'}    
title_font = {'size':'18', 'color':'black', 'weight':'normal'}


print "  Load sea-ice data..."

# Number of points over which to compute moving average (e.g., for monthly
# output, N_movavg=12 corresponds to a 12-month moving average window)
N_movavg = 1

# Load mesh
dsmesh = xr.open_dataset(meshfile)

# Load data
infiles = "".join([indir,'/am.mpas-cice.timeSeriesStatsMonthly.????-??-??.nc'])
ds = xr.open_mfdataset(infiles,preprocess=lambda x: preprocess_mpas_timeSeriesStats(x, yearoffset=yr_offset,                         timestr='timeSeriesStatsMonthly_avg_daysSinceStartOfSim_1',                                                  onlyvars=['timeSeriesStatsMonthly_avg_iceAreaCell_1',                                                                  'timeSeriesStatsMonthly_avg_iceVolumeCell_1']))
ds = remove_repeated_time_index(ds)

ds = ds.merge(dsmesh)

# Make Northern and Southern Hemisphere partition:
areaCell = ds.areaCell
ind_nh = ds.latCell > 0
ind_sh = ds.latCell < 0
areaCell_nh = areaCell.where(ind_nh)
areaCell_sh = areaCell.where(ind_sh)


print "  Compute NH and SH quantities..."
if varname == "iceThickCell":
    varnamefull = "timeSeriesStatsMonthly_avg_iceVolumeCell_1"
else:
    varnamefull = "".join(["timeSeriesStatsMonthly_avg_",varname,"_1"])
var = ds[varnamefull]

var_nh = var.where(ind_nh)*areaCell_nh
var_sh = var.where(ind_sh)*areaCell_sh

#ind_ice = var > 0
#var_nh_ice = var_nh.where(ind_ice)
#var_sh_ice = var_sh.where(ind_ice)
ind_iceext = var > 0.15
var_nh_iceext = var_nh.where(ind_iceext)
var_sh_iceext = var_sh.where(ind_iceext)

if varname == "iceAreaCell":
    var_nh = var_nh.sum('nCells')
    var_sh = var_sh.sum('nCells')
    var_nh = 1e-6*var_nh # m^2 to km^2
    var_sh = 1e-6*var_sh # m^2 to km^2
    var_nh_iceext = 1e-6*var_nh_iceext.sum('nCells')
    var_sh_iceext = 1e-6*var_sh_iceext.sum('nCells')
elif varname == "iceVolumeCell":
    var_nh = var_nh.sum('nCells')
    var_sh = var_sh.sum('nCells')
    var_nh = 1e-3*1e-9*var_nh # m^3 to 10^3 km^3
    var_sh = 1e-3*1e-9*var_sh # m^3 to 10^3 km^3
else:
    var_nh = var_nh.mean('nCells')/areaCell_nh.mean('nCells')
    var_sh = var_sh.mean('nCells')/areaCell_sh.mean('nCells')


def replicate_cycle(ds,ds_toreplicate):
    dsshift = ds_toreplicate.copy()
    shiftT = (dsshift.Time.max() - dsshift.Time.min()) + (dsshift.Time.isel(Time=1) - dsshift.Time.isel(Time=0))
    nT = np.ceil((ds.Time.max() - ds.Time.min())/shiftT)
        
    # replicate cycle:
    for i in np.arange(nT):
        dsnew = ds_toreplicate.copy()
        dsnew['Time'] = dsnew.Time + (i+1)*shiftT
        dsshift = xr.concat([dsshift,dsnew], dim='Time')
    # constrict replicated ds_short to same time dimension as ds_long:
    dsshift = dsshift.sel(Time=ds.Time.values, method='nearest')
    return dsshift


def timeseries_analysis_plot(dsvalue1,dsvalue2,dsvalue3,N,title,xlabel,ylabel,figname):
    
    plt.figure(figsize=(15,6), dpi=300)
    #dsvalue.plot.line('k-')
    ax1 = pd.Series.rolling(dsvalue1.to_pandas(),N,center=True).mean().plot(style='r-',lw=1.2)
    if len(dsvalue2):
        ax2 = pd.Series.rolling(dsvalue2.to_pandas(),N,center=True).mean().plot(style='k-',lw=1.2)
    if len(dsvalue3):
        ax3 = pd.Series.rolling(dsvalue3.to_pandas(),N,center=True).mean().plot(style='b-',lw=1.2)
    #ax1 = dsvalue1.to_pandas().plot(style='r-',lw=1.5)
    #for label in (ax.get_xticklabels() + ax.get_yticklabels()):
    #    label.set_fontsize(16)
    
    if (title != None):
        plt.title(title, **title_font)
    if (xlabel != None):
        plt.xlabel(xlabel, **axis_font)
    if (ylabel != None):
        plt.ylabel(ylabel, **axis_font)
    if (figname != None):
        plt.savefig(figname,bbox_inches='tight',pad_inches=0.1)


print "  Make plots..."

#xlabel = "time"
xlabel = ""
#ylabel = units
if compare_with_model == "true":
    figname_nh = "%s/%sNH_%s_%s.png" % (plots_dir,varname,casename,casename_model_tocompare)
    figname_sh = "%s/%sSH_%s_%s.png" % (plots_dir,varname,casename,casename_model_tocompare)
else:
    figname_nh = "%s/%sNH_%s.png" % (plots_dir,varname,casename)
    figname_sh = "%s/%sSH_%s.png" % (plots_dir,varname,casename)

year_start = (pd.to_datetime(ds.Time.min().values)).year
year_end   = (pd.to_datetime(ds.Time.max().values)).year
time_start = datetime.datetime(year_start,1,1)
time_end   = datetime.datetime(year_end,12,31)
#time_start = pd.to_datetime(ds.Time.min().values)
#time_end   = pd.to_datetime(ds.Time.max().values)
#print pd.to_datetime(ds.Time.min().values),pd.to_datetime(ds.Time.max().values)

if varname == "iceAreaCell":
    plot_title = "Sea-ice area"
    units = "[km$^2$]"
    
    title_nh = "%s (NH), %s (r)" % (plot_title,casename)
    title_sh = "%s (SH), %s (r)" % (plot_title,casename)
    
    if compare_with_obs == "true":
        title_nh = "%s\nSSM/I observations, annual cycle (k)" % title_nh
        title_sh = "%s\nSSM/I observations, annual cycle (k)" % title_sh

        ds_obs = xr.open_mfdataset(obs_filenameNH,preprocess=lambda x: preprocess_mpas(x, yearoffset=yr_offset))
        ds_obs = remove_repeated_time_index(ds_obs)
        var_nh_obs = ds_obs.IceArea
        var_nh_obs = replicate_cycle(var_nh,var_nh_obs)
    
        ds_obs = xr.open_mfdataset(obs_filenameSH,preprocess=lambda x: preprocess_mpas(x, yearoffset=yr_offset))
        ds_obs = remove_repeated_time_index(ds_obs)
        var_sh_obs = ds_obs.IceArea
        var_sh_obs = replicate_cycle(var_sh,var_sh_obs)
        
    if compare_with_model == "true":
        title_nh = "%s\n %s (b)" % (title_nh,casename_model_tocompare)
        title_sh = "%s\n %s (b)" % (title_sh,casename_model_tocompare)

        infiles_model_tocompare = "".join([indir_model_tocompare,'/icearea.',casename_model_tocompare,'.year*.nc'])
        ds_model_tocompare = xr.open_mfdataset(infiles_model_tocompare,preprocess=lambda x: preprocess_mpas(x, yearoffset=yr_offset))
        ds_model_tocompare_tslice = ds_model_tocompare.sel(Time=slice(time_start,time_end))
        var_nh_model_tocompare = ds_model_tocompare_tslice.icearea_nh
        var_sh_model_tocompare = ds_model_tocompare_tslice.icearea_sh

    if compare_with_obs == "true":
        if compare_with_model == "true":
            timeseries_analysis_plot(var_nh,var_nh_obs,var_nh_model_tocompare,N_movavg,title_nh,xlabel,units,figname_nh)
            timeseries_analysis_plot(var_sh,var_sh_obs,var_sh_model_tocompare,N_movavg,title_sh,xlabel,units,figname_sh)
        else:
            timeseries_analysis_plot(var_nh,var_nh_obs,[],N_movavg,title_nh,xlabel,units,figname_nh)
            timeseries_analysis_plot(var_sh,var_sh_obs,[],N_movavg,title_sh,xlabel,units,figname_sh)
            #timeseries_analysis_plot(var_nh_iceext,var_nh_obs,[],N_movavg,title_nh,xlabel,units,figname_nh)
            #timeseries_analysis_plot(var_sh_iceext,var_sh_obs,[],N_movavg,title_sh,xlabel,units,figname_sh)
    else:
        if compare_with_model == "true":
            timeseries_analysis_plot(var_nh,[],var_nh_model_tocompare,N_movavg,title_nh,xlabel,units,figname_nh)
            timeseries_analysis_plot(var_sh,[],var_sh_model_tocompare,N_movavg,title_sh,xlabel,units,figname_sh)
        else:
            figname = "%s/%s.%s.png" % (plots_dir,casename,varname)
            title = "%s, NH (r), SH (k)\n%s" % (plot_title,casename)
            timeseries_analysis_plot(var_nh,var_sh,[],N_movavg,title,xlabel,units,figname)
                
elif varname == "iceVolumeCell":
    plot_title = "Sea-ice volume"
    units = "[10$^3$ km$^3$]"
    
    title_nh = "%s (NH), %s (r)" % (plot_title,casename)
    title_sh = "%s (SH), %s (r)" % (plot_title,casename)

    if compare_with_obs == "true":
        title_nh = "%s\nPIOMAS, annual cycle (k)" % title_nh
        title_sh = "%s\n" % title_sh

        ds_obs = xr.open_mfdataset(obs_filenameNH,preprocess=lambda x: preprocess_mpas(x, yearoffset=yr_offset))
        ds_obs = remove_repeated_time_index(ds_obs)
        var_nh_obs = ds_obs.IceVol
        var_nh_obs = replicate_cycle(var_nh,var_nh_obs)
        
        var_sh_obs = []
        
    if compare_with_model == "true":
        title_nh = "%s\n %s (b)" % (title_nh,casename_model_tocompare)
        title_sh = "%s\n %s (b)" % (title_sh,casename_model_tocompare)

        infiles_model_tocompare = "".join([indir_model_tocompare,'/icevol.',casename_model_tocompare,'.year*.nc'])
        ds_model_tocompare = xr.open_mfdataset(infiles_model_tocompare,preprocess=lambda x: preprocess_mpas(x, yearoffset=yr_offset))
        ds_model_tocompare_tslice = ds_model_tocompare.sel(Time=slice(time_start,time_end))
        var_nh_model_tocompare = ds_model_tocompare_tslice.icevolume_nh
        var_sh_model_tocompare = ds_model_tocompare_tslice.icevolume_sh

    if compare_with_obs == "true":
        if compare_with_model == "true":
            timeseries_analysis_plot(var_nh,var_nh_obs,var_nh_model_tocompare,N_movavg,title_nh,xlabel,units,figname_nh)
            timeseries_analysis_plot(var_sh,var_sh_obs,var_sh_model_tocompare,N_movavg,title_sh,xlabel,units,figname_sh)
        else:
            timeseries_analysis_plot(var_nh,var_nh_obs,[],N_movavg,title_nh,xlabel,units,figname_nh)
            timeseries_analysis_plot(var_sh,var_sh_obs,[],N_movavg,title_sh,xlabel,units,figname_sh)
    else:
        if compare_with_model == "true":
            timeseries_analysis_plot(var_nh,[],var_nh_model_tocompare,N_movavg,title_nh,xlabel,units,figname_nh)
            timeseries_analysis_plot(var_sh,[],var_sh_model_tocompare,N_movavg,title_sh,xlabel,units,figname_sh)
        else:
            figname = "%s/%s.%s.png" % (plots_dir,casename,varname)
            title = "%s, NH (r), SH (k)\n%s" % (plot_title,casename)
            timeseries_analysis_plot(var_nh,var_sh,[],N_movavg,title,xlabel,units,figname)

elif varname == "iceThickCell":
    plot_title = "Sea-ice thickness"
    units = "[m]"
    
    figname = "%s/%s.%s.png" % (plots_dir,casename,varname)
    title = "%s NH (r), SH (k)\n%s" % (plot_title,casename)
    timeseries_analysis_plot(var_nh,var_sh,[],N_movavg,title,xlabel,units,figname)
    
else:
    raise SystemExit("varname variable %s not supported for plotting" % varname)




