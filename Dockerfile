# syntax=docker.io/docker/dockerfile:1.7-labs

# Usage:
#   docker build -t akb74/emscripten .
#   docker run -it -v .:/git/host akb74/emscripten
#
# Other commands I find useful:
#   docker run -it -v .:/git/host akb74/emscripten bash
#   emcc -O2 -s NODERAWFS=1 posix_spawn.c

FROM ubuntu:jammy

ARG EMSDK_VER=3.1.69
ARG NODE_VER=node-20.18.0-64bit
ARG NODE_VER_UNDERSCORE=20.18.0_64bit
ARG MAKE_VERSION=4.4.1

RUN echo "## Start building" \
    && echo "## Update and install packages" \
    && apt-get -qq -y update \
    && apt-get -qq install -y --no-install-recommends \
        binutils \
        build-essential \
        ca-certificates \
        curl \
        file \
        git \
        python3 \
        python3-pip \
        tar \
    && echo "## Done"

WORKDIR /git

# Get emsdk

WORKDIR /git
RUN git clone --depth 1 https://github.com/emscripten-core/emsdk.git

WORKDIR /git/emsdk

RUN ./emsdk install ${EMSDK_VER} ${NODE_VER}
RUN ./emsdk activate ${EMSDK_VER} ${NODE_VER}

COPY .emscripten .

ENV PATH=/git/emsdk:/git/emscripten:/git/emsdk/node/${NODE_VER_UNDERSCORE}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV EMSDK=/git/emsdk
ENV EMSDK_NODE=/git/emsdk/node/${NODE_VER_UNDERSCORE}/bin/node
ENV EM_CONFIG=/git/emsdk/.emscripten

# Bootstrap emscripten

WORKDIR /git/emscripten
COPY --exclude=Dockerfile --exclude=make-play --exclude=docker-wasm-build --exclude=make.wasm . .
RUN python3 bootstrap.py

# Get GNU Make

# WORKDIR /git
# RUN curl https://ftp.gnu.org/gnu/make/make-${MAKE_VERSION}.tar.gz -o make-${MAKE_VERSION}.tar.gz --fail-with-body
# RUN tar -xvzf make-${MAKE_VERSION}.tar.gz
# RUN mv make-${MAKE_VERSION} make

# Alternatively we can use our own local copy of the GNU Make source code instead, which can be useful diagnostically
# COPY make.wasm /git/make

# WORKDIR /git/make

COPY docker-wasm-build/package.json .

# Switch to the wasm build of make.  If you want to bootstrap from the regular binary build of make, comment from here

# # Remove existing regular build of make
# RUN which make | xargs -d '\n' rm -rf

# COPY make.wasm .
# COPY make.js .

# RUN npm install --global .

# If you want to bootstrap from the regular binary build of make, comment to here

# Build GNU Make

RUN emconfigure ./configure
RUN emmake make
RUN find . -name "*.o" -type f | xargs emcc -O2 -s NODERAWFS=1 -o make.js

# Replace make.js
COPY docker-wasm-build/make.js .

# Remove existing regular build of make
RUN which make | xargs -d '\n' rm -rf
RUN npm install --global .

WORKDIR /git

COPY docker-wasm-build/clean-and-copy-to-host.sh .

# make-play just some useful test code here

COPY make-play /git/make-play

WORKDIR /git/make-play
CMD ["make"]

