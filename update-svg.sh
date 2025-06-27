#!/bin/bash

cd dist
hyperfine --style=full "gcc.exe" "g++.exe" "clang.exe" "rust.exe" "msvc.exe"  --warmup=1 > ../assets/bench.ans

cd ../assets

ansi2 bench.ans > bench.svg

