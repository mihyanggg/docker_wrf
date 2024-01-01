FROM ubuntu:22.04

# Install the packages required by WRF and the ones I will use
RUN apt-get update && apt-get install -y \
    sudo \
    iputils-ping \
    net-tools \
    vim \
    git \
    curl \
    wget \
    unzip \
    tree \
    grads \
    gcc \
    gfortran \
    g++ \
    libtool \
    automake \
    autoconf \
    make \
    m4 \
    grads \
    default-jre \
    csh \
    libnetcdf-dev \
    libhdf5-dev \
    zlib1g-dev \
    libgrib2c-dev \
    ncview \
    python3 \
    python3-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set the 'root' password
RUN echo 'root:123' | chpasswd

# Create a user to use inside the container
RUN useradd -m myuser

# Give the new user 'sudo' privileges, and enable them to run 'sudo' without a password
RUN echo 'myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Change the default user to use in the container
USER myuser
ENV HOME /home/myuser

# Set the default working directory
WORKDIR /home/myuser

RUN mkdir WRF
RUN mkdir WRF/DATA
RUN mkdir WRF/Downloads
RUN mkdir WRF/Library

# COPY
COPY ./bin /home/myuser/bin/

COPY ./downloads/geog_high_res_mandatory.tar.gz   /home/myuser/WRF/Downloads/geog_high_res_mandatory.tar.gz
COPY ./downloads/hdf5-1.10.5.tar.gz               /home/myuser/WRF/Downloads/hdf5-1.10.5.tar.gz
COPY ./downloads/jasper-1.900.1.zip               /home/myuser/WRF/Downloads/jasper-1.900.1.zip
COPY ./downloads/libpng-1.6.37.tar.gz             /home/myuser/WRF/Downloads/libpng-1.6.37.tar.gz
COPY ./downloads/mpich-3.3.1.tar.gz               /home/myuser/WRF/Downloads/mpich-3.3.1.tar.gz
COPY ./downloads/netcdf-c-4.9.0.tar.gz            /home/myuser/WRF/Downloads/netcdf-c-4.9.0.tar.gz
COPY ./downloads/netcdf-fortran-4.6.0.tar.gz      /home/myuser/WRF/Downloads/netcdf-fortran-4.6.0.tar.gz
COPY ./downloads/zlib-1.3.tar.gz                  /home/myuser/WRF/Downloads/zlib-1.3.tar.gz

# Changing prompt colors and permissions
RUN /home/myuser/bin/color_prompt_and_bin_perm.sh
RUN mv ./bin/_bash_aliases /home/myuser/.bash_aliases 

# after v4.4 .. Please refer to [https://www2.mmm.ucar.edu/wrf/users/download/get_sources_new.php]
RUN cd /home/myuser/WRF \
    && git clone --recurse-submodules https://github.com/wrf-model/WRF \
    && git clone https://github.com/wrf-model/WPS

# Vtable by 'NIMR-TN-2014-016' p.30 of National meteorological research note in Korea # http://www.nims.go.kr/flexer/view.jsp?FileDir=/PU87/&SystemFileName=20141210163510_0.pdf&ftype=pdf&FileName=2014_%EC%9D%91%EC%9A%A9%EA%B3%BC_GIS%EB%A5%BC.pdf&org=KOR_OP_PU_MV_2&idx=405&c_idx=-999&seq=0
RUN mv /home/myuser/bin/Vtable.LDPS /home/myuser/WRF/WPS/ungrib/Variable_Tables

RUN cd /home/myuser/WRF/Downloads \
    && tar xvfz geog_high_res_mandatory.tar.gz \
    && tar xvfz hdf5-1.10.5.tar.gz \
    && tar xvfz libpng-1.6.37.tar.gz \
    && tar xvfz mpich-3.3.1.tar.gz \
    && tar xvfz netcdf-c-4.9.0.tar.gz \
    && tar xvfz netcdf-fortran-4.6.0.tar.gz \
    && tar xvfz zlib-1.3.tar.gz \
    && unzip    jasper-1.900.1.zip             

RUN mv /home/myuser/WRF/Downloads/WPS_GEOG /home/myuser/WRF

# install WRF libraries
RUN /home/myuser/bin/wrf_library_install.sh
RUN if [ ! -f $HOME/.wrf_library_installed ]; then echo "Libraries used by WRF were not installed correctly." && exit 1; fi

# install WRF libraries
ENV HOME /home/myuser
ENV DIR $HOME/WRF/Library
ENV CC gcc
ENV CXX g++
ENV FC gfortran
ENV F77 gfortran
ENV HDF5 $DIR
ENV PATH $DIR/bin:$PATH
ENV NETCDF $DIR
ENV LIBS "-lnetcdf -lhdf5_hl -lhdf5 -lz"
ENV JASPERLIB $DIR/lib
ENV JASPERINC $DIR/include
ENV LD_LIBRARY_PATH $DIR/lib:$LD_LIBRARY_PATH
ENV WRF_DIR $HOME/WRF/WRF

RUN /home/myuser/bin/wrf_install.sh
RUN if [ ! -f $HOME/.wrf_installed ]; then echo "WRF is not installed correctly." && exit 1; fi

RUN cd /home/myuser/WRF/Downloads \
    && rm geog_high_res_mandatory.tar.gz \
    && rm hdf5-1.10.5.tar.gz \
    && rm libpng-1.6.37.tar.gz \
    && rm mpich-3.3.1.tar.gz \
    && rm netcdf-c-4.9.0.tar.gz \
    && rm netcdf-fortran-4.6.0.tar.gz \
    && rm zlib-1.3.tar.gz \
    && rm jasper-1.900.1.zip             

CMD ["bash"]

ENTRYPOINT ["/home/myuser/bin/loop.sh"]

