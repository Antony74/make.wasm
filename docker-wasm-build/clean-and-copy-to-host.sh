set -e
set -x

cd host
ls --hide docker-wasm-build --hide Dockerfile --hide .gitignore | xargs -d '\n' rm -rf
cp -a ../make/. ./
