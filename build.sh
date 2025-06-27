#!/bin/bash

mkdir dist -p
gcc c/main.c -O3 -o dist/gcc
g++ c/main.c -O3 -o dist/g++

cargo build --release

cp target/release/process-info-bench dist/rust