#!/bin/bash
# script to set up a WPS/WRF run folder on SciNet
# created 28/06/2012 by Andre R. Erler, GPL v3
# environment variables: $MODEL_ROOT, $WPSSRC, $WRFSRC

## some settings: source folders
RUNDIR="${PWD}"
mkdir -p "${RUNDIR}"
# WRF Tools
WRFTOOLS="${MODEL_ROOT}/WRF Tools/"
GEOGRID="FLAKE"
METGRID="CESM"
DATA="cesm"
POPMAP="map_gx1v6_to_fv0.9x1.25_aave_da_090309.nc"
WPSSYS="GPC"
WPSQ="pbs"
CASE="clim"

## link in WPS stuff
# meta data
mkdir -p "${RUNDIR}/meta"
cd meta
ln -s "${WRFTOOLS}/misc/data/${POPMAP}" ${POPMAP}  
ln -s "${WRFTOOLS}/misc/data/GEOGRID.TBL.${GEOGRID}" GEOGRID.TBL
ln -s "${WRFTOOLS}/misc/data/METGRID.TBL.${METGRID}" METGRID.TBL
ln -s "${WRFTOOLS}/misc/data/namelist.data.${DATA}" namelist.data
ln -s "${WRFTOOLS}/misc/data/setup.ncl.${DATA}" setup.ncl
# WPS scripts and executables
cd "${RUNDIR}"
ln -s "${WRFTOOLS}/Scripts/execWPS.sh"
ln -s "${WRFTOOLS}/Python/pyWPS.py"
ln -s "${WRFTOOLS}/NCL/eta2p.ncl"
# WPS GPC-specific stuff (for largemem-nodes)
if [[ "$WPSSYS" == "GPC" ]]; then
	ln -s "${WRFTOOLS}/Scripts/run_WPS.pbs" "run_WPS.pbs"
	ln -s "${WRFTOOLS}/bin/GPC-lm/unccsm.exe"
	ln -s "${WPSSRC}/GPC-MPI/O3xSSSE3/geogrid.exe"
	ln -s "${WPSSRC}/GPC-MPI/O3xSSSE3/metgrid.exe"
	ln -s "${WRFSRC}/GPC-MPI/O3xSSSE3/real.exe"
fi

## WPS/WRF namelists
cp "${WRFTOOLS}/misc/namelists/namelist.wps.${CASE}" namelist.wps
cp "${WRFTOOLS}/misc/namelists/namelist.input.${CASE}" namelist.input

## link in WRF stuff


## prompt user to create data links
echo "Remainign tasks:"
echo " * link to data folders: atm, lnd, ice"
echo " * review meta data (meta/) and edit namelists"
echo " * adapt run scripts" 