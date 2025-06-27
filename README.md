Test the performance of C and Rust in obtaining process information

```bash

bash build.sh

bash bench.sh

bash update-svg.sh
```

## gcc
```bash
gcc c/main.c -O3 -flto -s -o dist/gcc
```

## g++
```bash
g++ c/main.c -O3 -flto -s -o dist/g++
```
## clang
```bash
clang c/main.c -O3 -s -o dist/clang

# clang: error: 'x86_64-w64-windows-gnu': unable to pass LLVM bit-code files to linker
```
## rust
```toml
[profile.release]
debug = false
lto = true
strip = true
opt-level = 3
codegen-units = 1
```


<div align="center">
		<img src="assets/bench.svg">
</div>