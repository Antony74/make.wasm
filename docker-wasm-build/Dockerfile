ARG EMSCRIPTEN_VERSON=3.1.67

FROM emscripten/emsdk:${EMSCRIPTEN_VERSON}

ARG MAKE_VERSION=4.4.1

RUN apt-get update
RUN apt-get install curl
RUN apt-get install tar

WORKDIR /build

RUN curl https://ftp.gnu.org/gnu/make/make-${MAKE_VERSION}.tar.gz -o make-${MAKE_VERSION}.tar.gz --fail-with-body
RUN tar -xvzf make-${MAKE_VERSION}.tar.gz
RUN mv make-${MAKE_VERSION} make

WORKDIR /build/make

COPY docker-wasm-build/package.json .

# Switch to the wasm build of make.  If you want to bootstrap from the regular binary build of make, comment from here

# # Remove existing regular build of make
# RUN which make | xargs -d '\n' rm -rf

# COPY make.wasm .
# COPY make.js .

# RUN npm install --global .

# If you want to bootstrap from the regular binary build of make, comment to here

RUN emconfigure ./configure
RUN emmake make
RUN find . -name "*.o" -type f | xargs emcc -O2 -s NODERAWFS=1 -o make.js

# Replace make.js
COPY docker-wasm-build/make.js .

WORKDIR /build

COPY docker-wasm-build/clean-and-copy-to-host.sh .

CMD ["sh", "./clean-and-copy-to-host.sh"]
