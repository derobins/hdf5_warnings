#!/usr/bin/env bash

hdf5_version="1.10.0"

# Configure step
# Uses gcc-12 build flags from develop as of July 7, 2022
# Adds -Wno-cpp to suppress some _BSD_SOURCE warnings that confuse warnhist
#
# NOTE: --enable-build-mode=debug is --enable-debug in HDF5 1.8.x
#
CFLAGS="-Wno-cpp -std=c99  -Wall -Wcast-qual -Wconversion -Wextra -Wfloat-equal -Wformat=2 -Winit-self -Winvalid-pch -Wmissing-include-dirs -Wshadow -Wundef -Wwrite-strings -pedantic -Wno-c++-compat -Wlarger-than=2560 -Wlogical-op -Wframe-larger-than=16384 -Wpacked-bitfield-compat -Wsync-nand -Wstrict-overflow=5 -Wno-unsuffixed-float-constants -Wdouble-promotion -Wtrampolines -Wstack-usage=8192 -Wmaybe-uninitialized -Wdate-time -Warray-bounds=2 -Wc99-c11-compat -Wduplicated-cond -Whsa -Wnormalized -Wnull-dereference -Wunused-const-variable -Walloca -Walloc-zero -Wduplicated-branches -Wformat-overflow=2 -Wformat-truncation=1 -Wattribute-alias -Wcast-align=strict -Wshift-overflow=2 -Wattribute-alias=2 -Wmissing-profile -Wc11-c2x-compat -ftrapv -fno-common -fdiagnostics-urls=never -fno-diagnostics-color -g -fno-omit-frame-pointer  -Wbad-function-cast -Wcast-align -Wformat -Wimplicit-function-declaration -Wint-to-pointer-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wpacked -Wpointer-sign -Wpointer-to-int-cast -Wredundant-decls -Wstrict-prototypes -Wswitch -Wunused-but-set-variable -Wunused-variable -Wunused-function -Wunused-parameter -Wincompatible-pointer-types -Wint-conversion -Wshadow -Wrestrict -Wcast-function-type -Wmaybe-uninitialized -Wno-aggregate-return -Wno-inline -Wno-missing-format-attribute -Wno-missing-noreturn -Wno-overlength-strings -Wno-jump-misses-init -Wno-suggest-attribute=const -Wno-suggest-attribute=noreturn -Wno-suggest-attribute=pure -Wno-suggest-attribute=format -Wno-suggest-attribute=cold -Wno-suggest-attribute=malloc -Og" ../hdf5/configure --enable-build-mode=debug --enable-build-all 2>&1 | tee configure.out

# Build step
make -j7 2>&1 | tee make.out

# Run warnhist (from develop, same as configure flags)
../warnings/warnhist make.out > warnhist.out

# Run cloc
cloc ../hdf5 > cloc.out

# Copy files to warnings directory
cp configure.out "../warnings/configure.$hdf5_version"
cp make.out      "../warnings/make.$hdf5_version"
cp warnhist.out  "../warnings/warnhist.$hdf5_version"
cp cloc.out      "../warnings/cloc.$hdf5_version"

