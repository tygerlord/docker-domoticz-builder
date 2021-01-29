FROM debian:buster-slim 

ARG TARGETPLATFORM 

RUN mkdir /app
WORKDIR /app

ENV CFLAGS=-D_FILE_OFFSET_BITS=64
ENV CXXFLAGS=-D_FILE_OFFSET_BITS=64

RUN export DEBIAN_FRONTEND=noninteractive \
 && echo "I'm building for $TARGETPLATFORM" \
 && apt-get update \
 && apt-get install -y --no-install-recommends make gcc g++ libssl-dev git rsync \
 	libcurl4-gnutls-dev libusb-dev python3-dev zlib1g-dev libcereal-dev liblua5.3-dev uthash-dev \
 	wget sudo python3-setuptools python3-pip python3-dev \
 && apt-get clean \
 && pip3 install pyserial rpi.GPIO \
 && echo "******** build cmake  ********" \
 && apt-get remove --purge --auto-remove cmake \
 && wget --no-check-certificate https://github.com/Kitware/CMake/releases/download/v3.19.3/cmake-3.19.3.tar.gz \
 && tar -xzvf cmake-3.19.3.tar.gz \
 && rm cmake-3.19.3.tar.gz \
 && cd cmake-3.19.3 \
 && ./bootstrap \
 && make CPPFLAGS=-D_FILE_OFFSET_BITS=64 \
 && make install \
 && cd .. \
 && rm -fr cmake-3.19.3 \
 && echo "******** build boost  ********" \
 && apt-get remove --purge --auto-remove libboost-dev libboost-thread-dev libboost-system-dev libboost-atomic-dev libboost-regex-dev libboost-chrono-dev \
 && wget https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.gz \
 && tar xfz boost_1_74_0.tar.gz \
 && cd boost_1_74_0 \
 && ./bootstrap.sh \
 && ./b2 stage threading=multi link=static --with-thread --with-system \
 && ./b2 install threading=multi link=static --with-thread --with-system \
 && cd .. \
 && rm -fr boost_1_74_0
