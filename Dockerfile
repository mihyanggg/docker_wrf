# 기본 이미지로 Ubuntu를 사용
FROM ubuntu:22.04

# 필요한 패키지 설치, 여기서는 sudo를 설치합니다
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
    python3 \
    python3-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 컨테이너의 호스트 이름 추가
#RUN echo "127.0.0.1 test" >> /etc/hosts

# root 비밀번호 설정
RUN echo 'root:123' | chpasswd

# 새 사용자 생성
RUN useradd -m myuser

# 새 사용자에게 sudo 권한 부여 및 비밀번호 없이 sudo 실행 가능하게 설정
RUN echo 'myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# 컨테이너 실행 시 사용할 기본 사용자 변경
USER myuser
ENV HOME /home/myuser

# 기본 작업 디렉토리 설정
WORKDIR /home/myuser

RUN mkdir WRF
RUN mkdir WRF/WPS_GEOG
RUN mkdir WRF/DATA
RUN mkdir WRF/Downloads
RUN mkdir WRF/Library

# COPY
COPY ./bin/_bash_aliases /home/myuser/.bash_aliases
COPY ./bin /home/myuser/bin/
COPY ./downloads /home/myuser/WRF/Downloads

# prompt change color and permission
RUN /home/myuser/bin/color_prompt_and_bin_perm.sh

# after v4.4 .. Please refer to [https://www2.mmm.ucar.edu/wrf/users/download/get_sources_new.php]
RUN cd /home/myuser/WRF \
    && git clone --recurse-submodules https://github.com/wrf-model/WRF \
    && git clone https://github.com/wrf-model/WPS

RUN cd /home/myuser/WRF/Downloads \
    && tar xvfz geog_high_res_mandatory.tar.gz \
    && tar xvfz hdf5-1.10.5.tar.gz \
    && tar xvfz libpng-1.6.37.tar.gz \
    && tar xvfz mpich-3.3.1.tar.gz \
    && tar xvfz netcdf-c-4.9.0.tar.gz \
    && tar xvfz netcdf-fortran-4.6.0.tar.gz \
    && tar xvfz zlib-1.3.tar.gz \
    && unzip    jasper-1.900.1.zip             

    #&& wget https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz \
    #&& tar xvfz geog_high_res_mandatory.tar.gz 
    #&& wget https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz \
    #&& tar xvfz geog_low_res_mandatory.tar.gz
    #tar xvf kwgrib2.tar # grib2 convert .. from datacenter

# install WRF libraries
RUN /home/myuser/bin/wrf_library_install.sh

## WRF와 WPS의 소스 코드 다운로드 (4.2.2)
#ENV WRF_VERSION 4.2.2
#RUN wget https://github.com/wrf-model/WRF/archive/refs/tags/v$WRF_VERSION.tar.gz \
#    && tar -xzf v$WRF_VERSION.tar.gz \
#    && rm v$WRF_VERSION.tar.gz

# 기본 명령어 설정
CMD ["bash"]

ENTRYPOINT ["/home/myuser/bin/loop.sh"]

