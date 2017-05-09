#!/bin/sh

export NDK=/home/davinctor/Android/Sdk/ndk-bundle
export WORKING_DIR=`pwd`

TARGET_ARMEABI_DIR=$WORKING_DIR/armeabi
TARGET_ARMEABIV7A_DIR=$WORKING_DIR/armeabi-v7a
TARGET_X86_DIR=$WORKING_DIR/x86
TARGET_MIPS_DIR=$WORKING_DIR/mips
TARGET_X86_64_DIR=$WORKING_DIR/x86_64
TARGET_ARMEABI_64_DIR=$WORKING_DIR/arm64-v8a

#export NDK=`grep ndk.dir $PROPS | cut -d'=' -f2`

if [ "$NDK" = "" ] || [ ! -d $NDK ]; then
	echo "NDK variable not set or path to NDK is invalid, exiting..."
	exit 1
fi

if [ ! -z $TARGET_ARMEABI_DIR ]; then
    # Build FFmpeg from ARM architecture
    ./_build_openssl.sh arm
    ./_build_ffmpeg.sh arm
fi

if [ ! -z $TARGET_ARMEABIV7A_DIR ]; then
    # Build FFmpeg from ARM v7 architecture
    ./_build_openssl.sh armv7-a
    ./_build_ffmpeg.sh armv7-a
fi

if [ ! -z $TARGET_X86_DIR ]; then
    # Build FFmpeg from x86 architecture
    ./_build_openssl.sh i686
    ./_build_ffmpeg.sh i686
fi

if [ ! -z $TARGET_MIPS_DIR ]; then
    # Build FFmpeg from MIPS architecture
    ./_build_openssl.sh mips
    ./_build_ffmpeg.sh mips
fi

if [ ! -z $TARGET_X86_64_DIR1 ]; then
    # Build FFmpeg from x86_64 architecture
    ./_build_openssl.sh x86_64
    ./_build_ffmpeg.sh x86_64
fi

if [ ! -z $TARGET_ARMEABI_64_DIR ]; then
    # Build FFmpeg from arneabi_64 architecture
    ./_build_openssl.sh arm64-v8a
    ./_build_ffmpeg.sh arm64-v8a
fi

echo Native build complete, exiting...
exit
