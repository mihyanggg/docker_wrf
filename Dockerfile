# 기본 이미지로 Ubuntu를 사용
FROM ubuntu:20.04

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
    sudo \
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

# COPY
COPY ./bin/_bash_aliases /home/myuser/.bash_aliases
COPY ./bin /home/myuser/bin/
COPY ./downloads /home/myuser/WRF/Downloads
RUN /home/myuser/bin/color_prompt.sh

# WRF와 WPS의 소스 코드 다운로드
ENV WRF_VERSION 4.4.2
RUN wget https://github.com/wrf-model/WRF/archive/refs/tags/v$WRF_VERSION.tar.gz \
    && tar -xzf v$WRF_VERSION.tar.gz \
    && rm v$WRF_VERSION.tar.gz

# 기본 명령어 설정
CMD ["bash"]

ENTRYPOINT ["/home/myuser/bin/loop.sh"]

