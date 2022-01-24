FROM ubuntu:16.04

RUN apt-get -qy update && \
apt-get -y install build-essential autoconf libtool libncurses-dev yasm curl libcurl4-openssl-dev \
libudev-dev libusb-1.0-0-dev pkg-config zlib1g-dev wget unzip && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN wget https://github.com/yinzheng-zhong/cgminer/archive/refs/heads/master.zip -O cgminer.zip && \
unzip cgminer.zip && rm cgminer.zip

WORKDIR /cgminer

ADD run.sh ./run.sh

RUN ./autogen.sh && \
export LIBCURL_CFLAGS='-I/usr/include/curl' && \
export LIBCURL_LIBS='-L/usr/lib -lcurl' && \
CFLAGS="-O2 -Wall -march=native" ./configure --enable-gekko --without-curses && \
make

RUN chmod +x ./run.sh

ENTRYPOINT ["bash"]

CMD ["/cgminer/run.sh"]
