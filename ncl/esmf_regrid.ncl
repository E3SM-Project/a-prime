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


; Call sequence: ncl indir=\"indir\" filename=\"filename\" wgt_file=\"wgt_file\" field_name=\"field_name\" interp_filename=\"interp_filename\" esmf_regrid_with_weights_ne30_T85.ncl 

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"

;print(indir)
;print(wgt_file)

begin
    print("------------------------------------------------------------")
    print("Will be regridding to the required grid")
    print("------------------------------------------------------------")


;---Data file containing source grid

    CAMSE_file = indir + "/" + filename

    sfile      = addfile(CAMSE_file,"r")


;---Get variable to regrid
    var_name = field_name
    vscale   = 1.
    var_in   = sfile->$var_name$              ; (time,ncol)
    var_in   = (/var_in*vscale/)
    ;src_date = sfile->date

;---Call the regridding function

    printVarSummary(var_in)

    Opt = True
    Opt@Debug = True
    Opt@CopyVarCoords = True

    var_regrid = ESMF_regrid_with_weights(var_in,wgt_file,Opt)
    printVarSummary(var_regrid)

;---Write regridded data

    setfileoption("nc","Format","NetCDF4Classic")

    outfile = indir + "/" + interp_filename 

    print("Writing regridded data to:" + outfile)
    print("")

    system("rm " + outfile)

    fout = addfile(outfile, "c")
    fout->$field_name$=var_regrid
	
    ;fout->date=src_date

end

