#!/bin/csh -f 

# calling sequence: ./generate_html_index_file.csh casename plots_dir www_dir


if ($#argv == 0) then
        echo Input arguments not set. Will stop!
else
        set casename    = $argv[1]
	set plots_dir   = $argv[2]
        set www_dir  = $argv[3]
	set begin_yr = $argv[4]
	set end_yr = $argv[5]
endif

set case_compare = B1850C5_ne30_v0.4

# padding begin_yr and end_yr with zeroes
@ nc = `echo $begin_yr | wc -c` - 1
while ($nc != 4)
	set begin_yr = "0"$begin_yr
	@ nc = `echo $begin_yr | wc -c` - 1
end

@ nc = `echo $end_yr | wc -c` - 1
while ($nc != 4)
	set end_yr = "0"$end_yr
	@ nc = `echo $end_yr | wc -c` - 1
end

echo $begin_yr $end_yr

cd $plots_dir

cat > index.html << EOF
<HTML>
<HEAD>
<TITLE>ACME Coupled Diagnostic Plots</TITLE>
</HEAD>
<BODY BGCOLOR="white">
<p>
<font color=green size=+3><b>
${casename} <br>and<br> OBS data 
<p>
</b></font>
<font color=orange size=+2><b> 
ACME Coupled Priority Metrics</b></font>
<p>
<font color=red size=+1><b>Time Series Plots: Global and Zonal-band means (ATM)</b></font>
<hr noshade size=2 size="100%">
</b></font>
<TABLE>
<TR>
  <TH ALIGN=LEFT><A HREF="${casename}_RESTOM_ANN_reg_ts.png">RESTOM</a>
<TR>
  <TH ALIGN=LEFT><A HREF="${casename}_FLNT_ANN_reg_ts.png">FLNT</a>
<TR>
  <TH ALIGN=LEFT><A HREF="${casename}_FSNT_ANN_reg_ts.png">FSNT</a>
<TR>
  <TH ALIGN=LEFT><A HREF="${casename}_PRECT_ANN_reg_ts.png">PRECT</a>
<TR>
</TABLE>
<hr noshade size=2 size="100%">
<p>
<font color=red size=+1><b>Time Series Plots: Global/Hemispheric means (OCN/ICE)</b></font>
<hr noshade size=2 size="100%">
</b></font>
<TABLE>
<TR>
  <TH ALIGN=LEFT><A HREF="sst_global_${casename}_$case_compare.png">Global SST</a>
<TR>
  <TH ALIGN=LEFT><A HREF="ohc_global_${casename}_$case_compare.png">Global OHC</a>
<TR>
  <TH ALIGN=LEFT><A HREF="iceAreaCellNH_${casename}_$case_compare.png">NH Ice Area</a>
<TR>
  <TH ALIGN=LEFT><A HREF="iceAreaCellSH_${casename}_$case_compare.png">SH Ice Area</a>
<TR>
  <TH ALIGN=LEFT><A HREF="iceVolumeCellNH_${casename}_$case_compare.png">NH Ice Volume</a>
<TR>
  <TH ALIGN=LEFT><A HREF="iceVolumeCellSH_${casename}_$case_compare.png">SH Ice Volume</a>
</TABLE>
<hr noshade size=2 size="100%">
<p>
<font color=red size=+1><b>Climatology Plots (ATM)</b></font>
<hr noshade size=2 size="100%">
<TABLE>
<TR>
  <TH><BR>
  <TH ALIGN=LEFT><font color=brown size=+1>GPCP</font>
  <TH>DJF
  <TH>JJA
  <TH>ANN
<TR>
<TR>
  <TH ALIGN=LEFT>PRECT 
  <TH ALIGN=LEFT>Precipitation rate
  <TH ALIGN=LEFT><A HREF="${casename}-GPCP_PRECT_climo_DJF.png">plot</a>
  <TH ALIGN=LEFT><A HREF="${casename}-GPCP_PRECT_climo_JJA.png">plot</a>
  <TH ALIGN=LEFT><A HREF="${casename}-GPCP_PRECT_climo_ANN.png">plot</a>
<TR>
  <TH><BR>
  <TH ALIGN=LEFT><font color=brown size=+1>CERES-EBAF</font>
  <TH>DJF
  <TH>JJA
  <TH>ANN
<TR>
  <TH ALIGN=LEFT>FLUT 
  <TH ALIGN=LEFT>TOA upward LW flux
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_FLUT_climo_DJF.png">plot</a>
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_FLUT_climo_JJA.png">plot</A>
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_FLUT_climo_ANN.png">plot</A>
<TR>
  <TH ALIGN=LEFT>FSNTOA 
  <TH ALIGN=LEFT>TOA net SW flux
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_FSNTOA_climo_DJF.png">plot</a>
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_FSNTOA_climo_JJA.png">plot</A>
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_FSNTOA_climo_ANN.png">plot</A>
<TR>
  <TH ALIGN=LEFT>LWCF 
  <TH ALIGN=LEFT>TOA longwave cloud forcing
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_LWCF_climo_DJF.png">plot</a>
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_LWCF_climo_JJA.png">plot</A>
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_LWCF_climo_ANN.png">plot</A>
<TR>
  <TH ALIGN=LEFT>SWCF 
  <TH ALIGN=LEFT>TOA shortwave cloud forcing
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_SWCF_climo_DJF.png">plot</a>
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_SWCF_climo_JJA.png">plot</A>
  <TH ALIGN=LEFT><A HREF="${casename}-CERES-EBAF_SWCF_climo_ANN.png">plot</A>
<TR>
  <TH><BR>
  <TH ALIGN=LEFT><font color=brown size=+1>ERS</font>
  <TH>DJF
  <TH>JJA
  <TH>ANN
<TR>
  <TH ALIGN=LEFT>Wind Stress 
  <TH ALIGN=LEFT>Ocean Wind Stress
  <TH ALIGN=LEFT><A HREF="${casename}-ERS_TAU_climo_DJF.png">plot</a>
  <TH ALIGN=LEFT><A HREF="${casename}-ERS_TAU_climo_JJA.png">plot</A>
  <TH ALIGN=LEFT><A HREF="${casename}-ERS_TAU_climo_ANN.png">plot</A>
<TR>
</TABLE>

<hr noshade size=2 size="100%">
<p>
<font color=red size=+1><b>Climatology Plots (OCN/ICE)</b></font>
<hr noshade size=2 size="100%">
<TABLE>
<TR>
  <TH ALIGN=LEFT><font color=green size=+1>Northern Hemisphere</font>
<TR>
  <TH><BR>
  <TH ALIGN=LEFT><font color=brown size=+1>SSM/I Bootstrap</font>
  <TH>JFM
  <TH>JAS
<TR>
<TR>
  <TH ALIGN=LEFT>Ice Conc. 
  <TH ALIGN=LEFT>Ice concentration
  <TH ALIGN=LEFT><A HREF="iceconcBootstrapNH_${casename}_JFM_years${begin_yr}-${end_yr}.png">plot</a>
  <TH ALIGN=LEFT><A HREF="iceconcBootstrapNH_${casename}_JAS_years${begin_yr}-${end_yr}.png">plot</a>
<TR>
  <TH><BR>
  <TH ALIGN=LEFT><font color=brown size=+1>SSM/I NASA Team</font>
  <TH>JFM
  <TH>JAS
<TR>
<TR>
  <TH ALIGN=LEFT>Ice Conc. 
  <TH ALIGN=LEFT>Ice concentration
  <TH ALIGN=LEFT><A HREF="iceconcNASATeamNH_${casename}_JFM_years${begin_yr}-${end_yr}.png">plot</a>
  <TH ALIGN=LEFT><A HREF="iceconcNASATeamNH_${casename}_JAS_years${begin_yr}-${end_yr}.png">plot</a>
<TR>
  <TH><BR>
  <TH ALIGN=LEFT><font color=brown size=+1>ICE Sat</font>
  <TH>FM
  <TH>ON
<TR>
<TR>
  <TH ALIGN=LEFT>Ice Thick. 
  <TH ALIGN=LEFT>Ice Thickness
  <TH ALIGN=LEFT><A HREF="icethickNH_${casename}_FM_years${begin_yr}-${end_yr}.png">plot</a>
  <TH ALIGN=LEFT><A HREF="icethickNH_${casename}_ON_years${begin_yr}-${end_yr}.png">plot</a>
<TR>
<TR>
  <TH><BR>
<TR>
<TR>
  <TH ALIGN=LEFT><font color=green size=+1>Southern Hemisphere</font>
<TR>
  <TH><BR>
  <TH ALIGN=LEFT><font color=brown size=+1>SSM/I Bootstrap</font>
  <TH>DJF
  <TH>JJA
<TR>
<TR>
  <TH ALIGN=LEFT>Ice Conc. 
  <TH ALIGN=LEFT>Ice concentration
  <TH ALIGN=LEFT><A HREF="iceconcBootstrapSH_${casename}_DJF_years${begin_yr}-${end_yr}.png">plot</a>
  <TH ALIGN=LEFT><A HREF="iceconcBootstrapSH_${casename}_JJA_years${begin_yr}-${end_yr}.png">plot</a>
<TR>
  <TH><BR>
  <TH ALIGN=LEFT><font color=brown size=+1>SSM/I NASA Team</font>
  <TH>JFM
  <TH>JAS
<TR>
<TR>
  <TH ALIGN=LEFT>Ice Conc. 
  <TH ALIGN=LEFT>Ice concentration
  <TH ALIGN=LEFT><A HREF="iceconcNASATeamSH_${casename}_DJF_years${begin_yr}-${end_yr}.png">plot</a>
  <TH ALIGN=LEFT><A HREF="iceconcNASATeamSH_${casename}_JJA_years${begin_yr}-${end_yr}.png">plot</a>
<TR>
  <TH><BR>
  <TH ALIGN=LEFT><font color=brown size=+1>ICE Sat</font>
  <TH>FM
  <TH>ON
<TR>
<TR>
  <TH ALIGN=LEFT>Ice Thick. 
  <TH ALIGN=LEFT>Ice Thickness
  <TH ALIGN=LEFT><A HREF="icethickSH_${casename}_FM_years${begin_yr}-${end_yr}.png">plot</a>
  <TH ALIGN=LEFT><A HREF="icethickSH_${casename}_ON_years${begin_yr}-${end_yr}.png">plot</a>
<TR>
</TABLE>

<hr noshade size=2 size="100%">
</BODY>
</HTML>


EOF

echo
echo Standalone HTML file with links to coupled diagnostic plots generated!
echo $plots_dir/index.html
echo
cp -r $plots_dir $www_dir
chmod -R a+rx $www_dir/coupled_diagnostics_$casename

echo Moved plots and index.html to the website directory: $www_dir
echo
echo On rhea, viewable at:
echo http://users.nccs.gov/~$USER/coupled_diagnostics_${casename}-$ref_case
echo
echo On edison, viewable at:
echo http://portal.nersc.gov/project/acme/$USER/coupled_diagnostics_$casename
echo
echo
cd -
