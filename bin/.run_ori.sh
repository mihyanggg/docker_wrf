sudo apt update && sudo apt upgrade -y

cd $HOME/WRF/Downloads

export DIR=$HOME/WRF/Library
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran

# zlib # https://dunggeul7843.tistory.com/95
cd $HOME/WRF/Downloads/zlib-1.3
./configure --prefix=$DIR
make
make install

# HDF5 # https://dunggeul7843.tistory.com/96
cd $HOME/WRF/Downloads/hdf5-1.10.5
./configure --prefix=$DIR --with-zlib=$DIR --enable-hl --enable-fortran
make check
make install
export HDF5=$DIR
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH

# netCDF-C # https://dunggeul7843.tistory.com/97
cd $HOME/WRF/Downloads/netcdf-c-4.9.0
export CPPFLAGS=-I$DIR/include 
export LDFLAGS=-L$DIR/lib
./configure --prefix=$DIR --disable-dap
make check
make install
export PATH=$DIR/bin:$PATH
export NETCDF=$DIR

# netCDF-fortran # https://dunggeul7843.tistory.com/98
cd $HOME/WRF/Downloads/netcdf-fortran-4.6.0
export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/include 
export LDFLAGS=-L$DIR/lib
export LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lz"
./configure --prefix=$DIR --disable-shared
make check
make install

# MPICH # https://dunggeul7843.tistory.com/99
cd $HOME/WRF/Downloads/mpich-3.3.1
./configure --prefix=$DIR
make
sudo make install

    # gfortran error.. # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91731
    export FFLAGS="-w -fallow-argument-mismatch -O2"
    ./configure |& tee sgk.log
    grep mismatched sgk.log
    make -j5
    grep mismatch src/env/*

# libpng # https://dunggeul7843.tistory.com/100
cd $HOME/WRF/Downloads/libpng-1.6.37
export LDFLAGS=-L$DIR/lib
export CPPFLAGS=-I$DIR/include
./configure --prefix=$DIR
make
sudo make install

# jasper # https://dunggeul7843.tistory.com/101
cd jasper-1.900.1
autoreconf -i
./configure --prefix=$DIR
make
sudo make install
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include



# WRF install 
export NETCDF='/home/myuser/WRF/Library'
./configure #34 #1
./compile em_real >& compile.log

