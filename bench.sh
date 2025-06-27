#!/bin/bash

cd dist
hyperfine "gcc.exe" "g++.exe" "clang.exe" "rust.exe" "msvc.exe" --warmup=1
