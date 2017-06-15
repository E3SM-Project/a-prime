#!/bin/bash
#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#
#
# calling sequence: ./generate_html_index_file.csh casename plots_dir www_dir
#

if [ $# -eq 0 ]; then
  echo "Input arguments not set. Will stop!"
else
  case_no=$1
  plots_dir=$2
  www_dir=$3
fi

# Reading case information from file
source $log_dir/case_info.temp
n_cases=${#case_set[@]}

casename="${case_set[$case_no-1]}"
ref_case="${case_set[$n_cases-1]}"

begin_yr_climo=${begin_yr_climo_set[$case_no-1]}
end_yr_climo=${end_yr_climo_set[$case_no-1]}
begin_yr_ts=${begin_yr_ts_set[$case_no-1]}
end_yr_ts=${end_yr_ts_set[$case_no-1]}
begin_yr_climateIndex=${begin_yr_climateIndex_set[$case_no-1]}
end_yr_climateIndex=${end_yr_climateIndex_set[$case_no-1]}

ref_begin_yr_climo=${begin_yr_climo_set[$n_cases-1]}
ref_end_yr_climo=${end_yr_climo_set[$n_cases-1]}
ref_begin_yr_ts=${begin_yr_ts_set[$n_cases-1]}
ref_end_yr_ts=${end_yr_ts_set[$n_cases-1]}

# padding begin_yr and end_yr with zeroes
begin_yr=`echo $begin_yr_climo | awk '{printf "%04d",$1}'`
end_yr=`echo $end_yr_climo | awk '{printf "%04d",$1}'`

cd $plots_dir

# Setting up text for ref case
if [ "$ref_case" == "obs" ]; then
  ref_case_text="$ref_case (climo)" 
  ref_case_text_ts="$ref_case (climo)"
else
  ref_case_text="$ref_case (Years: $ref_begin_yr_climo-$ref_end_yr_climo)"
  ref_case_text_ts="$ref_case (Years: $ref_begin_yr_ts-$ref_end_yr_ts)"
fi


# Beginning to write index.html file
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

if [ $generate_atm_diags -eq 1 ]; then
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

  # Generating time series part of index.html file
  if [ "$ref_case" == "obs" ]; then
    source $coupled_diags_home/bash_scripts/var_list_time_series_model_vs_obs.bash
  else
    source $coupled_diags_home/bash_scripts/var_list_time_series_model_vs_model.bash
  fi

  var_grp_unique_set=()
  grp_interp_grid_set=()

  i=0
  while [ $i -lt ${#var_group_set[@]} ]; do

     add_var=1

     j=0
     while [ $j -lt ${#var_grp_unique_set[@]} ]; do
        if [[ "${var_group_set[$i]}" =~ "${var_grp_unique_set[$j]}" ]]; then
          add_var=0
        fi
        j=$((j+1))
     done

     if [ $add_var -eq 1 ]; then
       var_grp_unique_set=("${var_grp_unique_set[@]}" "${var_group_set[$i]}")
       grp_interp_grid_set=("${grp_interp_grid_set[@]}" ${interp_grid_set[$i]})
     fi

     i=$((i + 1))
  done

  i=0
  while [ $i -lt ${#var_grp_unique_set[@]} ]; do
     if [ "$ref_case" == "obs" ]; then
       grp_text="${var_grp_unique_set[$i]} (${grp_interp_grid_set[$i]})"
     else
       grp_text="${var_grp_unique_set[$i]}"
     fi

     cat >> index.html << EOF
	<TR>
	  <TH><BR>
	  <TH ALIGN=LEFT><font color=brown size=+1>$grp_text</font>
EOF

     j=0
     while [ $j -lt ${#var_set[@]} ]; do
        var="${var_set[$j]}"
        if [ "${var_group_set[$j]}" == "${var_grp_unique_set[$i]}" ]; then
          if [ "$ref_case" == "obs" ]; then
            ref_casename_plot="${interp_grid_set[$j]}"
          else
            ref_casename_plot="$ref_case"
          fi

          cat >> index.html << EOF
		<TR>
		  <TH ALIGN=LEFT><A HREF="${casename}_${var}_ANN_reg_ts.png">$var</a> 
		  <TD ALIGN=LEFT>${var_name_set[$j]}
EOF
        fi
        j=$((j + 1))
     done

     cat >> index.html << EOF
	<TR>
	  <TD><BR>
EOF
     i=$((i + 1))
  done

  cat >> index.html << EOF
  </TABLE>
EOF
fi

if [ $generate_ocnice_diags -eq 1 ]; then
  # Generating time series ocn/ice part of index.html file
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
fi


if [ $generate_atm_diags -eq 1 ]; then
  # Generating climatology (atm) part of index.html file
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


  if [ "$ref_case" == "obs" ]; then
    source $coupled_diags_home/bash_scripts/var_list_climo_model_vs_obs.bash
  else
    source $coupled_diags_home/bash_scripts/var_list_climo_model_vs_model.bash
  fi

  var_grp_unique_set=()
  grp_interp_grid_set=()

  i=0
  while [ $i -lt ${#var_group_set[@]} ]; do

     add_var=1

     j=0
     while [ $j -lt ${#var_grp_unique_set[@]} ]; do
        if [[ "${var_group_set[$i]}" =~ "${var_grp_unique_set[$j]}" ]]; then
          add_var=0
        fi
        j=$((j+1))
     done

     if [ $add_var -eq 1 ]; then
       var_grp_unique_set=("${var_grp_unique_set[@]}" "${var_group_set[$i]}")
       grp_interp_grid_set=("${grp_interp_grid_set[@]}" "${interp_grid_set[$i]}")
     fi

     i=$((i + 1))
  done


  i=0
  while [ $i -lt ${#var_grp_unique_set[@]} ]; do

     if [ "$ref_case" == "obs" ]; then
       grp_text="${var_grp_unique_set[$i]} (${grp_interp_grid_set[$i]})"
     else
       grp_text="${var_grp_unique_set[$i]}"
     fi

     cat >> index.html << EOF
	<TR>
	  <TH><BR>
	  <TH ALIGN=LEFT><font color=brown size=+1>$grp_text</font>
	  <TH>DJF
	  <TH>JJA
	  <TH>ANN
EOF

     j=0
     while [ $j -lt ${#var_set[@]} ]; do
        var="${var_set[$j]}"

        if [ "${var_group_set[$j]}" == "${var_grp_unique_set[$i]}" ]; then
          if [ "$ref_case" == "obs" ]; then
            ref_casename_plot="${interp_grid_set[$j]}"
          else
            ref_casename_plot="$ref_case"  
          fi

          cat >> index.html << EOF
		<TR>
		  <TH ALIGN=LEFT>$var 
		  <TD ALIGN=LEFT>${var_name_set[$j]}
		  <TD ALIGN=LEFT><A HREF="${casename}-${ref_casename_plot}_${var}_climo_DJF.png">plot</a>
		  <TD ALIGN=LEFT><A HREF="${casename}-${ref_casename_plot}_${var}_climo_JJA.png">plot</a>
		  <TD ALIGN=LEFT><A HREF="${casename}-${ref_casename_plot}_${var}_climo_ANN.png">plot</a>
EOF
        fi
        j=$((j + 1))
     done

     cat >> index.html << EOF
	<TR>
	  <TD><BR>
EOF

     i=$((i + 1))
  done

  cat >> index.html << EOF
  </TABLE>
EOF
fi

if [ $generate_ocnice_diags -eq 1 ]; then
  # Generating climatology (ocn/ice) part of index.html file
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

  # Generating other ocn/ice part of index.html file
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
    <TH ALIGN=LEFT><font color=green size=+1>Meridional Heat Transport (MHT)</font>
  <TR>
    <TH><BR>
  <TR>
    <TH ALIGN=LEFT><A HREF="mht_${casename}_years${begin_yr}-${end_yr}.png">Global Ocean MHT</a> 
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
fi

cat >> index.html << EOF
  <hr noshade size=2 size="100%">
  </BODY>
  </HTML>
EOF

unalias cp
cp -f $coupled_diags_home/images/acme-banner_1.jpg $www_dir/$plots_dir_name
mv index.html $www_dir/$plots_dir_name
chmod -R a+rx $www_dir/$plots_dir_name

echo
echo "Standalone HTML file with links to coupled diagnostic plots generated!"
echo "$plots_dir/index.html"
echo

echo "Viewable at:"
if [ $machname == "nersc" ]; then
  echo "http://portal.nersc.gov/project/acme/$USER/$plots_dir_name"
elif [ $machname == "olcf" ]; then
  echo "http://users.nccs.gov/~$USER/$plots_dir_name"
elif  [ $machname == "aims4" ]; then
  echo "https://aims4.llnl.gov/$USER/$plots_dir_name"
  echo "*** The name and password to view the plots is acme/acme, respectively ***"
elif [ $machname == "acme1" ]; then
  echo "https://acme-viewer.llnl.gov/$USER/$plots_dir_name"
else
  echo "Machine $machname either not supported or online shared space not available for it"
fi
echo

cd -
