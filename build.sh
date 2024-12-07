#!/bin/bash
#
# Copyright (C) 2020-2021 Adithya R.

SECONDS=0 # builtin bash timer
TC_DIR="$(pwd)/tc/clang-r450784e"
DEFCONFIG="vendor/msm8953-perf_defconfig vendor/motorola/sanders/sanders.config vendor/common.config vendor/feature/no-camera-stack.config vendor/feature/no-wlan-driver.config vendor/feature/no-audio-stack.config"

export PATH="$TC_DIR/bin:$PATH"

if ! [ -d "$TC_DIR" ]; then
	echo "AOSP clang not found! Cloning to $TC_DIR..."
	if ! git clone --depth=1 -b 17 https://gitlab.com/ThankYouMario/android_prebuilts_clang-standalone "$TC_DIR"; then
		echo "Cloning failed! Aborting..."
		exit 1
	fi
fi

mkdir -p out
make O=out ARCH=arm64 $DEFCONFIG

echo -e "\nStarting compilation...\n"
make -j$(nproc --all) O=out ARCH=arm64 CC=clang LD=ld.lld AS=llvm-as AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- Image.gz
