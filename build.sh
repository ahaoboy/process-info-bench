#!/bin/bash

mkdir dist -p
gcc c/main.c -O3 -o -flto -s -o dist/gcc
g++ c/main.c -O3 -o -flto -s -o dist/g++
clang c/main.c -O3 -s -o dist/clang

cargo build --release

cp target/release/process-info-bench dist/rust