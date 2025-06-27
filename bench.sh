#!/bin/bash

cd dist
hyperfine "gcc.exe" "g++.exe" "rust.exe"
