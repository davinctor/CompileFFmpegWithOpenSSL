#!/bin/bash
# Cross-compile environment for Android on ARMv7 and x86
#

export WORKING_DIR=`pwd`

export NDK=~/Android/Sdk/ndk-bundle

export ANDROID_NDK_ROOT=$NDK

if [ $# -ne 1 ];
  then echo "illegal number of parameters"
  echo "usage: build_openssl.sh TARGET"
  exit 1
fi

export TARGET=$1

ARM_PLATFORM=$NDK/platforms/android-9/arch-arm/
ARM_PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64

ARM64_PLATFORM=$NDK/platforms/android-21/arch-arm64/
ARM64_PREBUILT=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64

X86_PLATFORM=$NDK/platforms/android-9/arch-x86/
X86_PREBUILT=$NDK/toolchains/x86-4.9/prebuilt/dlinux-x86_64

X86_64_PLATFORM=$NDK/platforms/android-21/arch-x86_64/
X86_64_PREBUILT=$NDK/toolchains/x86_64-4.9/prebuilt/linux-x86_64

MIPS_PLATFORM=$NDK/platforms/android-9/arch-mips/
MIPS_PREBUILT=$NDK/toolchains/mipsel-linux-android-4.9/prebuilt/linux-x86_64

OPENSSL_VERSION="1.0.2k" #1.0.2j #"1.1.0c"

TOP_ROOT=`pwd`
BUILD_DIR=${TOP_ROOT}/libs/openssl
SOURCE=${TOP_ROOT}/src
SOURCE_OPENSSL=$SOURCE/openssl-android
mkdir -p ${BUILD_DIR}
mkdir -p ${SOURCE}
mkdir -p ${SOURCE_OPENSSL}

cd $SOURCE

if [ ! -e "openssl-${OPENSSL_VERSION}.tar.gz" ]; then
  echo "Downloading openssl-${OPENSSL_VERSION}.tar.gz"
  curl -LO https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
  tar -xvf openssl-${OPENSSL_VERSION}.tar.gz -C $SOURCE_OPENSSL --strip-components=1
else
  echo "Using openssl-${OPENSSL_VERSION}.tar.gz"
fi

#if [ -d openssl-${OPENSSL_VERSION} ]
#then
#    rm -rf openssl-${OPENSSL_VERSION}
#fi

function build_one
{

if [ $ARCH == "arm" ]
then
    PLATFORM=$ARM_PLATFORM
    PREBUILT=$ARM_PREBUILT
    HOST=arm-linux-androideabi
#added by alexvas
elif [ $ARCH == "arm64" ]
then
    PLATFORM=$ARM64_PLATFORM
    PREBUILT=$ARM64_PREBUILT
    HOST=aarch64-linux-android
elif [ $ARCH == "mips" ]
then
    PLATFORM=$MIPS_PLATFORM
    PREBUILT=$MIPS_PREBUILT
    HOST=mipsel-linux-android
#alexvas
elif [ $ARCH == "x86_64" ]
then
    PLATFORM=$X86_64_PLATFORM
    PREBUILT=$X86_64_PREBUILT
    HOST=x86_64-linux-android
else
    PLATFORM=$X86_PLATFORM
    PREBUILT=$X86_PREBUILT
    HOST=i686-linux-android
fi

INSTALL_DIR=$BUILD_DIR/build/$ABI
mkdir -p ${INSTALL_DIR}

cd $TOP_ROOT
. ./Setenv-android.sh $NDK $ANDROID_EABI $ANDROID_ARCH
cd $SOURCE_OPENSSL

if [ $TARGET == "mips" ]
then
    ./Configure android-mips shared no-ssl2 no-ssl3 no-comp no-hw no-engine --openssldir=$INSTALL_DIR --prefix=$INSTALL_DIR
elif [ $TARGET == "x86_64" ]
then
    ./Configure linux-x86_64 shared no-ssl2 no-ssl3 no-comp no-hw no-engine --openssldir=$INSTALL_DIR --prefix=$INSTALL_DIR
else
    ./config shared no-ssl2 no-ssl3 no-comp no-hw no-engine --openssldir=$INSTALL_DIR --prefix=$INSTALL_DIR
fi

make clean
make depend
make CALC_VERSIONS="SHLIB_COMPAT=; SHLIB_SOVER=" MAKE="make -e" all

echo $ANDROID_TOOLCHAIN
echo $PREBUILT/bin

mkdir -p $INSTALL_DIR/lib
echo "place-holder make target for avoiding symlinks" >> $INSTALL_DIR/lib/link-shared
make SHLIB_EXT=.so install_sw
#make install CC=$PREBUILT/bin/$HOST-gcc RANLIB=$PREBUILT/bin/$HOST-ranlib

# copy the binaries
OPENSSL_LIB_DIR=$BUILD_DIR/lib/$ABI
OPENSSL_INCLUDE_DIR=$BUILD_DIR/include/$ABI
mkdir -p ${OPENSSL_LIB_DIR}
mkdir -p ${OPENSSL_INCLUDE_DIR}
cp -r $INSTALL_DIR/lib/*.so 	${OPENSSL_LIB_DIR}/.
cp -r $INSTALL_DIR/include/* 	${OPENSSL_INCLUDE_DIR}/.
}

if [ $TARGET == 'arm' ]; then
  ABI=armeabi
  CPU=arm
  ARCH=arm
  PREFIX=`pwd`/../jni/openssl-android/armeabi
  export ANDROID_EABI=arm-linux-androideabi-4.9
  export ANDROID_ARCH=arch-arm
  build_one
fi

if [ $TARGET == 'armv7-a' ]; then
  ABI=armeabi-v7a
  CPU=armv7-a
  ARCH=arm
  PREFIX=`pwd`/../jni/openssl-android/armeabi-v7a
  export ANDROID_EABI=arm-linux-androideabi-4.9
  export ANDROID_ARCH=arch-arm
  build_one
fi

if [ $TARGET == 'i686' ]; then
  ABI=x86
  CPU=i686
  ARCH=i686
  PREFIX=`pwd`/../jni/openssl-android/x86
  export ANDROID_EABI=x86-4.9
  export ANDROID_ARCH=arch-x86
  build_one
fi

if [ $TARGET == 'mips' ]; then
  ABI=mips
  CPU=mips
  ARCH=mips
  PREFIX=`pwd`/../jni/openssl-android/mips
  export ANDROID_EABI=mipsel-linux-android-4.9
  export ANDROID_ARCH=arch-mips
  build_one
fi

if [ $TARGET == 'x86_64' ]; then
  ABI=x86_64
  CPU=x86_64
  ARCH=x86_64
  PREFIX=`pwd`/../jni/openssl-android/x86_64
  export ANDROID_EABI=x86_64-4.9
  export ANDROID_ARCH=arch-x86_64
  build_one
fi

if [ $TARGET == 'arm64-v8a' ]; then
  ABI=arm64-v8a
  CPU=arm64-v8a
  ARCH=arm64
  PREFIX=`pwd`/../jni/openssl-android/arm64-v8a
  export ANDROID_EABI=aarch64-linux-android-4.9
  export ANDROID_ARCH=arch-arm64
  build_one
fi
