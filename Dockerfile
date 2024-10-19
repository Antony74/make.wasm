# docker build -t akb74/emscripten .
# docker run -it akb74/emscripten sh

FROM ubuntu:jammy

RUN echo "## Start building" \
    && echo "## Update and install packages" \
    && apt-get -qq -y update \
    && apt-get -qq install -y --no-install-recommends \
        binutils \
        build-essential \
        ca-certificates \
        file \
        git \
        python3 \
        python3-pip \
    && echo "## Done"

WORKDIR /git

# Get emsdk

WORKDIR /git
RUN git clone --depth 1 https://github.com/emscripten-core/emsdk.git

WORKDIR /git/emsdk
RUN ./emsdk install latest
RUN ./emsdk activate latest

COPY .emscripten .
ENV PATH=/git/emsdk:/git/emsdk/upstream/emscripten:/git/emsdk/node/18.20.3_64bit/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV EMSDK=/git/emsdk
ENV EMSDK_NODE=/git/emsdk/node/18.20.3_64bit/bin/node
ENV EM_CONFIG=/git/emsdk/.emscripten

# Bootstrap emscripten

WORKDIR /git/emscripten
COPY . .
RUN python3 bootstrap.py
