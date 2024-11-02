# docker build -t akb74/emscripten .
# docker run -it akb74/emscripten bash
# emcc -O2 -s NODERAWFS=1 posix_spawn.c

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

ARG EMSDK_VER=3.1.69
ARG NODE_VER=node-20.18.0-64bit
ARG NODE_VER_UNDERSCORE=20.18.0_64bit

RUN ./emsdk install ${EMSDK_VER} ${NODE_VER}
RUN ./emsdk activate ${EMSDK_VER} ${NODE_VER}

COPY .emscripten .

ENV PATH=/git/emsdk:/git/emscripten:/git/emsdk/node/${NODE_VER_UNDERSCORE}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV EMSDK=/git/emsdk
ENV EMSDK_NODE=/git/emsdk/node/${NODE_VER_UNDERSCORE}/bin/node
ENV EM_CONFIG=/git/emsdk/.emscripten

# Bootstrap emscripten

WORKDIR /git/emscripten
COPY . .
RUN python3 bootstrap.py

WORKDIR /git
COPY cat.c .
COPY getcwd.c .
COPY hello.c .
COPY posix_spawn.c .

CMD ["bash"]

