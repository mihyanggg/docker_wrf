#!/bin/bash

# package for wrf-ucm
# set timezone 6, 69 
sudo apt update -y && sudo apt upgrade -y \
    && sudo apt install -y grads \
    && sudo apt install -y gcc gfortran g++ libtool automake autoconf make m4 grads default-jre csh \
    && sudo apt install -y libnetcdf-dev libhdf5-dev zlib1g-dev libgrib2c-dev \
    && sudo rm -rf /var/lib/apt/lists/*


#cd /home/myuser/WRF/Downloads

#tar xvf kwgrib2.tar # grib2 convert .. from datacenter
#wget -c https://www.zlib.net/zlib-1.2.13.tar.gz
#wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz
#wget -c https://downloads.unidata.ucar.edu/netcdf-c/4.9.0/netcdf-c-4.9.0.tar.gz
#wget -c https://downloads.unidata.ucar.edu/netcdf-fortran/4.6.0/netcdf-fortran-4.6.0.tar.gz
#wget -c http://www.mpich.org/static/downloads/3.3.1/mpich-3.3.1.tar.gz
#wget -c https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz
#wget -c https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip


cd /home/myuser

