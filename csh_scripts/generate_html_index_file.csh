#!/bin/csh -f 

# calling sequence: ./generate_html_index_file.csh casename plots_dir www_dir

if ($#argv == 0) then
        echo Input arguments not set. Will stop!
else
        set case_no    = $argv[1]
	set plots_dir   = $argv[2]
        set www_dir  = $argv[3]
endif

#Reading case information from file
source $log_dir/case_info.temp
set n_cases = $#case_set

set casename = $case_set[$case_no]
set ref_case = $case_set[$n_cases]

set begin_yr_climo        = $begin_yr_climo_set[$case_no]
set end_yr_climo          = $end_yr_climo_set[$case_no]
set begin_yr_ts           = $begin_yr_ts_set[$case_no]
set end_yr_ts             = $end_yr_ts_set[$case_no]
set begin_yr_climateIndex = $begin_yr_climateIndex_set[$case_no]
set end_yr_climateIndex   = $end_yr_climateIndex_set[$case_no]

set ref_begin_yr_climo 	= $begin_yr_climo_set[$n_cases]
set ref_end_yr_climo 	= $end_yr_climo_set[$n_cases]
set ref_begin_yr_ts 	= $begin_yr_ts_set[$n_cases]
set ref_end_yr_ts   	= $end_yr_ts_set[$n_cases]


# padding begin_yr and end_yr with zeroes
set begin_yr = $begin_yr_climo
set end_yr   = $end_yr_climo


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

cd $plots_dir

#Setting up text for ref case
if $ref_case == obs then
	set ref_case_text = $ref_case' (climo)' 
	set ref_case_text_ts = $ref_case' (climo)' 
else
	set ref_case_text = $ref_case' (Years: '$ref_begin_yr_climo'-'$ref_end_yr_climo')'
	set ref_case_text_ts = $ref_case' (Years: '$ref_begin_yr_ts'-'$ref_end_yr_ts')'
endif


#Beginning to write index.html file
cat > index.html << EOF
<HTML>

<BODY BGCOLOR="ivory">

<HEAD>
<TITLE>ACME Coupled Diagnostic Plots</TITLE>
</HEAD>

<p><img src="acme-banner_1.jpg" style="float:right;width:590px;height:121px;">
</p>

<div style="text-align:center">
<font color=seagreen size=+3><b>ACME Coupled Priority Metrics</b></font><br>

<font color=sienna size=+2><b>
${casename} (Years: $begin_yr_climo-$end_yr_climo)<br>vs.<br>$ref_case_text
</b></font>
</div>
EOF

if ($generate_atm_diags == 1) then
  cat >> index.html << EOF
  <br>
  <br>
  <hr noshade size=2 size="100%">

  <font color=red size=+1><b>Time Series Plots: Global and Zonal-band means (ATM)</b></font><br>

  <div style="text-align:left">
  <font color=peru size=-1>$casename (Years: $begin_yr_ts-$end_yr_ts)</font><br>
  <font color=peru size=-1>$ref_case_text_ts</font>
  </div>

  <hr noshade size=2 size="100%">

  <TABLE>
EOF

  #Generating time series part of index.html file
  if ($ref_case == obs) then
  	source $coupled_diags_home/var_list_time_series_model_vs_obs.csh
  else
  	source $coupled_diags_home/var_list_time_series_model_vs_model.csh
  endif

  set var_grp_unique_set = ()
  set grp_interp_grid_set = ()

  @ i = 1

  foreach grp ($var_group_set)

        set add_var = 1

        foreach temp_grp ($var_grp_unique_set)
                if ($grp =~ $temp_grp) then
                        set add_var = 0
                endif
        end

        if ($add_var == 1) then
                set var_grp_unique_set = ($var_grp_unique_set $grp)
                set grp_interp_grid_set  = ($grp_interp_grid_set $interp_grid_set[$i])
        endif

        @ i = $i + 1
  end


  @ j = 1

  foreach grp ($var_grp_unique_set)

	if ($ref_case == obs) then
		set grp_text = "$grp ($grp_interp_grid_set[$j])"
	else
		set grp_text = $grp
	endif

	cat >> index.html << EOF
	<TR>
	  <TH><BR>
	  <TH ALIGN=LEFT><font color=brown size=+1>$grp_text</font>
EOF

	@ i = 1
	foreach var ($var_set)

		if ($var_group_set[$i] == $grp) then

			if ($ref_case == obs) then
				set ref_casename_plot = $interp_grid_set[$i]
			else
				set ref_casename_plot = $ref_case  
			endif

			cat >> index.html << EOF
			<TR>
			  <TH ALIGN=LEFT><A HREF="${casename}_${var}_ANN_reg_ts.png">$var</a> 
			  <TD ALIGN=LEFT>$var_name_set[$i]
EOF
		endif
		@ i = $i + 1
	end

	cat >> index.html << EOF
	<TR>
	  <TD><BR>
EOF
	@ j = $j + 1
  end

  cat >> index.html << EOF
  </TABLE>
EOF
endif

if ($generate_ocnice_diags == 1) then
  #Generating time series ocn/ice part of index.html file
  cat >> index.html << EOF
  <br>
  <br>
  </TABLE>
  <hr noshade size=2 size="100%">

  <font color=red size=+1><b>Time Series Plots: Global/Hemispheric means (OCN/ICE)</b></font>
  </b></font>

  <hr noshade size=2 size="100%">

  <TABLE>
  <TR>
    <TH ALIGN=LEFT><A HREF="sst_global_${casename}.png">Global SST</a>
  <TR>
    <TH ALIGN=LEFT><A HREF="ohc_global_${casename}.png">Global OHC</a>
  <TR>
    <TH ALIGN=LEFT><A HREF="iceAreaNH_${casename}.png">NH Ice Area</a>
  <TR>
    <TH ALIGN=LEFT><A HREF="iceAreaSH_${casename}.png">SH Ice Area</a>
  <TR>
    <TH ALIGN=LEFT><A HREF="iceVolumeNH_${casename}.png">NH Ice Volume</a>
  <TR>
    <TH ALIGN=LEFT><A HREF="iceVolumeSH_${casename}.png">SH Ice Volume</a>
EOF
endif


if ($generate_atm_diags == 1) then
  #Generating climatology (atm) part of index.html file
  cat >> index.html << EOF
  <TR>
  <TD><BR>
  </TABLE>
  <hr noshade size=2 size="100%">
  <font color=red size=+1><b>Climatology Plots (ATM)</b></font><br>

  <div style="text-align:left">
  <font color=peru size=-1>$casename (Years: $begin_yr_climo-$end_yr_climo)</font><br>
  <font color=peru size=-1>$ref_case_text</font>
  </div>

  <hr noshade size=2 size="100%">

  <TABLE>
EOF


  if ($ref_case == obs) then
	source $coupled_diags_home/var_list_climo_model_vs_obs.csh
  else
	source $coupled_diags_home/var_list_climo_model_vs_model.csh
  endif

  set var_grp_unique_set = ()
  set grp_interp_grid_set = ()

  @ i = 1

  foreach grp ($var_group_set)

        set add_var = 1

        foreach temp_grp ($var_grp_unique_set)
                if ($grp =~ $temp_grp) then
                        set add_var = 0
                endif
        end

        if ($add_var == 1) then
                set var_grp_unique_set = ($var_grp_unique_set $grp)
                set grp_interp_grid_set  = ($grp_interp_grid_set $interp_grid_set[$i])
        endif

        @ i = $i + 1
  end


  @ j = 1

  foreach grp ($var_grp_unique_set)

	if ($ref_case == obs) then
		set grp_text = "$grp ($grp_interp_grid_set[$j])"
	else
		set grp_text = $grp
	endif

	cat >> index.html << EOF

	<TR>
	  <TH><BR>
	  <TH ALIGN=LEFT><font color=brown size=+1>$grp_text</font>
	  <TH>DJF
	  <TH>JJA
	  <TH>ANN
EOF

	@ i = 1
	foreach var ($var_set)

		if ($var_group_set[$i] == $grp) then

			if ($ref_case == obs) then
				set ref_casename_plot = $interp_grid_set[$i]
			else
				set ref_casename_plot = $ref_case  
			endif

			cat >> index.html << EOF
			<TR>
			  <TH ALIGN=LEFT>$var 
			  <TD ALIGN=LEFT>$var_name_set[$i]
			  <TD ALIGN=LEFT><A HREF="${casename}-${ref_casename_plot}_${var}_climo_DJF.png">plot</a>
			  <TD ALIGN=LEFT><A HREF="${casename}-${ref_casename_plot}_${var}_climo_JJA.png">plot</a>
			  <TD ALIGN=LEFT><A HREF="${casename}-${ref_casename_plot}_${var}_climo_ANN.png">plot</a>
EOF
		endif
		@ i = $i + 1
	end

	cat >> index.html << EOF
	<TR>
	  <TD><BR>
EOF

	@ j = $j + 1
  end

  cat >> index.html << EOF
  </TABLE>
EOF
endif

if ($generate_ocnice_diags == 1) then
  #Generating climatology (ocn/ice) part of index.html file
  cat >> index.html << EOF
  <TR>
  <TD><BR>
  <hr noshade size=2 size="100%">
  <font color=red size=+1><b>Climatology Plots (OCN/ICE)</b></font>
  <hr noshade size=2 size="100%">
  <TABLE>
  <TR>
    <TH ALIGN=LEFT><font color=green size=+1>Global Ocean</font>
  <TR>
    <TH><BR>
    <TH ALIGN=LEFT><font color=brown size=+1>SST Hadley-NOAA-OI</font>
    <TH>JFM
    <TH>JAS
    <TH>ANN
  <TR>
  <TH ALIGN=LEFT>SST
  <TH><BR>
  <TD ALIGN=LEFT><A HREF="sstHADOI_${casename}_JFM_years${begin_yr}-${end_yr}.png">plot</a>
  <TD ALIGN=LEFT><A HREF="sstHADOI_${casename}_JAS_years${begin_yr}-${end_yr}.png">plot</a>
  <TD ALIGN=LEFT><A HREF="sstHADOI_${casename}_ANN_years${begin_yr}-${end_yr}.png">plot</a>
  <TR>
    <TH><BR>
    <TH ALIGN=LEFT><font color=brown size=+1>SSS Aquarius</font>
    <TH>JFM
    <TH>JAS
    <TH>ANN
  <TR>
    <TH ALIGN=LEFT>SSS
    <TH><BR>
    <TD ALIGN=LEFT><A HREF="sssAquarius_${casename}_JFM_years${begin_yr}-${end_yr}.png">plot</a>
    <TD ALIGN=LEFT><A HREF="sssAquarius_${casename}_JAS_years${begin_yr}-${end_yr}.png">plot</a>
    <TD ALIGN=LEFT><A HREF="sssAquarius_${casename}_ANN_years${begin_yr}-${end_yr}.png">plot</a>
  <TR>
    <TH><BR>
    <TH ALIGN=LEFT><font color=brown size=+1>MLD Holte-Talley ARGO</font>
    <TH>JFM
    <TH>JAS
    <TH>ANN
  <TR>
    <TH ALIGN=LEFT>MLD
    <TH><BR>
    <TD ALIGN=LEFT><A HREF="mldHolteTalleyARGO_${casename}_JFM_years${begin_yr}-${end_yr}.png">plot</a>
    <TD ALIGN=LEFT><A HREF="mldHolteTalleyARGO_${casename}_JAS_years${begin_yr}-${end_yr}.png">plot</a>
    <TD ALIGN=LEFT><A HREF="mldHolteTalleyARGO_${casename}_ANN_years${begin_yr}-${end_yr}.png">plot</a>
  <TR>
    <TH><BR>
  <TR>
    <TH ALIGN=LEFT><font color=green size=+1>Northern Hemisphere Sea-ice</font>
  <TR>
    <TH><BR>
    <TH ALIGN=LEFT><font color=brown size=+1>SSM/I NASATeam</font>
    <TH>JFM
    <TH>JAS
  <TR>
    <TH ALIGN=LEFT>Ice Conc. 
    <TD ALIGN=LEFT>Ice concentration
    <TD ALIGN=LEFT><A HREF="iceconcNASATeamNH_${casename}_JFM_years${begin_yr}-${end_yr}.png">plot</a>
    <TD ALIGN=LEFT><A HREF="iceconcNASATeamNH_${casename}_JAS_years${begin_yr}-${end_yr}.png">plot</a>
  <TR>
    <TH><BR>
    <TH ALIGN=LEFT><font color=brown size=+1>SSM/I Bootstrap</font>
    <TH>JFM
    <TH>JAS
  <TR>
    <TH ALIGN=LEFT>Ice Conc. 
    <TD ALIGN=LEFT>Ice concentration
    <TD ALIGN=LEFT><A HREF="iceconcBootstrapNH_${casename}_JFM_years${begin_yr}-${end_yr}.png">plot</a>
    <TD ALIGN=LEFT><A HREF="iceconcBootstrapNH_${casename}_JAS_years${begin_yr}-${end_yr}.png">plot</a>
  <TR>
    <TH><BR>
    <TH ALIGN=LEFT><font color=brown size=+1>ICESat</font>
    <TH>FM
    <TH>ON
  <TR>
    <TH ALIGN=LEFT>Ice Thick. 
    <TD ALIGN=LEFT>Ice Thickness
    <TD ALIGN=LEFT><A HREF="icethickNH_${casename}_FM_years${begin_yr}-${end_yr}.png">plot</a>
    <TD ALIGN=LEFT><A HREF="icethickNH_${casename}_ON_years${begin_yr}-${end_yr}.png">plot</a>
  <TR>
    <TH><BR>
  <TR>
    <TH ALIGN=LEFT><font color=green size=+1>Southern Hemisphere Sea-ice</font>
  <TR>
    <TH><BR>
    <TH ALIGN=LEFT><font color=brown size=+1>SSM/I NASATeam</font>
    <TH>DJF
    <TH>JJA
  <TR>
    <TH ALIGN=LEFT>Ice Conc. 
    <TD ALIGN=LEFT>Ice concentration
    <TD ALIGN=LEFT><A HREF="iceconcNASATeamSH_${casename}_DJF_years${begin_yr}-${end_yr}.png">plot</a>
    <TD ALIGN=LEFT><A HREF="iceconcNASATeamSH_${casename}_JJA_years${begin_yr}-${end_yr}.png">plot</a>
  <TR>
    <TH><BR>
    <TH ALIGN=LEFT><font color=brown size=+1>SSM/I Bootstrap</font>
    <TH>DJF
    <TH>JJA
  <TR>
    <TH ALIGN=LEFT>Ice Conc. 
    <TD ALIGN=LEFT>Ice concentration
    <TD ALIGN=LEFT><A HREF="iceconcBootstrapSH_${casename}_DJF_years${begin_yr}-${end_yr}.png">plot</a>
    <TD ALIGN=LEFT><A HREF="iceconcBootstrapSH_${casename}_JJA_years${begin_yr}-${end_yr}.png">plot</a>
  <TR>
    <TH><BR>
    <TH ALIGN=LEFT><font color=brown size=+1>ICESat</font>
    <TH>FM
    <TH>ON
  <TR>
    <TH ALIGN=LEFT>Ice Thick. 
    <TD ALIGN=LEFT>Ice Thickness
    <TD ALIGN=LEFT><A HREF="icethickSH_${casename}_FM_years${begin_yr}-${end_yr}.png">plot</a>
    <TD ALIGN=LEFT><A HREF="icethickSH_${casename}_ON_years${begin_yr}-${end_yr}.png">plot</a>
  <TR>
    <TD><BR>
  </TABLE>
EOF

  #Generating other ocn/ice part of index.html file
  cat >> index.html << EOF
  <hr noshade size=2 size="100%">
  <font color=red size=+1><b>Other OCN/ICE plots</b></font>
  <hr noshade size=2 size="100%">
  <TABLE>
  <TR>
    <TH ALIGN=LEFT><font color=green size=+1>Meridional Overturning Circulation (MOC)</font>
  <TR>
    <TH><BR>
  <TR>
    <TH ALIGN=LEFT><A HREF="mocGlobal_${casename}_years${begin_yr}-${end_yr}.png">Global Ocean MOC streamfunction</a> 
  <TR>
    <TH ALIGN=LEFT><A HREF="mocAtlantic_${casename}_years${begin_yr}-${end_yr}.png">Atlantic Ocean MOC streamfunction</a>
  <TR>
    <TH ALIGN=LEFT><A HREF="mocTimeseries_${casename}.png">Time series of Max Atlantic MOC at 26.5N</a>
  <TR>
    <TD><BR>
  <TR>
    <TD><BR>
  <TR>
    <TH ALIGN=LEFT><font color=green size=+1>Nino3.4 Index</font>
  <TR>
    <TD><BR>
  <TR>
    <TH ALIGN=LEFT><A HREF="NINO34_${casename}.png">Time series of Nino3.4 Index</a>
  <TR>
    <TH ALIGN=LEFT><A HREF="NINO34_spectra_${casename}.png">Nino3.4 Power Spectrum</a>
  <TR>
    <TH><BR>
  </TABLE>
EOF
endif

cat >> index.html << EOF
  <hr noshade size=2 size="100%">
  </BODY>
  </HTML>
EOF

echo
echo Standalone HTML file with links to coupled diagnostic plots generated!
echo $plots_dir/index.html
echo

if (! -d $www_dir/coupled_diagnostics_$casename-$ref_case) then
	mkdir $www_dir/coupled_diagnostics_$casename-$ref_case
endif

unalias cp
cp -fr $plots_dir/* $www_dir/coupled_diagnostics_$casename-$ref_case
cp -f $coupled_diags_home/images/acme-banner_1.jpg $www_dir/coupled_diagnostics_$casename-$ref_case

chmod -R a+rx $www_dir/coupled_diagnostics_$casename-$ref_case

echo Moved plots and index.html to the website directory: $www_dir/coupled_diagnostics_$casename-$ref_case
echo

if (`echo $HOSTNAME | cut -c1-4` == 'rhea') then
	echo Viewable at:
	echo http://users.nccs.gov/~$USER/coupled_diagnostics_${casename}-$ref_case
	echo
	echo Please ensure that the read and execute permissions for $www_dir are set for all:
	echo chmod a+rx $www_dir
endif

if (`echo $HOSTNAME | cut -c1-6` == 'edison') then
	echo Viewable at:
	echo http://portal.nersc.gov/project/acme/$USER/coupled_diagnostics_$casename-$ref_case
	echo
	echo Please ensure that the read and execute permissions for $www_dir are set for all:
	echo chmod a+rx $www_dir
endif

if (`echo $HOSTNAME | cut -c1-4` == 'aims') then
	echo Viewable at:
	echo http://aims4.llnl.gov/$USER/coupled_diagnostics_$casename-$ref_case
	echo
	echo The name and password to view the plots is acme/acmediags
	echo If trouble viewing, try chmod a+rx $www_dir
endif

echo

cd -
