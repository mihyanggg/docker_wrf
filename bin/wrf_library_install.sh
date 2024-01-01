#!/bin/bash

sudo apt update && sudo apt upgrade -y

export DIR=$HOME/WRF/Library
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran

echo "----- zlib install : START -----" \
&& cd $HOME/WRF/Downloads/zlib-1.3 \
&& ./configure --prefix=$DIR \
&& make \
&& make install \
&& echo "----- zlib install : END -----" \
&& echo "----- HDF5 install : START -----" \
&& cd $HOME/WRF/Downloads/hdf5-1.10.5 \
&& ./configure --prefix=$DIR --with-zlib=$DIR --enable-hl --enable-fortran \
&& make check \
&& make install \
&& export HDF5=$DIR \
&& export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH \
&& echo "----- HDF5 install : END -----" \
&& echo "----- netCDF-C install : START -----" \
&& cd $HOME/WRF/Downloads/netcdf-c-4.9.0 \
&& export CPPFLAGS=-I$DIR/include \
&& export LDFLAGS=-L$DIR/lib \
&& ./configure --prefix=$DIR --disable-dap \
&& make check \
&& make install \
&& export PATH=$DIR/bin:$PATH \
&& export NETCDF=$DIR \
&& echo "----- netCDF-C install : END -----" \
&& echo "----- netCDF-fortran install : START -----" \
&& cd $HOME/WRF/Downloads/netcdf-fortran-4.6.0 \
&& export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH \
&& export CPPFLAGS=-I$DIR/include \
&& export LDFLAGS=-L$DIR/lib \
&& export LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lz" \
&& ./configure --prefix=$DIR --disable-shared \
&& make check \
&& make install \
&& echo "----- netCDF-fortran install : END -----" \
&& echo "----- mpich install : START -----" \
&& cd $HOME/WRF/Downloads/mpich-3.3.1 \
&& export FFLAGS="-w -fallow-argument-mismatch -O2" \
&& ./configure --prefix=$DIR |& tee sgk.log \
&& make -j5 \
&& sudo make install \
&& echo "----- mpich install : END -----" \
&& echo "----- libpng install : START -----" \
&& cd $HOME/WRF/Downloads/libpng-1.6.37 \
&& export LDFLAGS=-L$DIR/lib \
&& export CPPFLAGS=-I$DIR/include \
&& ./configure --prefix=$DIR \
&& make \
&& sudo make install \
&& echo "----- libpng install : END -----" \
&& echo "----- jasper install : START -----" \
&& cd $HOME/WRF/Downloads/jasper-1.900.1 \
&& autoreconf -i \
&& ./configure --prefix=$DIR \
&& make \
&& sudo make install \
&& export JASPERLIB=$DIR/lib \
&& export JASPERINC=$DIR/include \
&& echo "----- jasper install : END -----" \
&& touch $HOME/.wrf_library_installed

