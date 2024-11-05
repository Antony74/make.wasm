set -e
set -x

cd host
mkdir -p make.wasm
cd make.wasm
ls --hide docker-wasm-build --hide Dockerfile --hide .gitignore | xargs -d '\n' rm -rf
cp -a ../../make/. ./
