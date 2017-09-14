; Copyright (c) 2017, UT-BATTELLE, LLC
; All rights reserved.
; 
; This software is released under the BSD license detailed
; in the LICENSE file in the top level a-prime directory
;

;======================================================================
; ESMF_wgts_17.ncl
;
; Concepts illustrated:
;   - Interpolating from one grid to another using ESMF_regrid_with_weights
;   - Interpolating from one grid to another using an existing weights file
;   - Interpolating data from a CAM-SE grid to a CAM finite volume grid
;   - Regridding to a subset of the destination grid.
;======================================================================
; This example is identical to ESMF_regrid_17.ncl, except it assumes
; the weights file already exists, and does regridding using 
; "ESMF_regrid_with_weights".  This is the best method to use if you 
; already have the weights.
;======================================================================
; This example uses ESMF regridding software to regrid from an
; unstructured CAM-SE grid to a CAM finite volume (FV) grid (96 x 144).
;
; If you want regrid to a subregion of the FV grid, then set SUBREGION
; to True, and set minlat/maxlat/minlon/maxlon to the desired region.
;======================================================================


; Call sequence: ncl esmf_regrid_ne120_CERES-EBAF_conservative_mapping.ncl 'indir="indir" 'wgt_file="wgt_file"''field_name="PRECT"' 'casename="ne30_g16_cam4_ar5_trop_bam.F2000"'



load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

;print(indir)
;print(casename)
;print(field_name)
;print(wgt_file)

begin
    ;wgt_file = "/lustre/atlas1/cli106/proj-shared/salil/archive/grids/ne120_to_CERES-EBAF.conservative.wgts.nc"
    print("------------------------------------------------------------")
    print("Will be regridding to the GPCP grid")
    print("------------------------------------------------------------")


;---Data file containing source grid
    filename = casename + ".cam.h0." + field_name + ".nc"

    CAMSE_file = indir + "/" + filename

    sfile      = addfile(CAMSE_file,"r")


;---Get variable to regrid
    var_name = field_name
    vscale   = 1.
    var_in   = sfile->$var_name$              ; (time,ncol)
    var_in   = (/var_in*vscale/)
    src_lat  = sfile->lat
    src_lon  = sfile->lon

;---Call the regridding function

    printVarSummary(var_in)

    Opt = True
    Opt@Debug = True
    Opt@CopyVarCoords = True

    var_regrid = ESMF_regrid_with_weights(var_in,wgt_file,Opt)
    printVarSummary(var_regrid)

;---Write regridded data
    outfile_name = casename + ".cam.h0" + ".CERES-EBAF_conservative_mapping." + field_name + ".nc"
    outfile = indir + "/" + outfile_name 

    print("Writing regridded data to:" + outfile)
    print("")

    system("rm " + outfile)

    fout = addfile(outfile, "c")
    fout->$field_name$=var_regrid


end

