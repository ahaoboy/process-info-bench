#!/bin/bash

cd dist
hyperfine --style=full "gcc.exe" "g++.exe" "rust.exe" > ../assets/bench.ans

cd ../assets

ansi2 bench.ans > bench.svg

