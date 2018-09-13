#!/bin/bash
#####################################################################
# Cross-compile environment for openssl
#####################################################################
printf "#######################################################\n"
printf "######## Cross-compile environment for openssl ########\n"
printf "#######################################################\n\n"

#####################################################################
usage () {
   echo "Simple Bash script to set environment and build openssl for android platform"
   echo "Author: Khandker Mahmudur Rahman <mahmudur.rahman@brotecs.com>"
   echo
   echo "Usage:"
   echo "   build-openssl.sh <starting directory> <arm|arm64>"

   exit 1
}

[ "$#" -eq 2 ] || usage

ROOT_DIR=$1
ARCH=$2

set_env_arm() {
    cd "${ROOT_DIR}"
    printf "Building at directory $ROOT_DIR\n"
    printf "Configuring for ${ARCH}\n\n"
    
    rm -rf android-toolchain-arm
       
    perl -pi -e 's/install: all install_docs install_sw/install: install_docs install_sw/g' Makefile.org
    
    $NDK/build/tools/make-standalone-toolchain.sh --platform=android-24 --toolchain=arm-linux-androideabi-4.9 --install-dir=`pwd`/../android-toolchain-arm
    
    export TOOLCHAIN_PATH=`pwd`/../android-toolchain-arm/bin
    export TOOL=arm-linux-androideabi
    export NDK_TOOLCHAIN_BASENAME=${TOOLCHAIN_PATH}/${TOOL}
    export CC=$NDK_TOOLCHAIN_BASENAME-gcc
    export CXX=$NDK_TOOLCHAIN_BASENAME-g++
    export LINK=${CXX}
    export LD=$NDK_TOOLCHAIN_BASENAME-ld
    export AR=$NDK_TOOLCHAIN_BASENAME-ar
    export RANLIB=$NDK_TOOLCHAIN_BASENAME-ranlib
    export STRIP=$NDK_TOOLCHAIN_BASENAME-strip
    export ARCH_FLAGS=
    export ARCH_LINK=
    export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
    export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
    export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
    export LDFLAGS=" ${ARCH_LINK} "
}

set_env_arm64() {
    cd "${ROOT_DIR}"
    printf "Building at directory $ROOT_DIR\n"
    printf "Configuring for ${ARCH}\n\n"
    
    rm -rf android-toolchain-arm64
    
    perl -pi -e 's/install: all install_docs install_sw/install: install_docs install_sw/g' Makefile.org
    
    $NDK/build/tools/make-standalone-toolchain.sh --platform=android-24 --toolchain=aarch64-linux-android-4.9 --install-dir=`pwd`/../android-toolchain-arm64

    export TOOLCHAIN_PATH=`pwd`/../android-toolchain-arm64/bin
    export TOOL=aarch64-linux-android
    export NDK_TOOLCHAIN_BASENAME=${TOOLCHAIN_PATH}/${TOOL}
    export CC=$NDK_TOOLCHAIN_BASENAME-gcc
    export CXX=$NDK_TOOLCHAIN_BASENAME-g++
    export LINK=${CXX}
    export LD=$NDK_TOOLCHAIN_BASENAME-ld
    export AR=$NDK_TOOLCHAIN_BASENAME-ar
    export RANLIB=$NDK_TOOLCHAIN_BASENAME-ranlib
    export STRIP=$NDK_TOOLCHAIN_BASENAME-strip
    export ARCH_FLAGS=
    export ARCH_LINK=
    export CPPFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
    export CXXFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 -frtti -fexceptions "
    export CFLAGS=" ${ARCH_FLAGS} -fpic -ffunction-sections -funwind-tables -fstack-protector -fno-strict-aliasing -finline-limit=64 "
    export LDFLAGS=" ${ARCH_LINK} "
}

set_env() {
    
    export NDK=${ANDROID_NDK}
    
    if [ "$ARCH" = "arm" ]; then
        set_env_arm
    elif [ "$ARCH" = "arm64" ]; then
        set_env_arm64
    fi
    
    ./Configure android
    make clean
    make
    
    mkdir -p lib
    cp lib*.a lib/
    chmod -R a+x lib
    ls lib
}

set_env

