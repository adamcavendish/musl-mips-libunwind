# musl-mips-libunwind

Current project is using libunwind **v1.7.2**.
Current project assumes that we are building on x86_64 architecture for mipsel.

Steps:
1. Run `bash musl-setup.bash` to retrieve the mipsel-linux-musl-cross toolchain.
2. Run `bash build-libunwind.bash` to clone, patch, build and install libunwind to current directory.
3. You'll find the libunwind.a and libunwind.so in `install/lib` directory.

# Extra - Sample Rust MIPS+MUSL Project

If you would like to build a statically linked binary for MIPS using musl toolchains after doing the basic steps above, you can review the following files:

1. [build-rust-mips-sample.bash](build-rust-mips-sample.bash)
    - This is the build script to use to build the rust sample project.
    - It specifies the `TARGET_CC`, `TARGET_CXX`, `TARGET_AR` which is required in the process of cross compilation.
2. [rust-mips-sample/rust-toolchain.toml](rust-mips-sample/rust-toolchain.toml)
    - At the time of writing, rust's `-Z build-std` cargo flag requires a nightly version.
3. [rust-mips-sample/.cargo/config.toml](rust-mips-sample/.cargo/config.toml)
    - It specifies the linker and extra rustflags that are required to build this musl version.
    - `-L ../toolchains/mipsel-linux-musl-cross-extra/`: 
        - We copy `libunwind.a` here and reveal to rustc.
    - `-L ../toolchains/mipsel-linux-musl-cross/mipsel-linux-musl/lib/`:
        - To reveal `crt1.o`, `crti.o`, `crtn.o` to rustc.
    - `-L ../toolchains/mipsel-linux-musl-cross/lib/gcc/mipsel-linux-musl/11.2.1`
        - To reveal `crtbegin.o`, `crtend.o`, etc. to rustc.
4. [rust-mips-sample/Cargo.toml](rust-mips-sample/Cargo.toml)
    - See the `profile.release` part on how to minimize the binary size.

Sample build:
1. Run `bash build-rust-mips-sample.bash debug` to build a debug version.
2. Run `bash build-rust-mips-sample.bash release` to build a minimal sized release version.
